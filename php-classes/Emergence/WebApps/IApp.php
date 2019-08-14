<?php

namespace Emergence\WebApps;


interface IApp
{
    public static function load($appName);
    public function render();
    public function getName();
    public function getUrl();
    public function buildCssMarkup();
    public function buildJsMarkup();
    public function renderAsset($path);
}