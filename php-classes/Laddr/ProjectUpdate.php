<?php

namespace Laddr;

class ProjectUpdate extends \VersionedRecord
{
    // VersionedRecord configuration
    public static $historyTable = 'history_project_updates'; // the name of this model's history table

    // ActiveRecord configuration
    public static $tableName = 'project_updates'; // the name of this model's table
    public static $collectionRoute = '/project-updates';

    // controllers will use these values to figure out what templates to use
    public static $singularNoun = 'project update'; // a singular noun for this model's object
    public static $pluralNoun = 'project updates'; // a plural noun for this model's object

    // gets combined with all the extended layers
    public static $fields = [
        'ProjectID' => [
            'type' => 'uint',
            'index' => true
        ],
        'Number' => 'uint',
        'Body' => 'clob'
    ];

    public static $relationships = [
        'Project' => [
            'type' => 'one-one',
            'class' => Project::class
        ]
    ];

    public static $validators = [
        'Body' => [
            'errorMessage' => 'Update body is required'
        ]
    ];

    public static $dynamicFields = [
        'Project'
    ];

    public function destroy()
    {
        $success = parent::destroy();

        if ($success && ($this->Project->NextUpdate - 1 == $this->Number)) {
            $this->Project->NextUpdate--;
            $this->Project->save();
        }

        return $success;
    }

    public function getTitle()
    {
        return $this->Project->Title . ' Update #' . $this->Number;
    }
}
