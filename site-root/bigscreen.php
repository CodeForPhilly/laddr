<?php

$now = new DateTime();
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
    $checkins = Laddr\MemberCheckin::getAllByField('MeetupID', $currentMeetup['id'], array('order' => 'ID DESC'));
}


RequestHandler::respond('bigscreen', array(
    'currentMeetup' => $currentMeetup
    ,'checkins' => $checkins
    ,'nextMeetup' => $nextMeetup
));
