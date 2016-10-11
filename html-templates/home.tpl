{extends designs/site.tpl}

{block "css"}
    {$dwoo.parent}
    {cssmin "pages/home.css"}
{/block}

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
                        <p class="media-heading">{Laddr::$siteSlogan|escape}</p>
                        <ul class="list-inline">
                            {if $.User}
                                <li><p><a href="/chat" class="btn btn-lg btn-success">{glyph "comment"}&nbsp;{_ "Chat with us on Slack"}</a></p></li>
                            {else}
                                <li><p><a href="/register" class="btn btn-lg btn-success">{glyph "heart"}&nbsp;{_ "Join Us!"}</a></p></li>
                            {/if}
                            <li><p><a href="/projects" class="btn btn-lg btn-primary">{glyph "book"}&nbsp;{_ "Browse Projects"}</a></p></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="container">
        <h1 class="sr-only">Code for [My Town]</h1>
        <div class="row">
            <div class="col-md-8">
                {include includes/home.announcements.tpl}

                {load_templates subtemplates/meetups.tpl}
                {load_templates subtemplates/projects.tpl}
                {load_templates subtemplates/people.tpl}

                {if $currentMeetup}
                    <h2>{_ "Current Meetup"}</h2>
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            {meetup $currentMeetup showRsvp=false}
                        </div>
                        <div class="panel-body">
                            <form class="checkin" action="/checkin" method="POST">
                                <div class="form-group">
                                    <input type="hidden" name="MeetupID" value="{$currentMeetup.id}">
                                    <select name="ProjectID" class="project-picker form-control">
                                        <option value="">Current Project (if any)</option>
                                        {foreach item=Project from=Laddr\Project::getAll()}
                                            <option value="{$Project->ID}">{$Project->Title|escape}</option>
                                        {/foreach}
                                    </select>
                                </div>
                                <input type="submit" value="Check In" class="btn btn-success">
                            </form>
                            <div class="checkins">
                                <h3>{_ "Checked-in Members"}</h3>

                                {$lastProjectID = false}
                                <dl class="checkins-list">
                                    <dt class="checkins-list-title">{_ "No Current Project"}</dt>
                                    {foreach item=Checkin from=$currentMeetup.checkins}
                                        {if $Checkin->Project && $Checkin->ProjectID != $lastProjectID}
                                            <dt class="checkins-list-title">{projectLink $Checkin->Project}</dt>
                                            {$lastProjectID = $Checkin->ProjectID}
                                        {/if}
                                        <dd class="checkins-list-person">{personLink $Checkin->Member photo=yes photoSize=32}</dd>
                                    {/foreach}
                                </dl>
                            </div>
                        </div>
                    </div>
                {/if}

                <h2>{_ "Latest Project Activity"}</h2>

                <ul class="list-inline">
                    <li><a href="/project-updates" class="btn btn-link">{glyph "asterisk"} {_ "Browse all project updates"}</a></li>
                    <li><a href="/project-buzz" class="btn btn-link">{glyph "flash"} {_ "Browse all project buzz"}</a></li>
                    <li><a href="/blog" class="btn btn-link">{glyph "file"} {_ "Browse all blog posts"}</a></li>
                </ul>

                {foreach item=Article from=$activity}
                    {projectActivity $Article headingLevel=h3 showProject=true}
                {foreachelse}
                    <i>{_ "No project updates have been posted on this site yet."}</i>
                {/foreach}
            </div>
            <div class="col-md-4">
                <aside class="meetups" role="complementary">
                    {include includes/home.meetups.tpl}
                </aside>
            </div>
        </div>
    </div>
</main>
{/block}
