/*jslint browser: true, undef: true, white: false, laxbreak: true *//*global Ext, EmergenceEditor*/
Ext.define('EmergenceEditor.proxy.Develop', {
	extend: 'Ext.data.proxy.Ajax'
	,alias: 'proxy.develop'
	,requires: ['Ext.data.Request']
	
    ,url: '/develop/json/'
    ,noCache: false
    
    ,buildRequest: function(operation) {
    
    	var url = this.url;
    	
    	if(!operation.node.isRoot())
    	{
			url += operation.node.get('FullPath');	
    	}
    	
		return Ext.create('Ext.data.Request', {
			action: operation.action//'Downloading file'//
			,records : operation.records
			,operation: operation
			,url: url
            ,task: 'directory-listing'
		});
	}



	,doRequest: function(operation, callback, scope) {
		var writer  = this.getWriter()
			,request = this.buildRequest(operation, callback, scope);
	
		Ext.apply(request, {
			headers       : this.headers,
			timeout       : this.timeout,
			scope         : this,
			callback      : this.createRequestCallback(request, operation, callback, scope),
			method        : this.getMethod(request),
			disableCaching: false // explicitly set it to false, ServerProxy handles caching
		});
	
		EmergenceEditor.store.DavClient.request(request);
	
		return request;
	}
});