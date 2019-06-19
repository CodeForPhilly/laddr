<?php

namespace Laddr;

class ProfileRequestHandler extends \ProfileRequestHandler
{
    /**
     * True to enable opting into newsletter
     */
    public static $enableNewsletterOptIn = false;

    public static function __classLoaded()
    {
        if (static::$enableNewsletterOptIn
            && !in_array('Newsletter', static::$profileFields)
        ) {
            static::$profileFields[] = 'Newsletter';
        }
    }
}
