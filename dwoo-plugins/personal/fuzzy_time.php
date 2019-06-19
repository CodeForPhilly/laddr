<?php

// Gracias http://blog.thetonk.com/archives/fuzzy-time and Andrew Collington

function Dwoo_Plugin_fuzzy_time(Dwoo $dwoo, $time)
{
    return Format::fuzzyTime($time);
}