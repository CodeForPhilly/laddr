<?php

Git::$repositories['emergence-slack'] = [
    'remote' => 'https://github.com/JarvusInnovations/emergence-slack.git',
    'originBranch' => 'master',
    'workingBranch' => 'master',
    'trees' => [
        'html-templates/connectors/slack',
        'php-classes/Emergence/Slack',
        'php-config/Emergence/Slack',
        'php-config/Git.config.d/emergence-slack.php',
        'site-root/connectors/slack.php'
    ]
];