<?php

// TODO: delete/comment this line and use this file to implement a gateway to your group's chat system
return RequestHandler::throwError('The administrator of this site has not yet implemented a redirect to your chat provider');

// $_GET['channel'] may be provided to indicate a specific channel to redirect to

// EXAMPLE 1: Redirect to Slack with authentication provided via SAML Single Sign On
//$GLOBALS['Session']->requireAuthentication();
//Site::redirect('https://codeforphilly.slack.com/sso/saml/start?redir=%2Fmessages%2F'.urlencode(!empty($_GET['channel']) ? $_GET['channel'] : 'general').'%2F');

// EXAMPLE 2: Redirect to Slack without SSO
//Site::redirect('https://codeforphilly.slack.com/messages/'.urlencode(!empty($_GET['channel']) ? $_GET['channel'] : 'general').'/');