{load_templates subtemplates/locale-selector.tpl}
<footer class="site">
    {capture assign=laddrLink}<a href="http://laddr.us">Laddr</a>{/capture}
    {capture assign=cfpLink}<a href="http://codeforphilly.org">Code for Philly</a>{/capture}
    {sprintf(_("Powered by %s &mdash; a %s project."), $laddrLink, $cfpLink)}
    <br>
    {localeSelector}
    {*
    {if $.responseId == 'home'}
        <br>Cover photo by <a href="XXXXXX" target="_blank">XXXXXX</a>.
    {/if}
    *}
</footer>