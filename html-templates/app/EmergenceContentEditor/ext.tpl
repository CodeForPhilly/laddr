{extends designs/site.tpl}

{block "meta-rendering"}
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=10, user-scalable=yes">
{/block}

{block content}
    <div id="app-viewport">Loading content editor&hellip;</div>
{/block}

{block js-bottom}
    {$cmsComposers = $cmsComposers|default:array('html', 'markdown', 'multimedia', 'embed')}

    <script type="text/javascript">
        var SiteEnvironment = SiteEnvironment || { };
        SiteEnvironment.user = {JSON::translateObjects($.User)|json_encode};
        SiteEnvironment.cmsContent = {tif $data ? JSON::translateObjects($data, false, 'tags,items,Author,Context.recordURL,Context.recordTitle')|json_encode : 'null'};
        SiteEnvironment.cmsComposers = {$cmsComposers|json_encode};
        SiteEnvironment.mediaSupportedTypes = {Media::getSupportedTypes()|json_encode};
    </script>

    {jsmin "lib/markdown.js"}

    <script>
	    window.Ext = window.Ext || { };
	    Ext.scopeCss = true;
	</script>

    {$App = $App|default:Sencha_App::getByName('EmergenceContentEditor')}
    {$appName = $App->getName()}
    <link rel="stylesheet" type="text/css" href="{$App->getVersionedPath("build/production/resources/$appName-all.css")}" />
    <script type="text/javascript" src="{$App->getVersionedPath('.sencha/app/Boot.js')}"></script>
    <script type="text/javascript" src="{$App->getVersionedPath("build/production/app.js")}"></script>
{/block}