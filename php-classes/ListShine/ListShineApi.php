<?php
//this file should be in your /php-classes/ListShine/ directory of your site
namespace ListShine;

    class ListShineApi{

        private $api_key = '';
        private $url = '';

        function __construct($api_key,$url){
            $this->url = $url;
            $this->api_key = $api_key;
        }

        public function subscribeUser($list_id, $email, $info_array){
            $cSession = curl_init();
            $temp_array = array("email"=>"", "firstname"=>"" , "lastname"=>"", "company"=>"", "website"=>"", "phone"=>"","city"=>"", "country" => "", "custom"=>"", "custom2"=>"", "custom3"=>"", "custom4"=>"");
            $temp_array  = array_replace($temp_array, array("email"=>$email), $info_array);
            $post_array = array();
            foreach($temp_array as $key => $value){
                if($value!=null)
                    $post_array[$key] = $value;
            }
            $authorization = "Authorization: Token ". $this->api_key;
            curl_setopt($cSession,CURLOPT_URL,$this->url."escontact/$list_id/");
            curl_setopt($cSession,CURLOPT_RETURNTRANSFER,true);
            curl_setopt($cSession,CURLOPT_HTTPHEADER, array('Content-Type: application/json' , $authorization ));
            curl_setopt($cSession,CURLOPT_HEADER, false);
            curl_setopt($cSession,CURLOPT_POST, true);
            curl_setopt($cSession,CURLOPT_POSTFIELDS, json_encode($post_array));
            $server_output = curl_exec($cSession);
            $server_response = curl_getinfo($cSession);
            curl_close ($cSession);
        }
   }
