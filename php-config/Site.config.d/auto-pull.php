<?php

// edit or remove the if conditions to disable autoPull on an descendant site
if (Site::$hostname == 'v2.laddr.us') {
    Site::$autoPull = false;
}