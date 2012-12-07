// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.operations
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import flox.app.FloxApp;
	import flox.app.core.managers.fileSystemProviders.operations.IDoesFileExistOperation;
	import flox.app.core.operations.IAsynchronousOperation;
	import flox.app.entities.URI;
	import flox.app.resources.FileType;
	import flox.app.resources.IResource;
	import flox.editor.FloxEditor;
	import flox.editor.contexts.IEditorContext;
	import flox.editor.core.FloxEditorEnvironment;
	import flox.editor.ui.panels.SaveAsFileListPanel;
	import flox.editor.ui.panels.SaveAsFilePanel;
	import flox.ui.components.Alert;
	import flox.ui.events.AlertEvent;
	
	public class SaveFileAsOperation extends EventDispatcher implements IAsynchronousOperation
	{
		private var panel				:SaveAsFileListPanel;
		private var fileToCreate		:URI;
		private var editorContext		:IEditorContext;
		
		private var _saved				:Boolean;
		private var _closeEditorAfter	:Boolean;
		
		public function SaveFileAsOperation( editorContext:IEditorContext, closeEditorAfter:Boolean = false )
		{
			this.editorContext = editorContext;
			_closeEditorAfter = closeEditorAfter;
		}
		
		public function execute():void
		{
			var recentURL:String;
			var recentURI:URI;
			var uriIsRoot:Boolean = false;
			
			// Limit to sharedObject fileSystem if in the browser.
			if ( FloxEditor.environment == FloxEditorEnvironment.BROWSER ) {
				recentURL = "cadet.sharedObject/";
				uriIsRoot = true;
			} else {
				//TODO: recentURI may be "cadet..." rather than "flox...", causing a "Cannot map uri to provider" error.
				recentURL = FloxEditor.settingsManager.getString("flox.app.core.managers.fileSystemProviders.MultiFileSystemProvider.recentFolder");				
			}
		
			if ( recentURL != null ) {
				recentURI = new URI(recentURL);
			}
			
			var validExtensions:Array = [];
			var fileTypes:Vector.<IResource> = FloxApp.resourceManager.getResourcesOfType(FileType);
			for ( var i:uint = 0; i < fileTypes.length; i ++ ) {
				var fileType:FileType = FileType(fileTypes[i]);
				validExtensions.push(fileType.extension);
			}
			
			panel = new SaveAsFileListPanel( recentURI, uriIsRoot, validExtensions );
			FloxEditor.viewManager.addPopUp(panel);
			
			if ( editorContext.isNewFile )
			{
				panel.nameInput.text = editorContext.uri.getFilename(true);
			}
			else
			{
				panel.nameInput.text = "Copy of " + editorContext.uri.getFilename(true)
			}
			panel.nameInput.addEventListener( Event.CHANGE, changeTextHandler );
			panel.okBtn.addEventListener( MouseEvent.CLICK, clickOkHandler );
			panel.cancelBtn.addEventListener( MouseEvent.CLICK, clickCancelHandler );
			
			updateState();
		}
		
		protected function disposePanel():void
		{			
			FloxEditor.viewManager.removePopUp( panel );
		
			// Remove Editor
			if ( _saved && _closeEditorAfter ) {
				var removeContextOperation:RemoveContextOperation = new RemoveContextOperation( editorContext );
				removeContextOperation.execute();
			}			
			
			panel.nameInput.removeEventListener( Event.CHANGE, changeTextHandler );
			panel.okBtn.removeEventListener( MouseEvent.CLICK, clickOkHandler );
			panel.cancelBtn.removeEventListener( MouseEvent.CLICK, clickCancelHandler );
			editorContext = null;
			panel = null;
		}
		
		protected function clickOkHandler( event:MouseEvent ):void
		{
			fileToCreate = panel.list.selectedFolderURI;
			fileToCreate.chdir( panel.nameInput.text + editorContext.uri.getExtension() );
			
			var operation:IDoesFileExistOperation = FloxApp.fileSystemProvider.doesFileExist( fileToCreate );
			operation.addEventListener( Event.COMPLETE, doesFileExistHandler );
			operation.execute();
		}
		
		protected function doesFileExistHandler( event:Event ):void
		{
			var operation:IDoesFileExistOperation = IDoesFileExistOperation(event.target);
			if ( operation.fileExists )
			{
				Alert.show(	"File Exists", "The file '" + operation.uri.path + "' already exists. Do you want to replace the file?", 
					["Yes","No"], "Yes",
					null, true,
					closeAlertHandler );
			}
			else
			{
				saveFile( fileToCreate );
				disposePanel();
			}
		}
		
		protected function closeAlertHandler( event:AlertEvent ):void
		{
			switch ( event.selectedButton )
			{
				case "Yes" :
					saveFile( fileToCreate );
					disposePanel();
					dispatchEvent( new Event( Event.COMPLETE ) );
					break;
			}
		}
		
		protected function saveFile( uri:URI ):void
		{
			_saved = true;
			trace("RECENT FOLDER: SAVE AS "+panel.list.rootNode.uri.toString());
			FloxEditor.settingsManager.setString("flox.app.core.managers.fileSystemProviders.MultiFileSystemProvider.recentFolder", panel.list.rootNode.uri.toString());
			
			editorContext.uri = uri;
			editorContext.save();
			editorContext.isNewFile = false;
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		
		protected function clickCancelHandler( event:MouseEvent ):void
		{
			disposePanel();
			dispatchEvent( new Event( Event.CANCEL ) );
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		protected function changeTextHandler( event:Event ):void
		{
			updateState();
		}
		
		protected function updateState():void
		{
			panel.okBtn.enabled = panel.nameInput.text != "";
		}
		
		public function get label():String
		{
			return "Save file as";
		}
	}
}