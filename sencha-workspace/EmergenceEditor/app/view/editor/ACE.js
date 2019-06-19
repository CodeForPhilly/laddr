/*jslint browser: true, undef: true, white: false, laxbreak: true *//*global Ext, EmergenceEditor*/
Ext.define('EmergenceEditor.view.editor.ACE', {
	extend: 'Ext.Component'
	,alias: 'widget.aceeditor'
	,initComponent: function() {
		
		this.itemId = this.itemId;
        
        this.isRevision = false;
        
        if(this.revisionID)
        {
            this.isRevision = true;
            this.itemId = 'revision:[' + this.revisionID + ']/'+this.path;
        }
        else
        {
            this.itemId = '/' + this.path;   
            
        }
        
        this.tabConfig = {icon: this.getIcon()};
		
		this.callParent(arguments);
	}

	,afterRender: function() {
		this.callParent(arguments);
		
		if(EmergenceEditor.app.aceReady)
			Ext.defer(this.initEditor, 10, this);
		else
			EmergenceEditor.app.on('aceReady', this.initEditor, this, {single: true, delay: 10});

	}
	,initEditor: function() {
        
		// create ACE editor instance
		this.aceEditor = ace.edit(this.el.down('div').id);
		
        this.onResize();
        
		// configure editor
		this.aceEditor.setShowPrintMargin(false);
		this.aceEditor.getSession().setTabSize(4);
		this.aceEditor.getSession().setUseSoftTabs(true);
		
		if(this.aceTheme)
			this.aceEditor.setTheme(this.aceTheme); 
			
		// listen for changes to mark dirty
		this.aceEditor.getSession().on('change', Ext.bind(this.onEditorChange, this));
        
        // listen for undos to validate dirty state
        Ext.Function.interceptAfter(this.aceEditor.getSession().getUndoManager(), 'undo', Ext.bind(this.onEditorUndo, this));
		
        // disable built in find dialog
        this.aceEditor.commands.removeCommand('find');
        
    /*
        var Split = require("ace/split").Split;
        var split = new Split(this.aceEditor.container, this.aceTheme, 1);
        split.on("focus", function(editor) {
            this.aceEditor = editor;
        });
        this.split = split;
    */
        		
		// load file if one was provided via path config
		if(this.path)
			this.loadFile();
		
        //this.setSplit('beside');	
			
		// relay resize events to ace
		this.on('resize', this.onResize, this);
	}
    ,setSplit: function(value) {
        var sp = this.split;
        if (value == "none") {
            if (sp.getSplits() == 2) {
                secondSession = sp.getEditor(1).session;
            }
            sp.setSplits(1);
        } else {
            var newEditor = (sp.getSplits() == 1);
            if (value == "below") {
                sp.setOriantation(sp.BELOW);
            } else {
                sp.setOriantation(sp.BESIDE);
            }
            sp.setSplits(2);

            if (newEditor) {
                var session = this.secondSession || sp.getEditor(0).session;
                var newSession = sp.setSession(session, 1);
                newSession.name = session.name;
            }
        }      
    }
	,onResize: function() {
        this.aceEditor.container.style.width = this.el.dom.style.width;
        this.aceEditor.container.style.height = this.el.dom.style.height;
        this.aceEditor.resize();
    }
	,onEditorChange: function() {
	
		if(this.loadedValue && !this.fileDirty)
		{
			this.fileDirty = true;
			this.tab.setText(this.tab.text+'*');
		}
	}
    
    ,onEditorUndo: function() {
        if(this.fileDirty && this.loadedValue == this.getValue())
        {
            this.fileDirty = false;
            this.tab.setText(this.tab.text.substr(0, this.tab.text.length-1));
        }
    }


	,loadFile: function(path) {
	
		if(path)
			this.path = path;
            
        this.setLoading({msg: 'Opening /' + this.path}); // enable loading mask
	   
       //console.log(this.isRevision);
       
        if(this.isRevision)
            EmergenceEditor.store.DavClient.getRevision(this.path, this.revisionID, this.afterLoadFile, this);
        else 
		    EmergenceEditor.store.DavClient.getFile(this.path, this.afterLoadFile, this);
	}
	,afterLoadFile: function(response) {

        this.revisionID = response.getResponseHeader('X-VFS-ID');  
        this.contentType = response.getResponseHeader('Content-Type');
        
        // set tab icon
        this.tab.setIcon(this.getIcon(this.contentType)); 

        // set editor mode
        var mode = this.getFileMode(this.contentType);
        if(mode)
             this.aceEditor.getSession().setMode(new (require("ace/mode/" + mode).Mode));
        
        // set editor content
        this.setValue(response.responseText);
        
        this.scanCode(mode,response.responseText);
        
        // set line
        this.aceEditor.gotoLine(this.initialLine);
        
        // clear loading  mask
        this.setLoading(false);
            
        EmergenceEditor.app.fireEvent('afterloadfile', this, this.revisionID, response);
    }
	,saveFile: function() {
        this.tab.setIcon('/img/loaders/spinner.gif');
        
        var fileData = this.getValue();

        EmergenceEditor.store.DavClient.writeFile(this.path, fileData, this.afterSaveFile, this);
	}
    ,afterSaveFile: function(response) {
        if(this.fileDirty)
        {
            this.fileDirty = false;
            this.tab.setText(this.tab.text.substr(0, this.tab.text.length-1));
        }
        
        this.loadedValue = response.request.options.params;
        
        this.tab.setIcon(this.getIcon(this.contentType)); 
    } 
	,getValue: function() {
		return this.aceEditor.getSession().getValue();
	}
	
	,setValue: function(value) {
		this.aceEditor.getSession().setValue(value);
        this.loadedValue = value; // store original text for dirty tracking
        return true;
	}
	
	
	,getFileMode: function(mimeType) {
		switch(mimeType)
		{
			case 'application/javascript':
				return 'javascript';
				
			case 'application/php':
				return 'php';
				
			case 'text/html':
			case 'text/x-c++':
			case 'text/plain':
				return 'html';
			
			case 'text/css':
				return 'css';
            
            case 'text/x-scss':
                return 'scss';
            
            case 'text/x-dwoo':
            case 'text/x-smarty':
            case 'text/x-html-template':
                return 'html';
				
			default:
				return false;
		}	
	}
    ,getIcon: function(mimeType)
    {
        switch(mimeType)
        {
            case 'application/javascript':
                return '/img/icons/fugue/blue-document-text.png';
                
            case 'application/php':
                return '/img/icons/fugue/blue-document-php.png';
                
            case 'text/html':
            case 'text/x-c++':
            case 'text/plain':
                return '/img/icons/fugue/blue-document-text.png';
            
            case 'text/css':
                return '/img/icons/fugue/blue-document-text.png';
                
            default:
                return '/img/icons/fugue/blue-document.png';
        }
    }
	,scanCode: function(mime,code) {
		switch(mime)
        {
            case 'application/javascript':
                return this.scanJS(code);
                
            case 'application/php':
                return this.scanPHP(code);
                
            default:
                return false;
        }
	}
	,scanJS: function(code) {
		parse(code);
	}
	,scanPHP: function(code) {
		
	}
});