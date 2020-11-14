<?php

use Emergence\People\User;

// can't currently be supported because we're not storing start/end time about meetup events
//User::$relationships['OpenCheckin'] = [
//    'type' => 'one-one',
//    'class' => \Laddr\MemberCheckin::class,
//    'local' => 'ID',
//    'foreign' => 'MemberID',
//    'conditions' => [
//        'OutTime IS NULL'
//    ]
//];
//User::$dynamicFields[] = 'OpenCheckin';

User::$relationships['LastCheckin'] = [
    'type' => 'one-one',
    'class' => \Laddr\MemberCheckin::class,
    'local' => 'ID',
    'foreign' => 'MemberID',
    'order' => [
        'ID' => 'DESC',
    ],
];
User::$dynamicFields[] = 'LastCheckin';

User::$relationships['Checkins'] = [
    'type' => 'one-many',
    'class' => \Laddr\MemberCheckin::class,
    'foreign' => 'MemberID',
];
User::$dynamicFields[] = 'Checkins';
