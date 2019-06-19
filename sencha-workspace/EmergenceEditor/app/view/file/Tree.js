/*jslint browser: true, undef: true, white: false, laxbreak: true *//*global Ext, EmergenceEditor*/
Ext.define('EmergenceEditor.view.file.Tree', {
	extend: 'Ext.tree.Panel'
	,xtype: 'emergence-filetree'
	,requires: [
		'Ext.tree.plugin.TreeViewDragDrop'
	]
	
	,stateId: 'editor-filetree'
	,store: 'FileTree'
	,title: 'Filesystem'
	,useArrows: true
	,rootVisible: false
	,autoScroll: true
	,scrollDelta: 10
	,multiSelect: true
	,viewConfig: {
		loadMask: false
		,plugins: {
			ptype: 'treeviewdragdrop'
			,pluginId : 'ddplugin'
			,appendOnly: true
			,dragText : '{0} selected item{1}'
			,containerScroll: true
		}
	}
});