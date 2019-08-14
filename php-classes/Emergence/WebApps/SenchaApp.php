<?php

namespace Emergence\WebApps;

use Exception;

use Site;
use Cache;
use JSON;
use Emergence\Site\Response;

class SenchaApp extends App
{
    public static $jsSiteEnvironment = [];
    public static $plugins = [];


    protected $manifest;


    public static function load($name)
    {
        $cacheKey = "sencha-app/{$name}";

        // if (!$manifest = Cache::fetch($cacheKey)) {
            // TODO: create cache clear event
            $manifestNode = Site::resolvePath([static::$buildsRoot, $name, 'app.json']);

            if (!$manifestNode) {
                return null;
            }

            $manifest = json_decode(file_get_contents($manifestNode->RealPath), true);

        //     Cache::store($cacheKey, $manifest);
        // }

        return new static($name, $manifest);
    }


    public function __construct($name, array $manifest)
    {
        parent::__construct($name);

        $this->manifest = $manifest;
    }

    protected static function getPlugins()
    {
        return static::$plugins;
    }

    public function render()
    {
        return new Response('sencha', [
            'app' => $this
        ]);
    }

    public function buildCssMarkup()
    {
        $baseUrl = $this->getUrl();

        $html = [];

        foreach ($this->manifest['css'] as $css) {
            $html[] = '<link rel="stylesheet" href="'.$this->getAssetUrl($css['path']).'"/>';
        }

        return implode(PHP_EOL, $html);
    }

    public function buildJsSiteEnvironment()
    {
        global $Session;

        $jsSiteEnvironment = static::$jsSiteEnvironment;

        $jsSiteEnvironment['user'] = $Session ? JSON::translateObjects($Session->Person) : null;
        $jsSiteEnvironment['appName'] = $this->getName();
        $jsSiteEnvironment['appBaseUrl'] = $this->getUrl();

        return $jsSiteEnvironment;
    }

    public function buildDataMarkup()
    {
        $html = [];

        $html[] = '<script type="text/javascript">';
        $html[] = 'window.SiteEnvironment = window.SiteEnvironment || {}';
        $html[] = 'Object.assign(window.SiteEnvironment, '.json_encode($this->buildJsSiteEnvironment()).');';
        $html[] = '</script>';

        return implode(PHP_EOL, $html);
    }

    public function buildJsMarkup()
    {
        $html = [];

        foreach ($this->manifest['js'] as $js) {
            $html[] = '<script type="text/javascript" src="'.$this->getAssetUrl($js['path']).'"></script>';
        }

        // patch manifest paths
        $html[] = '<script type="text/javascript">';
        $html[] = 'window.Ext = window.Ext || {}';
        $html[] = 'Ext.manifest = Ext.manifest || {}';
        $html[] = 'Ext.manifest.resources = Ext.manifest.resources || {}';
        $html[] = 'Ext.manifest.resources.path = '.json_encode($this->getUrl().'/resources');
        $html[] = '</script>';

        // TODO: migrate away from /app request handler
        foreach ($this->getPlugins() as $packageName) {
            $jsNode = Site::resolvePath(['sencha-workspace', 'packages', $packageName, 'build', "{$packageName}.js"]);

            if (!$jsNode) {
                throw new Exception("build for sencha plugin {$packageName} not found");
            }

            $html[] = "<script type=\"text/javascript\" src=\"/app/packages/{$packageName}/build/{$jsNode->Handle}?_sha1={$jsNode->SHA1}\"></script>";

            $cssNode = Site::resolvePath(['sencha-workspace', 'packages', $packageName, 'build', 'resources', "{$packageName}-all.css"]);

            if ($cssNode) {
                $html[] = "<link rel=\"stylesheet\" type=\"text/css\" href=\"/app/packages/{$packageName}/build/resources/{$cssNode->Handle}?_sha1={$cssNode->SHA1}\">";
            }
        }

        return implode(PHP_EOL, $html);
    }
}
