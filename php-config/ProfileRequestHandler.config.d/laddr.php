<?php

ProfileRequestHandler::$profileFields[] = 'FirstName';
ProfileRequestHandler::$profileFields[] = 'LastName';
ProfileRequestHandler::$profileFields[] = 'Twitter';

ProfileRequestHandler::$onBeforeProfileValidated = function ($User, $profileChanges, $requestData) {
    // trim @ from front of twitter username
    if (isset($profileChanges['Twitter']) && $profileChanges['Twitter'][0] == '@') {
        $User->Twitter = substr($profileChanges['Twitter'], 1);
    }
};

ProfileRequestHandler::$onProfileSaved = function ($User, $profileChanges, $requestData) {
    // assign tags
    if (isset($requestData['tags']) && is_array($requestData['tags'])) {
        foreach ($requestData['tags'] as $prefix => $tags) {
            Tag::setTags($User, $tags, true, $prefix);
        }
    }
};