<?php

use Emergence\People\User;

User::$relationships['OpenCheckin'] = [
    'type' => 'one-one',
    'class' => \Laddr\MemberCheckin::class,
    'local' => 'ID',
    'foreign' => 'MemberID',
    'conditions' => array(
        'OutTime IS NULL'
    )
];

User::$relationships['LastCheckin'] = [
    'type' => 'one-one',
    'class' => \Laddr\MemberCheckin::class,
    'local' => 'ID',
    'foreign' => 'MemberID',
    'order' => [
        'ID' => 'DESC'
    ]
];

User::$relationships['Checkins'] = [
    'type' => 'one-many',
    'class' => \Laddr\MemberCheckin::class,
    'foreign' => 'MemberID'
];