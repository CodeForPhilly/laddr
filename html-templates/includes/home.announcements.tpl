{load_templates subtemplates/contentBlocks.tpl}

{$ContentBlock = Emergence\CMS\ContentBlock::getByHandle('home-announcements')}

{if $.User->hasAccountLevel('Staff') || ($ContentBlock && $ContentBlock->Content)}
    <h2>{_ Announcements}</h2>

    {contentBlock "home-announcements" extraClass="alert alert-info"}
{/if}
