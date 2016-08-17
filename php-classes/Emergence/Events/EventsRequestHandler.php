<?php

namespace Emergence\Events;


class EventsRequestHandler extends \RecordsRequestHandler
{
    // RecordRequestHandler configuration
    public static $recordClass = Event::class;
    public static $accountLevelRead = false;
    public static $accountLevelBrowse = false;
    public static $accountLevelWrite = 'Staff';
    public static $browseOrder = ['StartTime'];

    public static function handleBrowseRequest($options = [], $conditions = [], $responseID = null, $responseData = [])
    {
        if (!$GLOBALS['Session']->hasAccountLevel('Staff')) {
            $conditions['Status'] = 'published';
        } elseif (!empty($_GET['status']) && $_GET['status'] != 'any' && in_array($_GET['status'], Event::getFieldOptions('Status', 'values'))) {
            $conditions['Status'] = $_GET['status'];
        }

        $conditions[] = 'StartTime >= FROM_UNIXTIME('.(strtotime(!empty($_GET['startTimeMin']) ? $_GET['startTimeMin'] : 'now')?:time()).')';

        return parent::handleBrowseRequest($options, $conditions, $responseID, $responseData);
    }
}