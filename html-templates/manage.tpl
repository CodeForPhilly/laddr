<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Emergence Site Manager</title> 
 
	<link rel="stylesheet" type="text/css" href="/x/ext/resources/css/ext-all.css" />
	<link rel="stylesheet" href="/x/Emergence/HQ/HQ.css" />
	
	<!-- typekit -->
	<script type="text/javascript" src="http://use.typekit.com/ipw0rgy.js"></script>
	<script type="text/javascript">try{ Typekit.load(); }catch(e){ }</script>
	<!-- /typekit -->
	
</head> 
<body class="loading">
	<script type="text/javascript" src="/x/ext/bootstrap.js"></script>
	
	<script type="text/javascript">
		// session/environment data {* dumped from Dwoo to JS *}
		var User = {
			data: {$.User->getData()|json_encode}
		};
		
		var viewport = null;
	
		// configure ExtJS 4 environment
		Ext.Loader.setConfig({
			enabled: true
			,disableCaching: true
			,paths: {
				'Ext': '/x/ext/src'
				,'Emergence': '/x/Emergence'
			}
		});
		
		
		// requirements
		Ext.require([
			'Emergence.HQ.Viewport'
			,'Emergence.Site.App'
			,'Emergence.Factory'
		]);

		// initialize viewport
		Ext.onReady(function(){
			viewport = Ext.create('Emergence.HQ.Viewport', {
				apps: [
					'Emergence.Site.App'
				]
				,siteSearch: true
			});
		});
	</script> 
</body>
</html>