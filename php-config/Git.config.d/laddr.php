<?php

Git::$repositories['laddr'] = [
    'remote' => 'https://github.com/CfABrigadePhiladelphia/laddr.git',
    'originBranch' => 'releases/v2',
    'workingBranch' => 'releases/v2',
    'localOnly' => true,
    'trees' => [
        'event-handlers',
        'html-templates' => [
            'exclude' => [
                '#^/redirects/#' // exclude redirects library
            ]
        ],
        'locales',
        'php-classes' => [
            'exclude' => [
                '#^/ReCaptcha/#', // exclude ReCaptcha library pulled from google repo
                '#^/Emergence/Redirects/#',
                '#^/Emergence/GitHub/#'
            ]
        ],
        'php-config' => [
            'exclude' => [
                '#^/Site.config.d/redirects\.php$#', // exclude redirects library
                '#^/Emergence/GitHub/#'
            ]
        ],
        'php-migrations',
        'site-root' => [
            'exclude' => [
                '#^/redirects\.php$#', // exclude redirects library
                '#^/connectors/github\.php#'
            ]
        ]
    ]
];