/*jslint browser: true, undef: true, white: false, laxbreak: true *//*global Ext, EmergenceEditor*/
Ext.define('EmergenceEditor.view.Viewport', {
	extend: 'Ext.container.Viewport'	
	,requires: [
		'Ext.layout.container.Border'
	]
	
	,layout: 'border'

	,initComponent: function() {
		//console.info('Emergence.Editor.view.Viewport.initComponent()');
	
	
		this.items = [{
			xtype: 'emergence-menubar'
			,region: 'north'
			//,html: 'Emergence Development Environment'
		},{
			xtype: 'emergence-filetree'
			,region: 'west'
			,stateId: 'viewport-files'
			,stateful: true
			,title: 'Files'
			,width: 200
			,collapsible: true
			,split: true
		},{
            xtype: 'emergence-editortabpanel'
			,region: 'center'
		},{
//			xtype: 'tabpanel'
            title: 'Revision History'
            ,xtype: 'emergence-file-revisions'
            ,icon: '/img/icons/fugue/edit-diff.png'
			,region: 'east'
			,stateId: 'viewport-details'
			,width: 275
			,collapsible: true
            ,collapsed: true
			,split: true
//            ,preventHeader: true
//            ,items: [
//                {
//                    title: 'Revisions'
//                    ,xtype: 'emergence-file-revisions'
//                    ,icon: '/img/icons/fugue/edit-diff.png'
//                }
//                /*,{
//                    title: 'Code Navigator'   
//                }*/
//            ]
		},{
			xtype: 'emergence-transfersgrid'
			,region: 'south'
			,stateful: true
			,stateId: 'viewport-transfers'
			,height: 200
			,collapsible: true
			,split: true
            ,icon: '/img/icons/fugue/system-monitor-network.png'
            ,collapsed: true
		}];
        
		this.callParent();
		
	}
	
});