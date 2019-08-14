{template personName Person summary=on}{strip}
    {$Person->FullName|escape}
    {if $summary && $Person->isA('Emergence\People\IUser')}
        &thinsp;
        {if $Person->hasAccountLevel('Administrator')}
            (Administrator)
        {elseif $Person->hasAccountLevel('Staff')}
            (Staff)
        {/if}
    {/if}
{/strip}{/template}