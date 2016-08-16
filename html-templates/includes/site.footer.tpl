{load_templates subtemplates/locale-selector.tpl}

{capture assign=laddrLink}<a href="http://laddr.us">Laddr</a>{/capture}
{capture assign=cfpLink}<a href="http://codeforphilly.org">Code for Philly</a>{/capture}

<p>{sprintf(_("Powered by %s &mdash; a %s project."), $laddrLink, $cfpLink)}</p>

{localeSelector}

{*
{if $.responseId == 'home'}
    <br>Cover photo by <a href="XXXXXX" target="_blank">XXXXXX</a>.
{/if}
*}