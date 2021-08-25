<?php

namespace Emergence\Mueller;

use DB;
use Cache;
use Email;
use ActiveRecord;
use User;
use Bookmark;
use TableNotFoundException;
use Emergence\People\IUser;
use Emergence\Comments\Comment;
use SMTPValidateEmail\Validator as SmtpEmailValidator;

class Investigator
{
    public static $tests = [
        'has-staff' => [
            'points' => 1000,
            'conclusive' => true,
            'function' => [__CLASS__, 'testHasStaff']
        ],
        'domain-whitelist' => [
            'points' => 1000,
            'conclusive' => true,
            'function' => [__CLASS__, 'testDomainWhitelist']
        ],
        'domain-blacklist' => [
            'points' => -1000,
            'conclusive' => true,
            'function' => [__CLASS__, 'testDomainBlacklist']
        ],
        'domain-toxic' => [
            'points' => -100,
            'function' => [__CLASS__, 'testDomainToxic']
        ],
        'domain-disposable' => [
            'points' => -100,
            'function' => [__CLASS__, 'testDomainDisposable']
        ],
        'charset-foreign' => [
            'points' => -100,
            'function' => [__CLASS__, 'testCharsetForeign']
        ],
        'name-doubleupper' => [
            'points' => -100,
            'function' => [__CLASS__, 'testNameDoubleUpper']
        ],
        'name-repeated' => [
            'points' => -100,
            'function' => [__CLASS__, 'testNameRepeated']
        ],
        'name-numbered' => [
            'points' => -100,
            'function' => [__CLASS__, 'testNameNumbered']
        ],
        'name-matching-shady' => [
            'points' => -100,
            'function' => [__CLASS__, 'testNameMatchingShady']
        ],
        'has-about' => [
            'points' => 100,
            'function' => [__CLASS__, 'testHasUserField'],
            'userField' => 'About'
        ],
        'has-location' => [
            'points' => 100,
            'function' => [__CLASS__, 'testHasUserField'],
            'userField' => 'Location'
        ],
        'comment-immediate' => [
            'points' => -100,
            'secondary' => 100,
            'function' => [__CLASS__, 'testCommentImmediate'],
            'maxSeconds' => 60
        ],
        'comment-foreign' => [
            'points' => -100,
            'secondary' => 101,
            'function' => [__CLASS__, 'testCommentForeign']
        ],
#        'comment-linkcode' => [
#            'points' => -100,
#            'secondary' => 102,
#            'function' => [__CLASS__, 'testCommentLinkCode']
#        ],
        'session-multiple' => [
            'points' => 100,
            'secondary' => 200,
            'function' => [__CLASS__, 'testSessionMultiple']
        ],
        'ip-whitelist' => [
            'points' => 100,
            'secondary' => 250,
            'function' => [__CLASS__, 'testIpWhitelist']
        ],
        'ip-blacklist' => [
            'points' => -100,
            'secondary' => 251,
            'function' => [__CLASS__, 'testIpBlacklist']
        ],
        'email-invalid' => [
            'points' => -100,
            'secondary' => 1000,
            'function' => [__CLASS__, 'testEmailInvalid']
        ]
    ];

    public static $domainsWhitelist = [];
    public static $domainsBlacklist = [];
    public static $domainsBlacklistPatterns = [];
    public static $domainsToxicWhole = 'https://www.stopforumspam.com/downloads/toxic_domains_whole.txt';
    public static $domainsToxicPartial = 'https://www.stopforumspam.com/downloads/toxic_domains_partial.txt';
    public static $domainsDisposable = 'https://raw.githubusercontent.com/ivolo/disposable-email-domains/master/index.json';
    public static $countriesWhitelist = ['US', 'CA'];
    public static $countriesBlacklist = ['RU', 'UA', 'MD', 'PL'];
    public static $ipLocationDatabase = 'https://download.ip2location.com/lite/IP2LOCATION-LITE-DB1.CSV.ZIP';

