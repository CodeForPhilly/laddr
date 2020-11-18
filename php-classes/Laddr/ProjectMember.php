<?php

namespace Laddr;

use Emergence\People\Person;

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
            'default' => null,
        ],
    ];

    public static $relationships = [
        'Project' => [
            'type' => 'one-one',
            'class' => Project::class,
        ],
        'Member' => [
            'type' => 'one-one',
            'class' => Person::class,
        ],
    ];

    public static $indexes = [
        'ProjectMember' => [
            'fields' => ['ProjectID', 'MemberID'],
            'unique' => true,
        ],
    ];

    public static $dynamicFields = [
        'Project',
        'Member',
    ];
}
