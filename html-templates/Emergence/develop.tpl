<!DOCTYPE html>
<html>
    <head>
        <title>Emergence Editor</title>
        <link rel="icon" type="image/png" href="http://emr.ge/img/logo-16.png">
        
        {if $.get.mode == 'extjs'}
            <link rel="stylesheet" type="text/css" href="http://cdn.sencha.io/ext-4.0.7-gpl/resources/css/ext-all.css">
        {elseif $.get.mode == 'init'}
            <link rel="stylesheet" type="text/css" href="/x/Emergence/Editor/resources/css/editor-init.css">
            <link rel="stylesheet" type="text/css" href="http://cdn.sencha.io/ext-4.0.7-gpl/resources/css/ext-all.css">
        {elseif $.get.mode == 'production'}
            <link rel="stylesheet" type="text/css" href="/x/Emergence/Editor/resources/css/editor-init.css">
            <link rel="stylesheet" type="text/css" href="/x/Emergence/Editor/resources/css/editor.css">
        {else}{*{elseif $.get.mode == 'bootstrap'}*}
            <link rel="stylesheet" type="text/css" href="http://cdn.sencha.io/ext-4.0.7-gpl/resources/css/ext-all.css" />
        {/if}
        <link rel="stylesheet" type="text/css" href="http://cdn.sencha.io/ext-4.0.7-gpl/examples/ux/css/TabScrollerMenu.css">
        <link rel="stylesheet" type="text/css" href="/x/Emergence/Editor/resources/css/diff.css">
        <link rel="stylesheet" type="text/css" href="/x/Emergence/Editor/resources/css/editor-override.css">
        <script src="/js/modernizr.js"></script>

    </head>
    <body class="loading">

        {*if $.get.fullscreen}
            <script type="text/javascript" src="http://cdn.sencha.io/ext-4.0.7-gpl/bootstrap.js"></script>
            <script type="text/javascript" src="/x/Emergence/FullscreenEditor/app.js"></script>
        {else*}
        
        {if $.get.mode == 'create-jsb'}
            <script type="text/javascript" src="/x/ext/ext.js"></script>    
            <script type="text/javascript" src="/x/Emergence/Editor/app.js"></script>
        {elseif $.get.mode == 'debug-all'}
            <script type="text/javascript" src="/x/ext/ext-debug.js"></script>
            <script type="text/javascript" src="/x/Emergence/Editor/app.js"></script>
         {elseif $.get.mode == 'debug-app'}
            <script type="text/javascript" src="/x/Emergence/Editor/builds/editor/ext-all.js"></script>
            <script type="text/javascript" src="/x/Emergence/Editor/app.js"></script>
        {elseif $.get.mode == 'bootstrap'}
            <script type="text/javascript" src="http://cdn.sencha.io/ext-4.0.7-gpl/bootstrap.js"></script>
            <script type="text/javascript" src="/x/Emergence/Editor/app.js"></script>
        {elseif $.get.mode == 'compiled-debug'}
            <script type="text/javascript" src="http://cdn.sencha.io/ext-4.0.7-gpl/bootstrap.js"></script>
            <script type="text/javascript" src="/x/Emergence/Editor/builds/editor/editor-classes-debug.js"></script>
        {else}
            <script type="text/javascript" src="/x/Emergence/Editor/builds/editor/editor-all.js"></script>
        {/if}
        <script type="text/javascript">
            document.User = {$.User->getData()|json_encode};
        </script>

    </body>
</html>