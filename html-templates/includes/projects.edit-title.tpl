{load_templates subtemplates/contentBlocks.tpl}

{if $Project->isPhantom}
    {$handle = "projects-create-title"}
{else}
    {$handle = "projects-edit-title"}
{/if}

{$ContentBlock = Emergence\CMS\ContentBlock::getByHandle($handle)}

{if $.User->hasAccountLevel('Staff') || ($ContentBlock && $ContentBlock->Content)}
    {if $.User->hasAccountLevel('Staff')}
        {$extraClasses = "alert alert-info"}
    {/if}
    {contentBlock $handle $ContentBlock extraClass="$extraClasses"}
{else}
    <h1>
        {if $Project->isPhantom}
            {_ "Create new project"}
        {else}
            {_("Edit project %s")|sprintf:$Project->Title|escape}
        {/if}
    </h1>
{/if}