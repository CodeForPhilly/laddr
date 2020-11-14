<?php

SearchRequestHandler::$searchClasses[Laddr\Project::class] = [
    'fields' => [
        [
            'field' => 'Title',
            'method' => 'like',
        ],
        [
            'field' => 'Handle',
            'method' => 'like',
        ],
    ],
];
