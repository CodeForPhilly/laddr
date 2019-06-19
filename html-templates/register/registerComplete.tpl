{extends "designs/site.tpl"}

{block title}{_ "Registration complete"} &mdash; {$dwoo.parent}{/block}

{block "content"}
    {$User = $data}

    <header class="page-header">
        <h2>{_ "Registration complete"}</h2>
    </header>

    {capture assign=personLink}<a href="{$User->getUrl()|escape}">{$User->Username|escape}</a>{/capture}
    <p class="lead">{"Your username for %s is: %s"|_|sprintf:Laddr::$siteName:$personLink}</p>

    <p>
        {_ "Things to do next…"}
        <ul>
            {if $.request.return}
                <li><a href="{$.request.return|escape}">{"Continue back to %s"|_|sprintf:$.request.return|escape}</a></li>
            {/if}

            {if Laddr::$chatLinker}
                <li><a href="/chat">{_ "Join the community chatrooms"}</a></li>
            {/if}

            <li><a href="/profile">{_ "Fill out your profile and upload a photo"}</a></li>
        </ul>
    </p>
{/block}