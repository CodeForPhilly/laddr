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
            'ContextClass' => 'Laddr\Project'
        )
    ));
    $pageData['projectsTags']['byTopic'] = TagItem::getTagsSummary(array(
        'tagConditions' => array(
            'Handle LIKE "topic.%"'
        )
        ,'itemConditions' => array(
            'ContextClass' => 'Laddr\Project'
        )
    ));
    $pageData['projectsTags']['byEvent'] = TagItem::getTagsSummary(array(
        'tagConditions' => array(
            'Handle LIKE "event.%"'
        )
        ,'itemConditions' => array(
            'ContextClass' => 'Laddr\Project'
        )
    ));


// members
    $pageData['membersTotal'] = Person::getCount();
    $pageData['membersTags']['byTech'] = TagItem::getTagsSummary(array(
        'tagConditions' => array(
            'Handle LIKE "tech.%"'
        )
        ,'itemConditions' => array(
            'ContextClass' => 'Person'
        )
    ));
    $pageData['membersTags']['byTopic'] = TagItem::getTagsSummary(array(
        'tagConditions' => array(
            'Handle LIKE "topic.%"'
        )
        ,'itemConditions' => array(
            'ContextClass' => 'Person'
        )
    ));


// project updates stream
    $pageData['updates'] = Laddr\ProjectUpdate::getAll(array(
        'limit' => 10
        ,'order' => array('ID' => 'DESC')
    ));


// render data against home template
RequestHandler::respond('home', $pageData);