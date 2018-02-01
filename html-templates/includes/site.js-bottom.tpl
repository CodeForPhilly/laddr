{*
    Compresses all JS files into a single request.
    Add ?jsdebug=1 to any URL to load separate uncompressed files
*}
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
{jsmin array(
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
