{extends designs/site.tpl}

{block title}{_ "Project Buzz"} &mdash; {$dwoo.parent}{/block}

{block content}
    <h2>
        <div class="btn-group pull-right">
            <a href="{Laddr\ProjectBuzz::$collectionRoute}/create" class="btn btn-mini btn-primary">{_ "Add Buzz"}</a>
        </div>

        {if $Project}
            {capture assign=projectLink}{projectLink $Project}{/capture}
            {_("Latest Buzz in %s")|sprintf:$projectLink}
        {else}
            {_ "Latest Buzz"}
        {/if}
    </h2>

    {foreach item=Buzz from=$data}
        {projectBuzz $Buzz headingLevel=h3}
    {/foreach}

{/block}