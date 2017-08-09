<?php

RequestHandler::$responseMode = 'csv';
RequestHandler::respond('projects', array(
    'data' => array_map(function($Project) {
        preg_match('/^\s*[^*#]\s*\w.*/m', $Project->README, $matches);
        return array(
            'name' => $Project->Title
            ,'description' => trim($matches[0])
            ,'link_url' => $Project->UsersUrl
            ,'code_url' => $Project->DevelopersUrl
            ,'chat_channel' => $Project->ChatChannel
            ,'tags' => implode(',',
                    array_map(
                        function($Tag) {
                            return $Tag->UnprefixedTitle;
                        }
                        ,$Project->TopicTags
                    )
                )
            ,'status' => $Project->Stage
        );
    }, Laddr\Project::getAll())
));