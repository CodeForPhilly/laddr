/*jslint browser: true, undef: true, white: false, laxbreak: true *//*global Ext, EmergenceEditor*/
Ext.define('EmergenceEditor.view.contextmenu.CollectionMenu', {
    extend: 'Ext.menu.Menu'
    ,alias: 'widget.emergence-collectionmenu'
    
    ,stateful: false
	,width: 100
	,items: [
        {
		    text: 'New File'
            ,action: 'new-file'
            ,icon: '/img/icons/fugue/blue-document.png' 
	    },{
		    text: 'New Folder'
            ,action: 'new-folder'
            ,icon: '/img/icons/fugue/blue-folder-horizontal-open.png'
	    },{
		    text: 'Rename'
            ,action: 'rename'
            ,icon: '/img/icons/fugue/blue-folder-rename.png' 
	    },{
		    text: 'Refresh'
            ,action: 'refresh'
            ,icon: '/img/icons/fugue/arrow-circle-135.png' 
	    },{
		    text: 'Delete'
            ,action: 'delete'
            ,icon: '/img/icons/fugue/cross.png'
	    }
    ]
});