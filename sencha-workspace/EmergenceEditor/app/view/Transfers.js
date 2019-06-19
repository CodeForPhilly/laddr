/*jslint browser: true, undef: true, white: false, laxbreak: true *//*global Ext, EmergenceEditor*/
Ext.define('EmergenceEditor.view.Transfers', {
	extend: 'Ext.grid.Panel'
    ,alias: 'widget.emergence-transfersgrid'
	,title: 'Transfers'
	,sortableColumns: false
	,enableColumnHide: false
	,enableColumnMove: false
	,columns: {
		defaults: {
			menuDisabled: true
		}
		,items: [
			{ header: 'Task',  dataIndex: 'task', width: 150 }
			,{ header: 'Path', dataIndex: 'path', flex: 1 }
			,{ header: 'Info', dataIndex: 'info', flex: 1 }
			,{ header: 'Status', dataIndex: 'status', width: 150 }
		]
	}
	
});