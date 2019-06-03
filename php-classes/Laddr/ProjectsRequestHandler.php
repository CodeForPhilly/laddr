<?php

namespace Laddr;

use DB;
use ActiveRecord;
use Emergence\People\User;
use Tag;
use TagItem;

class ProjectsRequestHandler extends \RecordsRequestHandler
{
    public static $recordClass = Project::class;
    public static $accountLevelBrowse = false;
    public static $accountLevelWrite = 'User';
    public static $browseOrder = ['ID' => 'DESC'];

    public static function handleRecordRequest(ActiveRecord $Project, $action = false)
    {
        switch ($action ? $action : $action = static::shiftPath()) {
            case 'add-member':
                return static::handleAddMemberRequest($Project);
            case 'remove-member':
                return static::handleRemoveMemberRequest($Project);
            case 'change-maintainer':
                return static::handleChangeMaintainerRequest($Project);
            case 'updates':
                return static::handleUpdatesRequest($Project);
            case 'comment':
                return static::handleCommentRequest($Project);
            default:
                return parent::handleRecordRequest($Project, $action);
        }
    }

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
                DB::escape(Project::class)
            );
        }

        // apply stage filter
        if (!empty($_REQUEST['stage'])) {
            $conditions['Stage'] = $_REQUEST['stage'];
        }

        $responseData['projectsTotal'] = Project::getCount();
        $responseData['projectsTags']['byTech'] = TagItem::getTagsSummary([
            'tagConditions' => [
                'Handle LIKE "tech.%"'
            ],
            'itemConditions' => [
                'ContextClass' => Project::getStaticRootClass()
            ],
            'limit' => 10
        ]);
        $responseData['projectsTags']['byTopic'] = TagItem::getTagsSummary([
            'tagConditions' => [
                'Handle LIKE "topic.%"'
            ],
            'itemConditions' => [
                'ContextClass' => Project::getStaticRootClass()
            ],'limit' => 10
        ]);
        $responseData['projectsTags']['byEvent'] = TagItem::getTagsSummary([
            'tagConditions' => [
                'Handle LIKE "event.%"'
            ],
            'itemConditions' => [
                'ContextClass' => Project::getStaticRootClass()
            ]
        ]);
        $responseData['projectsStages'] = Project::getStagesSummary();


        return parent::handleBrowseRequest($options, $conditions, $responseID, $responseData);
    }

    public static function handleAddMemberRequest(Project $Project)
    {
        $GLOBALS['Session']->requireAuthentication();

        if (empty($_POST['username'])) {
            return static::throwError(_('Parameter "username" required'));
        }

        if (!$Member = User::getByUsername($_POST['username'])) {
            return static::throwError(_('User not found'));
        }

        $recordData = [
            'ProjectID' => $Project->ID,
            'MemberID' => $Member->ID
        ];

        if (ProjectMember::getByWhere($recordData)) {
            return static::throwError(_('This member is already in this project'));
        }

        $ProjectMember = ProjectMember::create($recordData);

        if (!empty($_POST['role'])) {
            $ProjectMember->Role = $_POST['role'];
        }

        $ProjectMember->save();

        return static::respond('memberAdded', [
            'data' => $ProjectMember,
            'Project' => $Project,
            'Member' => $Member
        ]);
    }

    public static function handleRemoveMemberRequest(Project $Project)
    {
        $GLOBALS['Session']->requireAuthentication();

        if (empty($_REQUEST['username'])) {
            return static::throwError(_('Parameter "username" required'));
        }

        if (!$Member = User::getByUsername($_REQUEST['username'])) {
            return static::throwError(_('User not found'));
        }

        if ($_SERVER['REQUEST_METHOD'] != 'POST') {
            return static::respond('confirm', [
                'question' => sprintf(
                    _('Are you sure you want to remove %s from %s?'),
                    htmlspecialchars($Member->FullName),
                    htmlspecialchars($Project->Title)
                )
            ]);
        }

        $ProjectMember = ProjectMember::getByWhere([
            'ProjectID' => $Project->ID,
            'MemberID' => $Member->ID
        ]);

        if ($ProjectMember) {
            $ProjectMember->destroy();
        }

        return static::respond('memberRemoved', [
            'data' => $ProjectMember,
            'Project' => $Project,
            'Member' => $Member
        ]);
    }

    public static function handleChangeMaintainerRequest(Project $Project)
    {
        $GLOBALS['Session']->requireAuthentication();

        if (empty($_REQUEST['username'])) {
            return static::throwError('Parameter "username" required');
        }

        if (!$Project->Maintainer = User::getByUsername($_REQUEST['username'])) {
            return static::throwError('User not found');
        }

        if ($_SERVER['REQUEST_METHOD'] != 'POST') {
            return static::respond('confirm', [
                'question' => sprintf(
                    _('Are you sure you want to make %s the maintainer of %s?'),
                    htmlspecialchars($Project->Maintainer->FullName),
                    htmlspecialchars($Project->Title)
                )
            ]);
        }

        $Project->save();

        return static::respond('maintainerChanged', [
            'data' => $Project
        ]);
    }

    public static function handleUpdatesRequest(Project $Project)
    {
        if ($updateNumber = static::shiftPath()) {
            $Update = ProjectUpdate::getByWhere([
                'ProjectID' => $Project->ID,
                'Number' => $updateNumber
            ]);

            if (!$Update) {
                return static::throwNotFoundError(_('Update not found'));
            }

            return static::respond('projectUpdate', [
                'data' => $Update
            ]);
        }

        if ($_SERVER['REQUEST_METHOD'] == 'POST') {
            $GLOBALS['Session']->requireAuthentication();

            if (empty($_POST['Body'])) {
                return static::throwError(_('Update body cannot be blank'));
            }

            $Update = ProjectUpdate::create([
                'Project' => $Project,
                'Number' => $Project->NextUpdate++,
                'Body' => $_POST['Body']
            ], true);

            return static::respond('projectUpdateCreated', [
                'data' => $Update
            ]);
        }

        return static::respond('projectUpdates', [
            'data' => $Project->Updates,
            'Project' => $Project
        ]);
    }

    protected static function applyRecordDelta(ActiveRecord $Project, $requestData)
    {
        if (!empty($requestData['ChatChannel']) && $requestData['ChatChannel'][0] == '#') {
            $requestData['ChatChannel'] = substr($requestData['ChatChannel'], 1);
        }

        return parent::applyRecordDelta($Project, $requestData);
    }

    public static function onRecordSaved(\ActiveRecord $Project, $requestData)
    {
        // assign tags
        if (isset($requestData['tags']) && is_array($requestData['tags'])) {
            foreach ($requestData['tags'] as $prefix => $tags) {
                Tag::setTags($Project, $tags, true, $prefix);
            }
        }
    }
}
