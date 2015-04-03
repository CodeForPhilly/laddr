<?php

if ($GLOBALS['Session']->hasAccountLevel('User')) {
    SearchRequestHandler::$searchClasses[Emergence\People\User::class] = [
        'fields' => [
            [
                'field' => 'FirstName',
                'method' => 'like'
            ],
            [
                'field' => 'LastName',
                'method' => 'like'
            ],
            [
                'field' => 'Username',
                'method' => 'like'
            ]
        ],
        'conditions' => ['AccountLevel != "Deleted"']
    ];
}

SearchRequestHandler::$searchClasses[Tag::class] = [
    'fields' => [
        'Title',
        [
            'field' => 'Handle',
            'method' => 'like'
        ]
    ]
];

SearchRequestHandler::$searchClasses[Emergence\CMS\Page::class] = [
    'fields' => [
        'Title',
        [
            'field' => 'Handle',
            'method' => 'like'
        ]
    ],
    'conditions' => [
        'Class' => Emergence\CMS\Page::class,
        'Status' => 'Published',
        'Published IS NULL OR Published <= CURRENT_TIMESTAMP'
    ]
];

SearchRequestHandler::$searchClasses[Emergence\CMS\BlogPost::class] = [
    'fields' => [
        'Title',
        [
            'field' => 'Handle',
            'method' => 'like'
        ]
    ]
    ,'conditions' => [
        'Class' => Emergence\CMS\BlogPost::class,
        'Status' => 'Published',
        'Published IS NULL OR Published <= CURRENT_TIMESTAMP'
    ]
];

SearchRequestHandler::$searchClasses[Laddr\Project::class] = [
    'fields' => [
        [
            'field' => 'Title',
            'method' => 'like'
        ],
        [
            'field' => 'Handle',
            'method' => 'like'
        ]
    ]
];

SearchRequestHandler::$searchClasses[Laddr\ProjectBuzz::class] = [
    'fields' => [
        [
            'field' => 'Headline',
            'method' => 'like'
        ],
        [
            'field' => 'Handle',
            'method' => 'like'
        ],
        [
            'field' => 'URL',
            'method' => 'like'
        ],
        [
            'field' => 'Summary',
            'method' => 'like'
        ]
    ]
];

SearchRequestHandler::$searchClasses[Laddr\ProjectUpdate::class] = [
    'fields' => [
        [
            'field' => 'Body',
            'method' => 'like'
        ]
    ]
];