<?php

use Emergence\People\User;


User::$relationships['Projects'] = [
    'type' => 'many-many',
    'class' => \Laddr\Project::class,
    'linkClass' => \Laddr\ProjectMember::class,
    'linkForeign' => 'ProjectID',
    'linkLocal' => 'MemberID'
];
User::$dynamicFields[] = 'Projects';

User::$relationships['ProjectMemberships'] = [
    'type' => 'one-many',
    'class' => \Laddr\ProjectMember::class,
    'foreign' => 'MemberID'
];
User::$dynamicFields[] = 'ProjectMemberships';