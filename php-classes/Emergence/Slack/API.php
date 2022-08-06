<?php

namespace Emergence\Slack;

use Cache;


class API
{
    public static $clientId;
    public static $clientSecret;
    public static $verificationToken;
    public static $accessToken;
    public static $baseUrl = 'https://slack.com/api';
    public static $scopes = [
        'channels:read' => true,
        'channels:write' => true,
        'users:read' => true,
        'team:read' => true
    ];

    public static $channelsCacheKey = 'slack/channels';
    public static $channelsCacheTime = 60;

    public static function isAvailable()
    {
        return isset(static::$accessToken);
    }

    public static function getAccessToken()
    {
        return static::$accessToken;
    }

    public static function getScopes()
    {
        return array_keys(array_filter(static::$scopes));
    }

    public static function request($method, array $options = [])
    {
        // init get params
        if (empty($options['get'])) {
            $options['get'] = [];
        }

        // init post params
        if (empty($options['post'])) {
            $options['post'] = [];
        }

        // init headers
        if (empty($options['headers'])) {
            $options['headers'] = [];
        }

        if (empty($options['skipAuth'])) {
            $options['get']['token'] = empty($options['accessToken']) ? static::getAccessToken() : $options['accessToken'];
        }

        $options['headers'][] = 'User-Agent: emergence';

        // init url
        $url = static::$baseUrl . '/' . $method;

        if (!empty($options['get'])) {
            $url .= '?' . http_build_query(array_map(function($value) {
                if (is_bool($value)) {
                    return $value ? 'true' : 'false';
                }

                return $value;
            }, $options['get']));
        }

        // configure curl
        $ch = curl_init($url);

        // configure output
        if (!empty($options['outputPath'])) {
            $fp = fopen($options['outputPath'], 'w');
            curl_setopt($ch, CURLOPT_FILE, $fp);
        } else {
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        }

        // configure method and body
        if (!empty($options['post'])) {
            if (empty($options['method']) || $options['method'] == 'POST') {
                curl_setopt($ch, CURLOPT_POST, true);
            } else {
                curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $options['method']);
            }

            curl_setopt($ch, CURLOPT_POSTFIELDS, $options['post']);
        }

        // configure headers
        curl_setopt($ch, CURLOPT_HTTPHEADER, $options['headers']);

        // execute request
        $result = curl_exec($ch);
        curl_close($ch);

        if (isset($fp)) {
            fclose($fp);
        } elseif (!isset($options['decodeJson']) || $options['decodeJson']) {
            $result = json_decode($result, true);
        }

        return $result;
    }

    public static function getChannels($forceRefresh = false)
    {
        if ($forceRefresh || !($channels = Cache::fetch(static::$channelsCacheKey))) {
            $channelsResponse = static::request('conversations.list');

            if (empty($channelsResponse['channels'])) {
                throw new \Exception('Failed to parse channels response from Slack');
            }

            $channels = $channelsResponse['channels'];

            Cache::store(static::$channelsCacheKey, $channels, static::$channelsCacheTime);
        }

        return $channels;
    }

    public static function getChannelId($name)
    {
        static $map;

        if (!$map) {
            $map = [];

            foreach (static::getChannels() AS $channelData) {
                $map[$channelData['name']] = $channelData['id'];
            }
        }

        return array_key_exists($name, $map) ? $map[$name] : null;
    }
}
