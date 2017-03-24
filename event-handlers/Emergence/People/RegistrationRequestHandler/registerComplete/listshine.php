<?php
//this file should be in /event-handlers/People/RegistretationRequestHandler/registerComplete/  directory of your site
if(isset($_POST['Subscribe'])){
  \RemoteSystems\ListShine::subscribe('LIST_UUID',
        $_EVENT['User']->Email, array(
        'firstname'=> $_EVENT['User']->FirstName,
        'lastname' => $_EVENT['User']->LastName
  ));
}
