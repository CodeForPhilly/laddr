{load_templates subtemplates/people.tpl}
<nav class="navbar navbar-inverse navbar-fixed-top navbar-site">
    <section class="navbar-inner">
        <div class="container">

            <!-- .btn-navbar is used as the toggle for collapsed navbar content -->
            <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </a>

            <a class="brand" href="/">{Laddr::$siteName|escape}</a>

            <div class="nav-collapse collapse">
                <ul class="nav">
                    {include includes/site.nav-sitelinks.tpl}
                </ul>

                <ul class="nav pull-right">
                    {if $.User}
                        <li class="dropdown">
                            <a class="dropdown-toggle" data-toggle="dropdown" href="#">{avatar $.User 18} {$.User->FirstName} <b class="caret"></b></a>
                            <ul class="dropdown-menu" role="menu">
                                {include includes/site.nav-userlinks.tpl}
                            </ul>
                        </li>
                    {else}
                        <li><a href="/login?return={$.server.REQUEST_URI|escape:url}">Login</a></li>
                        <li><a href="/register?return={$.server.REQUEST_URI|escape:url}">Sign up!</a></li>
                    {/if}
                </ul>
            </div>
        </div>
    </section>
</nav>