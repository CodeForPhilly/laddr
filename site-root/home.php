<?php

// compile home page data
$now = time() * 1000;
$pageData = array();


// meetups
    $meetups = RemoteSystems\Meetup::getEvents();
    $nextMeetup = array_shift($meetups);

    // detect if meetup is happening right now
    if($nextMeetup && $nextMeetup['time'] < $now) {
        $currentMeetup = $nextMeetup;
        $nextMeetup = array_shift($meetups);
    }

    // TODO: delete this!
    elseif(!empty($_GET['force_current'])) {
        $currentMeetup = $nextMeetup;
    }

    if($currentMeetup) {
        $currentMeetup['checkins'] = Laddr\MemberCheckin::getAllForMeetupByProject($currentMeetup['id']);
    }

    $pageData['currentMeetup'] = $currentMeetup;
    $pageData['nextMeetup'] = $nextMeetup;
    $pageData['futureMeetups'] = $meetups;


// projects
    $pageData['projectsTotal'] = Laddr\Project::getCount();
    $pageData['projectsTags']['byTech'] = TagItem::getTagsSummary(array(
        'tagConditions' => array(
            'Handle LIKE "tech.%"'
        )
        ,'itemConditions' => array(
            'ContextClass' => Laddr\Project::getStaticRootClass()
        )
    ));
    $pageData['projectsTags']['byTopic'] = TagItem::getTagsSummary(array(
        'tagConditions' => array(
            'Handle LIKE "topic.%"'
        )
        ,'itemConditions' => array(
            'ContextClass' => Laddr\Project::getStaticRootClass()
        )
    ));
    $pageData['projectsTags']['byEvent'] = TagItem::getTagsSummary(array(
        'tagConditions' => array(
            'Handle LIKE "event.%"'
        )
        ,'itemConditions' => array(
            'ContextClass' => Laddr\Project::getStaticRootClass()
        )
    ));
    $pageData['projectsStages'] = Laddr\Project::getStagesSummary();


// members
    $pageData['membersTotal'] = Emergence\People\Person::getCount();
    $pageData['membersTags']['byTech'] = TagItem::getTagsSummary(array(
        'tagConditions' => array(
            'Handle LIKE "tech.%"'
        )
        ,'itemConditions' => array(
            'ContextClass' => Emergence\People\Person::getStaticRootClass()
        )
    ));
    $pageData['membersTags']['byTopic'] = TagItem::getTagsSummary(array(
        'tagConditions' => array(
            'Handle LIKE "topic.%"'
        )
        ,'itemConditions' => array(
            'ContextClass' => Emergence\People\Person::getStaticRootClass()
        )
    ));


// build activity stream
    if (!$pageData['activity'] = Cache::fetch('home-activity')) {
        $existingTables = \DB::allValues('table_name', 'SELECT table_name FROM information_schema.TABLES WHERE TABLE_SCHEMA = SCHEMA()');
        $activityQueries = [];
        
        if (in_array(Emergence\CMS\AbstractContent::$tableName, $existingTables)) {
            $activityQueries[] = sprintf('SELECT ID, Class, Published AS Timestamp FROM `%s`', Emergence\CMS\AbstractContent::$tableName);
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