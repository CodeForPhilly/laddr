{*
    Compresses all CSS files into a single request.
    Add ?cssdebug=1 to any URL to load separate uncompressed files
*}
{cssmin array(
    'lib/bootstrap.css',
    'lib/select2.css',
    'plugins/*',
    'laddr/*',
    'branding/*'
)}
{cssmin "fonts/font-awesome.css"}

<link href='https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,300italic,400,400italic,700,700italic' rel='stylesheet' type='text/css'>

{if $.User->hasAccountLevel('Staff')}
    {cssmin "features/content-editable.css"}
{/if}
