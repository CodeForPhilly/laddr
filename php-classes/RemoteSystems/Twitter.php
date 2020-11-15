<?php

namespace RemoteSystems;

class Twitter
{
    public static $siteHandle;
    public static $defaultTweetIntentParams = [
        'related' => 'codeforamerica',
    ];

    public static function getTweetIntentURL($text, $params = [])
    {
        $params = array_merge(static::$defaultTweetIntentParams, [
            'text' => $text,
        ], $params);

        if (static::$siteHandle) {
            $params['via'] = static::$siteHandle;
        }

        return '//twitter.com/intent/tweet/?' . http_build_query($params);
    }
}
