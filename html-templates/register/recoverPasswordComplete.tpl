{extends "designs/site.tpl"}

{block "app-class"}login{/block}

{block "app-menu"}{/block}


{block "content"}

    <header class="page-header">
        <h2>Recover your password</h2>
	</header>

	<p>We have sent an email to the address supplied when you created your account with a link that will allow you to create a new password. The link will expire after {Token::$expirationHours} hours.</p>

{/block}