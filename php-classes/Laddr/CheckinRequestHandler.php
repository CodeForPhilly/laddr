<?php

namespace Laddr;

use DB;
use Person;
use RequestHandler;

class CheckinRequestHandler extends RequestHandler
{
    public static $userResponseModes = [
        'application/json' => 'json',
        'text/csv' => 'csv',
    ];

    public static function handleRequest()
    {
        switch (static::shiftPath()) {
            case '*top-members':
                return static::handleTopMembersRequest();
            case '*latest-events':
                return static::handleLatestEventsRequest();
            case '':
            case false:
                return static::handleCheckinRequest();
            default:
                return static::throwNotFoundError();
        }
    }

    public static function handleCheckinRequest()
    {
        $GLOBALS['Session']->requireAuthentication();

        if ('POST' != $_SERVER['REQUEST_METHOD']) {
            return static::throwError('A checkin can only be performed via HTTP POST');
        }

        if (empty($_POST['MeetupID'])) {
            return static::throwError('A MeetupID must be provided');
        }

        // check for existing checkin for this Member+Meetup
        $Checkin = MemberCheckin::getByWhere([
            'MemberID' => $GLOBALS['Session']->PersonID,
            'MeetupID' => $_POST['MeetupID'],
        ]);

        // create new checkin if there wasn't an existing one
        if (!$Checkin) {
            $Checkin = MemberCheckin::create([
                'MemberID' => $GLOBALS['Session']->PersonID,
                'MeetupID' => $_POST['MeetupID'],
            ]);
        }

        // apply selected project
        $Checkin->ProjectID = empty($_POST['ProjectID']) ? null : $_POST['ProjectID'];

        // save checkin to database
        $Checkin->save();

        static::respond('checkinComplete', [
            'data' => $Checkin,
            'success' => true,
        ]);
    }

    public static function handleTopMembersRequest()
    {
        return static::respond('topMembers', [
            'data' => array_map(
                function ($result) {
                    $result['Member'] = Person::getByID($result['Member']);

                    return $result;
                },
                DB::allRecords('
                    SELECT MemberID AS Member,
                           COUNT(MeetupID) AS Checkins
                      FROM member_checkins
                     GROUP BY MemberID
                    HAVING Checkins > 1
                     ORDER BY Checkins DESC
                ')
            ),
        ]);
    }

    public static function handleLatestEventsRequest()
    {
        return static::respond('latestEvents', [
            'data' => DB::allRecords('
                SELECT MeetupID,
                       MIN(Created) AS First,
                       MAX(Created) AS Last,
                       COUNT(MeetupID) AS Checkins
                  FROM member_checkins
                 GROUP BY MeetupID
                 ORDER BY First DESC
            '),
        ]);
    }
}
