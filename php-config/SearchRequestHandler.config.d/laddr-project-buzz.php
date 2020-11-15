<?php

SearchRequestHandler::$searchClasses[Laddr\ProjectBuzz::class] = [
    'fields' => [
        [
            'field' => 'Headline',
            'method' => 'like',
        ],
        [
            'field' => 'Handle',
            'method' => 'like',
        ],
        [
            'field' => 'URL',
            'method' => 'like',
        ],
        [
            'field' => 'Summary',
            'method' => 'like',
        ],
    ],
];
