/*jslint browser: true, undef: true, white: false, laxbreak: true *//*global Ext, EmergenceEditor*/
Ext.define('EmergenceEditor.controller.Transfers', {
	extend: 'Ext.app.Controller'


	,views: ['Transfers']
	//,stores: ['Transfers']
	//,models: ['Transfer']
	
	,refs: [{
		ref: 'grid'
		,selector: 'emergence-transfersgrid'
	}]
	
	,init: function() {
		//console.info('Emergence.Editor.controller.Transfers.init()');
        
        this.uploadsInProgress = 0;

		this.application.on('transferComplete', function(data) {
			//throw "Caught deprecated transferComplete event!";
			this.getGrid().getStore().insert(0, data);
			
		}, this);

        EmergenceEditor.store.DavClient.addEvents('beforefileupload','afterfileupload','fileuploadprogress');
        
        EmergenceEditor.store.DavClient.on('beforefileupload', this.onBeforeFileUpload, this);
        EmergenceEditor.store.DavClient.on('afterfileupload', this.onAfterFileUpload, this);
        EmergenceEditor.store.DavClient.on('fileuploadprogress', this.onFileUploadProgress, this);
        
		EmergenceEditor.store.DavClient.on('beforerequest', this.onBeforeRequest, this);
		EmergenceEditor.store.DavClient.on('requestcomplete', this.onRequestComplete, this);
		EmergenceEditor.store.DavClient.on('requestexception', this.onRequestException, this);
	}
	
    ,onBeforeFileUpload: function(path, DOMFile, XHRObject) {
        
        this.getGrid().getStore().insert(0, {
            requestId: XHRObject.uniqueID
            ,task: 'PUT'
            ,path: path
            //,info: 'Transfer Completed, transferred ' + response.responseText.length + ' bytes'
            ,status: 'Request sent'
        });
        
    }
    ,onAfterFileUpload: function(path, DOMFile, XHRObject) {
        
        var store = this.getGrid().getStore()
            ,oldRecord = store.findRecord('requestId',XHRObject.uniqueID)
            ,newData = {
                requestId: XHRObject.uniqueID
                ,task: 'Uploaded file'
                ,path: path
                ,info: 'Transfer completed, uploaded ' + XHRObject.total + ' bytes' 
                ,status: 'Complete'
            };
            
        if(oldRecord)
            oldRecord.set(newData);
        else
            store.insert(0, newData);
            
            
    }
    ,onFileUploadProgress: function(progress, event, path, DOMFile, XHRObject) {
        
        // store total in the xhrobject for later
        XHRObject.total = event.total;
        
        var store = this.getGrid().getStore()
            ,oldRecord = store.findRecord('requestId',XHRObject.uniqueID)
            ,newData = {
                requestId: XHRObject.uniqueID
                ,task: 'PUT'
                ,path: path
                ,info: 'Transfer in progress: ' + Math.round(event.loaded / 1024) + 'KB /' + Math.round(event.total / 1024) + 'KB (' + progress + '%)' 
                ,status: 'In Progress'
            };
            
        if(oldRecord)
            oldRecord.set(newData);
        else
            store.insert(0, newData);   
    }
	,onBeforeRequest: function(connection, options) {
        
        if(options.method == 'PUT' || options.method == 'POST')
        {
            this.uploadsInProgress++;
            this.getGrid().setTitle('Uploading&hellip;');
        }
        
		this.getGrid().getStore().insert(0, {
			requestId: Ext.data.Connection.requestId+1
			,task: options.method
			,path: options.url
			//,info: 'Transfer Completed, transferred ' + response.responseText.length + ' bytes'
			,status: 'Request sent'
        });
        
	}
	
	,onRequestComplete: function(connection, response, options) {
        
        if(options.method == 'PUT' || options.method == 'POST')
        {
            if(--this.uploadsInProgress == 0)
                this.getGrid().setTitle('Transfers');
        }
        
		//console.log(response.request.options.url);

		var store = this.getGrid().getStore()
			,oldRecord = store.findRecord('requestId', response.requestId)
			,newData = {
				requestId: response.requestId
				,task: options.method
				,path: options.url
				,status: 'Complete'
	        };
	        
		// add method-specific attributes
		if(options.method == 'PUT')
        {
			newData.info = 'Transfer Completed, uploaded ' + options.params.length + ' bytes';
        }
        else
        {
            newData.info = 'Transfer Completed, downloaded ' + response.responseText.length + ' bytes';
        }
        
        switch(response.request.options.task)
        {
            case 'get-file':
                newData.task = 'Downloading file';
                if(typeof response.request.options.headers != 'undefined')
                {
                    newData.path = 'Revision (' + response.request.options.headers['X-Revision-ID'] + ') ' + newData.path;     
                }
                break;
            case 'directory-listing':
                newData.task = 'Reading directory';
                break;
            case 'save-file':
                newData.task = 'Uploading file';
                break;
            case 'delete-file':
                newData.task = 'Deleting file';
                break;
            case 'create-folder':
                newData.task = 'Creating directory';
                break;
        }
                
		// update or insert into grid
		if(oldRecord)
			oldRecord.set(newData);
		else
			store.insert(0, newData);
	}
	
	,onRequestException: function(connection, response, options) {
        
        if(options.method == 'PUT' || options.method == 'POST')
        {
            if(--this.uploadsInProgress == 0)
                this.getGrid().setTitle('Transfers (Exception)');
        }

		this.getGrid().getStore().insert(0, {
            task: options.method
            ,path: options.url
            ,info: 'Request failed with HTTP status '+response.status
            ,status: 'Exception'
        });
	}
	
});