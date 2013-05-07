// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.commandHandlers
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	
	import core.app.CoreApp;
	import core.appEx.core.commandHandlers.ICommandHandler;
	import core.app.core.managers.fileSystemProviders.operations.ICreateDirectoryOperation;
	import core.app.entities.FileSystemNode;
	import core.app.entities.URI;
	import core.appEx.resources.CommandHandlerFactory;
	import core.app.util.StringUtil;
	import core.editor.CoreEditor;
	import core.editor.contexts.FileExplorerContext;
	import core.editor.entities.Commands;
	import core.editor.ui.data.FileSystemTreeDataDescriptor;
	import core.editor.ui.panels.NewFolderPanel;
	import core.editor.utils.CoreEditorUtil;
	import core.ui.components.Alert;
	
	public class NewFolderCommandHandler implements ICommandHandler
	{
		static public function getFactory():CommandHandlerFactory
		{
			return new CommandHandlerFactory( Commands.NEW_FOLDER, NewFolderCommandHandler );
		}
		
		
		private var panel					:NewFolderPanel;
		private var initiallySelectedFolder	:URI;
		
		public function NewFolderCommandHandler()
		{
			
		}
		
		public function execute( parameters:Object ):void
		{
			var parentFolder:URI = parameters.parentFolder;
			var folderName:String = parameters.folderName || "New Folder";
			
			var selectedFiles:Array = CoreEditorUtil.getCurrentSelection( FileExplorerContext, URI );
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
			var operation:ICreateDirectoryOperation = CoreApp.fileSystemProvider.createDirectory( uri );
			operation.addEventListener(Event.COMPLETE, createDirectoryCompleteHandler);
			operation.addEventListener(ErrorEvent.ERROR, createFolderErrorHandler);
			CoreEditor.operationManager.addOperation(operation);
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
			closePanel();
		}
		
		private function openPanel():void
		{
			panel = new NewFolderPanel();
			CoreEditor.viewManager.addPopUp(panel);
			
			panel.tree.dataProvider = CoreApp.fileSystemProvider.fileSystem;
			panel.tree.dataDescriptor = new FileSystemTreeDataDescriptor( CoreApp.resourceManager );
			
			if ( initiallySelectedFolder )
			{
				var node:FileSystemNode = CoreApp.fileSystemProvider.fileSystem.getChildWithData(initiallySelectedFolder.path,true) as FileSystemNode;
				if ( node )
				{
					panel.tree.openToItem(node);
					panel.tree.selectedItems = [node];
				}
			}
		}
		
		private function closePanel():void
		{
			CoreEditor.viewManager.removePopUp(panel);
			panel.tree.removeEventListener(Event.CHANGE, changeTreeHandler);
			panel.nameInput.removeEventListener(TextEvent.TEXT_INPUT, textInputHandler);
			panel.okBtn.removeEventListener(MouseEvent.CLICK, newFolderClickOkHandler);
			panel.cancelBtn.removeEventListener(MouseEvent.CLICK, newFolderClickCancelHandler);
			panel = null;
		}
		
		private function validateState():void
		{
			var folderIsSelected:Boolean = panel.tree.selectedFolder != null;
			var filenameSupplied:Boolean = StringUtil.trim(panel.nameInput.text) != "";
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