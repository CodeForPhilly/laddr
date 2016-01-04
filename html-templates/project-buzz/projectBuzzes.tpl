{extends designs/site.tpl}

{block title}{_ "Project Buzz"} &mdash; {$dwoo.parent}{/block}

{block content}

    <header class="page-header">
        <div class="btn-group pull-right">
            <a href="{Laddr\ProjectBuzz::$collectionRoute}/create" class="btn btn-primary">{_ "Add Buzz"}</a>
        </div>

        <h2>
            {if $Project}
                {capture assign=projectLink}{projectLink $Project}{/capture}
                {_("Latest Buzz in %s")|sprintf:$projectLink}
            {else}
                {_ "Latest Buzz"}
            {/if}
        </h2>
    </header>

    {foreach item=Buzz from=$data}
        {projectBuzz $Buzz headingLevel=h3}
    {/foreach}

{/block}