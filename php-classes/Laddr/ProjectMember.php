<?php

namespace Laddr;

class ProjectMember extends \ActiveRecord
{
    // ActiveRecord configuration
    public static $tableName = 'project_members'; // the name of this model's table

    // controllers will use these values to figure out what templates to use
    public static $singularNoun = 'project member'; // a singular noun for this model's object
    public static $pluralNoun = 'project members'; // a plural noun for this model's object

    // gets combined with all the extended layers
    public static $fields = array(
        'ProjectID' => 'uint'
        ,'MemberID' => 'uint'
        ,'Role' => array(
            'type' => 'string'
            ,'notnull' => false
        )
    );

    public static $relationships = array(
        'Project' => array(
            'type' => 'one-one'
            ,'class' => 'Laddr\Project'
        )
        ,'Member' => array(
            'type' => 'one-one'
            ,'class' => 'Person'
        )
#        ,'Request' => array(
#            'type' => 'one-many'
#            ,'class' => 'Request'
#        )
    );

    public static $indexes = array(
        'ProjectMember' => array(
            'fields' => array('ProjectID', 'MemberID')
            ,'unique' => true
        )
    );
}