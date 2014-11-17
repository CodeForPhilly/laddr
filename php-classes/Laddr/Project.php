<?php

namespace Laddr;

use HandleBehavior;

class Project extends \VersionedRecord
{
    // VersionedRecord configuration
    public static $historyTable = 'history_projects'; // the name of this model's history table

    // ActiveRecord configuration
    public static $tableName = 'projects'; // the name of this model's table
    public static $collectionRoute = '/projects';

    // controllers will use these values to figure out what templates to use
    public static $singularNoun = 'project'; // a singular noun for this model's object
    public static $pluralNoun = 'projects'; // a plural noun for this model's object

    // gets combined with all the extended layers
    public static $fields = [
        'Title',
        'Handle' => [
            'type' => 'string',
            'unique' => true
        ],
        'MaintainerID' => [
            'type' => 'uint',
            'notnull' => false
        ],
        'UsersUrl' => [
            'type' => 'string',
            'notnull' => false
        ],
        'DevelopersUrl' => [
            'type' => 'string',
            'notnull' => false
        ],
        'README' => [
            'type' => 'clob',
            'notnull' => false
        ],
        'NextUpdate' => [
            'type' => 'uint',
            'default' => 1
        ]
    ];

    public static $relationships = [
        'Maintainer' => [
            'type' => 'one-one',
            'class' => \Emergence\People\Person::class
        ],
        'Members' => [
            'type' => 'many-many',
            'class' => \Emergence\People\Person::class,
            'linkClass' => ProjectMember::class,
            'linkLocal' => 'ProjectID',
            'linkForeign' => 'MemberID',
            'indexField' => 'ID'
        ],
        'Memberships' => [
            'type' => 'one-many',
            'class' => ProjectMember::class,
            'foreign' => 'ProjectID'
        ],
        'Updates' => [
            'type' => 'one-many',
            'class' => ProjectUpdate::class,
            'foreign' => 'ProjectID',
            'order' => ['ID' => 'DESC']
        ],
        'Comments' => [
            'type' => 'context-children',
            'class' => \Comment::class,
            'order' => ['ID' => 'DESC']
        ],
        'Tags' => [
            'type' => 'many-many',
            'class' => \Tag::class,
            'linkClass' => \TagItem::class,
            'linkLocal' => 'ContextID',
            'conditions' => ['Link.ContextClass = "Laddr\\\\Project"']
        ]
    ];
    
    public static $validators = [
        'Title' => [
            'errorMessage' => 'Project title is required'
        ],
        'UsersUrl' => [
            'validator' => 'url',
            'required' => false,
            'errorMessage' => 'Users\' URL must be blank or a complete and valid URL'
        ],
        'DevelopersUrl' => [
            'validator' => 'url',
            'required' => false,
            'errorMessage' => 'Developers\' URL must be blank or a complete and valid URL'
        ]
    ];

    public function getValue($name)
    {
        switch ($name) {
            case 'TitlePossessive':
                $title = $this->Title;

                if (substr($title, -1) == 's') {
                    return $title . '\'';
                } else {
                    return $title . '\'s';
                }
            default:
                return parent::getValue($name);
        }
    }

    public function save($deep = true)
    {
        HandleBehavior::onSave($this);

        if (!$this->Maintainer) {
            $this->Maintainer = $GLOBALS['Session']->Person;
        }

        parent::save($deep);

        if (!$this->Members) {
            ProjectMember::create([
                'ProjectID' => $this->ID,
                'MemberID' => $this->Maintainer->ID,
                'Role' => 'Founder' // _("Founder") -- placeholder to make this string translatable, actual translation is done during rendering though
            ], true);
        }
    }

    public function hasMember(\Emergence\People\IPerson $Person)
    {
        foreach ($this->Members AS $Member) {
            if ($Member->ID == $Person->ID) {
                return true;
            }
        }

        return false;
    }

    public function getActivity($limit = null)
    {
        $limitSql = is_numeric($limit) ? "LIMIT $limit" : '';

        // retrieve updates and buzz metadata from database
        try {
            $updates = \DB::allRecords(
                'SELECT ID, Class, UNIX_TIMESTAMP(Created) AS Timestamp FROM `%s` WHERE ProjectID = %u ORDER BY Timestamp DESC %s',
                [
                    ProjectUpdate::$tableName,
                    $this->ID,
                    $limitSql
                ]
            );
        } catch (\TableNotFoundException $e) {
            $updates = [];
        }

        try {
            $buzz = \DB::allRecords(
                'SELECT ID, Class, UNIX_TIMESTAMP(Published) AS Timestamp FROM `%s` WHERE ProjectID = %u ORDER BY Timestamp DESC %s',
                [
                    ProjectBuzz::$tableName,
                    $this->ID,
                    $limitSql
                ]
            );
        } catch (\TableNotFoundException $e) {
            $buzz = [];
        }

        // merge, sort, and limit
        $activity = array_merge($updates, $buzz);

        usort($activity, function($a, $b) {
            if ($a['Timestamp'] == $b['Timestamp']) {
                return 0;
            }
            return ($a['Timestamp'] > $b['Timestamp']) ? -1 : 1;
        });

        if ($limit) {
            $activity = array_slice($activity, 0, $limit);
        }

        // convert to instances
        return array_map(
            function($result) {
                return $result['Class']::getByID($result['ID']);
            },
            $activity
        );
    }
}