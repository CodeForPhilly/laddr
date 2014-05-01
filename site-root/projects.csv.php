<?php

RequestHandler::$responseMode = 'csv';
RequestHandler::respond('projects', array(
    'data' => array_map(function($Project) {
        return array(
            'name' => $Project->Title
            ,'description' => $Project->README
            ,'link_url' => $Project->UsersUrl
            ,'code_url' => $Project->DevelopersUrl
            ,'type' => ''
            ,'categories' =>
                implode(
                    ', ',
                    array_map(
                        function($Tag) {
                            return $Tag->UnprefixedTitle;
                        },
                        array_filter(
                            $Project->Tags,
                            function($Tag) {
                                return $Tag->Prefix == 'topic';
                            }
                        )
                    )
                )
        );
    }, Laddr\Project::getAll())
));