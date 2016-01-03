{extends "designs/site.tpl"}

{block title}{_ "Recovery email sent"} &mdash; {$dwoo.parent}{/block}

{block "content"}
    <header class="page-header">
        <h2>{_ "Recovery email sent"}</h2>
    </header>

    <p class="lead reading-width">{_("We have sent an email to the address supplied when you created your account with a link that will allow you to create a new password. The link will expire after %s hours.")|sprintf:Token::$expirationHours}</p>
{/block}