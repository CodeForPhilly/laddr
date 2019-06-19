/*jslint browser: true, undef: true, white: false, laxbreak: true *//*global Ext, EmergenceEditor*/
Ext.define('EmergenceEditor.store.SiteSearch', {
    extend: 'Ext.data.Store'
    ,alias: 'store.sitesearch'
    //,autoLoad: true
    ,model: 'EmergenceEditor.model.SearchResult'
    ,proxy: {
        type: 'ajax'
        ,url: '/editor/search'
        ,reader: {
            type: 'json'
            ,root: 'data'
        }
    }
});