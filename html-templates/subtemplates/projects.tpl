{load_templates subtemplates/buzz.tpl}
{load_templates subtemplates/updates.tpl}
{load_templates subtemplates/blog.tpl}

{template projectLink Project}
    <a href="{$Project->getURL()}">{$Project->Title|escape}</a>
{/template}

{template projectMemberTitle Membership}{strip}
    {if $Membership->Role && $Membership->MemberID == $Membership->Project->MaintainerID}
        {$Membership->Role|_|escape} {_ "and Maintainer"}
    {elseif $Membership->Role}
        {$Membership->Role|_|escape}
    {elseif $Membership->MemberID == $Membership->Project->MaintainerID}
        {_ "Maintainer"}
    {else}
        {_ "Member"}
    {/if}
{/strip}{/template}

{template projectActivity Article headingLevel=h2 showHeading=true showProject=true articleClass=""}
    {if is_a($Article, 'Laddr\\ProjectUpdate')}
        {projectUpdate $Article headingLevel=$headingLevel showHeading=$showHeading showProject=$showProject articleClass=$articleClass}
    {elseif is_a($Article, 'Laddr\\ProjectBuzz')}
        {projectBuzz $Article headingLevel=$headingLevel showHeading=$showHeading showProject=$showProject articleClass=$articleClass}
    {elseif is_a($Article, 'Emergence\\CMS\\BlogPost')}
        {blogPost $Article headingLevel=$headingLevel showHeader=$showHeading showContext=$showProject useSummary=true}
    {/if}
{/template}