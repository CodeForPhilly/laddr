<?php

class Laddr
{
    public static $siteName;
    public static $siteAbbr;
    public static $siteSlogan;
    public static $chatLinker;
    public static $gravatarDefault = 'mm';

    public static function __classLoaded()
    {
        if (empty(static::$siteName)) {
            static::$siteName = Site::getConfig('label') ?: 'Brigade';
        }

        if (empty(static::$siteAbbr)) {
            static::$siteAbbr = preg_replace('/[^A-Z]/', '', static::$siteName);
        }
    }
}
