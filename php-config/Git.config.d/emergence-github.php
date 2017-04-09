<?php

Git::$repositories['emergence-github'] = [
    'remote' => 'https://github.com/JarvusInnovations/emergence-github.git',
    'originBranch' => 'master',
    'workingBranch' => 'master',
    'trees' => [
        'html-templates/connectors/github',
        'php-classes/Emergence/GitHub',
        'php-config/Emergence/GitHub',
        'php-config/Emergence/People/User.config.d/github-token.php',
        'php-config/Git.config.d/emergence-github.php',
        'php-migrations/Emergence/GitHub',
        'site-root/connectors/github.php'
    ]
];