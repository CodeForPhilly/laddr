<?php

namespace RemoteSystems;

class Twitter
{
    public static $siteHandle;
    public static $defaultTweetIntentParams = array(
        'related' => 'codeforamerica'
    );

    public static function getTweetIntentURL($text, $params = array())
    {
        $params = array_merge(static::$defaultTweetIntentParams, array(
            'text' => $text
        ), $params);

        if (static::$siteHandle) {
            $params['via'] = static::$siteHandle;
        }

        return '//twitter.com/intent/tweet/?' . http_build_query($params);
    }
}