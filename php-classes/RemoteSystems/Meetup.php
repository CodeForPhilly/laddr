<?php

namespace RemoteSystems;

use Cache;

class Meetup
{
    public static $groupUrl;
    public static $signedEventsUrl;
    public static $defaultCacheTime = 1800;
    
    public static function getEventUrl($meetupID)
    {
        if (!static::$groupUrl) {
            return '#';
        }
        
        return sprintf('http://www.meetup.com/%s/events/%u/', static::$groupUrl, $meetupID);
    }

    public static function getEvents($ttl = null)
    {
        if ($ttl === null) {
            $ttl = static::$defaultCacheTime;
        }

        if (!static::$signedEventsUrl) {
            return array();
        }

        $cacheKey = 'meetup/events';

        if (!$data = Cache::fetch($cacheKey)) {
            $data = json_decode(file_get_contents(static::$signedEventsUrl), true);

            if (!empty($data['results'])) {
                Cache::store($cacheKey, $data, $ttl);
            }
        }

        return $data['results'];
    }
}