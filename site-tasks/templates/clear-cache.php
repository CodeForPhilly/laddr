<?php

return [
    'title' => 'Clear compiled templates cache',
    'description' => 'Erase the entire compiled templates cache, forcing all templates to be recompiled on their next use',
    'icon' => 'eraser',
    'handler' => function () {
        if ($_SERVER['REQUEST_METHOD'] == 'POST') {
            $templateDir = Emergence\Dwoo\Engine::$pathCompile.'/'.Site::getConfig('handle');

            $filesDeleted = intval(exec("find $templateDir -name \"*.d*.php\" -type f -delete -print | wc -l"));

            return static::respond('message', [
                'title' => 'Templates cleared',
                'message' => "Erased $filesDeleted compiled templates"
            ]);
        }

        return static::respond('confirm', [
            'question' => 'Clear entire compiled templates cache?'
        ]);
    }
];