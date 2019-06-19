/*jslint browser: true, undef: true, white: false, laxbreak: true *//*global Ext, EmergenceEditor*/
Ext.define('EmergenceEditor.view.contextmenu.RevisionsMenu', {
    extend: 'Ext.menu.Menu'
    ,alias: 'widget.emergence-revisionsmenu'
    ,width: 150
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
	    }
	    ,{
		    text: 'Compare Latest'
            ,action: 'compare_latest'
            //,icon: ''
	    }
		,{
		    text: 'Compare Next'
            ,action: 'compare_next'
            //,icon: ''
	    }
	   	,{
		    text: 'Compare Previous'
            ,action: 'compare_previous'
            //,icon: ''
	    }
    ]	
});