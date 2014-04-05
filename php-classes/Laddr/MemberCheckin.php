<?php

namespace Laddr;

class MemberCheckin extends \ActiveRecord
{
    // ActiveRecord configuration
    static public $tableName = 'member_checkins'; // the name of this model's table

    // controllers will use these values to figure out what templates to use
    static public $singularNoun = 'checkin'; // a singular noun for this model's object
    static public $pluralNoun = 'checkins'; // a plural noun for this model's object

    // gets combined with all the extended layers
    static public $fields = array(
        'MemberID' => 'uint'
        ,'ProjectID' => array(
            'type' => 'uint'
            ,'notnull' => false
        )
        ,'MeetupID' => array(
            'type' => 'uint'
            ,'notnull' => false
        )
    );

    static public $relationships = array(
        'Member' => array(
            'type' => 'one-one'
            ,'class' => 'Person'
        )
        ,'Project' => array(
            'type' => 'one-one'
            ,'class' => 'Laddr\Project'
        )
    );

    static public $indexes = array(
        'MeetupMember' => array(
            'fields' => array('MeetupID', 'MemberID')
            ,'unique' => true
        )
    );

    static public function getAllForMeetupByProject($meetupID)
    {
        return static::getAllByField('MeetupID', $meetupID, array('order' => 'ProjectID IS NOT NULL, ProjectID DESC'));
    }
}