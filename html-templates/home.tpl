{extends designs/site.tpl}

{block "css"}
    {$dwoo.parent}
    {cssmin "pages/home.css"}
{/block}

{block js-bottom}
    {$dwoo.parent}
    {jsmin "features/sidebar-tags.js+features/sidebar-checkin.js"}
{/block}

{block header}
    {$dwoo.parent}

    <div class="jumbotron">
        <div class="caption">
            <img src="{versioned_url img/logo.png}" class="logo" alt="{Laddr::$siteName|escape}">
            <p>{Laddr::$siteSlogan|escape}</p>
            <p>
                <a href="{tif $.User ? '/projects' : '/register'}" class="btn btn-lg btn-primary">{glyph "fire"}&nbsp;{_ "Start Hacking"}</a>
                <small>or <a href="/mission">{_ "Learn More"}&hellip;</a></small>
            </p>
        </div>
    </div>
{/block}

{block content-wrapper}
    <div class="container-fluid">
    {block content}

        {template tagLink tagData rootUrl linkCls=""}
            <a class="{$linkCls}" href="{$rootUrl}?tag={$tagData.Handle}">{$tagData.Title}{if $tagData.itemsCount} <span class="badge pull-right">{$tagData.itemsCount|number_format}</span>{/if}</a>
        {/template}

        <nav class="sidebar left">
        <!-- PROJECTS BLOCK -->
            <section class="tagsSummary projects ">
                <h4><a href="/projects">{_ "Projects"} <span class="badge">{$projectsTotal|number_format}</span></a>
                <a class="btn btn-success btn-xs pull-right" href="/projects/create">{glyph "plus"}&nbsp;{_ "Add Project"}</a></h4>

                <header class="btn-group btn-group-justified btn-group-xs" role="group">
                    <a href="#projects-by-topic" class="tagFilter active btn btn-default" role="button" data-group="byTopic">{_ "topics"}</a>
                    <a href="#projects-by-tech" class="tagFilter btn btn-default" role="button" data-group="byTech">{_ "tech"}</a>
                    <a href="#projects-by-event" class="tagFilter btn btn-default" role="button" data-group="byEvent">{_ "events"}</a>
                    <a href="#projects-by-event" class="tagFilter btn btn-default" role="button" data-group="byStage">{_ "stages"}</a>
                </header>

                <div class="tags list-group byTopic">
                    {foreach item=tag from=$projectsTags.byTopic}
                        {tagLink tagData=$tag rootUrl="/projects" linkCls="list-group-item"}
                    {/foreach}
                </div>

                <div class="tags list-group byTech" style="display: none">
                    {foreach item=tag from=$projectsTags.byTech}
                        {tagLink tagData=$tag rootUrl="/projects" linkCls="list-group-item"}
                    {/foreach}
                </div>

                <div class="tags list-group byEvent" style="display: none">
                    {foreach item=tag from=$projectsTags.byEvent}
                        {tagLink tagData=$tag rootUrl="/projects" linkCls="list-group-item"}
                    {/foreach}
                </div>

                <div class="tags list-group byStage" style="display: none">
                    {foreach item=stage from=$projectsStages}
                        <a class="list-group-item" href="/projects?stage={$stage.Stage}">{$stage.Stage} <span class="badge pull-right">{$stage.itemsCount|number_format}</span></a>
                    {/foreach}
                </div>
            </section>

    <!-- MEMBERS BLOCK -->
            <section class="tagsSummary members">
                <h4><a href="/people">{_ "Members"} <span class="badge">{$membersTotal|number_format}</span></a></h4>

                <header class="btn-group btn-group-justified btn-group-xs" role="group">
                    <a href="#members-by-tech" class="tagFilter active btn btn-default" role="button" data-group="byTech">{_ "skills"}</a>
                    <a href="#members-by-project" class="tagFilter btn btn-default" role="button" data-group="byTopic">{_ "projects"}</a>
                </header>

                <div class="tags list-group byTech">
                    {foreach item=tag from=$membersTags.byTech}
                        {tagLink tagData=$tag rootUrl="/people" linkCls="list-group-item"}
                    {/foreach}
                </div>

                <div class="tags list-group byTopic" style="display: none">
                    {foreach item=tag from=$membersTags.byTopic}
                        {tagLink tagData=$tag rootUrl="/people" linkCls="list-group-item"}
                    {/foreach}
                </div>
            </section>

    {*
    <!-- EVENTS BLOCK -->
            <section class="tagsSummary events">
                <h4><a href="/events">Events <span class="badge badge-info">108</span></a></h4>
                <header class="btn-group btn-group-justified btn-group-xs" role="group">
                    <a href="#events-by-date" class="tagFilter active btn btn-default" role="button" data-group="byDate">{_ "dates"}</a>
                    <a href="#events-by-topic" class="tagFilter btn btn-default" role="button" data-group="byTopic">{_ "topics"}</a>
                </header>
                <ul class="tags list-group">
                    <li class="list-group-item"><a href="#">Workshops <span class="badge pull-right">100/3</span></a></li>
                    <li class="list-group-item"><a href="#">Hackathons <span class="badge pull-right">10/4</span></a></li>
                    <li class="list-group-item"><a href="#">Social <span class="badge pull-right">6/3</span></a></li>
                </ul>
            </section>

    <!-- HELP WANTED BLOCK -->
            <section class="tagsSummary wanted">
                <h4><a href="/wanted">Help Wanted <span class="badge badge-info">10</span></a></h4>
                <header class="btn-group btn-group-justified btn-group-xs" role="group">
                    <a href="#wanted-by-tech" class="tagFilter active btn btn-default" role="button" data-group="byTech">{_ "skills"}</a>
                    <a href="#wanted-by-event" class="tagFilter btn btn-default" role="button" data-group="byEvent">{_ "events"}</a>
                    <a href="#wanted-by-topic" class="tagFilter btn btn-default" role="button" data-group="byTopic">{_ "topics"}</a>
                </header>
                <ul class="tags list-group">
                    <li class="list-group-item"><a href="#">PHP <span class="badge pull-right">1</span></a></li>
                    <li class="list-group-item"><a href="#">JS <span class="badge pull-right">2</span></a></li>
                    <li class="list-group-item"><a href="#">Python <span class="badge pull-right">100</span></a></li>
                    <li class="list-group-item"><a href="#">Rails <span class="badge pull-right">42</span></a></li>
                </ul>
            </section>

    <!-- HELP OFFERED BLOCK -->
            <section class="tagsSummary offered">
                <h4><a href="/offered">Help Offered <span class="badge badge-info">8</span></a></h4>
                <header class="btn-group btn-group-justified btn-group-xs" role="group">
                    <a href="#wanted-by-tech" class="tagFilter active btn btn-default" role="button" data-group="byTech">{_ "skills"}</a>
                    <a href="#wanted-by-event" class="tagFilter btn btn-default" role="button" data-group="byEvent">{_ "events"}</a>
                    <a href="#wanted-by-topic" class="tagFilter btn btn-default" role="button" data-group="byTopic">{_ "topics"}</a>
                </header>
                <ul class="tags list-group">
                    <li class="list-group-item"><a href="#">Django <span class="badge pull-right">2</span></a></li>
                    <li class="list-group-item"><a href="#">Node.js <span class="badge pull-right">1</span></a></li>
                </ul>
             </section>
    *}

        {* include includes/home.resources.tpl *}
        </nav>

        <aside class="sidebar right meetups">
            {include includes/home.meetups.tpl}
        </aside>

        <main class="fixed-fixed">
            {include includes/home.announcements.tpl}

            <header class="page-header">
                <h2>{_ "Latest Project Activity"}</h2>
            </header>

            <div class="row-fluid">
                {foreach item=Article from=$activity}
                    {projectActivity $Article headingLevel=h3 showProject=true}
                {foreachelse}
                    <em>{_ "No project updates have been posted on this site yet."}</em>
                {/foreach}
            </div> <!-- .row-fluid -->

            <div>
                <a href="/project-updates" class="btn btn-link">{glyph "asterisk"} {_ "Browse all project updates"}</a>
                <a href="/project-buzz" class="btn btn-link">{glyph "flash"} {_ "Browse all project buzz"}</a>
                <a href="/blog" class="btn btn-link">{glyph "file"} {_ "Browse all blog posts"}</a>
            </div> <!-- .row-fluid -->
    </main>

    {/block}
    </div>
{/block}