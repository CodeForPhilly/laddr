/*jslint browser: true, undef: true, white: false, laxbreak: true *//*global Ext, EmergenceEditor*/
Ext.define('EmergenceEditor.controller.Revisions', {
    extend: 'Ext.app.Controller'
    
    ,views: ['Revisions','contextmenu.RevisionsMenu','Viewport']
    ,stores: ['Revisions']
    ,models: []
    ,refs: [{
        ref: 'revisionsGrid'
        ,autoCreate: true
        ,selector: 'emergence-file-revisions'
        ,xtype: 'emergence-file-revisions'
    },{
		ref: 'revisionsMenu'
		,autoCreate: true
		,selector: 'emergence-revisionsmenu'
		,xtype: 'emergence-revisionsmenu'
	},{
        ref: 'diffWindow'
        ,autoCreate: true
        ,selector: 'SimpleCodeViewer'
        ,xtype: 'emergence-diff-viewer'   
    },{
        ref: 'tabPanel'
        ,selector: 'viewport > tabpanel'
    }]
    ,onLaunch: function() {
        //console.info('Emergence.Editor.controller.Revisions.onLaunch()');
    }
    ,init: function() {
        //console.info('Emergence.Editor.controller.Files.init()');
        
        // Start listening for events on views
        this.control({
            'emergence-file-revisions': {
                itemdblclick: this.openRevision
                ,itemcontextmenu: this.onRevisionContextMenu
            }
            ,'emergence-revisionsmenu > menuitem[action=open]': {
                click: this.onOpenClick  
            }
            ,'emergence-revisionsmenu > menuitem[action=properties]': {
                click: this.onPropertiesClick  
            }
            ,'emergence-revisionsmenu > menuitem[action=compare_latest]': {
                click: this.onCompareLatestClick  
            }
            ,'emergence-revisionsmenu > menuitem[action=compare_next]': {
                click: this.onCompareNextClick  
            }
            ,'emergence-revisionsmenu > menuitem[action=compare_previous]': {
                click: this.onComparePreviousClick  
            }
            ,'tabPanel': {
                tabchange: this.onTabChange   
            }
        });
        
        this.application.on('afterloadfile', this.onAfterLoadFile, this);
    }
    ,onTabChange: function(tabpanel, newcard, oldcard, eopts)
    {
        
    }
    ,openRevisionByRecord: function(record)
    {
    	Ext.util.History.add('revision:[' + record.get('ID') + ']/'+record.get('FullPath'), true);
    }
    ,openRevision: function(view, record, itemindex, event, options)
    {
        this.openRevisionByRecord(record);
    }
    ,onRevisionContextMenu: function(revisionsGrid, record, item, index, event, options)
    {
		event.stopEvent();
		
        this.currentRecord = record;
        this.currentIndex = index;

		this.getRevisionsMenu().showAt(event.getXY());  
	}
	,onPropertiesClick: function(menuItem, event, options)
    {
        var data = this.currentRecord.raw;
        
        var html = ""; 
        for (var key in data)
        {
            html += key + ": " + data[key] + "<br>\n";     
        }
        
        Ext.create('Ext.window.Window', {
            title: data.Handle,
            height: 300,
            width: 375,
            layout: 'fit',
            html: html
        }).show();
    }
    ,onOpenClick: function(menuItem, event, options)
    {
        this.openRevisionByRecord(this.currentRecord); 
    }
    ,onCompareLatestClick: function(menuItem, event, options)
    {
        this.openDiff(this.currentRecord,this.currentRecord.store.data.get(0));
    }
    ,onCompareNextClick: function(menuItem, event, options)
    {  
        this.openDiff(this.currentRecord,this.currentRecord.store.data.get(this.currentIndex-1));
    }
    ,onComparePreviousClick: function(menuItem, event, options)
    {
        this.openDiff(this.currentRecord.store.data.get(this.currentIndex+1),this.currentRecord);   
    }
    ,openDiff: function(sideA, sideB)
    {
        Ext.util.History.add('diff:[' + sideA.get('ID') + ',' + sideB.get('ID') + ']/'+sideA.get('FullPath'), true);    
    }
    
    ,onAfterLoadFile: function(editor, revisionID, response) {
        // load revisions
        var revisionsPanel = this.getRevisionsGrid();
        
        if(revisionsPanel.isVisible(true))
        {
            revisionsPanel.store.load({
                params: {ID: revisionID}
            });
        }
    }
});