    public static function scanUsers(array $options = [])
    {
        // collect tests
        $tests = [];
        foreach (static::$tests as $testId => $test) {
            if (!$test) {
                continue;
            }

            $test['conclusive'] = !empty($test['conclusive']);
            $test['points'] = !empty($test['points']) ? $test['points'] : 100;
            $test['secondary'] = !empty($test['secondary']) ? intval($test['secondary']) : 0;
            $tests[$testId] = $test;
        }


        // sort tests to defer secondary ones, treating value as weight
        uasort($tests, function ($a, $b) {
            if ($a['secondary'] == $b['secondary']) {
                return 0;
            }
            return ($a['secondary'] < $b['secondary']) ? -1 : 1;
        });


        // collect content tables
        $creatorColumns = DB::allRecords('SELECT * FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = SCHEMA() AND COLUMN_NAME = "CreatorID" AND TABLE_NAME NOT LIKE "_e_%" AND TABLE_NAME NOT LIKE "_purged_%" AND TABLE_NAME NOT IN ("people", "history_people")');
        $contentTables = [];
        foreach ($creatorColumns as $column) {
            $contentTables[$column['TABLE_NAME']] = false;
        }


        // create purged tables for people
        if (!empty($_REQUEST['execute'])) {
            DB::nonQuery('CREATE TABLE IF NOT EXISTS `_purged_people` AS SELECT * FROM `people` WHERE FALSE');
            DB::nonQuery('CREATE TABLE IF NOT EXISTS `_purged_history_people` AS SELECT * FROM `history_people` WHERE FALSE');
        }


        // scan users
        DB::suspendQueryLogging();
        set_time_limit(0);
        $report = [
            'investigated' => 0,
            'indicted' => 0,
            'purged' => 0,
            'cleared' => 0
        ];

        $params = [];
        $sql = 'SELECT * FROM people';

        if (!empty($_REQUEST['id_min'])) {
            $sql .= ' WHERE ID >= %u';
            $params[] = $_REQUEST['id_min'];
        } elseif (!empty($_REQUEST['id'])) {
            $sql .= ' WHERE ID = %u';
            $params[] = $_REQUEST['id'];
        }

        $sql .= ' ORDER BY ID';

        if (!empty($_REQUEST['limit'])) {
            $sql .= ' LIMIT %u';
            $params[] = $_REQUEST['limit'];
        }

        $usersResult = DB::query($sql, $params);

        while ($userData = $usersResult->fetch_assoc()) {
            $report['investigated']++;


            $User = ActiveRecord::instantiateRecord($userData);
            $userCache = [
                'diagnostics' => []
            ];
            $score = 0;
            $flags = [];
            $purgings = [];


            // execute tests until secondary ones are encountered without the score still being 0
            foreach ($tests as $testId => $test) {
                if ($test['secondary'] > 0 && $score != 0) {
                    // stop executing tests once getting into secondary ones if there's a score
                    break;
                }

                $result = call_user_func_array($test['function'], [
                    $User,
                    &$userCache,
                    $test
                ]);

                if ($result) {
                    $flags[] = $testId;

                    if ($test['conclusive']) {
                        $score = $test['points'];
                        break;
                    }

                    $score += $test['points'];
                }
            }


            // handle score, negative = bot
            if ($score < 0) {
                $report['indicted']++;

                if (!empty($_REQUEST['execute'])) {
                    foreach ($contentTables as $tableName => &$purgedTableName) {
                        if (!$purgedTableName) {
                            if (!DB::oneValue('SELECT 1 FROM `%s` WHERE CreatorID = %u', [$tableName, $User->ID])) {
                                continue;
                            }

                            $purgedTableName = "_purged_{$tableName}";
                            DB::nonQuery('CREATE TABLE IF NOT EXISTS `%s` AS SELECT * FROM `%s` WHERE FALSE', [$purgedTableName, $tableName]);
                        }

                        DB::nonQuery('INSERT INTO `%s` SELECT * FROM `%s` WHERE CreatorID = %u', [$purgedTableName, $tableName, $User->ID]);
                        DB::nonQuery('DELETE FROM `%s` WHERE CreatorID = %u', [$tableName, $User->ID]);
                        $purgings[$tableName] += DB::affectedRows();
                    }

                    foreach (['people', 'history_people'] as $tableName) {
                        DB::nonQuery('INSERT INTO `_purged_%1$s` SELECT * FROM `%1$s` WHERE ID = %2$u', [$tableName, $User->ID]);
                        DB::nonQuery('DELETE FROM `%s` WHERE ID = %u', [$tableName, $User->ID]);
                    }

                    $report['purged']++;
                }
            } else {
                $report['cleared']++;
            }


            // send result data to optional callback
            if (!empty($options['callback']) && is_callable($options['callback'])) {
                call_user_func($options['callback'], $User, [
                    'score' => $score,
                    'flags' => $flags,
                    'purgings' => $purgings,
                    'diagnostics' =>
                        $score == 0 && !empty($_REQUEST['show_diagnostics'])
                        ? array_merge($userCache['diagnostics'], [
                            'countries' => implode(', ', static::getUserCountries($User, $userCache))
                        ])
                        : null
                ]);
            }
        }

        DB::resumeQueryLogging();

        return $report;
    }

