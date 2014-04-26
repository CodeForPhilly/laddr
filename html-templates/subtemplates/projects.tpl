{load_templates subtemplates/buzz.tpl}
{load_templates subtemplates/updates.tpl}

{template projectLink Project}
    <a href="{$Project->getURL()}">{$Project->Title|escape}</a>
{/template}

{template projectMemberTitle Membership}{strip}
    {if $Membership->Role && $Membership->MemberID == $Membership->Project->MaintainerID}
        {$Membership->Role|escape} and Maintainer
    {elseif $Membership->Role}
        {$Membership->Role|escape}
    {elseif $Membership->MemberID == $Membership->Project->MaintainerID}
        Maintainer
    {else}
        Member
    {/if}
{/strip}{/template}

{template projectActivity Article headingLevel=h2 showHeading=true showProject=true articleClass=""}
    {if is_a($Article, 'Laddr\\ProjectUpdate')}
        {projectUpdate $Article headingLevel=$headingLevel showHeading=$showHeading showProject=$showProject articleClass=$articleClass}
    {elseif is_a($Article, 'Laddr\\ProjectBuzz')}
        {projectBuzz $Article headingLevel=$headingLevel showHeading=$showHeading showProject=$showProject articleClass=$articleClass}
    {/if}
{/template}