<?php

class Laddr
{
    static public $siteName;
    static public $siteAbbr;
    static public $siteSlogan = 'Making our community a better place to live, work, and play through technology.';

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