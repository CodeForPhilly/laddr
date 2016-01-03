{extends "designs/site.tpl"}

{block "app-class"}login{/block}

{block "app-menu"}{/block}


{block "content"}

    {capture assign=expirationHours}{Token::$expirationHours}{/capture}

    <header class="page-header">
        <h2>{_ "Recover your password"}</h2>
	</header>

	<p>{_("We have sent an email to the address supplied when you created your account with a link that will allow you to create a new password. The link will expire after %s hours.")|sprintf:$expirationHours}</p>

{/block}
