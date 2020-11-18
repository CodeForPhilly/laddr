<?php

$onInitialized = Site::$onInitialized;

Site::$onInitialized = function () use ($onInitialized) {
    if ($redirect = Emergence\Redirects\Redirect::getRedirectForPath(Site::$pathStack)) {
        Site::redirectPermanent($redirect, $_SERVER['QUERY_STRING']);
    }

    if (is_callable($onInitialized)) {
        call_user_func($onInitialized);
    }
};
