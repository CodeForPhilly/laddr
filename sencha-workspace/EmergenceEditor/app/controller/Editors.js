/*jslint browser: true, undef: true, white: false, laxbreak: true *//*global Ext, EmergenceEditor*/
Ext.define('EmergenceEditor.controller.Editors', {
	extend: 'Ext.app.Controller'
	
	,views: ['editor.TabPanel','editor.ACE']
	,refs: [{
		ref: 'tabPanel'
		,selector: 'tabpanel'
	}]
	
	,aceModules: [
		'/jslib/ace/mode-javascript.js'
		,'/jslib/ace/mode-html.js'
		,'/jslib/ace/mode-php.js'
		,'/jslib/ace/mode-css.js'
		,'/jslib/ace/mode-json.js'
        ,'/jslib/ace/mode-scss.js'
        //,'/jslib/ace/mode-smarty.js'
        ,'/jslib/ace/theme-specials_board.js'
	]
	,aceTheme: 'ace/theme/specials_board'
	
	,init: function() {
		var me = this
			,app = me.application
			,previousDisableCaching = Ext.Loader.getConfig('disableCaching');
			
		//console.info('Emergence.Editor.controller.Editors.init()');

		// Start listening for events on views
		me.control({
			'emergence-editortabpanel': {
				tabchange: me.onTabChange
                ,staterestore: me.onTabsStateRestore
			}
		});
		
		app.on({
			scope: me
			,fileopen: 'onFileOpen'
			,filesave: 'onFileSave'
			,fileclose: 'onFileClose'
			,diffopen: 'onDiffOpen'
		});
		
		// load ACE javascripts
		app.aceReady = false;
		app.aceModulesLoaded = [];

		Ext.Loader.setConfig('disableCaching', false);
		Ext.Loader.loadScript({
			url: '/jslib/ace/ace.js'
			,onLoad: function() {
				Ext.each(me.aceModules, function(moduleUrl) {
					Ext.Loader.loadScript({
						url: moduleUrl
						,onLoad: function() {
							app.aceModulesLoaded.push(moduleUrl);
							
							if(app.aceModulesLoaded.length == me.aceModules.length)
							{
								Ext.Loader.setConfig('disableCaching', previousDisableCaching);
								app.aceReady = true;
								app.fireEvent('aceReady');
							}
						}
					});
				});
			}
		});
	}
	,onLaunch: function()
    {
		//console.info('Emergence.Editor.controller.Editors.onLaunch()');
	}
	,onTabChange: function(tabPanel, newCard, oldCanel)
    {
        var token = newCard.itemId;
           
        if(token)
            this.application.setActiveView(token, newCard.title);
            
		var activeCard = this.getTabPanel().getActiveTab();
		
		if(activeCard.xtype == 'aceeditor' && typeof activeCard.aceEditor != 'undefined')
		{
			activeCard.onResize();
		}  
	}
    ,onTabsStateRestore: function(tabPanel, state) {
        
        Ext.each(state.openFiles, function(path) {
            this.onFileOpen(path, false);      
        }, this);
        
    }
    ,onDiffOpen: function(path, autoActivate, sideA, sideB)
    {
        autoActivate = autoActivate !== false; // default to true 
        
        var itemId, title;
        
        title = path.substr(path.lastIndexOf('/')+1) + ' (' + sideA + '&mdash;' + sideB + ')';
        itemId = 'diff:[' + sideA + ',' + sideB + ']/'+path;
        
        var tab = this.getTabPanel().getComponent(itemId); 
        
        if(!tab)
        {
            tab = this.getTabPanel().add({
                xtype: 'emergence-diff-viewer'
                ,path: path
                ,sideAid: sideA
                ,sideBid: sideB
                ,title: title
                ,closable: true
                ,html: '<div></div>'
            });
        }
        
        if(autoActivate)
            this.getTabPanel().setActiveTab(tab);        
    }
	,onFileOpen: function(path, autoActivate, id, line) {
    
        autoActivate = autoActivate !== false; // default to true
	    
        var itemId, title;
        
        if(id)
        {
            itemId = 'revision:[' + id + ']/'+path;
            title = path.substr(path.lastIndexOf('/')+1) + '(' + id + ')';
        }
        else
        {
            itemId = '/' + path;   
            title = path.substr(path.lastIndexOf('/')+1);
        }
        
		var tab = this.getTabPanel().getComponent(itemId);
                   
        if(!tab)
		{
        	tab = this.getTabPanel().add({
	        	xtype: 'aceeditor'
	        	,path: path
	        	,aceTheme: this.aceTheme
	        	,title: title
	        	,closable: true
	        	,initialLine: line
                ,html: '<div></div>'
                ,revisionID: id
                ,persistent: !id
	        });
		}
        
        if(autoActivate) {
	    	this.getTabPanel().setActiveTab(tab);
        }
	}
	,onFileSave: function() {
	
		var activeCard = this.getTabPanel().getActiveTab();
		
		if(activeCard.xtype == 'aceeditor')
		{
			activeCard.saveFile();
		}
	}
	,onFileClose: function() {
	
		var activeCard = this.getTabPanel().getActiveTab();
		
		if(activeCard.closable)
		{
			activeCard.close();
		}
	}
});