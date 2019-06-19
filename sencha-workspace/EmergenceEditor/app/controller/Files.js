/*jslint browser: true, undef: true, white: false, laxbreak: true *//*global Ext, EmergenceEditor*/
Ext.define('EmergenceEditor.controller.Files', {
	extend: 'Ext.app.Controller'
	
	,views: ['file.Tree', 'contextmenu.CollectionMenu', 'contextmenu.FileMenu', 'contextmenu.MultiNodeMenu']
	,stores: ['FileTree']
	,models: ['File']
	,refs: [{
		ref: 'fileMenu'
		,autoCreate: true
		,selector: 'emergence-filemenu'
		,xtype: 'emergence-filemenu'
	},{
		ref: 'collectionMenu'
		,autoCreate: true
		,selector: 'emergence-collectionmenu'
		,xtype: 'emergence-collectionmenu'
	},{
		ref: 'multiMenu'
		,autoCreate: true
		,selector: 'emergence-multinodemenu'
		,xtype: 'emergence-multinodemenu'
	},{
		ref: 'fileTree'
		,selector: 'emergence-filetree'
		,xtype: 'emergence-filetree'
	}]
    ,onLaunch: function() {
        //console.info('Emergence.Editor.controller.Files.onLaunch()');
    }
	,init: function() {
		//console.info('Emergence.Editor.controller.Files.init()');
		
		// Start listening for events on views
		this.control({
            /*
             *  FILE TREE EVENTS
             */
			'emergence-filetree': {
				itemcontextmenu: this.onNodeContextMenu
				,itemdblclick: this.onNodeDblClick
				,render: this.onTreeRendered
			}
			,'emergence-filetree treeview': {
				beforedrop: this.onTreeNodeBeforeDrop
				,drop: this.onTreeNodeMoveDrop
			}
            /*
             *  FILE NODE CONTEXT MENU
             */
            ,'emergence-filemenu > menuitem[action=properties]': {
                click: this.onPropertiesClick  
            }
            ,'emergence-filemenu > menuitem[action=rename]': {
                click: this.onRenameClick  
            }
            ,'emergence-filemenu > menuitem[action=open]': {
                click: this.onOpenClick  
            }
            ,'emergence-filemenu > menuitem[action=delete]': {
                click: this.onDeleteClick  
            }
            /*
             *  FOLDER NODE CONTEXT MENU
             */
            ,'emergence-collectionmenu > menuitem[action=new-file]': {
                click: this.onNewFileClick     
            }
            ,'emergence-collectionmenu > menuitem[action=new-folder]': {
                click: this.onNewFolderClick     
            }
            ,'emergence-collectionmenu > menuitem[action=rename]': {
                click: this.onRenameClick     
            }
            ,'emergence-collectionmenu > menuitem[action=refresh]': {
                click: this.onRefreshClick     
            }
            ,'emergence-collectionmenu > menuitem[action=delete]': {
                click: this.onDeleteClick     
            }
			/*
             *  MULTI NODE CONTEXT MENU
             */
            ,'emergence-multinodemenu > menuitem[action=open]': {
                click: this.onMultiOpenClick  
            }
            ,'emergence-multinodemenu > menuitem[action=delete]': {
                click: this.onMultiDeleteClick  
            }
		});
	}
	,onTreeRendered: function() {
		this.getFileTree().el.on('dragover', this.onTreeDragover, this);
        this.getFileTree().el.on('dragleave', this.onTreeDragleave, this); 
		this.getFileTree().el.on('drop', this.onFileTreeDrop, this);
	}
	,onFileTreeDrop: function(event) {
		event.preventDefault();
		
		var e = event.browserEvent;
		var treePanel = this.getFileTree();
		var treeView = treePanel.view;
		var node = treeView.findTargetByEvent(event);
		var record = treeView.getRecord(node);
		
        // if the drop occured on a file assume the file upload is simply being placed into the parent collection
		if(record.raw.Class == 'SiteFile')
		{
			record = record.parentNode;
		}
		
		if(record.raw.Class == 'SiteCollection')
		{
            //console.log(e.dataTransfer);
            
            var uploadStatus = new Array(e.dataTransfer.files.length);
            
            Ext.each(e.dataTransfer.files, function(file, index, files) {
                
                var path = record.raw.FullPath + '/' + file.name;

                EmergenceEditor.store.DavClient.putDOMFile(path
                    ,file
                    ,function() {
                        uploadStatus[index] = true;
                        
                        var done = true;
                        
                        Ext.each(uploadStatus, function(status, index, uploadStatus) {
                            if(!status)
                            {
                                done = false;   
                            }
                        }, this);
                        
                        if(done) {
                            this.afterDropUpload.call(this,record,e.dataTransfer.files);
                        }
                    }
                    ,function(percentage, event) {
                        //console.log(percentage);
                    }
                ,this);  
            }, this);
		}
	}
    ,afterDropUpload: function(collectionRecord, files) {
        //console.log('file upload sequence completed');
        this.getFileTreeStore().refreshNodeByRecord(collectionRecord);      
    }
    ,onTreeDragleave: function(event) {
        event.preventDefault();
        
        var e = event.browserEvent;
        var treePanel = this.getFileTree();
        var treeView = treePanel.view;
        var node = treeView.findTargetByEvent(event);
        
        if(node) {
            Ext.get(node).removeCls('x-grid-row-focused')
        }
    }
	,onTreeDragover: function(event) {
		event.preventDefault();
        
        var e = event.browserEvent;
        var treePanel = this.getFileTree();
        var treeView = treePanel.view;
        var node = treeView.findTargetByEvent(event);
        
        if(node) {
            Ext.get(node).addCls('x-grid-row-focused');
            
            var record = treeView.getRecord(node);
            
            if(record.raw.Class == 'SiteCollection')
            {
                record.expand();  
            }
        }
	}
    ,openFileByRecord: function(record)
    {
        Ext.util.History.add('/'+record.get('FullPath'), true);       
    }
    ,openRevisionByRecord: function(record)
    {
        
    }
    /*
     *           FILE TREE NODE MOVEMENT HANDLERS
     */
    ,onTreeNodeBeforeDrop: function(node, oldNodeData, overModel, dropPosition, dropHandler)
    {
    	var title = (oldNodeData.records.length == 1)?'Move Item':'Move Multiple Items';
    	var prompt = (oldNodeData.records.length == 1)?"Are you sure you want to move this item to " + overModel.data.FullPath + "?":"Are you sure you want to move these " + oldNodeData.records.length + " items to " + overModel.data.FullPath + "?";
    	
    	dropHandler.wait = true;
    	
    	Ext.Msg.confirm(title, prompt, function(button, value, opts) {
    		if(button == 'yes')
    		{
//    			/* Bug Fix Start
//    			 * see: http://www.sencha.com/forum/showthread.php?135377-beforedrop-not-working-as-expected&p=623011&viewfull=1#post623011
//    			 */
//    			var plugin = this.getFileTree().down('treeview').getPlugin('ddplugin');
//    			var dropZone = plugin.dropZone;
//    			
//				dropZone.overRecord = overModel;
//                dropZone.currentPosition = dropPosition;
//    			
//    			/* Bug Fix End */
    			
		    	dropHandler.processDrop();
    		}
    	},this);
    	
    	return false;
    }
	,onTreeNodeMoveDrop: function(node, oldNodeData, overModel, dropPosition, options)
	{
		var from,to;
		var toRefresh = {};
		
		Ext.each(oldNodeData.records, function(record) {
	    	from = record.data.FullPath;
	    	to = overModel.data.FullPath + '/' + record.data.text;

			EmergenceEditor.store.DavClient.renameNode(from,to,function() {     
				if(record.parentNode) {
					if(!toRefresh[record.parentNode.raw.ID])
					{
						toRefresh[record.parentNode.raw.ID] = true;
						this.getFileTreeStore().refreshNodeByRecord(record.parentNode);	
					}
				}
            },this); 
    	},this);
	}
    /*
     *           FILE TREE EVENT HANDLERS
     */
	,onTreeStoreLoad: function(store, node, records, successful, options)
    {  
		
	}
	,onNodeDblClick: function(view, record, item, index, event, options)
    {
        if(record.raw.Class == 'SiteFile')
        {
		    this.openFileByRecord(record); 
        }
	}
	,onNodeContextMenu: function(treePanel, record, item, index, event, options)
    {
		event.stopEvent();
		
        this.currentRecord = record;
        
        var selectionModel = this.getFileTree().getSelectionModel()
        
        var selection = selectionModel.getSelection();
        
        var foundRecordInSelection = false;
        
        Ext.each(selection,function(item) {
        	if(item.internalId == record.internalId) {
        		foundRecordInSelection = true;
        	}
        },this);
        
        if(!foundRecordInSelection) {
        	selectionModel.select(record);
        }
        
		if(record.raw.Class == 'SiteFile' && selection.length == 1)
		{
			this.getFileMenu().showAt(event.getXY()); 
		}
		else if(record.raw.Class == 'SiteCollection' && selection.length == 1)
		{
			this.getCollectionMenu().showAt(event.getXY()); 
		}
		else if(selection.length > 1)
		{
			this.getMultiMenu().showAt(event.getXY()); 
		}
	}
    /*
     *           FILE CONTEXT MENU EVENT HANDLERS
     */
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
        this.openFileByRecord(this.currentRecord); 
    }
    /*
     *           FOLDER CONTEXT MENU EVENT HANDLERS
     */
    ,onNewFileClick: function(menuItem, event, options)
    {
		Ext.Msg.prompt('New File', 'Provide a filename:', function(button, value, options) {
			if(button == 'ok' && !Ext.isEmpty(value)) {
				var newFile = this.currentRecord.raw.FullPath + '/' + value;
	            EmergenceEditor.store.DavClient.createFileNode(newFile,function() {
	                this.getFileTreeStore().refreshNodeByRecord(this.currentRecord);     
	            },this);  
			}
		},this);
    }
    ,onNewFolderClick: function(menuItem, event, options)
    {
		Ext.Msg.prompt('New Folder', 'Provide a folder name:', function(button, value, options) {
			if(button == 'ok' && !Ext.isEmpty(value)) {
				var newFolder = this.currentRecord.raw.FullPath + '/' + value;
	            EmergenceEditor.store.DavClient.createCollectionNode(newFolder,function() {
	                this.getFileTreeStore().refreshNodeByRecord(this.currentRecord);     
	            },this);  
			}
		},this);
    }
    ,onRefreshClick: function(menuItem, event, options)
    {
        this.getFileTreeStore().refreshNodeByRecord(this.currentRecord);
    }
    /*
     *           FOLDER & FILE CONTEXT MENU EVENT HANDLERS
     */
    ,onRenameClick: function(menuItem, event, options)
    {
		Ext.Msg.prompt('Rename File', 'Provide a new name:', function(button, value, options) {
			if(button == 'ok' && !Ext.isEmpty(value)) {
				var newPath = this.currentRecord.parentNode.raw.FullPath + '/' + value;
	            EmergenceEditor.store.DavClient.renameNode(this.currentRecord.raw.FullPath,newPath,function() {
	                this.getFileTreeStore().refreshNodeByRecord(this.currentRecord.parentNode);     
	            },this);  
			}
		},this,false,this.currentRecord.raw.Handle);
    } 
    ,onDeleteClick: function(menuItem, event, options)
    {
    	Ext.Msg.confirm('Delete File', "Are you sure you want to delete " + this.currentRecord.raw.Handle + "?", function(button, value, options) {
    		if(button == 'yes')
    		{
		    	EmergenceEditor.store.DavClient.deleteNode(this.currentRecord.raw.FullPath,function() {
		        	this.getFileTreeStore().refreshNodeByRecord(this.currentRecord.parentNode);     
	            },this);
    		}
    	},this);
    }
    /*
     *           MULTI NODE CONTEXT MENU EVENT HANDLERS
     */
    ,onMultiOpenClick: function(menuItem, event, options)
    {
    	var selection = this.getFileTree().getSelectionModel().getSelection();
    	Ext.each(selection, function(record) {
    		if(record.raw.Class == 'SiteFile')
    		{
    			this.openFileByRecord(record);
    		}
    		else if(record.raw.Class == 'SiteCollection')
    		{
    			this.getFileTree().expandPath(record.getPath());
    		}
    	}, this);
    }
    ,onMultiDeleteClick: function(menuItem, event, options)
    {
    	var selection = this.getFileTree().getSelectionModel().getSelection();
    	
    	var toRefresh = {};
    	
    	Ext.Msg.confirm('Delete Multiple Items', "Are you sure you want to delete these " + selection.length + " items?", function(button, value, options) {
    		if(button == 'yes')
    		{
		    	Ext.each(selection, function(record) {
					EmergenceEditor.store.DavClient.deleteNode(record.raw.FullPath,function() {
						if(record.parentNode) {
							if(!toRefresh[record.parentNode.raw.ID])
							{
								toRefresh[record.parentNode.raw.ID] = true;
								this.getFileTreeStore().refreshNodeByRecord(record.parentNode);	
							}
						}
		            },this);
		    	}, this);
    		}
    	},this);
    }
});