<?php

namespace Laddr;

use Comment;
use DB;
use Emergence\People\IPerson;
use Emergence\People\Person;
use HandleBehavior;
use TableNotFoundException;
use Tag;
use TagItem;

class Project extends \VersionedRecord
{
    public static $stageDescriptions = [];

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
            'unique' => true,
        ],
        'MaintainerID' => [
            'type' => 'uint',
            'default' => null,
        ],
        'UsersUrl' => [
            'type' => 'string',
            'default' => null,
        ],
        'DevelopersUrl' => [
            'type' => 'string',
            'default' => null,
        ],
        'README' => [
            'type' => 'clob',
            'default' => null,
        ],
        'NextUpdate' => [
            'type' => 'uint',
            'default' => 1,
        ],
        'Stage' => [
            'type' => 'enum',
            'values' => [
                'Commenting',
                'Bootstrapping',
                'Prototyping',
                'Testing',
                'Maintaining',
                'Drifting',
                'Hibernating',
            ],
            'default' => 'Commenting',
        ],
        'ChatChannel' => [
            'type' => 'string',
            'default' => null,
        ],
    ];

    public static $relationships = [
        'Maintainer' => [
            'type' => 'one-one',
            'class' => Person::class,
        ],
        'Members' => [
            'type' => 'many-many',
            'class' => Person::class,
            'linkClass' => ProjectMember::class,
            'linkLocal' => 'ProjectID',
            'linkForeign' => 'MemberID',
            'indexField' => 'ID',
        ],
        'Memberships' => [
            'type' => 'one-many',
            'class' => ProjectMember::class,
            'foreign' => 'ProjectID',
        ],
        'Updates' => [
            'type' => 'one-many',
            'class' => ProjectUpdate::class,
            'foreign' => 'ProjectID',
            'order' => ['ID' => 'DESC'],
        ],
        'Comments' => [
            'type' => 'context-children',
            'class' => Comment::class,
            'order' => ['ID' => 'DESC'],
        ],
        'Tags' => [
            'type' => 'many-many',
            'class' => Tag::class,
            'linkClass' => TagItem::class,
            'linkLocal' => 'ContextID',
            'conditions' => ['Link.ContextClass = "Laddr\\\\Project"'],
        ],
        'TopicTags' => [
            'type' => 'many-many',
            'class' => Tag::class,
            'linkClass' => TagItem::class,
            'linkLocal' => 'ContextID',
            'conditions' => [
                'Link.ContextClass = "Laddr\\\\Project"',
                'Related.Handle LIKE "topic.%"',
            ],
        ],
        'TechTags' => [
            'type' => 'many-many',
            'class' => Tag::class,
            'linkClass' => TagItem::class,
            'linkLocal' => 'ContextID',
            'conditions' => [
                'Link.ContextClass = "Laddr\\\\Project"',
                'Related.Handle LIKE "tech.%"',
            ],
        ],
        'EventTags' => [
            'type' => 'many-many',
            'class' => Tag::class,
            'linkClass' => TagItem::class,
            'linkLocal' => 'ContextID',
            'conditions' => [
                'Link.ContextClass = "Laddr\\\\Project"',
                'Related.Handle LIKE "event.%"',
            ],
        ],
    ];

    public static $dynamicFields = [
        'Maintainer',
        'Members',
        'Memberships',
        'Tags',
        'TopicTags',
        'TechTags',
        'EventTags',
    ];

    public static $validators = [
        'Title' => [
            'errorMessage' => 'Project title is required',
        ],
        'UsersUrl' => [
            'validator' => 'url',
            'required' => false,
            'errorMessage' => 'Users\' URL must be blank or a complete and valid URL',
        ],
        'DevelopersUrl' => [
            'validator' => 'url',
            'required' => false,
            'errorMessage' => 'Developers\' URL must be blank or a complete and valid URL',
        ],
    ];

    public function getValue($name)
    {
        switch ($name) {
            case 'TitlePossessive':
                $title = $this->Title;

                if ('s' == substr($title, -1)) {
                    return $title . '\'';
                } else {
                    return $title . '\'s';
                }
                // no break
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
                'Role' => 'Founder', // _("Founder") -- placeholder to make this string translatable, actual translation is done during rendering though
            ], true);
        }
    }

    public function hasMember(IPerson $Person)
    {
        foreach ($this->Members as $Member) {
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
            $updates = DB::allRecords(
                '
                    SELECT ID,
                           Class,
                           UNIX_TIMESTAMP(Created) AS Timestamp
                      FROM `%s`
                     WHERE ProjectID = %u
                     ORDER BY Timestamp DESC
                        %s
                ',
                [
                    ProjectUpdate::$tableName,
                    $this->ID,
                    $limitSql,
                ]
            );
        } catch (TableNotFoundException $e) {
            $updates = [];
        }

        try {
            $buzz = DB::allRecords(
                '
                    SELECT ID,
                           Class,
                           UNIX_TIMESTAMP(Published) AS Timestamp
                      FROM `%s`
                     WHERE ProjectID = %u
                     ORDER BY Timestamp DESC
                        %s
                ',
                [
                    ProjectBuzz::$tableName,
                    $this->ID,
                    $limitSql,
                ]
            );
        } catch (TableNotFoundException $e) {
            $buzz = [];
        }

        // merge, sort, and limit
        $activity = array_merge($updates, $buzz);

        usort($activity, function ($a, $b) {
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
            function ($result) {
                return $result['Class']::getByID($result['ID']);
            },
            $activity
        );
    }

    public static function getStagesSummary()
    {
        try {
            $stages = DB::allRecords(
                '
                    SELECT Stage,
                           COUNT(*) AS itemsCount
                      FROM `%s`
                     GROUP BY Stage
                     ORDER BY itemsCount DESC
                ',
                [
                    static::$tableName,
                ]
            );
        } catch (TableNotFoundException $e) {
            $stages = [];
        }

        return $stages;
    }

    public static function getStageDescription($stage = null)
    {
        return $stage ? static::$stageDescriptions[$stage] : static::$stageDescriptions;
    }
}
