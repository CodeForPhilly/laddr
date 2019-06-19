<?php



function Dwoo_Plugin_collapse(Dwoo $dwoo, $string)
{
    return preg_replace('/\s+/', ' ', $string);
}

