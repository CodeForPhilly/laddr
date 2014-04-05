{extends designs/site.tpl}

{block title}Members &mdash; {$dwoo.parent}{/block}

{block content}
    <p>{personLink $data->Maintainer} has been made the maintainer of {projectLink $data}</p>
{/block}