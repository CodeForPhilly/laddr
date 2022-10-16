<?php

namespace Emergence\Mueller;

use DB;
use Emergence\People\IUser;
use Emergence\Slack\API as SlackAPI;

Investigator::$tests['email-invalid'] = false;

Investigator::$tests['has-about'] = [
    'points' => -10,
    'function' => [Investigator::class, 'testHasUserField'],
    'userField' => 'About'
];

Investigator::$tests['has-comment'] = [
    'points' => -10,
    'function' => function (IUser $User, array &$userCache) {
        return count(Investigator::getUserComments($User, $userCache)) > 0;
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
