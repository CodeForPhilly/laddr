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
    public static $fields = [
        'ProjectID' => 'uint',
        'MemberID' => 'uint',
        'Role' => [
            'type' => 'string',
            'notnull' => false
        ]
    ];

    public static $relationships = [
        'Project' => [
            'type' => 'one-one',
            'class' => 'Laddr\Project'
        ],
        'Member' => [
            'type' => 'one-one',
            'class' => 'Person'
        ]
    ];

    public static $indexes = [
        'ProjectMember' => [
            'fields' => ['ProjectID', 'MemberID'],
            'unique' => true
        ]
    ];
}