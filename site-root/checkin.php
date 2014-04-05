<?php

use Laddr\MemberCheckin;

$GLOBALS['Session']->requireAuthentication();

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    return RequestHandler::throwError('A checkin can only be performed via HTTP POST');
}

if (empty($_POST['MeetupID'])) {
    return RequestHandler::throwError('A MeetupID must be provided');
}

// check for existing checkin for this Member+Meetup
$Checkin = MemberCheckin::getByWhere(array(
    'MemberID' => $GLOBALS['Session']->PersonID
    ,'MeetupID' => $_POST['MeetupID']
));

// create new checkin if there wasn't an existing one
if (!$Checkin) {
    $Checkin = MemberCheckin::create(array(
        'MemberID' => $GLOBALS['Session']->PersonID
        ,'MeetupID' => $_POST['MeetupID']
    ));
}

// apply selected project
$Checkin->ProjectID = empty($_POST['ProjectID']) ? null : $_POST['ProjectID'];

// save checkin to database
$Checkin->save();

// output response
if (Site::$pathStack[0] == 'json') {
    RequestHandler::$responseMode = 'json';
}

RequestHandler::respond('checked-in', array(
    'data' => $Checkin
    ,'success' => true
));