<?php

namespace Laddr;

class ProjectUpdatesRequestHandler extends \RecordsRequestHandler
{
    static public $recordClass = 'Laddr\ProjectUpdate';
    static public $accountLevelBrowse = false;
    static public $accountLevelWrite = 'User'; // TODO: implement custom write checker that authenticats only project members
    static public $browseOrder = array('ID' => 'DESC');

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