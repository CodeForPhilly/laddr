<?php

namespace Laddr;

class MemberCheckin extends \ActiveRecord
{
    // ActiveRecord configuration
    public static $tableName = 'member_checkins'; // the name of this model's table

    // controllers will use these values to figure out what templates to use
    public static $singularNoun = 'checkin'; // a singular noun for this model's object
    public static $pluralNoun = 'checkins'; // a plural noun for this model's object

    // gets combined with all the extended layers
    public static $fields = [
        'MemberID' => 'uint',
        'ProjectID' => [
            'type' => 'uint',
            'notnull' => false
        ],
        'MeetupID' => [
            'type' => 'string',
            'notnull' => false
        ]
    ];

    public static $relationships = [
        'Member' => [
            'type' => 'one-one',
            'class' => \Emergence\People\Person::class
        ],
        'Project' => [
            'type' => 'one-one',
            'class' => Project::class
        ]
    );

    public static $indexes = [
        'MeetupMember' => [
            'fields' => ['MeetupID', 'MemberID'],
            'unique' => true
        ]
    );

    public static function getAllForMeetupByProject($meetupID)
    {
        return static::getAllByField('MeetupID', $meetupID, ['order' => 'ProjectID IS NOT NULL, ProjectID DESC']);
    }
}