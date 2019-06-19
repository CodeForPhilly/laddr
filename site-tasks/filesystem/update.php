<?php

return [
    'title' => 'Update parent tree',
    'description' => 'Scan parent site for updates and deletions to locally cached files to review and pull down',
    'icon' => 'clone',
    'handler' => function () {
        Sencha_RequestHandler::respond('app/ext', [
            'App' => Sencha_App::getByName('EmergencePullTool'),
            'mode' => 'production'
        ]);
    }
];