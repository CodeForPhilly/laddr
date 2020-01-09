{extends designs/site.tpl}

{block title}{_ 'Project Deleted'} &mdash; {$dwoo.parent}{/block}

{block content}
    {capture assign=projectTitle}{$data->Title|escape}{/capture}
    <p>{sprintf(_("Project %s deleted."), $projectTitle)}</p>       
{/block}
