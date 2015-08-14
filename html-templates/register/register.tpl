{extends "designs/site.tpl"}

{block "title"}Register &mdash; {$dwoo.parent}{/block}

{block "content"}
    {$User = $data}
    <form method="POST" id="register">
    {strip}

        <div class="form-horizontal span6 offset3">
            <h2>{_("Register with %s")|sprintf:Laddr::$siteName|escape}!</h2>

            {if $User->validationErrors}
                <h3>{_ "There were problems with your submission:"}</h3>
                <ul class="well text-error">
                {foreach item=error key=field from=$User->validationErrors}
                    <li>{$field}: {$error|escape}</li>
                {/foreach}
                </ul>
            {/if}

            <div class="control-group">
                <label class="control-label">
                    {_ "First Name"}
                </label>
                <div class="controls">
                    <input type="text" name="FirstName" value="{refill field=FirstName}" placeholder="{_ 'Jenny'}">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">
                    {_ "Last Name"}
                </label>
                <div class="controls">
                    <input type="text" name="LastName" value="{refill field=LastName}" placeholder="{_ 'Appleseed'}">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">
                    {_ "Email Address"}
                </label>
                <div class="controls">
                    <input type="email" name="Email" value="{refill field=Email}" placeholder="{_ 'civic.hacker@example.com'}">
                    <div class="muted" id="register-privacy">
                        {_ "Email address <strong>will</strong> be visible to other signed-in members."}
                    </div>
                </div>

            </div>
            <div class="control-group">
                <label class="control-label">
                    {_ "Username"}
                </label>
                <div class="controls">
                    <input type="text" name="Username" value="{refill field=Username}" placeholder="{_ 'CivicHacker'}">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">
                    {_ "Password"}
                </label>
                <div class="controls">
                    <input type="password" name="Password">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">
                    {_ "Password Confirmation"}
                </label>
                <div class="controls">
                    <input type="password" name="PasswordConfirm">
                </div>
            </div>
            <!--Uncomment the following lines to enable recaptcha on the Registration form, you also need to enable it in RegistrationRequestHandler.config.php and Captcha.config.php -->
            <!--
            <div class="control-group">
                <label class="control-label"></label>
                <div class="controls">
                    <div class="g-recaptcha" data-sitekey="{\Captcha\Captcha::$captchaPublicKey}"></div>
                </div>
                </div>
                -->
            <div class="control-group">
                <label class="control-label"></label>
                <div class="controls">
                    <input type="submit" class="btn btn-primary submit" value="{_ 'Create Account'}"><br/><br/>
                    <p class="form-hint">{_ "Already have an account?"} <a href="/login{tif $.request.return ? cat('?return=', escape($.request.return, url))}">{_ "Log in"}</a></p>
                </div>
            </div>
        </div>
    {/strip}
    </form>

{/block}