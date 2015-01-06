<?php

namespace Emergence\People;

#RegistrationRequestHandler::$onRegisterComplete = function(User $User, array $requestData) {
#    // this hook to run after a new user acconut has been registered (the user is waiting though keep things moving!)
#
#    // add new user to a MailChimp list
#    \RemoteSystems\MailChimp::call('lists/subscribe', [
#        'id' => 'YOUR_LIST_ID_HERE', // find your list's id on the MailChimp website under Setting > List name & defaults
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