<?php

Git::$repositories['laddr'] = [
    'remote' => 'https://github.com/CfABrigadePhiladelphia/laddr.git',
    'originBranch' => 'releases/v2',
    'workingBranch' => 'releases/v2',
    'localOnly' => true,
    'trees' => [
        'event-handlers',
        'html-templates',
        'locales',
        'php-classes' => [
            'exclude' => '#^/ReCaptcha/#' // exclude ReCaptcha library pulled from google repo
        ],
        'php-config',
        'php-migrations',
        'site-root'
    ]
];