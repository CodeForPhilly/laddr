<?php

namespace om\Emergence;

use Site;

/**
 * Replace constructor to load table from VFS instead of local path.
 */
class IcalParser extends \om\IcalParser
{
    public function __construct()
    {
        $node = Site::resolvePath('php-classes/om/WindowsTimezones.php');
        $this->windowsTimezones = require $node->RealPath; // load Windows timezones from separate file
    }
}
