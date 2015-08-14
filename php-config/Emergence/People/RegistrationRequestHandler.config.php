<?php

namespace Emergence\People;


#RegistrationRequestHandler::$onRegisterComplete = function(User $User, array $requestData) {
#    // this hook is run after a new user acconut has been registered (the user is waiting though so keep things moving!)
#
#    // add new user to a MailChimp list (see http://forum.laddr.io/t/mailchimp-integration/26)
#    \RemoteSystems\MailChimp::call('lists/subscribe', [
#        'id' => 'YOUR_LIST_ID_HERE',
#        'email' => [
#            'email' => $User->Email
#        ],
#        'merge_vars' => [
#            'FNAME' => $User->FirstName,
#            'LNAME' => $User->LastName
#        ],
#        'double_optin' => false,
#        'replace_interests' => false,
#        'send_welcome' => false
#    ]);
#};



//Uncomment these lines to enabled checking the Captcha, make sure you have set your public/private keys!
#RegistrationRequestHandler::$applyRegistrationData = function($User, $requestData, &$additionalErrors) {
#   //Instantiate Captcha Class
#    $captcha = new \Captcha\Captcha();
#   //Declare Public/Private Keys based on config
#    $captcha->setPrivateKey(\Captcha\Captcha::$captchaPrivateKey);
#    $captcha->setPublicKey(\Captcha\Captcha::$captchaPublicKey);
#   //Check if the user's key is valid    
#if (!$captcha->check()->isValid()) {
#    
#        $additionalErrors['Captcha'] = $captcha->check()->getError();
#    
#    }
#
#};