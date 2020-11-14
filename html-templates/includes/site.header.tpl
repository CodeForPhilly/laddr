{load_templates subtemplates/people.tpl}
<nav class="navbar navbar-toggleable-md fixed-top navbar-dark bg-dark navbar-expand-lg" role="navigation">
    <div class="container">

        <a class="navbar-brand" href="/">{include includes/site.brand.tpl}</a>

        <!-- Collect the nav links, forms, and other content for toggling -->
        <div class="collapse navbar-collapse" id="laddr-site-navbar">
            <ul class="nav navbar-nav mr-auto">
                {include includes/site.nav-sitelinks.tpl}
            </ul>

            <form class="inline-form pull-right dropdown dropdown-results site-search js-site-search" role="search" action="/search">
                <div class="input-group">
                    <input type="search" class="form-control" placeholder="{_ Search}" name="q" autocomplete="off">
                </div>

                {*
                <button type="submit" class="btn btn-secondary" >
                    <span class="fa fa-search" aria-hidden="true"></span>
                </button>
                *}
            </form>
            <ul class="nav navbar-nav pull-right">
                {if $.User}
                    <li class="dropdown nav-item">
                        <a class="dropdown-toggle nav-link" data-toggle="dropdown" href="#">{avatar $.User 18} {$.User->FirstName}</a>
                        <div class="dropdown-menu">
                            {include includes/site.nav-userlinks.tpl}
                        </div>
                     </li>
                {else}
                    <li class="nav-item">
                        <a class="nav-link" href="/login?return={$.server.REQUEST_URI|escape:url}">{_ "Login"}</a></li>
                    <li class="nav-item">
                        <a class="nav-link" href="/register?return={$.server.REQUEST_URI|escape:url}">{_ "Sign up"}</a></li>
                {/if}
            </ul>
        </div><!-- /.navbar-collapse -->
        <!-- Brand and toggle get grouped for better mobile display -->
        <button class="navbar-toggler pull-right" type="button" data-toggle="collapse" data-target="#laddr-site-navbar"
                aria-controls="laddr-site-navbar" aria-expanded="false" aria-label="{_ 'Toggle navigation'}">
            <span class="navbar-toggler-icon"></span>
        </button>
    </div><!-- /.container-fluid -->
</nav>
