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
    public static $fields = array(
        'Title'
        ,'Handle' => array(
            'type' => 'string'
            ,'unique' => true
        )
        ,'MaintainerID' => array(
            'type' => 'uint'
            ,'notnull' => false
        )
        ,'UsersUrl' => array(
            'type' => 'string'
            ,'notnull' => falsea
        )
        ,'DevelopersUrl' => array(
            'type' => 'string'
            ,'notnull' => false
        )
        ,'README' => array(
            'type' => 'clob'
            ,'notnull' => false
        )
        ,'NextUpdate' => array(
            'type' => 'uint'
            ,'default' => 1
        )
    );

    public static $relationships = array(
        'Maintainer' => array(
            'type' => 'one-one'
            ,'class' => 'Person'
        )
        ,'Members' => array(
            'type' => 'many-many'
            ,'class' => 'Person'
            ,'linkClass' => 'Laddr\ProjectMember'
            ,'linkLocal' => 'ProjectID'
            ,'linkForeign' => 'MemberID'
            ,'indexField' => 'ID'
        )
        ,'Memberships' => array(
            'type' => 'one-many'
            ,'class' => 'Laddr\ProjectMember'
            ,'foreign' => 'ProjectID'
        )
        ,'Updates' => array(
            'type' => 'one-many'
            ,'class' => 'Laddr\ProjectUpdate'
            ,'foreign' => 'ProjectID'
            ,'order' => array('ID' => 'DESC')
        )
        ,'Requests' => array(
            'type' => 'one-many'
            ,'class' => 'Request'
        )
        ,'Comments' => array(
            'type' => 'context-children'
            ,'class' => 'Comment'
            ,'order' => array('ID' => 'DESC')
        )
        ,'Tags' => array(
            'type' => 'many-many'
            ,'class' => 'Tag'
            ,'linkClass' => 'TagItem'
            ,'linkLocal' => 'ContextID'
            ,'conditions' => array('Link.ContextClass = "Laddr\\\\Project"')
        )
    );

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
            ProjectMember::create(array(
                'ProjectID' => $this->ID
                ,'MemberID' => $this->Maintainer->ID
                ,'Role' => 'Founder'
            ), true);
        }
    }

    public function validate($deep = true)
    {
        parent::validate($deep);

        HandleBehavior::onValidate($this, $this->_validator);

        $this->_validator->validate(array(
            'field' => 'Title'
            ,'errorMessage' => 'Project title is required'
        ));

        $this->_validator->validate(array(
            'field' => 'UsersUrl'
            ,'validator' => 'url'
            ,'required' => false
            ,'errorMessage' => 'Users\' URL must be blank or a complete and valid URL'
        ));

        $this->_validator->validate(array(
            'field' => 'DevelopersUrl'
            ,'validator' => 'url'
            ,'required' => false
            ,'errorMessage' => 'Developers\' URL must be blank or a complete and valid URL'
        ));

        return $this->finishValidation();
    }

    public function hasMember(\Person $Person)
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
                'SELECT ID, Class, UNIX_TIMESTAMP(Created) AS Timestamp FROM `%s` WHERE ProjectID = %u ORDER BY Timestamp DESC %s'
                ,array(
                    ProjectUpdate::$tableName
                    ,$this->ID
                    ,$limitSql
                )
            );
        } catch (\TableNotFoundException $e) {
            $updates = array();
        }

        try {
            $buzz = \DB::allRecords(
                'SELECT ID, Class, UNIX_TIMESTAMP(Published) AS Timestamp FROM `%s` WHERE ProjectID = %u ORDER BY Timestamp DESC %s'
                ,array(
                    ProjectBuzz::$tableName
                    ,$this->ID
                    ,$limitSql
                )
            );
        } catch (\TableNotFoundException $e) {
            $buzz = array();
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
            }
            ,$activity
        );
    }
}