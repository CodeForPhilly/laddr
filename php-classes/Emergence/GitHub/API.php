<?php

namespace Emergence\GitHub;

class API
{
    public static $clientId;
    public static $clientSecret;
    public static $accessToken;
    public static $baseUrl = 'https://api.github.com';

    public static function getAccessToken()
    {
        return static::$accessToken;
    }

    /**
     * Backwards-compatibility with old method name
     */
    public static function executeRequest($path, array $options = [])
    {
        return static::request($path, $options);
    }


    public static function request($path, array $options = [])
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
            $options['headers'][] = 'Authorization: token ' . (empty($options['accessToken']) ? static::getAccessToken() : $options['accessToken']);
        }

        $options['headers'][] = 'User-Agent: emergence';

        // init url
        $url = preg_match('/^https?:\/\//', $path) ? $path : static::$baseUrl . $path;

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

            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($options['post']));
            $options['headers'][] = 'Content-Type: application/json';
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
}