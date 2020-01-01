{extends "designs/site.tpl"}

{block "title"}{_ 'Edit Profile'} &mdash; {$dwoo.parent}{/block}

{block js-bottom}
    {$dwoo.parent}
    {jsmin "lib/epiceditor.js"}
    {jsmin "pages/profile-edit.js"}
    {jsmin "features/tag-fields.js"}
{/block}

{block "content"}
    {$User = $data}

    <div class="row">
        <div class="col-sm-8 col-sm-offset-2 col-md-6 col-md-offset-3">
            <div class="page-header">
                <h1>{if $User->ID == $.User->ID}{_ "Manage Your Profile"}{else}{sprintf(_("Manage %s Profile"), $User->FullNamePossessive|escape)}{/if}</h1>
            </div>

            {if $.get.status == 'photoUploaded'}
                <p class="status highlight">{_ "Photo uploaded."}</p>
            {elseif $.get.status == 'photoPrimaried'}
                <p class="status highlight">{_ "Default photo selected."}</p>
            {elseif $.get.status == 'photoDeleted'}
                <p class="status highlight">{_ "Photo deleted."}</p>
            {elseif $.get.status == 'passwordChanged'}
                <p class="status highlight">{_ "Password changed."}</p>
            {elseif $.get.status == 'saved'}
                <p class="status highlight">{_ "Profile saved."}</p>
            {/if}

            <form method="POST">
                {if ProfileRequestHandler::$accountLevelEditOthers && $.User->hasAccountLevel(ProfileRequestHandler::$accountLevelEditOthers)}
                    <h2 class="h3">{sprintf(_("Account Settings (%s only)"), ProfileRequestHandler::$accountLevelEditOthers)}</h2>

                    {field inputName="Username" label=_('Username') default=$User->Username}

                    {capture assign=accountLevelHtml}
                        <select class="form-control" id="AccountLevel" name="AccountLevel">
                            {foreach item=level from=Emergence\People\User::getFieldOptions(AccountLevel, values)}
                                <option {refill field=AccountLevel default=$User->AccountLevel selected=$level}>{$level}</option>
                            {/foreach}
                        </select>
                    {/capture}

                    {labeledField html=$accountLevelHtml id=AccountLevel type=select label=_('Account Level')}

                    {capture assign=classHtml}
                        <select class="form-control" id="Class" name="Class">
                            {foreach item=class from=Emergence\People\User::getFieldOptions(Class, values)}
                                <option {refill field=Class default=$User->Class selected=$class}>{$class}</option>
                            {/foreach}
                        </select>
                    {/capture}
                    {labeledField html=$classHtml type=select id="Class" label=_('Person subclass')}

                    <div class="form-group">
                        <button type="submit" class="btn btn-primary">{_ 'Save Profile'}</button>
                    </div>
                {/if}

                <h2 class="h3">{_ 'Profile Details'}</h2>

                {field inputName="Location" label=_("Location") default=$User->Location}
                {textarea inputName="About" label=_("About Me") default=$User->About hint=markdown(_("Use [Markdown](http://daringfireball.net/projects/markdown) to give your text some style"))}

                {tagsField Record=$User prefix=topic label=_("Topics of interest") placeholder=_("Education, Mapping, Crime")}
                {tagsField Record=$User prefix=tech label=_("Technologies of interest") placeholder=_("PHP, Bootstrap, JavaScript")}

                <div class="form-group">
                    <button type="submit" class="btn btn-primary">{_ 'Save Profile'}</button>
                </div>

                <h2 class="h3">{_ 'Contact Information'}</h2>

                {field inputName="FirstName" label="First Name" type="text" default=$User->FirstName}
                {field inputName="LastName" label="Last Name" type="text" default=$User->LastName}
                {field inputName="Email" label="Email" type="email" default=$User->Email}

                {if Laddr\ProfileRequestHandler::$enableNewsletterOptIn}
                    {checkbox inputName="Newsletter" value="1" unsetValue="0" label="Subscribe to Newsletter" default=$User->Newsletter}
                {/if}

                {field inputName="Phone" label="Phone" type="tel" default=$User->Phone}
                {field inputName="Twitter" label="Twitter" type="text" default=$User->Twitter}

                <div class="form-group">
                    <button type="submit" class="btn btn-primary">{_ 'Save Profile'}</button>
                </div>
            </form>

            <form action="/profile/password?{refill_query}" method="POST">
                <h2 class="h3">{_ 'Change Password'}</h2>
                {field inputName="OldPassword" label=_('Old Password') type="password"}
                {field inputName="Password" label=_('New Password') type="password"}
                {field inputName="PasswordConfirm" label=_('New Password (Confirm)') type="password"}

                <div class="form-group">
                    <button type="submit" class="btn btn-primary">{_ 'Change Password'}</button>
                </div>
            </form>

            <form class="profile-photo-form" action="/profile/uploadPhoto?{refill_query}" method="POST" enctype="multipart/form-data">
                <h2 class="h3">{_ 'Profile Photo'}</h2>

                <div class="current-photo">
                    {avatar $User size=200}
                    {if $User->PrimaryPhoto}
                        <a class="button small block destructive" href="/profile/deletePhoto?{refill_query MediaID=$User->PrimaryPhotoID}">{_ 'Remove This Photo'}</a>
                    {else}
                        <div class="muted">{markdown(sprintf(_('Using [Gravatar](//gravatar.com) image for %s.'), $User->Email))}</div>
                    {/if}
                </div>

                {if $User->Photos}
                    <ul class="available-photos">
                        <p class="hint">{_ 'Choose a default:'}</p>
                    {foreach item=Photo from=$User->Photos}
                        <li class="photo-item {if $Photo->ID == $User->PrimaryPhotoID}current{/if}">
                            {if $Photo->ID != $.Session->Person->PrimaryPhotoID}<a href="/profile/primaryPhoto?{refill_query MediaID=$Photo->ID}" title="{_ 'Make Default'}">{/if}
                                <img src="{$Photo->getThumbnailRequest(96, 96, null, true)}" width=48 height=48 alt="">
                            {if $Photo->ID != $.Session->Person->PrimaryPhotoID}</a>{/if}
                        </li>
                    {/foreach}
                    </ul>
                {/if}

                <div class="photo-upload form-group">
                    <label class="sr-only" for="photoFile">{_ 'Photo Upload'}</label>
                    <input class="form-control" type="file" id="photoFile" name="photoFile">
                </div>

                <div class="form-group">
                    <button type="submit" class="btn btn-primary">{_ 'Upload New Photo'}</button>
                </div>
            </form>
        </div>
    </div>
{/block}
