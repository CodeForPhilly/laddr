<?php

namespace Emergence\Meetup;

use Cache;
use om\Emergence\IcalParser;

class Connector extends \Emergence\Connectors\AbstractConnector
{
    public static $groupSlug;
    public static $feedCacheTime = 60;

    public static function getUpcomingEvents()
    {
        $groupSlug = static::$groupSlug;
        if (!$groupSlug) {
            return [];
        }

        $cacheKey = "meetup/{$groupSlug}/events";
        $events = Cache::fetch($cacheKey);

        if ($events === null) {
            // cached failure
            throw new Exception('meetup feed unavailable');
        } elseif ($events === false) {
            $cal = new IcalParser();
            $cal->parseFile("https://www.meetup.com/{$groupSlug}/events/ical/");

            $events = [];
            foreach ($cal->getSortedEvents() as $event) {
                $matches = null;
                $events[] = [
                    'id' => preg_match('/^event_(?P<id>\d+)@meetup\\.com$/', $event['UID'], $matches)
                        ? $matches['id']
                        : $event['UID'],
                    'url' => $event['URL'],
                    'title' => $event['SUMMARY'],
                    'description' => $event['DESCRIPTION'],
                    'location' => preg_match('/^(?P<name>.+) \((?P<address>.+)\)$/', $event['LOCATION'], $matches)
                        ? [ 'name' => $matches['name'], 'address' => $matches['address'] ]
                        : [ 'name' => '', 'address' => $event['LOCATION'] ],
                    'time_start' => $event['DTSTART'],
                    'time_end' => $event['DTEND'],
                    'ical' => $event
                ];
            }

            Cache::store($cacheKey, $events, static::$feedCacheTime);
        }

        return $events;
    }

    public static function getUpcomingEvents_Atom()
    {
        $groupSlug = static::$groupSlug;
        if (!$groupSlug) {
            return [];
        }

        $xml = simplexml_load_file("https://www.meetup.com/{$groupSlug}/events/atom/");

        $events = [];

        foreach ($xml->entry as $event) {
            $events[] = [
                'id' => (string)$event->id,
                'name' => (string)$event->title,
                'description' => (string)$event->content,
                'url' => (string)$event->link['href']
            ];
        }

        return $events;
    }
}
