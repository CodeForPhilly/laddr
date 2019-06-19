/*jslint browser: true, undef: true, white: false, laxbreak: true *//*global Ext, EmergenceEditor*/
Ext.define('EmergenceEditor.model.ActivityEvent', {
    extend: 'Ext.data.Model'

    ,idProperty: 'href'
    ,fields: [{
    	name: 'EventType'
        ,type: 'string'
    },{
    	name: 'Handle'
        ,type: 'string'
    },{
        name: 'CollectionPath'
        ,type: 'string'
    },{
        name: 'FirstTimestamp'
    	,type: 'date'
        ,dateFormat: 'timestamp'
        ,useNull: true
    },{
        name: 'Timestamp'
    	,type: 'date'
        ,dateFormat: 'timestamp'
    },{
        name: 'RevisionID'
        ,type: 'integer'
    },{
        name: 'FirstRevisionID'
        ,type: 'integer'
    },{
        name: 'FirstAncestorID'
        ,type: 'integer'
        ,useNull: true
    },{
        name: 'revisions'
        ,useNull: true
    },{
        name: 'files'
        ,useNull: true
    },{
        name: 'revisionsCount'
        ,convert: function(v, r) {
        	var revisions = r.get('revisions');
            return revisions ? revisions.length : null;
        }
        ,useNull: true
    },{
    	name: 'Author'
    },{
    	name: 'Collection'
    }]
});