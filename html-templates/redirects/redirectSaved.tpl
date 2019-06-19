<?php
$Redirect = $this->scope['data'];
Site::redirect('/redirects', null, "redirect-$Redirect->ID");
?>