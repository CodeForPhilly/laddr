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

    public static function handleRecordsRequest($action = null)
    {
        switch ($action ?: $action = static::shiftPath()) {
            case '*all':
                return static::handleBrowseRequest(['startTime' => 'any']);
            case '*past':
                return static::handleBrowseRequest(['startTime' => 'past', 'order' => ['StartTime' => 'DESC']]);
            case '*upcoming':
                return static::handleBrowseRequest(['startTime' => 'upcoming']);
            default:
                return parent::handleRecordsRequest($action);
        }
    }

    public static function handleBrowseRequest($options = [], $conditions = [], $responseID = null, $responseData = [])
    {
        if (!$GLOBALS['Session']->hasAccountLevel('Staff')) {
            $conditions['Status'] = 'published';
        } elseif (!empty($_GET['status']) && $_GET['status'] != 'any' && in_array($_GET['status'], Event::getFieldOptions('Status', 'values'))) {
            $conditions['Status'] = $_GET['status'];
        }

        switch ($options['startTime']) {
            case 'any':
                break;
            case 'past':
                $conditions[] = '(EndTime IS NULL AND StartTime <= CURRENT_TIMESTAMP) OR (EndTime IS NOT NULL AND EndTime <= CURRENT_TIMESTAMP)';
                break;
            case 'upcoming':
                $conditions[] = '(EndTime IS NULL AND StartTime >= CURRENT_TIMESTAMP) OR (EndTime IS NOT NULL AND EndTime >= CURRENT_TIMESTAMP)';
                break;
            default:
                if (empty($_GET['startTimeMin'])) {
                    $startTimeMin = time();
                } elseif (!$startTimeMin = strtotime($_GET['startTimeMin'])) {
                    return static::throwInvalidRequestError('startTimeMin not parsable');
                }

                $conditions[] = 'StartTime >= FROM_UNIXTIME('.$startTimeMin.')';
                break;
        }


        return parent::handleBrowseRequest($options, $conditions, $responseID, $responseData);
    }

    public static function handleRecordRequest(\ActiveRecord $Event, $action = false)
    {
        switch ($action ?: $action = static::shiftPath()) {
            case 'segments':
                return static::handleSegmentsRequest($Event);
            default:
                return parent::handleRecordRequest($Event, $action);
        }
    }

    public static function handleSegmentsRequest(Event $Event)
    {
        if (!$segmentHandle = static::shiftPath()) {
            return static::respond('eventSegments', [
                'data' => $Event->Segments,
                'total' => count($Event->Segments)
            ]);
        }

        if ($segmentHandle == '!create') {
            return EventSegmentsRequestHandler::handleCreateRequest(EventSegment::create(['Event' => $Event]));
        }

        if (!$Segment = $Event->getSegmentByHandle($segmentHandle)) {
            return EventSegmentsRequestHandler::throwNotFoundError('Segment not found');
        }

        return EventSegmentsRequestHandler::handleRecordRequest($Segment);
    }
}