    public static function getUserDomain(IUser $User, array &$userCache)
    {
        if (!isset($userCache['domain'])) {
            $userCache['domain'] = $User->Email && count($split = explode('@', $User->Email)) == 2
                ? $split[1]
                : null;
        }

        return $userCache['domain'];
    }

    public static function getUserComments(IUser $User, array &$userCache)
    {
        if (!isset($userCache['comments'])) {
            try {
                $userCache['comments'] = DB::allRecords('SELECT * FROM `%s` WHERE CreatorID = %u', [Comment::$tableName, $User->ID]);
            } catch (TableNotFoundException $e) {
                $userCache['comments'] = [];
            }
        }

        return $userCache['comments'];
    }

    public static function getUserSessions(IUser $User, array &$userCache)
    {
        if (!isset($userCache['sessions'])) {
            $userCache['sessions'] = DB::allRecords('SELECT * FROM sessions WHERE PersonID = %u', $User->ID);
        }

        return $userCache['sessions'];
    }

    public static function getUserIps(IUser $User, array &$userCache)
    {
        if (!isset($userCache['ips'])) {
            $userCache['ips'] = [];
            foreach (static::getUserSessions($User, $userCache) as $session) {
                $userCache['ips'][] = intval($session['LastIP']);
            }
        }

        return $userCache['ips'];
    }

    public static function getUserCountries(IUser $User, array &$userCache)
    {
        if (!isset($userCache['countries'])) {
            $ipTable = static::getIpTable();

            $userCache['countries'] = [];
            foreach (static::getUserIps($User, $userCache) as $ip) {
                foreach ($ipTable as list ($from, $to, $country)) {
                    if ($ip >= $from && $ip <= $to) {
                        if (!in_array($country, $userCache['countries'])) {
                            $userCache['countries'][] = $country;
                        }
                        break;
                    }
                }
            }
        }

        return $userCache['countries'];
    }

    public static function getIpTable()
    {
        static $ipTable;

        if ($ipTable === null) {
            $downloadPath = \Site::$rootPath.'/site-data/ip2location.zip';
            list ($downloadMD5) = explode(' ', file_get_contents(static::$ipLocationDatabase.'.md5'));

            if (!file_exists($downloadPath) || md5_file($downloadPath) != $downloadMD5) {
                copy(static::$ipLocationDatabase, $downloadPath);
            }

            $ipTable = [];
            $fh = fopen("zip://{$downloadPath}#IP2LOCATION-LITE-DB1.CSV", 'r');

            while ($row = fgetcsv($fh)) {
                $ipTable[] = [intval($row[0]), intval($row[1]), $row[2]];
            }

            fclose($fh);
        }

        return $ipTable;
    }

    public static function testHasStaff(IUser $User)
    {
        return $User->hasAccountLevel('Staff');
    }

    public static function testDomainWhitelist(IUser $User, array &$userCache)
    {
        return in_array(static::getUserDomain($User, $userCache), static::$domainsWhitelist);
    }

    public static function testDomainBlacklist(IUser $User, array &$userCache)
    {
        $domain = static::getUserDomain($User, $userCache);

        if (in_array($domain, static::$domainsBlacklist)) {
            return true;
        }

        foreach (static::$domainsBlacklistPatterns as $pattern) {
            if (fnmatch($pattern, $domain)) {
                return true;
            }
        }

        return false;
    }

    public static function testDomainToxic(IUser $User, array &$userCache)
    {
        $domain = static::getUserDomain($User, $userCache);


        // for the "whole" domains list, look for exact match
        static $toxicWhole;
        if (static::$domainsToxicWhole) {
            if ($toxicWhole === null) {
                $toxicWhole = file(static::$domainsToxicWhole, FILE_IGNORE_NEW_LINES);
            }

            if (in_array($domain, $toxicWhole)) {
                return true;
            }
        }


        // for the "partial" domains list, look for a substring match
        static $toxicPartial;
        if (static::$domainsToxicPartial) {
            if ($toxicPartial === null) {
                $toxicPartial = file(static::$domainsToxicPartial, FILE_IGNORE_NEW_LINES);
            }

            foreach ($toxicPartial as $partial) {
                if (strpos($domain, $partial) !== false) {
                    return true;
                }
            }
        }

        return false;
    }

