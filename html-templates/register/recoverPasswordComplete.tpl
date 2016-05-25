{extends "designs/site.tpl"}

{block title}{_ "Recovery email sent"} &mdash; {$dwoo.parent}{/block}

{block "content"}
    <div class="page-header">
        <h1>{_ "Recovery email sent"}</h1>
    </div>
    
    <p class="lead">{_("We have sent an email to the address supplied when you created your account with a link that will allow you to create a new password. The link will expire after %s hours.")|sprintf:Token::$expirationHours}</p>
{/block}