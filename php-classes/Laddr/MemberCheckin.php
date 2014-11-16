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
    public static $fields = array(
        'MemberID' => 'uint'
        ,'ProjectID' => array(
            'type' => 'uint'
            ,'notnull' => false
        )
        ,'MeetupID' => array(
            'type' => 'string'
            ,'notnull' => false
        )
    );

    public static $relationships = array(
        'Member' => array(
            'type' => 'one-one'
            ,'class' => 'Person'
        )
        ,'Project' => array(
            'type' => 'one-one'
            ,'class' => 'Laddr\Project'
        )
    );

    public static $indexes = array(
        'MeetupMember' => array(
            'fields' => array('MeetupID', 'MemberID')
            ,'unique' => true
        )
    );

    public static function getAllForMeetupByProject($meetupID)
    {
        return static::getAllByField('MeetupID', $meetupID, array('order' => 'ProjectID IS NOT NULL, ProjectID DESC'));
    }
}