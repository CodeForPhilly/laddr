<?php

use Emergence\People\User;

User::$fields['Twitter'] = [
    'notnull' => false,
    'unique' => true,
];

User::$relationships['Tags'] = [
    'type' => 'many-many',
    'class' => \Tag::class,
    'linkClass' => \TagItem::class,
    'linkLocal' => 'ContextID',
    'conditions' => ['Link.ContextClass = "Emergence\\\\People\\\\Person"'],
];
User::$dynamicFields[] = 'Tags';

User::$relationships['TopicTags'] = [
    'type' => 'many-many',
    'class' => \Tag::class,
    'linkClass' => \TagItem::class,
    'linkLocal' => 'ContextID',
    'conditions' => [
        'Link.ContextClass = "Emergence\\\\People\\\\Person"',
        'Related.Handle LIKE "topic.%"',
    ],
];
User::$dynamicFields[] = 'TopicTags';

User::$relationships['TechTags'] = [
    'type' => 'many-many',
    'class' => \Tag::class,
    'linkClass' => \TagItem::class,
    'linkLocal' => 'ContextID',
    'conditions' => [
        'Link.ContextClass = "Emergence\\\\People\\\\Person"',
        'Related.Handle LIKE "tech.%"',
    ],
];
User::$dynamicFields[] = 'TechTags';

User::$relationships['Comments'] = [
    'type' => 'context-children',
    'class' => \Comment::class,
    'contextClass' => __CLASS__,
    'order' => ['ID' => 'DESC'],
];
