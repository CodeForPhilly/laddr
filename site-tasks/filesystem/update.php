<?php

return [
    'title' => 'Update parent tree',
    'description' => 'Scan parent site for updates and deletions to locally cached files to review and pull down',
    'icon' => 'clone',
    'handler' => function () {
        Emergence\Site\RequestHandler::sendResponse(
            Emergence\WebApps\SenchaApp::load('EmergencePullTool')->render(),
            'webapps'
        );
    }
];
