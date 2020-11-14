{template localeSelector}
    {$locales = Emergence\Locale::getAvailableLocales()}
    {if count($locales) > 1}
    <label for="site-language" class="sr-only">{_ Language}</label>
    <select id="site-language" class="form-control" onchange="document.cookie='locale='+this.value;location.reload();" style="display: inline-block; width: auto;">
        {foreach item=locale from=$locales}
            <option value="{$locale}" {refill default=Emergence\Locale::getRequestedLocale() selected=$locale}>{Locale::getDisplayName($locale)|escape}</option>
        {/foreach}
    </select>
    {/if}
{/template}
