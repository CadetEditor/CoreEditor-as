// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.commandHandlers
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	
	import flox.app.FloxApp;
	import flox.app.core.commandHandlers.ICommandHandler;
	import flox.app.core.managers.fileSystemProviders.operations.ICreateDirectoryOperation;
	import flox.app.entities.FileSystemNode;
	import flox.app.entities.URI;
	import flox.app.resources.CommandHandlerFactory;
	import flox.app.util.StringUtil;
	import flox.editor.FloxEditor;
	import flox.editor.contexts.FileExplorerContext;
	import flox.editor.entities.Commands;
	import flox.editor.ui.data.FileSystemTreeDataDescriptor;
	import flox.editor.ui.panels.NewFolderPanel;
	import flox.editor.utils.FloxEditorUtil;
	import flox.ui.components.Alert;
	
	public class NewFolderCommandHandler implements ICommandHandler
	{
		static public function getFactory():CommandHandlerFactory
		{
			return new CommandHandlerFactory( Commands.NEW_FOLDER, NewFolderCommandHandler );
		}
		
		
		private var panel					:NewFolderPanel
		private var initiallySelectedFolder	:URI;
		
		public function NewFolderCommandHandler()
		{
			
		}
		
		public function execute( parameters:Object ):void
		{
			var parentFolder:URI = parameters.parentFolder
			var folderName:String = parameters.folderName || "New Folder"
			
			var selectedFiles:Array = FloxEditorUtil.getCurrentSelection( FileExplorerContext, URI );
			if ( selectedFiles.length > 0 )
			{
				initiallySelectedFolder = selectedFiles[0];
				if ( initiallySelectedFolder.isDirectory() == false )
				{
					initiallySelectedFolder = initiallySelectedFolder.getParentURI();
				}
			}
			
			openPanel();
				
			panel.tree.addEventListener(Event.CHANGE, changeTreeHandler);
			panel.nameInput.addEventListener(TextEvent.TEXT_INPUT, textInputHandler);
			panel.okBtn.addEventListener(MouseEvent.CLICK, newFolderClickOkHandler);
			panel.cancelBtn.addEventListener(MouseEvent.CLICK, newFolderClickCancelHandler);
			
			validateState();
		}
		
		private function newFolderClickOkHandler(event:Event):void
		{
			var folderName:String = StringUtil.trim(panel.nameInput.text);
			var folderURI:URI = panel.tree.selectedFolder;
			var uri:URI = new URI();
			uri.copyURI(folderURI);
			uri.chdir( folderName + "/", true );
			
			createFolder(uri);
		}
		
		private function createFolder( uri:URI ):void
		{
			var operation:ICreateDirectoryOperation = FloxApp.fileSystemProvider.createDirectory( uri );
			operation.addEventListener(Event.COMPLETE, createDirectoryCompleteHandler);
			operation.addEventListener(ErrorEvent.ERROR, createFolderErrorHandler);
			FloxEditor.operationManager.addOperation(operation);
		}
		
		private function createDirectoryCompleteHandler( event:Event ):void
		{
			closePanel();
		}
		
		private function createFolderErrorHandler( event:ErrorEvent ):void
		{
			Alert.show( event.text, "Error", ["OK"] );
		}
		
		private function newFolderClickCancelHandler(event:Event):void
		{
			closePanel()
		}
		
		private function openPanel():void
		{
			panel = new NewFolderPanel()
			FloxEditor.viewManager.addPopUp(panel);
			
			panel.tree.dataProvider = FloxApp.fileSystemProvider.fileSystem;
			panel.tree.dataDescriptor = new FileSystemTreeDataDescriptor( FloxApp.resourceManager );
			
			if ( initiallySelectedFolder )
			{
				var node:FileSystemNode = FloxApp.fileSystemProvider.fileSystem.getChildWithData(initiallySelectedFolder.path,true) as FileSystemNode;
				if ( node )
				{
					panel.tree.openToItem(node);
					panel.tree.selectedItems = [node];
				}
			}
		}
		
		private function closePanel():void
		{
			FloxEditor.viewManager.removePopUp(panel);
			panel.tree.removeEventListener(Event.CHANGE, changeTreeHandler);
			panel.nameInput.removeEventListener(TextEvent.TEXT_INPUT, textInputHandler);
			panel.okBtn.removeEventListener(MouseEvent.CLICK, newFolderClickOkHandler);
			panel.cancelBtn.removeEventListener(MouseEvent.CLICK, newFolderClickCancelHandler);
			panel = null;
		}
		
		private function validateState():void
		{
			var folderIsSelected:Boolean = panel.tree.selectedFolder != null;
			var filenameSupplied:Boolean = StringUtil.trim(panel.nameInput.text) != ""
			panel.okBtn.enabled = filenameSupplied && folderIsSelected;
		}
		
		private function textInputHandler( event:Event ):void
		{
			validateState();
		}
		
		private function changeTreeHandler( event:Event ):void
		{
			validateState();
		}
	}
}