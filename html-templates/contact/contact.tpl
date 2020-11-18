{extends designs/site.tpl}

{block "title"}{_ 'Contact'} &mdash; {$dwoo.parent}{/block}

{block js-top}
    {$dwoo.parent}

    {if RemoteSystems\ReCaptcha::$siteKey}
        <script src='https://www.google.com/recaptcha/api.js'></script>
    {/if}
{/block}

{block "content"}
    <div class="row">
        <div class="col-sm-8 col-sm-offset-2 col-md-6 col-md-offset-3">

            <div class="page-header">
                <h1>{_ "Contact Us"}</h1>
            </div>

            {contentBlock "contact-introduction"}

            <form action="/contact" method="POST" class="contact-form">
                {if $validationErrors}
                    <div class="alert alert-danger">
                        {_ "Please double-check the fields highlighted below."}
                    </div>
                {/if}

                {* field name label='' error='' type=text placeholder='' hint='' required=false attribs='' *}

                {field inputName=Name  label=Name  error=$validationErrors.Name  required=true attribs='autofocus autocapitalize="words"'}
                {field inputName=Email label=Email error=$validationErrors.Email type=email required=true}
                {field inputName=Phone label=Phone error=$validationErrors.Phone type=tel hint='{_ "Optional. Include your area code."}'}

                {textarea inputName=Message label=Message error=$validationErrors.Message required=true}

                {if RemoteSystems\ReCaptcha::$siteKey}
                    <div class="form-group g-recaptcha" data-sitekey="{RemoteSystems\ReCaptcha::$siteKey|escape}"></div>
                {/if}

                {if $validationErrors.ReCaptcha}
                    <p class="text-danger">{$validationErrors.ReCaptcha}</p>
                {/if}

                <button type="submit" class="btn btn-primary">{_ Send}</button>
            </form>

        </div>
    </div>
{/block}
