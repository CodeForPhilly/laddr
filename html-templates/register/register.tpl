{extends "designs/site.tpl"}

{block "title"}Register &mdash; {$dwoo.parent}{/block}

{block js-top}
    {$dwoo.parent}

    {if RemoteSystems\ReCaptcha::$siteKey}
        <script src='https://www.google.com/recaptcha/api.js'></script>
    {/if}
{/block}

{block "content"}
    {$User = $data}
    <form method="POST" id="register">
        {strip}
            <h2>{_("Register with %s")|sprintf:Laddr::$siteName|escape}!</h2>
        
            {if $User->validationErrors}
                <div class="well well-sm">
                    <h3>{_ "There were problems with your submission:"}</h3>
                    <ul>
                        {foreach item=error key=field from=$User->validationErrors}
                            <li class="text-danger">{$field}: {$error|escape}</li>
                        {/foreach}
                    </ul>
                </div>
            {/if}
            
            <div class="form-group">
                <label for="FirstName">{_ "First Name"}</label>
                <input type="text" class="form-control" id="FirstName" name="FirstName" value="{refill field=FirstName}" placeholder="{_ 'Jill'}">
            </div>
            
            <div class="form-group">
                <label for="LastName">{_ "Last Name"}</label>
                <input type="text" class="form-control" id="LastName" name="LastName" value="{refill field=LastName}" placeholder="{_ 'Appleseed'}">
            </div>
            
            <div class="form-group">
                <label for="Email">{_ "Email"}</label>
                <input type="email" class="form-control" id="Email" name="Email" value="{refill field=Email}" placeholder="{_ 'civichacker@example.com'}">
                <p class="help-block">Email address <strong>will</strong> be visible to other signed-in memebers.</p>
            </div>
        
            <div class="form-group">
                <label for="Username">{_ "Username"}</label>
                <input type="text" class="form-control" id="Username" name="Username" value="{refill field=Username}" placeholder="{_ 'CivicHacker'}">
            </div>
            
            <div class="form-group">
                <label for="Password">{_ "Password"}</label>
                <input type="password" class="form-control" id="Password" name="Password" value="{refill field=Password}">
            </div>
            
            <div class="form-group">
                <label for="PasswordConfirm">{_ "Password Confirmation"}</label>
                <input type="password" class="form-control" id="PasswordConfirm" name="PasswordConfirm" value="{refill field=PasswordConfirm}">
            </div>

            {if RemoteSystems\ReCaptcha::$siteKey}
                <div class="form-group g-recaptcha" data-sitekey="{RemoteSystems\ReCaptcha::$siteKey|escape}"></div>
            {/if}

            <div class="form-group">
                <button type="submit" class="btn btn-primary">{_ "Create Account"}</button>
                <p class="help-block">{_ "Already have an account?"} <a href="/login{tif $.request.return ? cat('?return=', escape($.request.return, url))}">{_ "Log in"}</a></p>
            </div>
        {/strip}
    </form>

{/block}