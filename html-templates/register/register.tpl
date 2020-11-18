{extends "designs/site.tpl"}

{block "title"}{_ 'Register'} &mdash; {$dwoo.parent}{/block}

{block js-top}
    {$dwoo.parent}

    {if RemoteSystems\ReCaptcha::$siteKey}
        <script src='https://www.google.com/recaptcha/api.js'></script>
    {/if}
{/block}

{block "content"}
    {$User = $data}

    <div class="row">
        <div class="col-sm-8 col-sm-offset-2 col-md-6 col-md-offset-3">
            <div class="page-header">
                <h1>{_("Register with %s")|sprintf:Laddr::$siteName|escape}!</h1>
            </div>

            {contentBlock "register-introduction"}

            <form method="POST" id="register">
                {strip}
                    {if $User->validationErrors}
                        <div class="well well-sm">
                            <h2>{_ "There were problems with your submission:"}</h2>
                            <ul>
                                {foreach item=error key=field from=$User->validationErrors}
                                    <li class="text-danger">{$field}: {$error|escape}</li>
                                {/foreach}
                            </ul>
                        </div>
                    {/if}

                    <div class="form-group">
                        <label class="control-label" for="FirstName">{_ "First Name"}</label>
                        <input type="text" class="form-control" id="FirstName" name="FirstName" value="{refill field=FirstName}" placeholder="{_ 'Jill'}" autofocus>
                    </div>

                    <div class="form-group">
                        <label class="control-label" for="LastName">{_ "Last Name"}</label>
                        <input type="text" class="form-control" id="LastName" name="LastName" value="{refill field=LastName}" placeholder="{_ 'Appleseed'}">
                    </div>

                    <div class="form-group">
                        <label class="control-label" for="Email">{_ "Email"}</label>
                        <input type="email" class="form-control" id="Email" name="Email" value="{refill field=Email}" placeholder="{_ 'civichacker@example.com'}" aria-describedby="email-help-block">
                        <p id="email-help-block" class="help-block">{_ "Email address <strong>will</strong> be visible to other signed-in members."}</p>
                    </div>

                    <div class="form-group">
                        <label class="control-label" for="Username">{_ "Username"}</label>
                        <input type="text" class="form-control" id="Username" name="Username" value="{refill field=Username}" placeholder="{_ 'CivicHacker'}">
                    </div>

                    <div class="form-group">
                        <label class="control-label" for="Password">{_ "Password"}</label>
                        <input type="password" class="form-control" id="Password" name="Password" value="{refill field=Password}">
                    </div>

                    <div class="form-group">
                        <label class="control-label" for="PasswordConfirm">{_ "Password Confirmation"}</label>
                        <input type="password" class="form-control" id="PasswordConfirm" name="PasswordConfirm" value="{refill field=PasswordConfirm}">
                    </div>

                    {if RemoteSystems\ReCaptcha::$siteKey}
                        <div class="form-group g-recaptcha" data-sitekey="{RemoteSystems\ReCaptcha::$siteKey|escape}"></div>
                    {/if}

                    <div class="form-group">
                        <p><button type="submit" class="btn btn-primary">{_ "Create Account"}</button></p>
                        <p class="help-block">{_ "Already have an account?"} <a href="/login{tif $.request.return ? cat('?return=', escape($.request.return, url))}">{_ "Log in"}</a></p>
                    </div>
                {/strip}
            </form>
        </div>
    </div>
{/block}
