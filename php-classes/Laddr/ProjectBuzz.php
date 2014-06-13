<?php

namespace Laddr;

use HandleBehavior;

class ProjectBuzz extends \ActiveRecord
{
    // ActiveRecord configuration
    public static $tableName = 'project_buzz'; // the name of this model's table
    public static $collectionRoute = '/project-buzz';

    // controllers will use these values to figure out what templates to use
    public static $singularNoun = 'project buzz'; // a singular noun for this model's object
    public static $pluralNoun = 'project buzzes'; // a plural noun for this model's object

    // gets combined with all the extended layers
    public static $fields = array(
        'ProjectID' => array(
            'type' => 'uint'
            ,'index' => true
        )
        ,'Handle' => array(
            'type' => 'string'
            ,'unique' => true
        )
        ,'Headline' => 'string'
        ,'URL' => 'string'
        ,'Published' => 'timestamp'
        ,'ImageID' => array(
            'type' => 'uint'
            ,'notnull' => false
        )
        ,'Summary' => array(
            'type' => 'clob'
            ,'notnull' => false
        )
    );

    public static $relationships = array(
        'Project' => array(
            'type' => 'one-one'
            ,'class' => 'Laddr\Project'
        )
        ,'Image' => array(
            'type' => 'one-one'
            ,'class' => 'Media'
        )
    );

    public static $validators = array(
        'ProjectID' => array(
            'validator' => 'number'
            ,'min' => 1
            ,'errorMessage' => 'Please select a project'
        )
        ,'Headline' => array(
            'errorMessage' => 'Please enter a headline for the buzz'
        )
        ,'URL' => array(
            'validator' => 'URL'
            ,'errorMessage' => 'Please enter the URL for the buzz'
        )
        ,'Published' => array(
            'validator' => 'datetime'
            ,'errorMessage' => 'Please enter the date/time that the buzz was originally published'
        )
    );

    public function validate($deep = true)
    {
        parent::validate($deep);

        HandleBehavior::onValidate($this, $this->_validator);

        // check if URL has already been posted in this project
        if ($this->isFieldDirty('URL') && !$this->_validator->hasErrors('URL') && $this->URL && $this->ProjectID) {
            $duplicateConditions = array(
                'ProjectID' => $this->ProjectID
                ,'URL' => $this->URL
            );

            if ($this->ID) {
                $duplicateConditions[] = sprintf('ID != %u', $this->ID);
            }

            if ($this::getByWhere($duplicateConditions)) {
                $this->_validator->addError('URL', _('This URL has already been logged as buzz for this project'));
            }
        }

        return $this->finishValidation();
    }

    public function save($deep = true)
    {
        HandleBehavior::onSave($this, $this->Headline);

        parent::save($deep);
    }
}