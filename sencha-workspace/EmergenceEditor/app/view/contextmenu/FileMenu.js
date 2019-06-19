/*jslint browser: true, undef: true, white: false, laxbreak: true *//*global Ext, EmergenceEditor*/
Ext.define('EmergenceEditor.view.contextmenu.FileMenu', {
    extend: 'Ext.menu.Menu'
    ,alias: 'widget.emergence-filemenu'
	
    ,stateful: false
    ,width: 130
	,items: [
		{
		    text: 'Open'
            ,action: 'open'
            ,icon: '/img/icons/fugue/blue-folder-horizontal-open.png'
	    }
        ,{
		    text: 'Properties'
            ,action: 'properties'
            ,icon: '/img/icons/fugue/property-blue.png'
	    },{
		    text: 'Rename'
            ,action: 'rename'
            ,icon: '/img/icons/fugue/blue-document-rename.png'  
	    },{
		    text: 'Delete'
            ,action: 'delete'
            ,icon: '/img/icons/fugue/cross.png'
	    }
    ]
});