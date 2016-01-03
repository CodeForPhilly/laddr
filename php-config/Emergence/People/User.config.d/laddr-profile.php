<?php

use Emergence\People\User;

User::$fields['Twitter'] = [
    'notnull' => false,
    'unique' => true
];

User::$relationships['Tags'] = [
    'type' => 'many-many',
    'class' => \Tag::class,
    'linkClass' => \TagItem::class,
    'linkLocal' => 'ContextID',
    'conditions' => ['Link.ContextClass = "Emergence\\\\People\\\\Person"']
];

User::$relationships['Comments'] = [
    'type' => 'context-children',
    'class' => \Comment::class,
    'contextClass' => __CLASS__,
    'order' => ['ID' => 'DESC']
];