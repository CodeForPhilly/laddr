<?php

Git::$repositories['laddr'] = [
    'remote' => 'https://github.com/CfABrigadePhiladelphia/laddr.git',
    'originBranch' => 'releases/v2',
    'workingBranch' => 'releases/v2',
    'localOnly' => true,
    'trees' => [
        'html-templates',
        'locales',
        'php-classes' => [
            'exclude' => '#^/ReCaptcha/#' // exclude ReCaptcha library pulled from google repo
        ],
        'php-config' => [
            'exclude' => '#^/Git\\.config\\.php$#' // don't sync this file
        ],
        'php-migrations',
        'site-root'
    ]
];

Git::$repositories['ReCaptcha'] = [
    'remote' => 'https://github.com/google/recaptcha.git',
    'originBranch' => 'master',
    'workingBranch' => 'master',
    'trees' => [
        'php-classes/ReCaptcha' => 'src/ReCaptcha'
    ]
];
