Ext.define('EmergencePullTool.view.Viewport', {
    extend: 'Ext.container.Viewport',
    requires:[
        'Ext.layout.container.Fit',
        'EmergencePullTool.view.Main',
        'Emergence.ext.ux.DiffPanel'
    ],

    layout: {
        type: 'border'
    },

    items: [{
        xtype: 'app-main'
        ,region: 'center'
    },{
    	xtype: 'diffpanel'
    	,title: 'Select change to view differences'
    	,region: 'south'
    	,height: 400
    	,collapsible: true
    	,split: true
//    	,collapsed: true
    	,html: 'diff goes here'
    }]
});
