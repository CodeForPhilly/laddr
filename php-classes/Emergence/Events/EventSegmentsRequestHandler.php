<?php

namespace Emergence\Events;


class EventSegmentsRequestHandler extends \RecordsRequestHandler
{
    // RecordRequestHandler configuration
    public static $recordClass = EventSegment::class;
    public static $accountLevelRead = false;
    public static $accountLevelBrowse = false;
    public static $accountLevelWrite = 'Staff';
    public static $browseOrder = ['StartTime'];
}