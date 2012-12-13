// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.commandHandlers
{
	import flash.events.MouseEvent;
	
	import flox.app.FloxApp;
	import flox.app.core.commandHandlers.ICommandHandler;
	import flox.app.entities.URI;
	import flox.app.resources.CommandHandlerFactory;
	import flox.app.resources.FileType;
	import flox.app.resources.IResource;
	import flox.editor.FloxEditor;
	import flox.editor.entities.Commands;
	import flox.editor.operations.OpenFileOperation;
	import flox.editor.ui.panels.FileSystemListBrowserPanel;
	import flox.editor.ui.panels.FileSystemTreeBrowserPanel;

	public class OpenFileCommandHandler implements ICommandHandler
	{
		public static function getFactory():CommandHandlerFactory
		{
			return new CommandHandlerFactory( Commands.OPEN_FILE, OpenFileCommandHandler );
		}
		
		//private static var panel	:FileSystemTreeBrowserPanel;
		private var panel	:FileSystemListBrowserPanel;
		
		
		public function OpenFileCommandHandler() {}
		
		public function execute( parameters:Object ):void
		{
			openPanel();
		}
		
		private function doubleClickHandler( event:MouseEvent ):void
		{
			//if (!panel.list.selectedFile) return;
			if (!panel.list.selectedFile || panel.list.selectedFile.isDirectory()) return;
			
			openFile();
			disposePanel();	
		}
		private function clickOkHandler( event:MouseEvent ):void
		{
			openFile();
			disposePanel();	
		}
		private function clickCancelHandler( event:MouseEvent ):void
		{
			disposePanel();
		}
		
		private function openFile():void
		{
			trace("RECENT FOLDER: OPEN "+panel.list.rootNode.uri.toString());
			FloxEditor.settingsManager.setString("flox.app.core.managers.fileSystemProviders.MultiFileSystemProvider.recentFolder", panel.list.rootNode.uri.toString());
			FloxEditor.operationManager.addOperation( new OpenFileOperation( panel.list.selectedFile, FloxApp.fileSystemProvider, FloxEditor.settingsManager ) );
		}
		
		private function openPanel():void
		{
			//TODO: recentURI may be "cadet..." rather than "flox...", causing a "Cannot map uri to provider" error.
			var recentURL:String = FloxEditor.settingsManager.getString("flox.app.core.managers.fileSystemProviders.MultiFileSystemProvider.recentFolder");
			var recentURI:URI;
			if ( recentURL != null ) {
				recentURI = new URI(recentURL);
			}
			
			var validExtensions:Array = [];
			var fileTypes:Vector.<IResource> = FloxApp.resourceManager.getResourcesOfType(FileType);
			for ( var i:uint = 0; i < fileTypes.length; i ++ ) {
				var fileType:FileType = FileType(fileTypes[i]);
				validExtensions.push(fileType.extension);
			}
			
			panel = new FileSystemListBrowserPanel( recentURI, null, validExtensions );
			panel.label = "Open File";
			panel.validSelectionIsFolder = false;
			panel.validSelectionIsFile = true;
			
			FloxEditor.viewManager.addPopUp(panel);
			panel.list.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
			panel.okBtn.addEventListener(MouseEvent.CLICK, clickOkHandler);
			panel.cancelBtn.addEventListener(MouseEvent.CLICK, clickCancelHandler);
		}
		
		private function disposePanel():void
		{
			panel.list.removeEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
			panel.okBtn.removeEventListener(MouseEvent.CLICK, clickOkHandler);
			panel.cancelBtn.removeEventListener(MouseEvent.CLICK, clickCancelHandler);
			FloxEditor.viewManager.removePopUp(panel);
			panel = null;
		}
		
	}
}