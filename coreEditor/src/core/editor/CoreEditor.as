// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor
{
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import core.app.CoreApp;
	import core.app.entities.URI;
	import core.app.events.ContextManagerEvent;
	import core.app.managers.CommandManager;
	import core.app.managers.ContextManager;
	import core.app.managers.KeyBindingManager;
	import core.app.managers.OperationManager;
	import core.app.managers.SettingsManager;
	import core.app.util.AsynchronousUtil;
	import core.data.ArrayCollection;
	import core.editor.contexts.IEditorContext;
	import core.editor.core.coreEditor_internal;
	import core.editor.entities.CoreEditorConfig;
	import core.editor.managers.ErrorManager;
	import core.editor.managers.ViewManager;


	public class CoreEditor
	{
		use namespace coreEditor_internal;
		
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
		static private var _config						:CoreEditorConfig;
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
		static public function get config()				:CoreEditorConfig			{ return _config;				}
		static public function get stage()				:Stage						{ return _stage;				}
		static public function get environment()		:String						{ return _environment;			}
		
		static public function get currentEditorContextURI():URI { return _currentEditorContextURI; }
		
		coreEditor_internal static function init( configXML:XML, stage:Stage, environment:String ):void
		{
			_stage = stage;
			_environment = environment;
			_config					= new CoreEditorConfig(configXML);
			_viewManager 			= new ViewManager(stage);
			_contextManager 		= new ContextManager();
			_operationManager 		= new OperationManager();
			_copyClipboard 			= new ArrayCollection();
			_cutClipboard 			= new ArrayCollection();
			_commandManager 		= new CommandManager(CoreApp.resourceManager);
			_keyBindingManager 		= new KeyBindingManager(_stage, CoreApp.resourceManager, _commandManager);
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
	}
}








