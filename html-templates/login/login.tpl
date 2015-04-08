{extends "designs/site.tpl"}

{block "title"}Login &mdash; {$dwoo.parent}{/block}


{block "content"}
    <div class="container">
        <div class="span9 offset3">
            <h2>{sprintf(_("Login to %s"), Laddr::$siteName|escape)}</h2>

            <form method="POST" id="login" class="form-horizontal">
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

                {if $authException}
                    <p class="text-error">
                        {sprintf(_("Login Failed: %s"), escape($authException->getMessage()))}
                    </p>
                {elseif $error}
                    <p class="text-error">
                        {sprintf(_("Login Failed: %s"), escape($error))}
                    </p>
                {/if}

                {strip}
                    <div class="control-group">
                        <label for="_LOGIN[username]" class="control-label">{_ "Username"}</label>
                        <div class="controls">
                            <input type="text" placeholder="{_ 'Username or email address'}" name="_LOGIN[username]" value="{refill field=_LOGIN.username}"
                                autocorrect="off" autocapitalize="off">
                        </div>
                    </div>

                    <div class="control-group">
                        <label for="_LOGIN[password]" class="control-label">{_ "Password"}</label>
                        <div class="controls">
                            <input type="password" name="_LOGIN[password]" placeholder="{_ 'Password'}"/>
                        </div>
                    </div>

                    <div class="control-group">
                        <div class="controls">
                            <label class="checkbox" for="_LOGIN[remember]">
                                <input type="checkbox" name="_LOGIN[remember]"/> {_ "Remember me"}
                            </label>
                            <input type="submit" class="btn btn-default btn-sm" value="{_ Login}"/>
                        </div>
                    </div>

                    <div class="control-group">
                        <div class="controls">
                            {capture assign=recoverLink}<a href="/register/recover{tif $.request.return || $.server.SCRIPT_NAME != '/login' ? cat('?return=', escape(default($.request.return, $.server.REQUEST_URI), url))}">{_ "recover your password"}</a>{/capture}
                            {capture assign=registerLink}<a href="/register{tif $.request.return || $.server.SCRIPT_NAME != '/login' ? cat('?return=', escape(default($.request.return, $.server.REQUEST_URI), url))}">{_ "create an account"}</a>{/capture}
                            <p>{sprintf(_('You can %s,<br/>or %s now.'), $recoverLink, $registerLink)}</p>
                        </div>
                    </div>
                {/strip}
            </form>
        </div>
    </div>
{/block}