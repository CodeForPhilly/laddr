<?php

namespace Laddr;

class ProjectUpdatesRequestHandler extends \RecordsRequestHandler
{
    static public $recordClass = 'Laddr\ProjectUpdate';
    static public $accountLevelBrowse = false;
    static public $accountLevelWrite = 'User';
    static public $browseOrder = array('ID' => 'DESC');

    static public function handleBrowseRequest($options = array(), $conditions = array(), $responseID = null, $responseData = array())
    {
        if (!empty($_GET['ProjectID']) && ctype_digit($_GET['ProjectID']) && ($Project = Project::getByID($_GET['ProjectID']))) {
            $conditions['ProjectID'] = $Project->ID;
            $responseData['Project'] = $Project;
        }
        
        return parent::handleBrowseRequest($options, $conditions, $responseID, $responseData);
    }

    static public function checkWriteAccess(\ActiveRecord $ProjectUpdate, $suppressLogin = false)
    {
        // only allow creating, editing your own, and staff editing
        if (!$ProjectUpdate->isPhantom && ($ProjectUpdate->CreatorID != $GLOBALS['Session']->PersonID) && !$GLOBALS['Session']->hasAccountLevel('Staff')) {
            return false;
        }

        if ($ProjectUpdate->isPhantom && !$GLOBALS['Session']->PersonID) {
            return false;
        }

        return true;
    }
}