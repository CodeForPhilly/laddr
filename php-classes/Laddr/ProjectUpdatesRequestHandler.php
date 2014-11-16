<?php

namespace Laddr;

class ProjectUpdatesRequestHandler extends \RecordsRequestHandler
{
    public static $recordClass = 'Laddr\ProjectUpdate';
    public static $accountLevelBrowse = false;
    public static $accountLevelWrite = 'User';
    public static $browseOrder = array('ID' => 'DESC');

    public static function handleBrowseRequest($options = array(), $conditions = array(), $responseID = null, $responseData = array())
    {
        if (!empty($_GET['ProjectID']) && ctype_digit($_GET['ProjectID']) && ($Project = Project::getByID($_GET['ProjectID']))) {
            $conditions['ProjectID'] = $Project->ID;
            $responseData['Project'] = $Project;
        }

        return parent::handleBrowseRequest($options, $conditions, $responseID, $responseData);
    }

    public static function checkWriteAccess(\ActiveRecord $ProjectUpdate, $suppressLogin = false)
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

    public static function respond($responseID, $responseData = array(), $responseMode = false)
    {
        if ($responseID == 'projectUpdates' && $_GET['format'] == 'rss') {
            header('Content-Type: application/rss+xml');
            return \Emergence\Dwoo\Engine::respond('projectUpdates.rss', $responseData);
        }

        return parent::respond($responseID, $responseData, $responseMode);
    }
}