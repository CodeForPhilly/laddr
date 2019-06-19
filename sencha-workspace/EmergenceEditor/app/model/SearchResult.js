/*jslint browser: true, undef: true, white: false, laxbreak: true *//*global Ext, EmergenceEditor*/
Ext.define('EmergenceEditor.model.SearchResult', {
    extend: 'Ext.data.Model'

    ,fields: [{
    	name: 'File'
    },{
        name: 'line'
        ,type: 'integer'
    },{
    	name: 'result'
    }]
});