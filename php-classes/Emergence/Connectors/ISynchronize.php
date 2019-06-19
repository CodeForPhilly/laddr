<?php

namespace Emergence\Connectors;

interface ISynchronize
{
    public static function synchronize(Job $Job, $pretend = true);
}