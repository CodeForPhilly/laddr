<?php

namespace Laddr;

use DB;
use Emergence\People\Person;
use Tag;
use TagItem;

class PeopleRequestHandler extends \PeopleRequestHandler
{
    public static $accountLevelBrowse = false;
    public static $browseOrder = ['ID' => 'DESC'];
    public static $browseLimitDefault = 30;

    public static function handleBrowseRequest($options = [], $conditions = [], $responseID = null, $responseData = [])
    {

        // apply tag filter
        if (!empty($_REQUEST['tag'])) {
            // get tag
            if (!$Tag = Tag::getByHandle($_REQUEST['tag'])) {
                return static::throwNotFoundError('Tag not found');
            }

            $conditions[] = sprintf(
                '
                    ID IN (
                        SELECT ContextID
                        FROM tag_items
                        WHERE TagID = %u
                        AND ContextClass = "%s"
                    )
                ',
                $Tag->ID,
                DB::escape(Person::getStaticRootClass())
            );
        }


        $responseData['membersTotal'] = Person::getCount();
        $responseData['membersTags']['byTech'] = TagItem::getTagsSummary([
            'tagConditions' => [
                'Handle LIKE "tech.%"'
            ],
            'itemConditions' => [
                'ContextClass' => Person::getStaticRootClass()
            ],
            'limit' => 10
        ]);
        $responseData['membersTags']['byTopic'] = TagItem::getTagsSummary([
            'tagConditions' => [
                'Handle LIKE "topic.%"'
            ],
            'itemConditions' => [
                'ContextClass' => Person::getStaticRootClass()
            ],
            'limit' => 10
        ]);

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
