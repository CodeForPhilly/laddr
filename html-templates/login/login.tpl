{extends "designs/site.tpl"}

{block "title"}Login &mdash; {$dwoo.parent}{/block}


{block "content"}
    <div class="row">
        <div class="col-sm-8 col-sm-offset-2 col-md-6 col-md-offset-3">
            <div class="page-header">
                <h1>{sprintf(_("Login to %s"), Laddr::$siteName|escape)}</h1>
            </div>

            <form method="POST" id="login">

                {if $authException || $error}
                    <div class="well well-sm">
                        <h2>{_ "There were problems with your submission:"}</h2>
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
                        <label for="_LOGIN[username]" class="control-label">{_ "Username"}</label>
                        <input type="text" class="form-control" placeholder="{_ 'Username or email address'}" name="_LOGIN[username]" value="{refill field=_LOGIN.username}" autocorrect="off" autocapitalize="off" autofocus>
                    </div>

                    <div class="form-group">
                        <label for="_LOGIN[password]" class="control-label">{_ "Password"}</label>
                        <input type="password" class="form-control" name="_LOGIN[password]" placeholder="{_ 'Password'}"/>
                    </div>

                    <div class="form-group">
                        <button type="submit" class="btn btn-primary">{_ Login}</button>
                    </div>

                    {capture assign=recoverLink}<a href="/register/recover{tif $.request.return || $.server.SCRIPT_NAME != '/login' ? cat('?return=', escape(default($.request.return, $.server.REQUEST_URI), url))}">{_ "recover your password"}</a>{/capture}
                    {capture assign=registerLink}<a href="/register{tif $.request.return || $.server.SCRIPT_NAME != '/login' ? cat('?return=', escape(default($.request.return, $.server.REQUEST_URI), url))}">{_ "create an account"}</a>{/capture}

                    <p>{sprintf(_('You can %s, or %s now.'), $recoverLink, $registerLink)}</p>
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
        </div>
    </div>
{/block}