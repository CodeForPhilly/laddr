<?php

namespace Laddr;

use Tag;

class PeopleRequestHandler extends \PeopleRequestHandler
{
    public static $accountLevelBrowse = false;
    public static $browseOrder = array('ID' => 'DESC');

    public static function handleBrowseRequest($options = [], $conditions = [], $responseID = null, $responseData = [])
    {
        // apply tag filter
        if (!empty($_REQUEST['tag'])) {
            // get tag
            if (!$Tag = Tag::getByHandle($_REQUEST['tag'])) {
                return static::throwNotFoundError('Tag not found');
            }

            $conditions[] = 'ID IN (SELECT ContextID FROM tag_items WHERE TagID = '.$Tag->ID.' AND ContextClass = "Person")';
        }

        return parent::handleBrowseRequest($options, $conditions, $responseID, $responseData);
    }

    public static function handleRecordRequest(\ActiveRecord $Member, $action = false)
    {
        switch ($action ? $action : $action = static::shiftPath()) {
            case 'comment':
                return static::handleCommentRequest($Member);
            default:
                return parent::handleRecordRequest($Member, $action);
        }
    }
}