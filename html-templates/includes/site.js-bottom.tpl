{*
    Compresses all JS files into a single request.
    Add ?jsdebug=1 to any URL to load separate uncompressed files
*}
{jsmin array(
    "lib/jquery.js",
    "lib/popper.js",
    "lib/bootstrap.js",
    "lib/select2.js",
    "features/site-search.js",
    "features/site-search-renderers/*",
    "features/tooltips.js"
)}

{if $.User->hasAccountLevel('Staff')}
    {jsmin "lib/jquery.filedrop.js+lib/markdown.js+features/content-editable.js"}
{/if}
