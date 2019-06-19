{load_templates subtemplates/personName.tpl}
{load_templates subtemplates/people.tpl}

<section class="user-tools">
    <div class="inner">
    {if $.User}
        <a class="logged-in user-link" href="/profile">{avatar $.User size=16} {personName $.User}</a>
        <a class="log-out-link" href="/logout">Log Out</a>
    {else}
        <a href="/login" id="log-in-link" class="mobile-only">Log In</a>
        {if Emergence\People\RegistrationRequestHandler::$enableRegistration}
            <a href="/register" id="register-link" class="mobile-hidden">Register</a>
        {/if}
        <a href="/register/recover" id="recover-link">Forgot Password</a>
        <form action="/login" method="post" class="mini-login mobile-hidden">
            <fieldset>
                <input type="text" class="text" name="_LOGIN[username]" placeholder="Username or email" id="minilogin-username" autocorrect="off" autocapitalize="off">
                <input type="password" class="text password" name="_LOGIN[password]" placeholder="Password" id="minilogin-password">
                <input type="submit" class="button submit" id="minilogin-submit" value="Log in">
            </fieldset>
        </form>
    {/if}
    </div>
</section>