<?php

class Laddr
{
    static public $siteName;
    static public $siteAbbr;
    static public $siteSlogan;

    static function __classLoaded()
    {
        if (empty(static::$siteName)) {
            static::$siteName = Site::getConfig('label');
        }

        if (empty(static::$siteAbbr)) {
            static::$siteAbbr = preg_replace('/[^A-Z]/', '', static::$siteName);
        }
    }
}