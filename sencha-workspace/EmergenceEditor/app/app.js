/*jslint browser: true, undef: true, white: false, laxbreak: true *//*global Ext, EmergenceEditor*/

// DO NOT DELETE - this directive is required for Sencha Cmd packages to work.
//@require @packageOverrides

Ext.application({
	name: 'EmergenceEditor'
	,requires: [
		'Ext.util.KeyMap'
		,'Ext.state.LocalStorageProvider'
		,'EmergenceEditor.store.DavClient'
		,'EmergenceEditor.view.FullscreenViewport'
	]
	
	,controllers: [
		'Viewport'
		,'Files'
		,'Transfers'
		,'Editors'
		,'Revisions'
		,'Activity'
	]
	
	,launch: function() {
		EmergenceEditor.app = this;
		
		// Create viewport
		if(location.search.match(/\Wfullscreen\W/))
		{
			this.viewport = Ext.create('EmergenceEditor.view.FullscreenViewport');
		}
		else
		{
			// initialize state manager
			Ext.state.Manager.setProvider(Ext.create('Ext.state.LocalStorageProvider'));
			
			this.viewport = Ext.create('EmergenceEditor.view.Viewport');
		}
		
		// remove loading class
		Ext.getBody().removeCls('loading');
		
		// get ref to title tag
		this.titleDom = document.querySelector('title');
	}
	
	// todo: make this ask the tab for the title and moving this to ontabchange 
	,setActiveView: function(token, title) {
		Ext.util.History.add(token, true);
		this.titleDom.innerHTML = title + " - " + location.hostname;
	}
});