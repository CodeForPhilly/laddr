{*
    Compresses all JS files into a single request.
    Add ?jsdebug=1 to any URL to load separate uncompressed files
*}
{jsmin array(
    'jquery.min.js'
    ,'bootstrap.js'
    ,'typeahead.bundle.js'
    ,'bootstrap-combobox.js'
    ,'bootstrap-tagsinput.js'
    ,'features/site-search.js'
    ,'features/site-search-renderers/*'
    ,'features/tooltips.js'
)}

{if $.User->hasAccountLevel('Staff')}
    {jsmin "jquery.filedrop.js+markdown.js+features/content-editable.js"}
{/if}