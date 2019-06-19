<?php

namespace Laddr;

use HandleBehavior;
use Media;

class ProjectBuzz extends \ActiveRecord
{
    // ActiveRecord configuration
    public static $tableName = 'project_buzz'; // the name of this model's table
    public static $collectionRoute = '/project-buzz';

    // controllers will use these values to figure out what templates to use
    public static $singularNoun = 'project buzz'; // a singular noun for this model's object
    public static $pluralNoun = 'project buzzes'; // a plural noun for this model's object

    // gets combined with all the extended layers
    public static $fields = [
        'ProjectID' => [
            'type' => 'uint',
            'index' => true
        ],
        'Handle' => [
            'type' => 'string',
            'unique' => true
        ],
        'Headline' => 'string',
        'URL' => 'string',
        'Published' => 'timestamp',
        'ImageID' => [
            'type' => 'uint',
            'default' => null
        ],
        'Summary' => [
            'type' => 'clob',
            'default' => null
        ]
    ];

    public static $relationships = [
        'Project' => [
            'type' => 'one-one',
            'class' => Project::class
        ],
        'Image' => [
            'type' => 'one-one',
            'class' => Media::class
        ]
    ];

    public static $validators = [
        'ProjectID' => [
            'validator' => 'number',
            'min' => 1,
            'errorMessage' => 'Please select a project'
        ],
        'Headline' => [
            'errorMessage' => 'Please enter a headline for the buzz'
        ],
        'URL' => [
            'validator' => 'URL',
            'errorMessage' => 'Please enter the URL for the buzz'
        ],
        'Published' => [
            'validator' => 'datetime',
            'errorMessage' => 'Please enter the date/time that the buzz was originally published'
        ]
    ];

    public static $dynamicFields = [
        'Project'
    ];

    public function getTitle()
    {
        return $this->Headline;
    }

    public function validate($deep = true)
    {
        parent::validate($deep);

        HandleBehavior::onValidate($this, $this->_validator);

        // check if URL has already been posted in this project
        if ($this->isFieldDirty('URL') && !$this->_validator->hasErrors('URL') && $this->URL && $this->ProjectID) {
            $duplicateConditions = [
                'ProjectID' => $this->ProjectID,
                'URL' => $this->URL
            ];

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
