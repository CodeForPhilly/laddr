{load_templates subtemplates/people.tpl}
<nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
    <div class="container-fluid">

        <!-- Brand and toggle get grouped for better mobile display -->
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#laddr-site-navbar">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="#"> {include includes/site.brand.tpl}</a>
        </div>


        <!-- Collect the nav links, forms, and other content for toggling -->
        <div class="collapse navbar-collapse" id="laddr-site-navbar">
            <ul class="nav navbar-nav">
                {include includes/site.nav-sitelinks.tpl}
            </ul>

            <ul class="nav navbar-nav navbar-right">
                {if $.User}
                    <li class="dropdown">
                        <a class="dropdown-toggle" data-toggle="dropdown" href="#">{avatar $.User 18} {$.User->FirstName} <b class="caret"></b></a>
                        <ul class="dropdown-menu">
                            {include includes/site.nav-userlinks.tpl}
                        </ul>
                     </li>
                {else}
                    <li><a href="/login?return={$.server.REQUEST_URI|escape:url}">{_ "Login"}</a></li>
                    <li><a href="/register?return={$.server.REQUEST_URI|escape:url}">{_ "Sign up"}</a></li>
                {/if}
            </ul>

            <form class="navbar-form navbar-right dropdown dropdown-results site-search" role="search" action="/search">
                <div class="form-group">
                    <input type="search" class="form-control" placeholder="Search" name="q">
                </div>

                {*
                <button type="submit" class="btn btn-default" >
                    <span class="glyphicon glyphicon-search" aria-hidden="true"></span>
                </button>
                *}
            </form>
        </div><!-- /.navbar-collapse -->
    </div><!-- /.container-fluid -->
</nav>