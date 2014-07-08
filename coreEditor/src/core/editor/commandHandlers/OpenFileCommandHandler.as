// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.commandHandlers
{
	import flash.events.MouseEvent;
	
	import core.app.CoreApp;
	import core.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import core.app.entities.URI;
	import core.app.resources.IResource;
	import core.appEx.core.commandHandlers.ICommandHandler;
	import core.appEx.resources.CommandHandlerFactory;
	import core.appEx.resources.FileType;
	import core.editor.CoreEditor;
	import core.editor.entities.Commands;
	import core.editor.operations.OpenFileOperation;
	import core.editor.ui.panels.FileSystemListBrowserPanel;

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
			CoreEditor.settingsManager.setString("core.app.core.managers.fileSystemProviders.MultiFileSystemProvider.recentFolder", panel.list.rootNode.uri.toString());
			CoreEditor.operationManager.addOperation( new OpenFileOperation( panel.list.selectedFile, CoreApp.fileSystemProvider, CoreEditor.settingsManager ) );
		}
		
		private function openPanel():void
		{
			//TODO: recentURI may be "cadet..." rather than "core...", causing a "Cannot map uri to provider" error.
			var recentURL:String = CoreEditor.settingsManager.getString("core.app.core.managers.fileSystemProviders.MultiFileSystemProvider.recentFolder");
			var recentURI:URI;
			
			// If no fileSystemProvider exists for this URI, clear the recentURI to avoid problems.
			var provider:IFileSystemProvider = CoreApp.fileSystemProvider.getFileSystemProviderForURI(new URI(recentURL));
			if ( provider != null ) {
				recentURI = new URI(recentURL);
			}
			
			var validExtensions:Array = [];
			var fileTypes:Vector.<IResource> = CoreApp.resourceManager.getResourcesOfType(FileType);
			for ( var i:uint = 0; i < fileTypes.length; i ++ ) {
				var fileType:FileType = FileType(fileTypes[i]);
				validExtensions.push(fileType.extension);
			}
			
			panel = new FileSystemListBrowserPanel( recentURI, null, validExtensions );
			panel.label = "Open File";
			panel.validSelectionIsFolder = false;
			panel.validSelectionIsFile = true;
			
			CoreEditor.viewManager.addPopUp(panel);
			panel.list.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
			panel.okBtn.addEventListener(MouseEvent.CLICK, clickOkHandler);
			panel.cancelBtn.addEventListener(MouseEvent.CLICK, clickCancelHandler);
		}
		
		private function disposePanel():void
		{
			panel.list.removeEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
			panel.okBtn.removeEventListener(MouseEvent.CLICK, clickOkHandler);
			panel.cancelBtn.removeEventListener(MouseEvent.CLICK, clickCancelHandler);
			CoreEditor.viewManager.removePopUp(panel);
			panel = null;
		}
		
	}
}