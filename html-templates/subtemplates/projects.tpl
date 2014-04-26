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