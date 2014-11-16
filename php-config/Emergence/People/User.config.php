<?php

use Emergence\People\User;

User::$fields['Twitter'] = [
    'notnull' => false,
    'unique' => true
];

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

User::$relationships['Tags'] = [
    'type' => 'many-many',
    'class' => \Tag::class,
    'linkClass' => \TagItem::class,
    'linkLocal' => 'ContextID',
    'conditions' => ['Link.ContextClass = "Person"']
];

User::$relationships['Comments'] = [
    'type' => 'context-children',
    'class' => \Comment::class,
    'contextClass' => __CLASS__,
    'order' => ['ID' => 'DESC']
];

User::$relationships['Projects'] = [
    'type' => 'many-many',
    'class' => \Laddr\Project::class,
    'linkClass' => \Laddr\ProjectMember::class,
    'linkForeign' => 'ProjectID',
    'linkLocal' => 'MemberID'
];

User::$relationships['ProjectMemberships'] = [
    'type' => 'one-many',
    'class' => \Laddr\ProjectMember::class,
    'foreign' => 'MemberID'
];