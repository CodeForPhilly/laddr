<?php

namespace Emergence\Site;


abstract class RequestHandler extends \RequestHandler implements IRequestHandler
{
    public static function sendResponse(IResponse $response, $templatePrefix = null)
    {
        $templateId = $response->getId();

        if ($templatePrefix) {
            $templateId = trim($templatePrefix, '/').'/'.$templateId;
        }

        return static::respond($templateId, $response->getPayload(), $response->getMode());
    }
}