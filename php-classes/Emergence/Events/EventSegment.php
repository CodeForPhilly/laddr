<?php

namespace Emergence\Events;

use HandleBehavior;


class EventSegment extends \VersionedRecord
{
    // ActiveRecord configuration
    public static $tableName = 'event_segments'; // the name of this model's table
    public static $collectionRoute = '/event-segments';

    // controllers will use these values to figure out what templates to use
    public static $singularNoun = 'event segment'; // a singular noun for this model's object
    public static $pluralNoun = 'event segments'; // a plural noun for this model's object

    public static $fields = [
        'EventID' => 'uint',
        'Title',
        'Handle',
        'StartTime' => [
            'type' => 'datetime'
        ],
        'EndTime' => [
            'type' => 'datetime'
        ],
        'LocationName' => [
            'type' => 'string',
            'default' => null
        ],
        'LocationAddress' => [
            'type' => 'string',
            'default' => null
        ],
        'Summary' => [
            'type' => 'clob',
            'default' => null
        ],
        'Description' => [
            'type' => 'clob',
            'default' => null
        ]
    ];

    public static $indexes = [
        'EventHandle' => [
            'fields' => ['EventID', 'Handle'],
            'unique' => true
        ]
    ];

    public static $relationships = [
        'Event' => [
            'type' => 'one-one',
            'class' => Event::class
        ]
    ];

    public static $dynamicFields = [
        'Event'
    ];

    public static $validators = [
        'Event' => 'require-relationship',
        'StartTime' => [
            'validator' => 'datetime',
            'errorMessage' => 'Event start time is required'
        ]
        // TODO: validate that EndTime > StartTime if set
    ];

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

    public function getURL($suffix = '/', $params = [])
    {
        $url = $this->Event->getURL();

        if (!$url) {
            return null;
        }

        $url .= '/segments/'.$this->getHandle();

        $suffix = ltrim($suffix, '/');

        if ($suffix) {
            $url .= '/'.$suffix;
        }

        if (!empty($params)) {
            $url .= '?'.http_build_query($params);
        }

        return $url;
    }
}