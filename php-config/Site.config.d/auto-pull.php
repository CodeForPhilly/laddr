<?php

// edit or remove the if conditions to disable autoPull on an descendant site
if ('v2.laddr.us' == Site::$hostname) {
    Site::$autoPull = false;
}
