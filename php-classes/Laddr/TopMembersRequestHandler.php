<?php

namespace Laddr;

use RequestHandler;
use DB;
use Person;

class TopMembersRequestHandler extends RequestHandler
{
    public static $userResponseModes = [
        'application/json' => 'json'
        ,'text/csv' => 'csv'
    ];

    public static function handleRequest()
    {
        return static::respond('topMembers', [
            'data' => array_map(
                function($result) {
                    $result['Member'] = Person::getByID($result['Member']);
                    return $result;
                }
                ,DB::allRecords('SELECT MemberID AS Member, COUNT(MeetupID) AS Checkins FROM `member_checkins` GROUP BY MemberID HAVING Checkins > 1 ORDER BY Checkins DESC')
            )
        ]);
    }
}