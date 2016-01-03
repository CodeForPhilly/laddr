{extends "designs/site.tpl"}

{block "title"}Login &mdash; {$dwoo.parent}{/block}


{block "content"}
    <header class="page-header">
        <h2>{sprintf(_("Login to %s"), Laddr::$siteName|escape)}</h2>
    </header>

    <form method="POST" class="form-horizontal" id="login">
        
        {if $authException || $error}
            <div class="well well-sm">
                <h3>{_ "There were problems with your submission:"}</h3>
                <ul>
                    {if $authException}
                        <li class="text-danger">{sprintf(_("Login Failed: %s"), escape($authException->getMessage()))}</li>
                    {/if}
                    {if $error}
                        <li class="text-danger">{sprintf(_("Login Failed: %s"), escape($error))}</li>
                    {/if}
                </ul>
            </div>
        {/if}

        {strip}
            <div class="form-group">
                <label for="_LOGIN[username]" class="col-sm-2 control-label">{_ "Username"}</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" placeholder="{_ 'Username or email address'}" name="_LOGIN[username]" value="{refill field=_LOGIN.username}"
                        autocorrect="off" autocapitalize="off">
                </div>
            </div>

            <div class="form-group">
                <label for="_LOGIN[password]" class="col-sm-2 control-label">{_ "Password"}</label>
                <div class="col-sm-10">
                    <input type="password" class="form-control" name="_LOGIN[password]" placeholder="{_ 'Password'}"/>
                </div>
            </div>

            <div class="form-group">
                <div class="col-sm-offset-2 col-sm-10">
                    <button type="submit" class="btn btn-primary">{_ Login}</button>
                </div>
            </div>

            <div class="form-group">
                {capture assign=recoverLink}<a href="/register/recover{tif $.request.return || $.server.SCRIPT_NAME != '/login' ? cat('?return=', escape(default($.request.return, $.server.REQUEST_URI), url))}">{_ "recover your password"}</a>{/capture}
                {capture assign=registerLink}<a href="/register{tif $.request.return || $.server.SCRIPT_NAME != '/login' ? cat('?return=', escape(default($.request.return, $.server.REQUEST_URI), url))}">{_ "create an account"}</a>{/capture}
                <div class="col-sm-offset-2 col-sm-10">
                    <p>{sprintf(_('You can %s,<br/>or %s now.'), $recoverLink, $registerLink)}</p>
                </div>
            </div>
        {/strip}
        
        {foreach item=value key=name from=$postVars}
            {if is_array($value)}
                {foreach item=subvalue key=subkey from=$value}
                    <input type="hidden" name="{$name|escape}[{$subkey|escape}]" value="{$subvalue|escape}">
                {/foreach}
            {else}
                <input type="hidden" name="{$name|escape}" value="{$value|escape}">
            {/if}
        {/foreach}
        <input type="hidden" name="_LOGIN[returnMethod]" value="{refill field=_LOGIN.returnMethod default=$.server.REQUEST_METHOD}">
        <input type="hidden" name="_LOGIN[return]" value="{refill field=_LOGIN.return default=$.server.REQUEST_URI}">
    </form>
{/block}