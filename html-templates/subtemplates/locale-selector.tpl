{template localeSelector}
    {$locales = Emergence\Locale::getAvailableLocales()}
    {if count($locales) > 1}
    <select onchange="document.cookie='locale='+this.value;location.reload();" style="width: auto;">
        {foreach item=locale from=$locales}
            <option value="{$locale}" {refill default=Emergence\Locale::getRequestedLocale() selected=$locale}>{Locale::getDisplayName($locale)|escape}</option>
        {/foreach}
    </select>
    {/if}
{/template}