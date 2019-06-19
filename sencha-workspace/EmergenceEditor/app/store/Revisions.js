/*jslint browser: true, undef: true, white: false, laxbreak: true *//*global Ext, EmergenceEditor*/
Ext.define('EmergenceEditor.store.Revisions', {
    extend: 'Ext.data.Store'
    ,alias: 'store.revisions'
    ,storeId:'revisions'
    //,autoLoad: true
    ,fields:[
        {name:  'ID', type: 'integer'}
        ,'Class'
        ,'Handle'
        ,'Type'
        ,'MIMEType'
        ,{name:  'Size', type: 'integer'}
        ,'SHA1'
        ,'Status'
        ,{name:  'Timestamp', type: 'date', dateFormat: 'timestamp'}
        ,'Author'
        ,{name:  'AuthorID', type: 'integer'}
        ,{name:  'AncestorID', type: 'integer'}
        ,{name:  'CollectionID', type: 'integer'}
        ,'FullPath'
    ]
    
    ,sorters: [{
        property: 'Timestamp'
        ,direction: 'DESC'
    }]
    
    
    ,proxy: {
        type: 'ajax'
        ,url: '/editor/getRevisions/'
        ,reader: {
            type: 'json'
            ,root: 'revisions'
        }
    }
});