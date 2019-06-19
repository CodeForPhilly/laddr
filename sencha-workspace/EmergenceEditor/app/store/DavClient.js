/*jslint browser: true, undef: true, white: false, laxbreak: true *//*global Ext, EmergenceEditor*/
Ext.define('EmergenceEditor.store.DavClient', {
	extend: 'Ext.data.Connection'
	,singleton: true
	,mixins: {
        observable: 'Ext.util.Observable'
    }
	,disableCaching: false
	,JSONurl: '/develop/json/' /* this is only for getting collection directory listings */
	,url: '/develop/' /* use this for 'most' calls */
	,failure: function () { console.log('failure'); }
    ,getRevision: function(path, id, callback, scope)
    {
        return this.request({
            url: this.url + path
            ,headers: {
                'X-Revision-ID': id   
            }
            ,method: 'GET'
            ,success: callback
            ,scope: scope
            ,task: 'get-file'
        });
    }
	,getFile: function(path, callback, scope)
    {
		return this.request({
			url: this.url + path
			,method: 'GET'
			,success: callback
			,scope: scope
            ,task: 'get-file'
		});
	}
    ,getCollection: function(path, callback, scope)
    {
        return this.request({
            url: this.JSONurl + path
            ,method: 'PROPFIND'
            ,success: callback
            ,scope: scope
        });
    }
	,writeFile: function(path, data, callback, scope)
    {
		return this.request({
			url: this.url + path
			,method: 'PUT'
			,params: data
			,success: callback
			,scope: scope
            ,task: 'save-file'
		});
	}
    ,createCollectionNode: function(path, callback, scope)
    {
        return this.request({
            url: this.url + path
            ,method: 'MKCOL'
            ,params: ''
            ,success: callback
            ,scope: scope
            ,task: 'create-folder'
        });       
    }
    ,createFileNode: function(path, callback, scope)
    {
        return this.writeFile(path, '', callback, scope);
    }
	,renameNode: function(path, newPath, callback, scope)
    {
        return this.request({
            url: this.url + path
            ,method: 'MOVE'
            ,headers: {
                Destination: this.url + newPath
            }
            ,success: callback
            ,scope: scope   
        });   
    }
    ,deleteNode: function(path,callback,scope) {
        return this.request({
            url: this.url + path
            ,method: 'DELETE'
            ,success: callback
            ,scope: scope 
            ,task: 'delete-node'  
        });    
    }
    ,putDOMFile: function(path, file, completeCallback, progressCallback, scope) {
        
        var url = this.url + path;
        
        return this.putFile(url, file, completeCallback, progressCallback, scope);
    }
    ,putFile: function(path, file, completeCallback, progressCallback, scope) {
        
        var xhr = new XMLHttpRequest(); 
        
        xhr.uniqueID = Ext.id(null, 'xhr');
        
        var url = path;
        
        this.fireEvent('beforefileupload', url, file, xhr);
    	
        var progress = function(args, event) {
            
            var percentage = Math.round( (event.loaded / event.total) * 100);
            
            this.fireEvent('fileuploadprogress', percentage, event, url, file, xhr);
            
            progressCallback.call(scope, percentage, event);
        }
          
    	xhr.upload.addEventListener('progress', progress.bind(this,arguments));
    	
    	xhr.open('PUT',url);
    	
    	xhr.send(file);
    	        
        var readStateChange = function() {
            if(xhr.readyState != 4)
            {
                completeCallback.call(scope);
                this.fireEvent('afterfileupload', url, file, xhr);
            }
        }
                     
    	xhr.onreadystatechange = readStateChange.bind(this, arguments);
    }
});
