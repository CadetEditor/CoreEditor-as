// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.operations
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	import core.app.CoreApp;
	import core.appEx.core.contexts.IContext;
	import core.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import core.app.core.managers.fileSystemProviders.operations.IDoesFileExistOperation;
	import core.app.core.operations.IAsynchronousOperation;
	import core.app.entities.URI;
	import core.appEx.managers.SettingsManager;
	import core.app.resources.IResource;
	import core.data.ArrayCollection;
	import core.editor.CoreEditor;
	import core.editor.contexts.IEditorContext;
	import core.editor.core.IViewContainer;
	import core.editor.resources.EditorFactory;
	import core.editor.ui.panels.OpenWithPanel;
	import core.ui.components.Alert;

	[Event(type="core.app.events.OperationProgressEvent", name="progress")]
	[Event(type="flash.events.Event", name="complete")]

	/**
	 * Given a uri, this Operation will attempt to find an existing editor has the same uri. If found
	 * it will simply switch focus to it and exit.
	 * If not found, it will search all contributed EditorFatory's. If a single matching factory is found
	 * it will automatically create a new editor and load data from the uri.
	 * If multiple are found, it will display a list for the user to choose which editor they want to
	 * use to open this file.
	 * If none are found, an alert is show then the operation completes.
	 * @author Jonathan
	 * 
	 */	
	public class OpenFileOperation extends EventDispatcher implements IAsynchronousOperation
	{
		private var uri					:URI;
		private var fileSystemProvider		:IFileSystemProvider;
		private var settingsManager		:SettingsManager;
		private var isNewFile				:Boolean;
		private var addToRecentList			:Boolean;
		
		private var panel					:OpenWithPanel;
		private var editorContext			:IEditorContext;
		private var editorView				:IViewContainer;
		
		public function OpenFileOperation( uri:URI, fileSystemProvider:IFileSystemProvider, settingsManager:SettingsManager, isNewFile:Boolean = false, addToRecentList:Boolean = true )
		{
			this.uri = uri;
			this.fileSystemProvider = fileSystemProvider;
			this.settingsManager = settingsManager;
			this.isNewFile = isNewFile;
			this.addToRecentList = addToRecentList;
			
			if ( uri.isDirectory() )
			{
				throw( new Error( "File path must not be a folder" ) );
				return;
			}
		}
		
		public function execute():void
		{
			// First check to see if an editor for this URI is already opened
			var contexts:Vector.<IContext> = CoreEditor.contextManager.getContextsOfType(IEditorContext);
			for each ( var context:IEditorContext in contexts )
			{
				if ( context.uri == null ) continue;
				
				if ( context.uri.path == uri.path )
				{
					CoreEditor.viewManager.showVisualContext( context );
					CoreEditor.contextManager.setCurrentContext(context);
					dispatchEvent( new Event( Event.COMPLETE ) );
					return;
				}
			}
			
			// Check to see if the file exists
			try
			{
				var doesFileExistOperation:IDoesFileExistOperation = fileSystemProvider.doesFileExist( uri );
			}
			catch( e:Error )
			{
				removeFileFromRecentFiles();
				dispatchEvent( new ErrorEvent( ErrorEvent.ERROR, e.message ) );
				return;
			}
			doesFileExistOperation.addEventListener(Event.COMPLETE, doesFileExistOperationCompleteHandler );
			doesFileExistOperation.execute();
			
		}
		
		protected function removeFileFromRecentFiles():void
		{
			var recentFiles:Array = settingsManager.getArray("recentFiles");
			for ( var i:int = 0; i < recentFiles.length; i++ )
			{
				var recentFile:String = recentFiles[i];
				if ( recentFile == uri.path )
				{
					recentFiles.splice(i,1);
					settingsManager.setArray("recentFiles", recentFiles);
					break;
				}
			}
		}
		
		protected function doesFileExistOperationCompleteHandler( event:Event ):void
		{
			var operation:IDoesFileExistOperation = IDoesFileExistOperation(event.target);
			if ( operation.fileExists == false )
			{
				removeFileFromRecentFiles();
				dispatchEvent( new ErrorEvent( ErrorEvent.ERROR, false, false, "File does not exist" ) );
				return;
			}
			
			var editorFactories:Vector.<IResource> = CoreApp.resourceManager.getResourcesOfType(EditorFactory);
			editorFactories = editorFactories.filter( 
				function( item:*, index:int, arvecray:Vector.<IResource> ):Boolean 
				{ 
					return item.extensions.indexOf( uri.getExtension(true) ) != -1; 
				}, this );
			
			// No editors available - show alert box
			if ( editorFactories.length == 0 )
			{
				Alert.show( "Unable to open file", "Unknown file type", ["OK"] );
				dispatchEvent( new Event( Event.COMPLETE ) );
				return;
			}
			if ( editorFactories.length == 1 ) 
			{
				createEditorAndFinish( EditorFactory(editorFactories[0]) );
			}
				// Multiple handlers available, show selection box
			else if ( editorFactories.length > 1 )
			{
				createWindow();
				var dp:ArrayCollection = new ArrayCollection();
				for ( var i:int = 0; i < editorFactories.length; i++ )
				{
					dp[i] = editorFactories[i];
				}
				panel.list.dataProvider = dp;
				panel.list.selectedItem = panel.list.dataProvider[0];
			}
		}
		
		protected function createWindow():void
		{
			panel = new OpenWithPanel();
			CoreEditor.viewManager.addPopUp(panel);
			panel.okBtn.addEventListener( MouseEvent.CLICK, clickOkHandler );
			panel.cancelBtn.addEventListener( MouseEvent.CLICK, clickCancelHandler );
		}
		
		protected function disposeWindow():void
		{
			if ( !panel ) return;
			CoreEditor.viewManager.removePopUp( panel );
			panel.okBtn.removeEventListener( MouseEvent.CLICK, clickOkHandler );
			panel.cancelBtn.removeEventListener( MouseEvent.CLICK, clickCancelHandler );
			panel = null;
		}
		
		protected function clickOkHandler( event:MouseEvent ):void
		{
			createEditorAndFinish( EditorFactory( panel.list.selectedItem ) );
		}
		
		protected function clickCancelHandler( event:MouseEvent ):void
		{
			disposeWindow();
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		private function createEditorAndFinish( factory:EditorFactory ):void
		{
			var addContextOperation:AddContextOperation = new AddContextOperation(factory);
			addContextOperation.execute();
			editorContext = IEditorContext( addContextOperation.context );
			editorContext.isNewFile = isNewFile;
			editorContext.uri = uri;
			
			if ( addToRecentList )
			{
				// Add uri to the list of recently opened files
				var recentFiles:Array = settingsManager.getArray("recentFiles");
				var foundExisting:Boolean = false;
				for ( var i:int = 0; i < recentFiles.length; i++ )
				{
					var recentFile:String = recentFiles[i];
					if ( recentFile == uri.path )
					{
						foundExisting = true;
						break;
					}
				}
				if ( !foundExisting )
				{
					recentFiles.push(uri.path);
					settingsManager.setArray("recentFiles", recentFiles);
				}
			} 
			
			editorContext.load();
			
			disposeWindow();
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		public function getEditorContext():IEditorContext
		{
			return editorContext;
		}
		
		public function getURI():URI
		{
			return uri;
		}
		
		public function get label():String
		{
			return "Open file: " + uri.getFilename();
		}
	}
}