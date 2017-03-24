<?php
//this file should be in /php-classes/RemoteSystems directory of your site
namespace RemoteSystems;


class ListShine
{
    public static $api_key;
    public static $url = 'http://send.listshine.com/api/v1/';
    public $listshine_connection;

    public static function subscribe($email, $list_uuid, $value_array){
         $listshine_connection = new \ListShine\ListShineApi(static::$api_key, static::$url);
         $listshine_connection->subscribeUser($email, $list_uuid, $value_array);
    }
}
