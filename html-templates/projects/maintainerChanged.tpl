{extends designs/site.tpl}

{block title}Members &mdash; {$dwoo.parent}{/block}

{block content}
    <div class="page-header">
        <h1>Maintainer Changed</h1>
    </div>
    <p class="lead">{personLink $data->Maintainer} has been made the maintainer of {projectLink $data}</p>
{/block}