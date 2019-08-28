<?php

// compile home page data
$now = new DateTime();
$pageData = array();


// meetups
    try {
        $meetups = Emergence\Meetup\Connector::getUpcomingEvents();
        $nextMeetup = array_shift($meetups);

        // detect if meetup is happening right now
        // - use ?next_meetup_now=1 to test feature before any event
        if(
            ($nextMeetup && $nextMeetup['time_start'] < $now)
            || !empty($_GET['next_meetup_now'])
        ) {
            $currentMeetup = $nextMeetup;
            $nextMeetup = array_shift($meetups);
        }

        if($currentMeetup) {
            $currentMeetup['checkins'] = Laddr\MemberCheckin::getAllForMeetupByProject($currentMeetup['id']);
        }

        $pageData['currentMeetup'] = $currentMeetup;
        $pageData['nextMeetup'] = $nextMeetup;
        $pageData['futureMeetups'] = $meetups;
    } catch (Exception $e) {
        // just omit meetup data
    }


// build activity stream
    if (!$pageData['activity'] = Cache::fetch('home-activity')) {
        $existingTables = \DB::allValues('table_name', 'SELECT table_name FROM information_schema.TABLES WHERE TABLE_SCHEMA = SCHEMA()');
        $activityQueries = [];

        if (in_array(Emergence\CMS\AbstractContent::$tableName, $existingTables)) {
            $activityQueries[] = sprintf(
                'SELECT'
                .'  ID, Class, Published AS Timestamp'
                .' FROM `%s`'
                .' WHERE'
                .'  Class = "%s" AND'
                .'  Visibility = "Public" AND'
                .'  Status = "Published" AND'
                .'  (Published IS NULL OR Published <= CURRENT_TIMESTAMP)',
                Emergence\CMS\AbstractContent::$tableName,
                DB::escape(Emergence\CMS\BlogPost::class)
            );
        }

        if (in_array(Laddr\ProjectUpdate::$tableName, $existingTables)) {
            $activityQueries[] = sprintf('SELECT ID, Class, Created AS Timestamp FROM `%s`', Laddr\ProjectUpdate::$tableName);
        }

        if (in_array(Laddr\ProjectBuzz::$tableName, $existingTables)) {
            $activityQueries[] = sprintf('SELECT ID, Class, Published AS Timestamp FROM `%s`', Laddr\ProjectBuzz::$tableName);
        }

        if (count($activityQueries)) {
            $pageData['activity'] = array_map(
                function($result) {
                    return $result['Class']::getByID($result['ID']);
                }
                ,DB::allRecords(implode(' UNION ', $activityQueries).' ORDER BY Timestamp DESC LIMIT 10')
            );
        } else {
            $pageData['activity'] = [];
        }
        Cache::store('home-activity', $pageData['activity'], 30);
    }


// render data against home template
RequestHandler::respond('home', $pageData);