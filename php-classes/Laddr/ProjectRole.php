<?php

namespace Laddr;

use Emergence\People\Person;


class ProjectRole extends \ActiveRecord
{
    // ActiveRecord configuration
    public static $tableName = 'project_roles'; // the name of this model's table

    // controllers will use these values to figure out what templates to use
    public static $singularNoun = 'project role'; // a singular noun for this model's object
    public static $pluralNoun = 'project roles'; // a plural noun for this model's object

    // gets combined with all the extended layers
    public static $fields = [
        'ProjectID' => 'uint',
        'PersonID' => [
            'type' =>'uint',
            'default'=>null
        ],
        'Role' => 'string',
        'Description' => [
            'type' =>'string',
            'default'=>null
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
        ]
    ];

    public static $dynamicFields = [
        'Project',
        'Person'
    ];
}
