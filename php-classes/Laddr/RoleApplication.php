<?php

namespace Laddr;

use Emergence\People\Person;


class RoleApplication extends \ActiveRecord
{
    // ActiveRecord configuration
    public static $tableName = 'role_applications'; // the name of this model's table

    // controllers will use these values to figure out what templates to use
    public static $singularNoun = 'role application'; // a singular noun for this model's object
    public static $pluralNoun = 'role applications'; // a plural noun for this model's object

    // gets combined with all the extended layers
    public static $fields = [
        'ProjectID'   => 'uint',
        'PersonID'    => 'uint',
        'RoleID'      => 'uint',
        'Application' => 'string',
        'Status'      => [
            'type' => 'enum',
            'values' => [
                'Pending',
                'Accepted',
                'Rejected'
            ],
            'default' => 'Pending'
        ]
    ];

    public static $relationships = [
        'Project' => [
            'type' => 'one-one',
            'class' => Project::class
        ],
        'Person' => [
            'type' => 'one-one',
            'class' => Person::class
        ],
        'ProjectRole' => [
            'type' => 'one-one',
            'class' => ProjectRole::class
        ]
    ];
    
    public static $indexes = [
        'ProjectRoleApplication' => [
            'fields' => ['ProjectID', 'PersonID', 'RoleID'],
            'unique' => true
        ]
    ];

    public static $dynamicFields = [
        'Project',
        'Person',
        'Role'
    ];
}