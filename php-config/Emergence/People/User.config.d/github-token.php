<?php

use Emergence\People\User;


User::$fields['GitHubToken'] = [
    'default' => null,
    'excludeFromData' => true
];