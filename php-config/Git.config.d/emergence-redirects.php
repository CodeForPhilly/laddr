<?php

Git::$repositories['emergence-redirects'] = [
    'remote' => 'https://github.com/JarvusInnovations/emergence-redirects.git',
    'originBranch' => 'master',
    'workingBranch' => 'master',
    'trees' => [
        'html-templates/redirects',

        'php-classes/Emergence/Redirects',

        'php-config/Git.config.d/emergence-redirects.php',
        'php-config/Site.config.d/redirects.php',

        'site-root/redirects.php'
    ]
];