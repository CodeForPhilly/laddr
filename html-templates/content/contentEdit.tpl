{extends app/EmergenceContentEditor/ext.tpl}

{block "css"}
    {$dwoo.parent}
    {cssmin "pages/article.css"}
{/block}

{block js-bottom}
    {$cmsComposers = array('markdown', 'multimedia', 'embed')}
    {$dwoo.parent}
{/block}