{load_templates subtemplates/meetups.tpl}
{load_templates subtemplates/projects.tpl}
{load_templates subtemplates/people.tpl}

{if $currentMeetup}
    <article class="meetup meetup-current">
        <h3>{_ "Current Meetup"}</h3>
        {meetup $currentMeetup showRsvp=false}
        <form class="checkin well" action="/checkin" method="POST">
            <p><strong>At the Meetup?</strong> Check in to a project:</p>
            <input type="hidden" name="MeetupID" value="{$currentMeetup.id}">
            <select name="ProjectID" class="project-picker">
                <option value="">Current Project (if any)</option>
                {foreach item=Project from=Laddr\Project::getAll()}
                    <option value="{$Project->ID}">{$Project->Title|escape}</option>
                {/foreach}
            </select>
            <input type="submit" value="Check In" class="btn btn-success">
        </form>
        <aside class="checkins">
            <h4>{_ "Checked-in Members"}</h4>
            {$lastProjectID = false}
            <h5 class="muted">{_ "No Current Project"}</h5>
            <ul class="nav nav-pills nav-stacked">
            {foreach item=Checkin from=$currentMeetup.checkins}
                {if $Checkin->ProjectID != $lastProjectID || $lastProjectID === false}
                    {if $lastProjectID}
                        </ul>
                    {/if}
                    <h5>{if $Checkin->Project}{projectLink $Checkin->Project}{/if}</h5>
                    {$lastProjectID = $Checkin->ProjectID}
                    <ul class="nav nav-pills nav-stacked">
                {/if}
                <li>{personLink $Checkin->Member photo=yes photoSize=32}</li>
            {/foreach}
            </ul>
        </aside>
    </article>
{/if}

{if $nextMeetup}
    <article class="meetup meetup-next">
        <h3>{_ "Next Meetup"}</h3>
        {meetup $nextMeetup}
    </article>
{/if}

{if count($futureMeetups)}
    <h3>{_ "Future Meetups"}</h3>
    {foreach item=futureMeetup from=$futureMeetups}
        <article class="meetup meetup-future">
            {meetup $futureMeetup}
        </article>
    {/foreach}
{/if}