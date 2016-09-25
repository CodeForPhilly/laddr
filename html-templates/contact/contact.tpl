{extends designs/site.tpl}

{block "title"}Contact &mdash; {$dwoo.parent}{/block}

{block js-top}
    {$dwoo.parent}

    {if RemoteSystems\ReCaptcha::$siteKey}
        <script src='https://www.google.com/recaptcha/api.js'></script>
    {/if}
{/block}

{block "content"}
    <header class="page-header">
        <h2>Contact Us</h2>
    </header>

	<form action="/contact" method="POST" class="contact-form">
		{if $validationErrors}
			<div class="notify error">
				<strong>Please double-check the fields highlighted below.</strong>
			</div>
		{/if}

		<fieldset class="shrink show-required left-labels">

			{* field name label='' error='' type=text placeholder='' hint='' required=false attribs='' *}

            {field inputName=Name  label=Name  error=$validationErrors.Name  required=true attribs='autofocus autocapitalize="words"'}
            {field inputName=Email label=Email error=$validationErrors.Email type=email required=true}
            {field inputName=Phone label=Phone error=$validationErrors.Phone type=tel hint='Optional. Include your area code.'}

            {textarea inputName=Message label=Message error=$validationErrors.Message required=true}

            {if RemoteSystems\ReCaptcha::$siteKey}
                <div class="form-group g-recaptcha" data-sitekey="{RemoteSystems\ReCaptcha::$siteKey|escape}"></div>
            {/if}

            {if $validationErrors.ReCaptcha}
                <p class="error-text">{$validationErrors.ReCaptcha}</p>
            {/if}

            <div class="submit-area">
            	<input type="submit" class="btn btn-primary btn-block" value="Send">
            </div>

		</fieldset>
	</form>
{/block}