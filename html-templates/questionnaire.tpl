{extends "designs/site.tpl"}

{block "title"}{_ 'Onboarding Questionnaire'} &mdash; {$dwoo.parent}{/block}

{block "content"}
    <div class="container">
        <div class="row">
            <div class="col-8">
                <div class="page-header">
                    <h1>Onboarding Questionnaire</h1>
                </div>

                {contentBlock "questionnaire-introduction"}

                {*if !$Project->isValid}
                <div class="error well">
                    <strong>{_ "There were problems with your entry:"}</strong>
                    <ul class="errors">
                    {foreach item=error key=field from=$Project->validationErrors}
                        <li>{$error}</li>
                    {/foreach}
                    </ul>
                </div>
                {/if*}

                <form method="POST">

                    <fieldset class="form-group">
                        <legend>I am a&hellip;</legend>

                        <div class="row">
                            <div class="offset-sm-1 col-sm-6">
                                {foreach from=$roles key=key item=title}
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" name="roles[]" id="role__{$key|escape}" value="{$key|escape}">
                                        <label class="form-check-label" for="role__{$key|escape}">{$title|escape}</label>
                                    </div>
                                {/foreach}
                                <div class="form-row align-items-center">
                                    <label class="sr-only" for="role__other">Other:</label>
                                    <input type="text" class="form-control" id="role__other" placeholder="Other&hellip;">
                                </div>
                            </div>
                        </div>
                    </fieldset>

                    <fieldset class="form-group">
                        <legend>Technology Experience</legend>

                        <div class="row">
                            <div class="offset-sm-4 col-sm-2 text-center">
                                No experience / Want to learn
                            </div>
                            <div class="col-sm-2 text-center">
                                Beginner
                            </div>
                            <div class="col-sm-2 text-center">
                                Intermediate
                            </div>
                            <div class="col-sm-2 text-center">
                                Advanced
                            </div>
                        </div>

                        {foreach from=$technologies key=key item=title}
                            <div class="row">
                                <div class="offset-sm-1 col-sm-3">
                                    {$title|escape}
                                </div>
                                <div class="col-sm-2 text-center">
                                    <input type="checkbox" name="skills[{$key|escape}]" value="1">
                                </div>
                                <div class="col-sm-2 text-center">
                                    <input type="checkbox" name="skills[{$key|escape}]" value="2">
                                </div>
                                <div class="col-sm-2 text-center">
                                    <input type="checkbox" name="skills[{$key|escape}]" value="3">
                                </div>
                                <div class="col-sm-2 text-center">
                                    <input type="checkbox" name="skills[{$key|escape}]" value="4">
                                </div>
                            </div>
                        {/foreach}
                    </fieldset>

                    <fieldset class="form-group">
                        <legend>I would describe my tech experience as</legend>

                        <div class="row">
                            <div class="offset-sm-1 col-sm-6">
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="experience" id="experience__1" value="1">
                                    <label class="form-check-label" for="experience__1">Just Starting/Student</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="experience" id="experience__2" value="2">
                                    <label class="form-check-label" for="experience__2">Mid-level</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="experience" id="experience__3" value="3">
                                    <label class="form-check-label" for="experience__3">Senior</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="experience" id="experience__4" value="4">
                                    <label class="form-check-label" for="experience__4">Lead</label>
                                </div>
                            </div>
                        </div>
                    </fieldset>

                    <button type="submit" class="btn btn-primary">{if $Project->isPhantom}{_ 'Create Project'}{else}{_ 'Save Changes'}{/if}</button>
                </form>
            </div>
        </div>
    </div>
{/block}
