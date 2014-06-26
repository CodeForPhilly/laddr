<footer class="site">
    {capture assign=laddrLink}<a href="http://laddr.io">Laddr</a>{/capture}
    {capture assign=cfpLink}<a href="http://codeforphilly.org">Code for Philly</a>{/capture}
    {sprintf(_("Powered by %s &mdash; a %s project."), $laddrLink, $cfpLink)}
    <br>
    {$locales = Emergence\Locale::getAvailableLocales()}
    {if count($locales) > 1}
    <select class="input-medium" onchange="document.cookie='locale='+this.value;location.reload();">
        {foreach item=locale from=$locales}
            <option value="{$locale}" {refill default=Emergence\Locale::getRequestedLocale() selected=$locale}>{Locale::getDisplayName($locale)|escape}</option>
        {/foreach}
    </select>
    {/if}
    {*
    {if $responseID == 'home'}
        <br>Cover photo by <a href="XXXXXX" target="_blank">XXXXXX</a>.
    {/if}
    *}
</footer>