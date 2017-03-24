<?php
//this file should be in /php-classes/RemoteSystems directory of your site
namespace RemoteSystems;


class ListShine
{
    public static $api_key;
    public static $url = 'http://send.listshine.com/api/v1/';
    public static $listshine_connection;

    public static function subscribe($email, $list_uuid, $value_array){
         $random = new \ListShine\ListShineApi(static::$api_key, static::$url);
         $random->subscribeUser($email, $list_uuid, $value_array);
    }
}
