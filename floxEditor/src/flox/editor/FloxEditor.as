// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor
{
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import flox.app.FloxApp;
	import flox.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import flox.app.core.managers.fileSystemProviders.IMultiFileSystemProvider;
	import flox.app.core.managers.fileSystemProviders.MultiFileSystemProvider;
	import flox.app.entities.URI;
	import flox.app.events.ContextManagerEvent;
	import flox.app.managers.CommandManager;
	import flox.app.managers.ContextManager;
	import flox.app.managers.KeyBindingManager;
	import flox.app.managers.OperationManager;
	import flox.app.managers.ResourceManager;
	import flox.app.managers.SettingsManager;
	import flox.app.managers.fileSystemProviders.local.LocalFileSystemProvider;
	import flox.app.managers.fileSystemProviders.memory.MemoryFileSystemProvider;
	import flox.app.util.AsynchronousUtil;
	import flox.core.data.ArrayCollection;
	import flox.editor.contexts.IEditorContext;
	import flox.editor.core.FloxEditorEnvironment;
	import flox.editor.core.floxEditor_internal;
	import flox.editor.entities.FloxEditorConfig;
	import flox.editor.managers.ErrorManager;
	import flox.editor.managers.ViewManager;


	public class FloxEditor
	{
		use namespace floxEditor_internal;
		
		static private var _viewManager					:ViewManager;
		static private var _contextManager				:ContextManager;
		static private var _operationManager			:OperationManager;
		static private var _copyClipboard				:ArrayCollection;
		static private var _cutClipboard				:ArrayCollection;
		static private var _keyBindingManager			:KeyBindingManager;
		static private var _commandManager				:CommandManager;
		static private var _settingsManager				:SettingsManager;
		static private var _errorManager				:ErrorManager;
		static private var _eventDispatcher				:IEventDispatcher;
		static private var _config						:FloxEditorConfig;
		static private var _stage						:Stage;
		static private var _environment					:String;
		
		static private var _currentEditorContextURI		:URI;
		
		// Getters for the managers and providers
		static public function get viewManager()		:ViewManager	 			{ return _viewManager; 			}
		static public function get contextManager()		:ContextManager				{ return _contextManager; 		}
		static public function get copyClipboard()		:ArrayCollection			{ return _copyClipboard;		}
		static public function get cutClipboard()		:ArrayCollection			{ return _cutClipboard;			}
		static public function get keyBindingManager()	:KeyBindingManager			{ return _keyBindingManager;	}
		static public function get commandManager()		:CommandManager				{ return _commandManager;		}
		static public function get settingsManager()	:SettingsManager			{ return _settingsManager;		}
		static public function get errorManager()		:ErrorManager				{ return _errorManager;			}
		static public function get operationManager()	:OperationManager			{ return _operationManager;		}
		static public function get eventDispatcher()	:IEventDispatcher			{ return _eventDispatcher;		}
		static public function get config()				:FloxEditorConfig			{ return _config;				}
		static public function get stage()				:Stage						{ return _stage;				}
		static public function get environment()		:String						{ return _environment;			}
		
		static public function get currentEditorContextURI():URI { return _currentEditorContextURI; }
		
		floxEditor_internal static function init( configXML:XML, stage:Stage, environment:String ):void
		{
			_stage = stage;
			_environment = environment;
			_config					= new FloxEditorConfig(configXML);
			_viewManager 			= new ViewManager(stage);
			_contextManager 		= new ContextManager();
			_operationManager 		= new OperationManager();
			_copyClipboard 			= new ArrayCollection();
			_cutClipboard 			= new ArrayCollection();
			_commandManager 		= new CommandManager(FloxApp.resourceManager);
			_keyBindingManager 		= new KeyBindingManager(_stage, FloxApp.resourceManager, _commandManager);
			_settingsManager 		= new SettingsManager();
			_errorManager 			= new ErrorManager();
			_eventDispatcher 		= new EventDispatcher();
			
			_contextManager.addEventListener( ContextManagerEvent.CURRENT_CONTEXT_CHANGED, contextChangedHandler );
		}
		
		private static function contextChangedHandler( event:ContextManagerEvent ):void
		{
			if ( !(event.context is IEditorContext) ) return;
	
			var context:IEditorContext = IEditorContext(event.context);
			
			// Don't init straight away, so the uri has a chance to be updated.
			AsynchronousUtil.callLater(setCurrentURI, [context]);
		}
		
		private static function setCurrentURI(context:IEditorContext):void
		{
			var uri:URI = context.uri;
			if ( context.uri.path.indexOf("/" ) == -1) {
				uri = new URI("memory/"+context.uri.path);
			}
			
			trace("CONTEXT CHANGED "+uri);
			_currentEditorContextURI = uri;
		}
		
		public static function getProjectDirectoryURI(contextURI:URI = null):URI
		{
			if (!contextURI) {
				contextURI = currentEditorContextURI;
			}
			var projectURI:URI = contextURI.getParentURI();//+ FloxApp.externalResourceFolderName);
			// If reading from memory (i.e. we're editing an unsaved template file) default to "Documents/Cadet2D"
			var provider:IFileSystemProvider = FloxApp.fileSystemProvider.getFileSystemProviderForURI(contextURI);
			if ( provider is MemoryFileSystemProvider ) {
				if ( FloxEditor.environment == FloxEditorEnvironment.AIR ) {
					provider = FloxApp.fileSystemProvider.getFileSystemProviderForURI(new URI("cadet.local/"));//+FloxApp.externalResourceFolderName));
					var localFSP:LocalFileSystemProvider = LocalFileSystemProvider(provider); 
					var defaultDirPath:String = localFSP.defaultDirectoryURI.path;
					if ( defaultDirPath.indexOf( localFSP.rootDirectoryURI.path ) != -1 ) {
						defaultDirPath = defaultDirPath.replace( localFSP.rootDirectoryURI.path, "" );
					}
					projectURI = new URI("cadet.local"+defaultDirPath+"/");//+FloxApp.externalResourceFolderName);
				}
				else if ( FloxEditor.environment == FloxEditorEnvironment.BROWSER ) {
					projectURI = new URI("cadet.url/");//+FloxApp.externalResourceFolderName);				
				}
			} else {
				if ( FloxEditor.environment == FloxEditorEnvironment.AIR ) {
					projectURI = contextURI.getParentURI();//+FloxApp.externalResourceFolderName);
				}
				else if ( FloxEditor.environment == FloxEditorEnvironment.BROWSER ) {
					projectURI = new URI("cadet.url/");//+FloxApp.externalResourceFolderName);				
				}				
			}
			
			return projectURI;
		}
	}
}








