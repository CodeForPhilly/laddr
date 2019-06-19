/*jslint browser: true, undef: true, white: false, laxbreak: true *//*global Ext, EmergenceEditor*/
Ext.define('EmergenceEditor.view.SiteTools', { 
    extend: 'Ext.window.Window' 
    ,title: 'Site Tools'
    ,alias: 'widget.emergence-site-tools'
    ,height: 200
    ,width: 400
    ,layout: 'fit'
    ,icon: '/img/icons/fugue/gear.png'
    ,html: '<iframe src="/admin/" style="width:100%;height:100%"></iframe>'    
});