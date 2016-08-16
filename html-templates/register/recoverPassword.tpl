{extends "designs/site.tpl"}

{block "title"}Reset Password &mdash; {$dwoo.parent}{/block}

{block "content"}
    <div class="row">
        <div class="col-sm-8 col-sm-offset-2 col-md-6 col-md-offset-3">
            <div class="page-header">
                <h1>Reset Your Password</h1>
            </div>

            <p>Enter the username or email address associated with your account below, and you will receive an email with instructions to reset your password.</p>

            {if $error}
                <div class="well well-sm">
                    <h2>{_ "There were problems with your submission:"}</h2>
                    <ul>
                        <li class="text-danger">{$error|escape}</li>
                    </ul>
                </div>
            {/if}

            <form method="POST" id="recover-form">
                <div class="form-group">
                    <label for="username">{_ "Email or Username"}</label>
                    <input type="text" class="form-control" placeholder="{_ 'Username or email address'}" name="username" autocorrect="off" autocapitalize="off" autofocus="true" required>
                </div>
                <div class="form-group">
                    <button type="submit" class="btn btn-primary">{_ "Reset Password"}</button>
                </div>
            </form>
        </div>
    </div>
{/block}