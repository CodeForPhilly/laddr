{template validationErrors errors}
    {if count($errors) > 0}
        <div class="error notify">
            <ul class="validation-errors">
                {foreach $errors error}
                    <li>{$error}</li>
                {/foreach}
            </ul>
        </div>
    {/if}
{/template}

{template labeledField html type=text label='' error='' hint='' required=false id=null class=null}
    <div class="form-group {$type}-field {if $error}has-error{/if} {if $required}is-required{/if} {$class}">
        {if $label}<label class="control-label" for="{$id}">{$label}{/if}</label>
        {$html}
        {if $error}<p class="error-text">{$error}</p>{/if}
        {if $hint}<p class="hint help-block">{$hint}</p>{/if}
    </div>
{/template}

{template field inputName label='' error='' type=text placeholder='' hint='' required=false autofocus=false attribs='' default=null class=null fieldClass=null}

        {capture assign=html}
        <input type="{$type}"
            class="form-control {$class}"
            id="{$inputName|escape}"
            name="{$inputName|escape}"
            {if $placeholder}placeholder="{$placeholder|escape}"{/if}
            {if $autofocus}autofocus{/if}
            {if $required}required aria-required="true"{/if}
            {$attribs}
            value="{refill field=$inputName default=$default}">
        {/capture}

        {labeledField html=$html type=$type label=$label error=$error hint=$hint required=$required id=$inputName class=$fieldClass}
{/template}

{template checkbox inputName value label='' error='' hint='' attribs='' default=null class=null unsetValue=null}
    <div class="checkbox">
        {if $unsetValue !== null}
            <input type="hidden" name="{$inputName|escape}" value="{$unsetValue|escape}">
        {/if}

        <label>
            <input type="checkbox"
                class="{$class}"
                name="{$inputName|escape}"
                value="{$value|escape}"
                {$attribs}
                {refill field=$inputName default=$default checked=$value}>

            {$label}
        </label>

        {if $error}<p class="error-text">{$error}</p>{/if}
        {if $hint}<p class="hint help-block">{$hint}</p>{/if}
    </div>
{/template}

{template textarea inputName label='' error='' placeholder='' hint='' required=false attribs='' default=null}
    <div class="form-group">
        {capture assign=html}
            <textarea
                class="field-control form-control"
                name="{$inputName|escape}"
                {if $placeholder}placeholder="{$placeholder|escape}"{/if}
                {if $required}required aria-required="true"{/if}
                {$attribs}
            >{refill field=$inputName default=$default}</textarea>
        {/capture}

        {labeledField html=$html type=textarea label=$label error=$error hint=$hint required=$required}
    </div>
{/template}

{template loginField}{field inputName=_LOGIN[username] label=Username required=true attribs='autofocus autocapitalize="none" autocorrect="off"' hint='You can also log in with your email address.'}{/template}
{template passwordField}{field inputName=_LOGIN[password] label=Password hint='<a href="/register/recover">{_ "Forgot?"}</a>' required=true refill=false type=password}{/template}

{template selectField inputName label='' options=null useKeyAsValue=yes default=null multiple=no error='' hint='' required=false attribs='' class=null fieldClass=null blankOption='Select' blankValue=''}
    <div class="form-group">
        {capture assign=html}
            <select
                class="form-control {$class}"
                name="{$inputName}"
                {if $required}required aria-required="true"{/if}
                {if $multiple}multiple{/if}
                {$attribs}
            >
                {if $blankOption && !$multiple}
                    <option value="{$blankValue|escape}">{$blankOption|escape}</option>
                {/if}

                {foreach key=value item=text from=$options}
                    {$value = tif($useKeyAsValue, $value, tif(is_a($text, 'ActiveRecord'), $text->ID, $text))}
                    {$text = tif(is_a($text, 'ActiveRecord'), $text->getTitle(), $text)}
                    <option {refill field=$inputName default=$default selected=$value} value="{$value|escape}">{$text|escape}</option>
                {/foreach}
            </select>
        {/capture}

        {labeledField html=$html type='select' label=$label error=$error hint=$hint required=$required class=$fieldClass}
    </div>
{/template}

{template tagsField Record baseName=tags prefix=no label='' blankOption='Select' attribs='' placeholder='' error='' hint='' required=false}
    {$inputName = tif($prefix, cat($baseName, "[$prefix][]"), $baseName)}
    {capture assign=attribs}{strip}
        {$attribs}
        {if $prefix} data-tag-prefix="{$prefix|escape}"{/if}
        {if $placeholder} data-tag-placeholder="{$placeholder|escape}"{/if}
    {/strip}{/capture}

    {selectField
        inputName=$inputName
        label=$label
        blankOption=$blankOption
        options=Tag::filterTagsByPrefix($Record->Tags, $prefix)
        default=true
        multiple=yes
        useKeyAsValue=no
        error=$error
        hint=$hint
        required=$required
        attribs=$attribs
    }
{/template}
