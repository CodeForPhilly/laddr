/*jslint browser: true, undef: true, white: false, laxbreak: true *//*global Ext, EmergenceEditor*/
Ext.define('EmergenceEditor.controller.Viewport', {
    extend: 'Ext.app.Controller'
	,requires: ['Ext.util.History']
	
	,refs: [{
		ref: 'menubar'
		,selector: 'emergence-menubar'
	},{
		ref: 'tabPanel'
		,selector: 'viewport > tabpanel'
	},{
		ref: 'siteTools'
		,selector: 'emergence-site-tools'
		,xtype: 'emergence-site-tools'
		,autoCreate: true	 
	},{
		ref: 'searchInput'
		,selector: 'viewport textfield[name=globalSearch]' 
	},{
		ref: 'detailsPanel'
		,selector: 'viewport > tabpanel:last' 
	},{
		ref: 'findWindow'
		,autoCreate: true
		,selector: 'emergence-find-window'
		,xtype: 'emergence-find-window'
	},{
		ref: 'importWindow'
		,autoCreate: true
		,selector: 'emergence-import-window'
		,xtype: 'emergence-import-window'
	}]
	,stores: ['SiteSearch']
	,views: ['Viewport','Menubar','Activity','SimpleCodeViewer','SiteTools','window.Find','SearchResults','window.Import']
	
	,init: function()
	{
		//console.info('Emergence.Editor.controller.Viewport.init()');
		
		// Start listening for events on views
		this.control({
			'emergence-menubar menuitem[action=site-tools]': {
				click: this.onSiteToolsClick
			}
			,'emergence-menubar menuitem[action=import]': {
				click: this.onImportClick
			}
			,'emergence-menubar menuitem[action=save]': {
				click: this.onSaveClick
			}
			,'emergence-menubar menuitem[action=find]': {
				click: this.onFindClick
			} 
			,'emergence-menubar textfield[action=help-lookup]': {
				specialkey: this.onHelpLookupSpecialKey
			}
			,'emergence-find-window': {
				show: this.onFindShow	
			}
			,'emergence-find-window textfield[name=find]': {
				specialkey: this.onFindSpecialKey	
			}
			,'emergence-find-window button[action=find]': {
				click: this.onFindButtonClick	
			}
			,'emergence-find-window button[action=next]': {
				click: this.onFindNextButtonClick	
			}
			,'emergence-find-window button[action=previous]': {
				click: this.onFindPreviousButtonClick	
			}
			//viewport
			,'viewport button[text=Search]' : {
				'click': this.onSearchClick
			}
			,'viewport > tabpanel:last': {
				expand: this.onDetailsPanelExpand	
			}
			,'viewport textfield[name=globalSearch]': {
				keydown: this.onSearchKeydown
			}
		});
	
	}
	
	,onLaunch: function()
	{
		//console.info('Emergence.Editor.controller.Viewport.onLaunch()');

		// setup history class
		Ext.getBody().createChild({
			tag: 'form'
			,id: 'history-form'
			,cls: 'x-hide-display'
			,cn: [{
				tag: 'input'
				,type: 'hidden'
				,id: 'x-history-field'
			},{
				tag: 'iframe'
				,id: 'x-history-frame'
			}]
		});
		
		// init history
		Ext.util.History.init(this.onHistoryChange, this);
		Ext.util.History.on('change', this.onHistoryChange, this);

		// init keymap
		this.keyMap = Ext.create('Ext.util.KeyMap', document, [{
			key: "s"
			,ctrl: true
			,defaultEventAction: 'stopEvent'
			,scope: this
			,handler: function() {
				this.application.fireEvent('filesave');
			}
		},{
			key: "f"
			,ctrl: true
			,defaultEventAction: 'stopEvent'
			,scope: this
			,handler: function() {
				this.onFindClick();
			}
		}]); 
		
		this.getDetailsPanel().on('expand', this.onDetailsPanelExpand, this);
	}
	,onImportDrop: function(event) {
		event.preventDefault();
		
		var e = event.browserEvent;
		
		Ext.each(e.dataTransfer.files, function(file, index, files) {
			EmergenceEditor.store.DavClient.putFile('/editor/import'
				,file
				,function() {
					/*uploadStatus[index] = true;
					
					var done = true;
					
					Ext.each(uploadStatus, function(status, index, uploadStatus) {
						if(!status)
						{
							done = false;	
						}
					}, this);
					
					if(done) {
						this.afterDropUpload.call(this,record,e.dataTransfer.files);
					}*/
				}
				,function(percentage, event) {
					//console.log(percentage);
				}
			,this);
		},this);
	}
	,onImportDragleave: function(event) {
		event.preventDefault();
		
		var e = event.browserEvent;
	}
	,onImportDragover: function(event) {
		event.preventDefault();
		
		var e = event.browserEvent;
	}
	,onSearchKeydown: function(field, event, options) {
		if(event.button == 12)
		{
			this.onSearchClick();
		}
	}
	,onSearchClick: function() {
		var query = this.getSearchInput().value;
		
		document.location.hash = '#search:' + query;
	}
	,openSearch: function(query) {
		// create search tab
		var tab = this.getTabPanel().add({
				xtype: 'search-results'
				,searchQuery: query
				,title: 'Search Results for ' + query
				,closable: true
		    })
            ,store = tab.getStore();

		// load search results
		store.getProxy().extraParams.q = query;
        store.load();

		// set search tab to activetab
		this.getTabPanel().setActiveTab(tab); 
	}
	,onHistoryChange: function()
	{
		var token = Ext.util.History.getToken();
		
		if(token)
			this.loadNavPath(token);
	}
	,loadNavPath: function(navPath)
	{
		if(navPath.charAt(0) == '/') {
			if(navPath.indexOf(':') == -1) {
				var path = navPath.substr(1);
				var line = 1;	
			}
			else {
				var path = navPath.substring(1,navPath.indexOf(':'));
				var line = navPath.substring(navPath.indexOf(':')+1);
			}
			
			this.application.fireEvent('fileopen', path, true, false, line);
		}
		else if(navPath.substr(0, 9).toLowerCase()== 'revision:')
		{
			var pathpos = navPath.indexOf('/')+1;
			var path = navPath.substr(pathpos);
			
			var idpos = navPath.indexOf('[')+1;
			var idposend = navPath.indexOf(']');
			var id = navPath.substring(idpos,idposend);
			
			this.application.fireEvent('fileopen', path, true, id);	   
		}
		else if(navPath.substr(0, 5).toLowerCase() == 'diff:')
		{
			var pathpos = navPath.indexOf('/')+1;
			var path = navPath.substr(pathpos);
			
			var idpos = navPath.indexOf('[')+1;
			var idposend = navPath.indexOf(']');
			var ids = navPath.substring(idpos,idposend);
			
			if(ids.indexOf(',') != false)
			{
				var sides = ids.split(',');
				var sideA = sides[0];
				var sideB = sides[1];
				
				this.application.fireEvent('diffopen', path, true, sideA, sideB);	
			}		
		}
		else if(navPath.substr(0,7).toLowerCase() == 'search:')
		{
			var query = navPath.substr(navPath.indexOf(':')+1);
			this.openSearch(query);
		}
		else
			this.getTabPanel().getLayout().setActiveItem(navPath);
	}
	,onImportClick: function(item, event, opts)
	{
		this.getImportWindow().show();
		this.getImportWindow().el.on('dragover', this.onImportDragover, this);
		this.getImportWindow().el.on('dragleave', this.onImportDragleave, this); 
		this.getImportWindow().el.on('drop', this.onImportDrop, this);
	}
	,onSiteToolsClick: function(item, event, opts)
	{
		this.getSiteTools().show();		   
	}
	,onHelpLookupSpecialKey: function(field, event)
	{
		if (event.getKey() == event.ENTER)
		{
			window.open('http://emr.ge/classes/'+field.getValue());
		}
	}
	,onSaveClick: function() {
		this.application.fireEvent('filesave');
	}
	,onFindShow: function(window, options)
	{
		window.down('textfield[name=find]').focus('',true);		  
	}
	,onFindSpecialKey: function(field, event)
	{
		if (event.getKey() == event.ENTER)
		{
			this.onFindButtonClick();
		}	 
	}
	,onFindClick: function() {
		this.getFindWindow().show();
	}
	,onFindButtonClick: function() {
		var findText = this.getFindWindow().down('textfield[name=find]').value;
		
		var activeTab = this.getTabPanel().activeTab;
		if(typeof activeTab.aceEditor != 'undefined')
		{
			var regex = this.getFindWindow().down('checkboxfield[name=regex]');
			var casesens = this.getFindWindow().down('checkboxfield[name=casesens]');
			var wholewords = this.getFindWindow().down('checkboxfield[name=wholewords]');
			
			activeTab.aceEditor.find(findText, {
				regExp: regex.value
				,caseSensitive: casesens.value
				,wholeWord: wholewords.value	
			});		  
		}
	}
	,onFindNextButtonClick: function() {
		var activeTab = this.getTabPanel().activeTab;
		if(typeof activeTab.aceEditor != 'undefined')
		{
			activeTab.aceEditor.findNext();		  
		}
	}
	,onFindPreviousButtonClick: function() {
		var activeTab = this.getTabPanel().activeTab;
		if(typeof activeTab.aceEditor != 'undefined')
		{
			activeTab.aceEditor.findPrevious();		  
		}
	}
	,onDetailsPanelExpand: function(tabpanel, options) {
		var activeTab = this.getTabPanel().activeTab;
		
		if(activeTab.ID)
		{
			tabpanel.down('emergence-file-revisions').store.load({params: {ID:activeTab.ID}});		 
		}
	}
});