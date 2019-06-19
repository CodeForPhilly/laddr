/*jslint browser: true, undef: true, white: false, laxbreak: true *//*global Ext, EmergenceEditor*/
Ext.define('EmergenceEditor.view.FullscreenViewport', {
    extend: 'Ext.container.Viewport'	
	,requires: [
		'Ext.layout.container.Fit'
	]
	
	,layout: 'border'

	,initComponent: function() {
		//console.info('Emergence.Editor.view.Viewport.initComponent()');
	
	
		this.items = [{
            xtype: 'emergence-editortabpanel'
			,region: 'center'
            ,singleFile: true
            ,listeners: {
                scope: this
                ,tabchange: function(tabPanel, newCard, oldCard) {
                    tabPanel.getTabBar().show();
                    tabPanel.doComponentLayout();
                }
                ,remove: function(tabPanel, oldCard) {
                    if(!tabPanel.is('emergence-editortabpanel'))
                        return true;
                        
                    if(tabPanel.items.getCount() == 1)
                    {
                        tabPanel.getTabBar().hide();
                        tabPanel.doComponentLayout();
                    }
                }
            }
		},{
			xtype: 'emergence-transfersgrid'
			,region: 'south'
			,height: 100
            ,collapsed: true
			,collapsible: true
			,split: true
            ,icon: '/img/icons/fugue/system-monitor-network.png'
		}];
        
		this.callParent();
		
	}
	
});