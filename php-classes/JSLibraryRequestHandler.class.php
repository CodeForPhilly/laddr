<?php


class JSLibraryRequestHandler extends RequestHandler
{
    public static $libraryCollection = 'js-library';
    public static $cacheMaxAge = 1800;

    public static function handleRequest()
    {
        // build file path
        $filePath = Site::$pathStack;
        array_unshift($filePath, static::$libraryCollection);

        // try to get node
        $fileNode = Site::resolvePath($filePath);

        if ($fileNode) {
            $fileNode->outputAsResponse();
        } else {
            Site::respondNotFound('Resource not found');
        }
    }
}
