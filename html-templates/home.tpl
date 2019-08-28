{extends designs/site.tpl}

{block js-bottom}
    {$dwoo.parent}
    {jsmin "features/sidebar-checkin.js"}
{/block}

{block content-wrapper}
<main role="main">
    <div class="jumbotron">
        <div class="container-fluid">
            <div class="jumbotron-caption">
                <div class="media">
                    <div class="media-left">
                        <img src="{versioned_url img/logo.png}" class="media-object" height="140" alt="{Laddr::$siteName|escape}">
                    </div>
                    <div class="media-body">
                        <p class="media-heading">{Laddr::$siteSlogan|escape|markdown}</p>
                        <ul class="list-inline">
                            {if $.User}
                                <li class="list-inline-item"><p><a href="/chat" class="btn btn-success">{icon "comment"}&nbsp;{_ "Chat with us on Slack"}</a></p></li>
                            {else}
                                <li class="list-inline-item"><p><a href="/register" class="btn btn-success">{icon "heart"}&nbsp;{_ "Join Us!"}</a></p></li>
                            {/if}
                            <li class="list-inline-item"><p><a href="/projects" class="btn btn-primary">{icon "book"}&nbsp;{_ "Browse Projects"}</a></p></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="container">
        <h1 class="sr-only">{Laddr::$siteName|escape}</h1>
        <div class="row">
            <div class="col-md-8 home-column-main">
                {include includes/home.announcements.tpl}

                {load_templates subtemplates/meetups.tpl}
                {load_templates subtemplates/projects.tpl}
                {load_templates subtemplates/people.tpl}

                {if $currentMeetup}
                    <h2>{_ "Current Meetup"}</h2>
                    <div class="card mb-4">
                        <div class="card-header">
                            {meetup $currentMeetup showRsvp=false}
                        </div>
                        <div class="card-body">
                            <form class="checkin" action="/checkin" method="POST">
                                <div class="form-group">
                                    <input type="hidden" name="MeetupID" value="{$currentMeetup.id}">

                                    {selectField inputName=ProjectID blankOption='Current Project (if any)' options=Laddr\Project::getAll() useKeyAsValue=no default=$Buzz->ProjectID}
                                </div>
                                <input type="submit" value="Check In" class="btn btn-success">
                            </form>

                            {if count($currentMeetup.checkins)}
                            <div class="checkins">
                                <h3>{_ "Checked-in Members"}</h3>

                                {$lastProjectID = false}

                                {foreach item=Checkin from=$currentMeetup.checkins}
                                    {if $Checkin->ProjectID !== $lastProjectID}
                                        {tif !$.foreach.default.first ? '</ul>'}
                                        <h4>
                                        {if $Checkin->Project}
                                            {projectLink $Checkin->Project}
                                        {else}
                                            No Current Project
                                        {/if}
                                        </h4>

                                        {$lastProjectID = $Checkin->ProjectID}

                                        <ul class="row list-unstyled">
                                    {/if}

                                    <li class="col-xs-6 col-sm-4 col-md-3">
                                        {personLink $Checkin->Member photo=yes photoSize=64 linkCls="thumbnail"}
                                    </li>
                                {/foreach}

                                </ul>

                            </div>
                            {/if}

                        </div>
                    </div>
                {/if}

                <h2>{_ "Latest Project Activity"}</h2>

                <ul class="list-inline">
                    <li class="list-inline-item"><a href="/project-updates" class="btn btn-link">{icon "asterisk"} {_ "Browse all project updates"}</a></li>
                    <li class="list-inline-item"><a href="/project-buzz" class="btn btn-link">{icon "flash"} {_ "Browse all project buzz"}</a></li>
                    <li class="list-inline-item"><a href="/blog" class="btn btn-link">{icon "file"} {_ "Browse all blog posts"}</a></li>
                </ul>

