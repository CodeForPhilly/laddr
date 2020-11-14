<?php

namespace Laddr;

use ActiveRecord;
use MediaRequestHandler;

class ProjectBuzzRequestHandler extends \RecordsRequestHandler
{
    public static $recordClass = ProjectBuzz::class;
    public static $accountLevelBrowse = false;
    public static $accountLevelWrite = 'User';
    public static $browseOrder = ['Published' => 'DESC'];

    public static function handleBrowseRequest($options = [], $conditions = [], $responseID = null, $responseData = [])
    {
        if (!empty($_GET['ProjectID'])
            && ctype_digit($_GET['ProjectID'])
            && ($Project = Project::getByID($_GET['ProjectID']))
        ) {
            $conditions['ProjectID'] = $Project->ID;
            $responseData['Project'] = $Project;
        }

        return parent::handleBrowseRequest($options, $conditions, $responseID, $responseData);
    }

    public static function checkWriteAccess(ActiveRecord $ProjectUpdate = null, $suppressLogin = false)
    {
        // only allow creating, editing your own, and staff editing
        if (!$ProjectUpdate->isPhantom
            && $ProjectUpdate->CreatorID != $GLOBALS['Session']->PersonID
            && !$GLOBALS['Session']->hasAccountLevel('Staff')
        ) {
            return false;
        }

        if ($ProjectUpdate->isPhantom && !$GLOBALS['Session']->PersonID) {
            return false;
        }

        return true;
    }

    protected static function onRecordSaved(ActiveRecord $Buzz, $requestData)
    {
        parent::onRecordSaved($Buzz, $requestData);

        // attach uploaded images
        MediaRequestHandler::$responseMode = 'return';

        if (!empty($_FILES['image'])) {
            $uploadResponse = MediaRequestHandler::handleUploadRequest([
                'fieldName' => 'image',
                'ContextClass' => 'Buzz',
                'ContextID' => $Buzz->ID,
            ]);

            if ('uploadComplete' == $uploadResponse['responseID']) {
                $Buzz->Image = $uploadResponse['data']['data'];
            }
        }

        $Buzz->save();
    }

    protected static function applyRecordDelta(ActiveRecord $Buzz, $requestData)
    {
        if (isset($requestData['Published']) && is_array($requestData['Published'])) {
            $datetime = trim($requestData['Published']['date'] . ' ' . $requestData['Published']['time']);
            $requestData['Published'] = $datetime ? strtotime($datetime) : null;
        }

        return parent::applyRecordDelta($Buzz, $requestData);
    }
}
