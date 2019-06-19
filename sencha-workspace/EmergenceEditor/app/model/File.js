/*jslint browser: true, undef: true, white: false, laxbreak: true *//*global Ext, EmergenceEditor*/
Ext.define('EmergenceEditor.model.File', {
	extend: 'Ext.data.Model'
	//,idProperty: 'ID' // ID isn't unique between SiteFile and SiteCollection!
    ,fields: [{
    	name: 'ID'
    	,type: 'integer'
    },{
    	name: 'Handle'
    },{
    	name: 'Status'
    },{
    	name:  'Created'
    	,type: 'date'
    	,dateFormat: 'timestamp'
    },{
    	name: 'CreatorID'
    	,type: 'integer'
    },{
    	name: 'ParentID'
    	,type: 'integer'
    },{
    	name: 'PosLeft'
    	,type: 'integer'
    },{
    	name: 'PosRight'
    	,type: 'integer'
    },{
    	name: 'Class'
    },{
    	name: 'FullPath'
    },{
        // override the special "text" field to programmatically populate it from a different place
        name: 'text'
        ,type: 'string'
        ,convert: function(v,r) {
            if(r.raw)
                return r.raw.Handle;
            else
                return '[[Unknown Node]]';
        }
    },{
        name: 'leaf'
        ,type: 'boolean'
        ,convert: function(v,r) {
            if(r.raw)
                return (r.raw.Class=='SiteFile'?true:false);
            else 
                return false;
        }
    }]
    /*
     *   Default implementation tries to run destroy through the store just cause I asked for a refresh
     *   This work around is as awesome as it is since it cuts down the call stack considerably.    
    */
    ,destroy: function() {
        this.remove(true);   
    }
});