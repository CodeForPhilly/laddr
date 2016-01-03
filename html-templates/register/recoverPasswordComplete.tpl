{extends "designs/site.tpl"}

{block title}{_ "Recovery email sent"} &mdash; {$dwoo.parent}{/block}

{block "content"}

    {capture assign=expirationHours}{Token::$expirationHours}{/capture}

    <header class="page-header">
        <h2>{_ "Recovery email sent"}</h2>
	</header>

	<p>{_("We have sent an email to the address supplied when you created your account with a link that will allow you to create a new password. The link will expire after %s hours.")|sprintf:$expirationHours}</p>

{/block}
