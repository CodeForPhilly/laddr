{extends "designs/site.tpl"}


{block "content"}
	{$User = $data}

    <header class="page-header">
	    <h2>{$.server.HTTP_HOST} account created</h2>
    </header>
	
	<p>Your username is: <a href="/people/{$User->Username}">{$User->Username|escape}</a></p>
	
	<p>
		Things to do next&hellip;
		<ul>
			{if $.request.return}
			<li><a href="{$.request.return|escape}">Continue back to {$.request.return|escape}</a></li>
			{/if}
			<li><a href="/profile">Fill out your profile and upload a photo</a></li>
		</ul>
	</p>
{/block}
