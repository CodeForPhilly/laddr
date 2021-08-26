<?php

namespace Emergence\Events;

use Emergence\Comments\Comment;
use HandleBehavior;

class Event extends \VersionedRecord
{
    // ActiveRecord configuration
    public static $tableName = 'events'; // the name of this model's table
    public static $collectionRoute = '/events';

    // controllers will use these values to figure out what templates to use
    public static $singularNoun = 'event'; // a singular noun for this model's object
    public static $pluralNoun = 'events'; // a plural noun for this model's object

    public static $fields = [
        'Title',
        'Handle' => [
            'unique' => true,
        ],
        'Status' => [
            'type' => 'enum',
            'values' => ['draft', 'published', 'deleted'],
            'default' => 'published',
        ],
        'StartTime' => [
            'type' => 'datetime',
        ],
        'EndTime' => [
            'type' => 'datetime',
            'default' => null,
        ],
        'LocationName' => [
            'type' => 'string',
            'default' => null,
        ],
        'LocationAddress' => [
            'type' => 'string',
            'default' => null,
        ],
        'Description' => [
            'type' => 'clob',
            'default' => null,
        ],
    ];

    public static $relationships = [
        'Comments' => [
            'type' => 'context-children',
            'class' => Comment::class,
            'order' => ['ID' => 'DESC'],
        ],
        'Segments' => [
            'type' => 'one-many',
            'class' => EventSegment::class,
            'order' => 'StartTime, EndTime IS NOT NULL, EndTime DESC',
        ],
    ];

    public static $searchConditions = [
        'Title' => [
            'qualifiers' => ['any', 'title'],
            'points' => 3,
            'sql' => 'Title Like "%%%s%%"',
        ],
        'Handle' => [
            'qualifiers' => ['any', 'handle'],
            'points' => 3,
            'sql' => 'Handle Like "%%%s%%"',
        ],
        'Description' => [
            'qualifiers' => ['any', 'description'],
            'points' => 1,
            'sql' => 'Description Like "%%%s%%"',
        ],
        'Location' => [
            'qualifiers' => ['any', 'location'],
            'points' => 2,
            'sql' => 'Location Like "%%%s%%"',
        ],
    ];

    public static $dynamicFields = [
        'IsAllDay' => ['getter' => 'getIsAllDay'],
        'IsMultiDay' => ['getter' => 'getIsMultiDay'],
    ];

    public static $validators = [
        'Title' => [
            'errorMessage' => 'Event title is required',
        ],
        'StartTime' => [
            'validator' => 'datetime',
            'errorMessage' => 'Event start time is required',
        ],
        // TODO: validate that EndTime > StartTime if set
    ];

    public function getSegmentByHandle($handle)
    {
        return EventSegment::getByWhere([
            'EventID' => $this->ID,
            'Handle' => $handle,
        ]);
    }

    public function getIsAllDay()
    {
        $start = getdate($this->StartTime);
        $end = getdate($this->EndTime);

        return !$start['hours'] && !$start['minutes'] && !$start['seconds'] && !$end['hours'] && !$end['minutes'] && !$end['seconds'];
    }

    public function getIsMultiDay()
    {
        return $this->EndTime - $this->StartTime > 86400;
    }

    public static function getUpcoming($options = [], $conditions = [])
    {
        $conditions[] = 'EndTime >= CURRENT_TIMESTAMP';
        $conditions['Status'] = 'published';

        $options = array_merge([
            'limit' => is_numeric($options) ? $options : 10,
            'order' => 'StartTime',
        ], is_array($options) ? $options : []);

        return static::getAllByWhere($conditions, $options);
    }

    public static function getUntil($when, $options = [], $conditions = [])
    {
        $conditions[] = 'EndTime >= CURRENT_TIMESTAMP';
        $conditions[] = 'StartTime <= FROM_UNIXTIME('.strtotime($when).')';
        $conditions['Status'] = 'published';

        $options = array_merge([
            'order' => 'StartTime',
        ], is_array($options) ? $options : []);

        return static::getAllByWhere($conditions, $options);
    }

    public function validate($deep = true)
    {
        // call parent
        parent::validate();

        HandleBehavior::onValidate($this, $this->_validator);

        // save results
        return $this->finishValidation();
    }

    public function save($deep = true)
    {
        HandleBehavior::onSave($this);

        // call parent
        parent::save();
    }

    public static function groupEventsByDate(array $events)
    {
        $dateFormat = 'Y-m-d';
        $timeFormat = 'Y-m-d H:i:s';
        $dates = [];
        $oneDay = 3600 * 24;

        foreach ($events as &$Event) {
            $daysSpanned = ($Event->EndTime - $Event->StartTime) / $oneDay;

            for ($daysWritten = 0; $daysWritten < $daysSpanned; ++$daysWritten) {
                if ($daysWritten) {
                    $startTime = strtotime(date($dateFormat, $Event->StartTime + ($daysWritten * $oneDay)));
                } else {
                    $startTime = $Event->StartTime;
                }

                if ($daysWritten == floor($daysSpanned)) {
                    $endTime = $Event->EndTime;
                } else {
                    $endTime = strtotime(date($dateFormat, $startTime + $oneDay));
                }

                $dates[date($dateFormat, $startTime)][] = [
                    'start' => $startTime, 'end' => $endTime, 'Event' => &$Event,
                ];
            }
        }

        return $dates;
    }
}
