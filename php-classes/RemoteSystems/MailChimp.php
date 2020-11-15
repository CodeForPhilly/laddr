<?php

namespace RemoteSystems;

class MailChimp
{
    public static $apiKey;
    public static $defaultTimeout = 10;

    public static $apiInstance;

    public static function getApi()
    {
        if (!static::$apiInstance) {
            static::$apiInstance = new \Drewm\MailChimp(static::$apiKey);
        }

        return static::$apiInstance;
    }

    public static function call($method, $args = [], $timeout = null)
    {
        return static::getApi()->call($method, $args, null === $timeout ? static::$defaultTimeout : 10);
    }
}
