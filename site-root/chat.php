<?php

if (Laddr::$chatLinker) {
    $url = call_user_func(Laddr::$chatLinker, !empty($_GET['channel']) ? $_GET['channel'] : null);
    Site::redirect($url);
}

RequestHandler::throwError('The administrator of this site has not yet configured Laddr:$chatLinker');