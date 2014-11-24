{load_templates subtemplates/forms.tpl}

{template tagsField Record baseName=tags prefix=no label='' attribs='' placeholder='' hint=''}
    {$fieldName = tif($prefix, cat($baseName, "[$prefix]"), $baseName)}
    {capture assign=attribs}{$attribs}{if $prefix} data-tag-prefix="{$prefix}"{/if}{/capture}

    {field inputName=$fieldName type=tags label=$label attribs=$attribs placeholder=$placeholder hint=$hint default=Tag::getTagsString($Record->Tags, $prefix)}
{/template}
