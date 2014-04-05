<?php

$path = Site::$pathStack;

array_unshift($path, 'people');

Site::redirectPermanent($path, $_GET);