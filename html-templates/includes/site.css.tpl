{*
    Compresses all CSS files into a single request.
    Add ?cssdebug=1 to any URL to load separate uncompressed files
*}
{cssmin array(
    'bootstrap/bootstrap4.min.css',
    'plugins/*',
    'laddr/*',
    'branding/*'
)}
{cssmin array('shards.css')}

<link href='https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,300italic,400,400italic,700,700italic' rel='stylesheet' type='text/css'>

{if $.User->hasAccountLevel('Staff')}
    {cssmin "features/content-editable.css"}
{/if}
