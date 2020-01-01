{extends designs/site.tpl}

{block title}{_ "Members"} &mdash; {$dwoo.parent}{/block}

{block content}
  {capture assign=person}{personLink $Member} {if $data && $data->Role}({$data->Role|escape}){/if}{/capture}
  {capture assign=project}{projectLink $Project}{/capture}

  <div class="row">
      <div class="col-sm-8 col-sm-offset-2 col-md-6 col-md-offset-3">
          <div class="page-header">
              <h1>{_ "Member Removed"}</h1>
          </div>
          <p>{sprintf(_("%s has been removed from %s"), $person, $project)}</p>
      </div>
  </div>
{/block}
