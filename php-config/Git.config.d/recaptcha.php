<?php

Git::$repositories['ReCaptcha'] = [
    'remote' => 'https://github.com/google/recaptcha.git',
    'originBranch' => 'master',
    'workingBranch' => 'master',
    'trees' => [
        'php-classes/ReCaptcha' => 'src/ReCaptcha'
    ]
];