<?php

SearchRequestHandler::$searchClasses[Laddr\ProjectUpdate::class] = [
    'fields' => [
        [
            'field' => 'Body',
            'method' => 'like',
        ],
    ],
];
