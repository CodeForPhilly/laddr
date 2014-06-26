<footer class="site">
    Powered by <a href="http://laddr.io">Laddr</a> &mdash; a <a href="http://codeforphilly.org">Code for Philly</a> project.
    <br>
    <select class="input-medium" onchange="document.cookie='locale='+this.value;location.reload();">
        {foreach key=locale item=label from=Emergence\Locale::getAvailableLocales()}
            <option value="{$locale}" {refill default=Emergence\Locale::getRequestedLocale() selected=$locale}>{$label|escape}</option>
        {/foreach}
    </select>
    {*
    {if $responseID == 'home'}
        <br>Cover photo by <a href="XXXXXX" target="_blank">XXXXXX</a>.
    {/if}
    *}
</footer>