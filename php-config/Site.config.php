<?php

Site::$debug = true;

Site::$onBeforeScriptExecute = function() {
    Emergence\Locale::loadRequestedLocale();
};