{*
                <article class="post card">
                    <div class="card-block">
                        <header class="post-header">
                            <h3 class="post-title">
                                <a href="#">Code for Philly Hack Night</a><small class="text-muted margin-left">{icon "console"}</small>
                            </h3>
                        </header>
                        <div class="update-body">
                            <p>Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vestibulum tortor quam, feugiat vitae, ultricies eget, tempor sit amet, ante. Donec eu libero sit amet quam egestas semper. Aenean ultricies mi vitae est. Mauris placerat eleifend leo.</p>

                            <h4>Projects</h4>
                            <h5><a href="/projects/example_project-4">Example Project</a></h5>
                            <ul class="row list-unstyled">
                                <li class="col-xs-6 col-sm-4 col-md-3"><a href="/people/chris" title="Chris Alfano" class="thumbnail text-center"><img src="//www.gravatar.com/avatar/36b6d909c0c65d4fcdfcc307b84fb06f?s=128&amp;r=g&amp;d=mm" class="avatar " width="64" height="64"><span class="name ">Chris Alfano</span></a></li>
                                <li class="col-xs-6 col-sm-4 col-md-3"><a href="/people/chris" title="Chris Alfano" class="thumbnail text-center"><img src="//www.gravatar.com/avatar/36b6d909c0c65d4fcdfcc307b84fb06f?s=128&amp;r=g&amp;d=mm" class="avatar " width="64" height="64"><span class="name ">Chris Alfano</span></a></li>
                                <li class="col-xs-6 col-sm-4 col-md-3"><a href="/people/kurt" title="Kurt Gawinowicz" class="thumbnail text-center"><img src="//www.gravatar.com/avatar/5d5ff5fd825a914d5057562aec05eb9b?s=128&amp;r=g&amp;d=mm" class="avatar " width="64" height="64"><span class="name ">Kurt Gawinowicz</span></a></li>
                                <li class="col-xs-6 col-sm-4 col-md-3"><a href="/people/kurt" title="Kurt Gawinowicz" class="thumbnail text-center"><img src="//www.gravatar.com/avatar/5d5ff5fd825a914d5057562aec05eb9b?s=128&amp;r=g&amp;d=mm" class="avatar " width="64" height="64"><span class="name ">Kurt Gawinowicz</span></a></li>
                                <li class="col-xs-6 col-sm-4 col-md-3"><a href="/people/chris" title="Chris Alfano" class="thumbnail text-center"><img src="//www.gravatar.com/avatar/36b6d909c0c65d4fcdfcc307b84fb06f?s=128&amp;r=g&amp;d=mm" class="avatar " width="64" height="64"><span class="name ">Chris Alfano</span></a></li>
                                <li class="col-xs-6 col-sm-4 col-md-3"><a href="/people/kurt" title="Kurt Gawinowicz" class="thumbnail text-center"><img src="//www.gravatar.com/avatar/5d5ff5fd825a914d5057562aec05eb9b?s=128&amp;r=g&amp;d=mm" class="avatar " width="64" height="64"><span class="name ">Kurt Gawinowicz</span></a></li>
                            </ul>

                            <h4>New Projects</h4>
                            <ul class="padding-bottom">
                                <li><a href="#">Example Project 2</a></li>
                                <li><a href="#">Example Project 3</a></li>
                                <li><a href="#">Example Project 4</a></li>
                                <li><a href="#">Example Project 5</a></li>
                            </ul>

                            <h4>New Members</h4>
                            <ul class="row list-unstyled">
                                <li class="col-xs-6 col-sm-4 col-md-3"><a href="/people/chris" title="Chris Alfano" class="thumbnail text-center"><img src="//www.gravatar.com/avatar/36b6d909c0c65d4fcdfcc307b84fb06f?s=128&amp;r=g&amp;d=mm" class="avatar " width="64" height="64"><span class="name ">Chris Alfano</span></a></li>
                                <li class="col-xs-6 col-sm-4 col-md-3"><a href="/people/chris" title="Chris Alfano" class="thumbnail text-center"><img src="//www.gravatar.com/avatar/36b6d909c0c65d4fcdfcc307b84fb06f?s=128&amp;r=g&amp;d=mm" class="avatar " width="64" height="64"><span class="name ">Chris Alfano</span></a></li>
                                <li class="col-xs-6 col-sm-4 col-md-3"><a href="/people/kurt" title="Kurt Gawinowicz" class="thumbnail text-center"><img src="//www.gravatar.com/avatar/5d5ff5fd825a914d5057562aec05eb9b?s=128&amp;r=g&amp;d=mm" class="avatar " width="64" height="64"><span class="name ">Kurt Gawinowicz</span></a></li>
                            </ul>

                        </div>
                    </div>
                    <footer class="post-footer card-footer clearfix">
                        <small class="text-muted">{icon "clock-o"}&nbsp;<a href="/blog/lorem_ipsum_dolor_sit_amet"><time datetime="2016-10-05T19:21:00-04:00" title="Wed 05 Oct 2016 07:21:00 PM EDT">5 Oct 2016</time></a></small>
                    </footer>
                </article>
*}

                {foreach item=Article from=$activity}
                    {projectActivity $Article headingLevel=h3 showProject=true}
                {foreachelse}
                    <i>{_ "No project updates have been posted on this site yet."}</i>
                {/foreach}
            </div>
            <div class="col-md-4 home-column-side">
                <aside class="meetups" role="complementary">
                    {include includes/home.meetups.tpl}
                </aside>
                <footer class="footer" role="complementary">
                    {contentBlock "home-footer-side"}
                </footer>
            </div>
        </div>
    </div>
</main>
{/block}
