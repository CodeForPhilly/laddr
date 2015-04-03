<?php

Site::$debug = true; // set to true for extended query logging
//Site::$production = true; // set to true for heavy file caching

Site::$autoPull = Site::$hostname != 'v1.laddr.io';

// these resolved paths will skip initializing a user session
Site::$skipSessionPaths[] = 'thumbnail.php';


// uncomment or set to an array of specific hostnames to enable CORS
//Site::$permittedOrigins = '*';


// load locale before scripts execute
Site::$onBeforeScriptExecute = function() {
    Emergence\Locale::loadRequestedLocale();
};