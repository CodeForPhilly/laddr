<?xml version='1.0' encoding='UTF-8'?>
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns="http://purl.org/rss/1.0/"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
>

{load_templates subtemplates/personName.tpl}


<channel rdf:about="http://{$.server.HTTP_HOST}{$.server.REQUEST_URI|escape}">
    <title>{if $Project}{$Project->Title|escape} &#8212; {/if}{_ 'Project Updates'}</title>
    <link>http://{Site::getConfig(primary_hostname)}/project-updates{if $Project}?ProjectID={$Project->ID}{/if}</link>
    {capture assign=projectTitleText}{$Project->Title|escape}{/capture}
    {capture assign=siteNameText}{Laddr::$siteName}{/capture}
    {if $Project}
      <description>{sprintf(_("Updates from %s on %s"), $projectTitleText, $siteNameText)}</description>
    {else}
      <description>{sprintf(_("Updates from all projects on %s"), $siteNameText)}</description>
    {/if}
    <language>en-us</language>
    <items>
        <rdf:Seq>
            {foreach item=Update from=$data}
                <rdf:li rdf:resource="http://{Site::getConfig(primary_hostname)}{$Update->getURL()}"/>
            {/foreach}
        </rdf:Seq>
    </items>
</channel>

{foreach item=Update from=$data}
    <item rdf:about="http://{Site::getConfig(primary_hostname)}{$Update->getURL()}">
        <title>{$Update->Project->Title|escape} &#8212; {_("Update #%u")|sprintf:$Update->Number}</title>
        <link>http://{Site::getConfig(primary_hostname)}{$Update->getURL()}</link>
        <description>{$Update->Body|escape|markdown|escape}</description>
        <dc:creator>{personName $Update->Creator}</dc:creator>
        <dc:date>{date($dwoo.const.DATE_W3C, $Update->Created)}</dc:date>
    </item>
{/foreach}

</rdf:RDF>
