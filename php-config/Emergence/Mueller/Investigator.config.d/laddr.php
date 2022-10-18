<?php

namespace Emergence\Mueller;

use DB;
use Emergence\People\IUser;
use Emergence\Slack\API as SlackAPI;

Investigator::$tests['email-invalid'] = false;
Investigator::$tests['ip-whitelist'] = false;
Investigator::$tests['ip-blacklist'] = false;
Investigator::$tests['session-multiple'] = false;

Investigator::$tests['has-about-url'] = [
    'points' => -100,
    'function' => function (IUser $User, array &$userCache) {
        return $User->About && (stripos($User->About, 'http://') !== false || stripos($User->About, 'https://') !== false || stripos($User->About, 'www.') !== false);
    }
];

Investigator::$tests['has-twitter-url'] = [
    'points' => -100,
    'function' => function (IUser $User) {
        return $User->Twitter
               && stripos($User->Twitter, 'https://twitter.com/') !== 0
               && (stripos($User->Twitter, 'http://') !== false || stripos($User->Twitter, 'https://') !== false);
    }
];

Investigator::$tests['has-comment-url'] = [
    'points' => -100,
    'function' => function (IUser $User, array &$userCache) {

        foreach (Investigator::getUserComments($User, $userCache) as $Comment) {
            if (
                stripos($Comment['Message'], 'http://') !== false
                || stripos($Comment['Message'], 'https://') !== false
                || stripos($Comment['Message'], 'www.') !== false
            ) {
                return true;
            }
        }

        return false;
    }
];

Investigator::$tests['has-project'] = [
    'points' => 1000,
    'function' => function (IUser $User) {
        static $projectMemberIds;

        if ($projectMemberIds === null) {
            $projectMemberIds = array_map(
                'intval',
                DB::allValues(
                    'MemberID',
                    'SELECT DISTINCT MemberID FROM `project_members`'
                )
            );
        }

        return in_array(strtolower($User->ID), $projectMemberIds);
    },
];

Investigator::$tests['has-checkin'] = [
    'points' => 1000,
    'function' => function (IUser $User) {
        static $checkinMemberIds;

        if ($checkinMemberIds === null) {
            $checkinMemberIds = array_map(
                'intval',
                DB::allValues(
                    'MemberID',
                    'SELECT DISTINCT MemberID FROM `member_checkins`'
                )
            );
        }

        return in_array(strtolower($User->ID), $checkinMemberIds);
    },
];

if (SlackAPI::isAvailable()) {
    Investigator::$tests['has-slack-account'] = [
        'points' => 1000,
        'function' => function (IUser $User) {
            static $slackUsernames;

            if ($slackUsernames === null) {
                $slackMembersResponse = SlackAPI::request('users.list');
                $slackUsernames = [];

                foreach ($slackMembersResponse['members'] as $member) {
                    $slackUsernames[] = strtolower($member['name']);
                }
            }

            return in_array(strtolower($User->Username), $slackUsernames);
        }
    ];
}
