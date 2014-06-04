<?php

$meetups = RemoteSystems\Meetup::getEvents();
$nextMeetup = array_shift($meetups);

// detect if meetup is happening right now
if($nextMeetup && $nextMeetup['time'] < time() * 1000) {
    $currentMeetup = $nextMeetup;
    $checkins = Laddr\MemberCheckin::getAllByField('MeetupID', $currentMeetup['id'], array('order' => 'ID DESC'));
    $nextMeetup = array_shift($meetups);
}
    
RequestHandler::respond('bigscreen', array(
    'currentMeetup' => $currentMeetup
    ,'checkins' => $checkins
    ,'nextMeetup' => $nextMeetup
));