{*
    Compresses all JS files into a single request.
    Add ?jsdebug=1 to any URL to load separate uncompressed files
*}
<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
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