    public static function testDomainDisposable(IUser $User, array &$userCache)
    {
        static $disposables;

        if ($disposables === null) {
            $disposables = json_decode(file_get_contents(static::$domainsDisposable));
        }

        return in_array(static::getUserDomain($User, $userCache), $disposables);
    }

    public static function testCharsetForeign(IUser $User)
    {
        return preg_match('/[^\p{Common}\p{Latin}]/u', "{$User->FirstName} {$User->LastName} {$User->Username}");
    }

    public static function testNameDoubleUpper(IUser $User)
    {
        return preg_match('/[^A-Z][A-Z]{2}$/', $User->FirstName) || preg_match('/[^A-Z][A-Z]{2}$/', $User->LastName);
    }

    public static function testNameRepeated(IUser $User)
    {
        return strpos($User->LastName, $User->FirstName) === 0 || strpos($User->FirstName, $User->LastName) === 0 || substr($User->FirstName, 0, 5) == substr($User->LastName, 0, 5);
    }

    public static function testNameNumbered(IUser $User)
    {
        return $User->FirstName == $User->Username && preg_match('/\d+/', $User->FirstName);
    }

    public static function testNameMatchingShady(IUser $User)
    {
        if ($User->FirstName != $User->Username) {
            return false;
        }

        return (
            substr($User->Email, -3) == '.ru' // .ru emails are shady
            || preg_match('/[A-Z]/', $User->Email) // capital letters in email are shady
            || preg_match('/[A-Z]$/', $User->LastName) // a last name ending in a capital letter is shady
        );
    }

    public static function testHasUserField(IUser $User, array &$userCache, array $options)
    {
        return !empty($User->{$options['userField']});
    }

    public static function testCommentImmediate(IUser $User, array &$userCache, array $options)
    {
        $firstCommentTime = null;
        foreach (static::getUserComments($User, $userCache) as $comment) {
            $time = strtotime($comment['Created']);
            if (!$firstCommentTime || $firstCommentTime > $time) {
                $firstCommentTime = $time;
            }
        }

        $userCache['diagnostics']['time-to-comment'] = $firstCommentTime ? $firstCommentTime - $User->Created : null;

        return $firstCommentTime && $firstCommentTime - $User->Created < $options['maxSeconds'];
    }

    public static function testCommentForeign(IUser $User, array &$userCache, array $options)
    {
        foreach (static::getUserComments($User, $userCache) as $comment) {
            if (preg_match('/[^\p{Common}\p{Latin}]/u', $comment['Message'])) {
                return true;
            }
        }

        return false;
    }

#    public static function testCommentLinkCode(IUser $User, array &$userCache, array $options)
#    {
#        foreach (static::getUserComments($User, $userCache) as $comment) {
#            // TODO: detect [url and [img and <a href
#        }
#
#        return false;
#    }

    public static function testIpBlacklist(IUser $User, array &$userCache)
    {
        return count(array_intersect(static::getUserCountries($User, $userCache), static::$countriesBlacklist)) > 0;
    }

    public static function testIpWhitelist(IUser $User, array &$userCache)
    {
        return count(array_intersect(static::getUserCountries($User, $userCache), static::$countriesWhitelist)) > 0;
    }

    public static function testSessionMultiple(IUser $User, array &$userCache)
    {
        return count(static::getUserSessions($User, $userCache)) > 1;
    }

    public static function testEmailInvalid(IUser $User)
    {
        $cacheKey = 'smtp-valid:'.$User->Email;

        $cacheResult = Cache::fetch($cacheKey);
        if ($cacheResult !== false) {
            return !$cacheResult;
        }

        static $validator;
        if ($validator === null) {
            $validator = new SmtpEmailValidator(null, Email::getDefaultFrom());
            if (!empty($_REQUEST['show_smtp_log'])) {
                $validator->debug = true;
            }
        }

        try {
            $result = $validator->validate($User->Email)[$User->Email];
            Cache::store($cacheKey, $result ?: null);
            return !$result;
        } catch (\Exception $e) {
            return false;
        }
    }
}
