<?php

function Dwoo_Plugin_spacify_caps(Dwoo $dwoo, $text)
{
    return Inflector::spacifyCaps($text);
}