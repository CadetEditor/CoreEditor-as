// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.operations
{
	import flash.display.Stage;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	
	import core.app.CoreApp;
	import core.app.core.operations.IAsynchronousOperation;
	import core.app.core.operations.IOperation;
	import core.app.events.OperationProgressEvent;
	import core.appEx.managers.fileSystemProviders.azureBrowser.AzureFileSystemProviderBrowser;
	import core.appEx.managers.fileSystemProviders.memory.MemoryFileSystemProvider;
	import core.appEx.managers.fileSystemProviders.sharedObject.SharedObjectFileSystemProvider;
	import core.app.managers.fileSystemProviders.url.URLFileSystemProvider;
	import core.app.operations.CompoundOperation;
	import core.app.operations.LoadManifestsOperation;
	import core.appEx.operations.LoadSWFOperation;
	import core.editor.CoreEditor;
	import core.editor.controllers.CurrentVisualContextController;
	import core.editor.controllers.OperationFeedbackController;
	import core.editor.controllers.VisualContextSettingsController;
	import core.editor.controllers.WelcomeScreenController;
	import core.editor.core.coreEditor_internal;
	import core.editor.events.CoreEditorEvent;
	import core.editor.ui.components.DefaultEditorViewContainer;
	import core.editor.ui.components.DefaultGlobalViewContainer;
	import core.editor.ui.components.DefaultViewContainer;
	

	[Event(type="core.app.events.OperationProgressEvent", name="progress")];
	[Event(type="flash.events.Event", name="complete")];
	[Event(type="flash.events.ErrorEvent", name="error")];
	
	public class InitializeCoreOperation extends EventDispatcher implements IAsynchronousOperation
	{
		private var stage			:Stage;
		private var configURL		:String;
		private var configXML		:XML;
		private var _label			:String = "";
		private var environment		:String;
		
		public function InitializeCoreOperation( stage:Stage, configURL:String, environment:String )
		{
			this.stage = stage;
			this.configURL = configURL;
			this.environment = environment;
		}
		
		public function execute():void
		{
			label = "Loading config file";
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loadConfigCompleteHandler);
			loader.load(new URLRequest(configURL));
		}
		
		private function loadConfigCompleteHandler( event:Event ):void
		{
			var loader:URLLoader = URLLoader(event.target);
			
			configXML = XML(loader.data);
			
			// Filter the configXML via the optional 'environment' attribute.
			// Only keep nodes that either don't specify an environment, or match it.
			var currentEnvironment:String = environment.toLowerCase();
			for ( var i:int = 0; i < configXML.children().length(); i++ )
			{
				var child:XML = configXML.children()[i];
				var environments:String = String(child.@environment);
				if ( environments == null || environments == "" ) continue;
				environments = environments.toLowerCase();
				if ( environments.indexOf( currentEnvironment ) == -1 )
				{
					delete configXML.children()[i];
					i--;
				}
			}
			
			use namespace coreEditor_internal;
			CoreEditor.init(configXML, stage, environment);
			
			CoreEditor.viewManager.init( DefaultGlobalViewContainer, DefaultViewContainer, DefaultEditorViewContainer );
			CoreEditor.viewManager.application.visible = false;
			
			// Create a memory FileSystemProvider by default
			CoreApp.fileSystemProvider.registerFileSystemProvider( new MemoryFileSystemProvider( "memory", null ), false );
			
			// Config fileSystemProviders
			for ( i = 0; i < configXML.fileSystemProvider.length(); i++ )
			{
				var node:XML = configXML.fileSystemProvider[i];
				addFileSystemProvider( node );
			}
			
			
			// Create and set-up the big init operation.
			var compoundOperation:CompoundOperation = new CompoundOperation();
			compoundOperation.addEventListener(Event.COMPLETE, operationsCompleteHandler);
			compoundOperation.addEventListener(OperationProgressEvent.PROGRESS, operationProgressHandler);
			compoundOperation.addEventListener(ErrorEvent.ERROR, errorHandler);
						
			// Load extensions
			var loadExtensionsOperation:CompoundOperation = new CompoundOperation();
			for ( i = 0; i < configXML.extension.length(); i++ )
			{
				var extensionNode:XML = configXML.extension[i];
				loadExtensionsOperation.addOperation( new LoadSWFOperation( CoreEditor.config.resourceURL + extensionNode.@url, ApplicationDomain.currentDomain ) );
			}
			if ( loadExtensionsOperation.operations.length > 0 )
			{
				compoundOperation.addOperation( loadExtensionsOperation );
			}
			
			// Load manifests
			var loadManifestsOperation:LoadManifestsOperation = new LoadManifestsOperation(configXML.manifest);
			compoundOperation.addOperation( loadManifestsOperation );
			
			// Load file templates
			var loadFileTemplatesOperation:LoadFileTemplatesOperation = new LoadFileTemplatesOperation( CoreApp.resourceManager, configXML.template );
			compoundOperation.addOperation(loadFileTemplatesOperation);
			
			// Allow subclasses to add further operations.
			addSubOperations( compoundOperation );
			
			
			
			compoundOperation.execute();
		}
		
		private function operationProgressHandler( event:OperationProgressEvent ):void
		{
			label = IOperation(event.target).label;
			dispatchEvent( event  );
		}
		
		private function errorHandler( event:ErrorEvent ):void
		{
			dispatchEvent(event);
		}
		
		protected function addSubOperations( compoundOperation:CompoundOperation ):void {}
		
		private function operationsCompleteHandler( event:Event ):void
		{
			initControllers();
			initComplete();
			CoreEditor.viewManager.application.visible = true;
			
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		protected function initControllers():void
		{
			trace("Initialising Controllers");
			label = "Initialising Controllers";
			new CurrentVisualContextController();
			new VisualContextSettingsController();
			new OperationFeedbackController();
			//TODO: Welcome Screen shouldn't be created here, not neccessarily required for all CoreEditor apps
			// (conflicts with basic HelloWorldExtension example)
			new WelcomeScreenController();
		}
		
		protected function initComplete():void
		{
			trace("Init Complete");
			label = "Init Complete";
			CoreEditor.eventDispatcher.dispatchEvent( new CoreEditorEvent( CoreEditorEvent.INIT_COMPLETE ) );
		}
		
		/**
		 * Designed to be overriden so that this Operation can provide all common init logic, while derived classes can
		 * add their own custom logic when setting up filesystem provider for their particular environment.  
		 * @param node
		 * 
		 */		
		protected function addFileSystemProvider( node:XML ):void
		{
			var type:String = String(node.@type).toLowerCase();
			var visible:Boolean = node.@visible == undefined || node.@visible == "true";
			
			if ( type == "sharedobject" )
			{
				CoreApp.fileSystemProvider.registerFileSystemProvider( new SharedObjectFileSystemProvider( node.@id, node.@label ), visible );
			}
			else if ( type == "url" )
			{
				CoreApp.fileSystemProvider.registerFileSystemProvider( new URLFileSystemProvider( node.@id, node.@label, node.@baseURL ), visible );
			}
			else if ( type == "azureblobstoragebrowser" )
			{
				if ( stage.loaderInfo.parameters.sas == null )
				{
					throw( new Error( "Could not find a shared access signature for the AzureFileSystemProviderBrowser within Flash vars" ) );
					return;
				}
				
				var params:Object = stage.loaderInfo.parameters;
				var storageURL:String = params.storageUri ? params.storageUri : storageURL = node.@endPoint;
				storageURL = params.storageUri + "/" + String(params.uid) + "/"
				storageURL = storageURL.replace("https://", "http://");
				
				var sas:String = params.sas ? params.sas : sas = node.sas.text();
				if ( sas.charAt(0) == "?" )
				{
					sas = sas.substr(1);
				}
				
				var hostUri:String = params.hostUri ? params.hostUri : node.@hostUri;
				var id:String = params.uid ? params.uid  : node.@id;
				
				CoreApp.fileSystemProvider.registerFileSystemProvider( new AzureFileSystemProviderBrowser( id, node.@label, storageURL, sas, hostUri ), visible );
			}
		}
		
		public function set label( value:String ):void
		{
			_label = value;
		}
		public function get label():String { return _label; }
	}
}