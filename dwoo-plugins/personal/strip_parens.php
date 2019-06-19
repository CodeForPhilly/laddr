<?php

function Dwoo_Plugin_strip_parens(Dwoo $dwoo, $input)
{
    return trim(preg_replace('/\([^)]*\)/','',$input));
}
