/*jslint browser: true, undef: true, white: false, laxbreak: true *//*global Ext, EmergenceEditor*/
Ext.define('EmergenceEditor.view.contextmenu.MultiNodeMenu', {
    extend: 'Ext.menu.Menu'
    ,alias: 'widget.emergence-multinodemenu'
    ,stateful: false
    ,width: 130
	,items: [
		{
		    text: 'Open'
            ,action: 'open'
            ,icon: '/img/icons/fugue/blue-folder-horizontal-open.png'
	    },{
		    text: 'Delete'
            ,action: 'delete'
            ,icon: '/img/icons/fugue/cross.png'
	    }
    ]
});