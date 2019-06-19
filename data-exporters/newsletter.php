<?php

return [
    'title' => 'Newsletter Subscribers',
    'description' => 'Each row represents a registered user who has not opted out from the newsletter',
    'filename' => 'subscribers',
    'headers' => [
        'Created' => 'Joined',
        'Email',
        'FirstName' => 'First Name',
        'LastName' => 'Last Name'
    ],
    'readQuery' => function (array $input) {
        $query = [];

        return $query;
    },
    'buildRows' => function (array $query = [], array $config = []) {

        // build rows
        try {
            $result = DB::query(
                '
                    SELECT Person.*
                      FROM `%s` Person
                     WHERE Email IS NOT NULL
                       AND Newsletter
                     ORDER BY Created DESC
                ',
                [
                    Person::$tableName
                ]
            );

            while ($record = $result->fetch_assoc()) {
                $Person = Person::instantiateRecord($record);

                yield [
                    'Created' => date('Y-m-d H:i:s', $Person->Created),
                    'Email' => $Person->Email,
                    'FirstName' => $Person->FirstName,
                    'LastName' => $Person->LastName
                ];
            }
        } finally {
            unset($record);
            unset($Person);

            if ($result) {
                $result->free();
            }
            unset($result);
        }
    }
];