<?php

namespace Emergence\Redirects;

class RedirectsRequestHandler extends \RecordsRequestHandler
{
    public static $recordClass = Redirect::class;
    public static $browseOrder = ['ID' => 'DESC'];
}