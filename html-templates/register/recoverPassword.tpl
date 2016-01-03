{extends "designs/site.tpl"}

{block "title"}Reset Password &mdash; {$dwoo.parent}{/block}

{block "content"}
    
	<header class="page-header">
        <h2>Reset Your Password</h2>
    </header>

	<p>Enter the username or email address associated with your account below, and you will receive an email with instructions to reset your password.</p>

	{if $error}
        <div class="well well-sm">
            <h3>{_ "There were problems with your submission:"}</h3>
            <ul>
		        <li class="text-danger">{$error|escape}</li>
            </ul>
        </div>
	{/if}
	
    <form method="POST" class="form-horizontal" id="recover-form">
        <div class="form-group">
            <label for="username" class="col-sm-3 control-label">{_ "Email or Username"}</label>
            <div class="col-sm-9">
                <input type="text" class="form-control" placeholder="{_ 'Username or email address'}" name="username"
                    autocorrect="off" autocapitalize="off" autofocus="true" required>
            </div>
        </div>
        
        <div class="form-group">
            <div class="col-sm-offset-3 col-sm-9">
                <button type="submit" class="btn btn-primary">{_ "Reset Password"}</button>
            </div>
        </div>
	</form>
{/block}