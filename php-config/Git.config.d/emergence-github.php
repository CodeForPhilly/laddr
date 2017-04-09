<?php

Git::$repositories['emergence-github'] = [
    'remote' => 'https://github.com/JarvusInnovations/emergence-github.git',
    'originBranch' => 'master',
    'workingBranch' => 'master',
    'trees' => [
        'php-classes/Emergence/GitHub',
        'php-config/Emergence/GitHub',
        'php-config/Git.config.d/emergence-github.php',
        'site-root/connectors/github.php'
    ]
];