// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.commandHandlers
{
	import core.app.CoreApp;
	import core.appEx.core.commandHandlers.ICommandHandler;
	import core.app.core.managers.fileSystemProviders.operations.IDeleteFileOperation;
	import core.app.entities.URI;
	import core.appEx.resources.CommandHandlerFactory;
	import core.appEx.validators.ContextSelectionValidator;
	import core.editor.CoreEditor;
	import core.editor.entities.Commands;
	import core.editor.utils.CoreEditorUtil;
	import core.ui.components.Alert;
	import core.ui.events.AlertEvent;
	
	public class DeleteFileCommandHandler implements ICommandHandler
	{
		static public function getFactory():CommandHandlerFactory
		{
			var descriptor:CommandHandlerFactory = new CommandHandlerFactory( Commands.DELETE, DeleteFileCommandHandler );
			descriptor.validators.push( new ContextSelectionValidator( CoreEditor.contextManager, null, true, URI ) );
			return descriptor;
		}
		
		public function DeleteFileCommandHandler() {}
		
		
		protected var filesToDelete		:Array;
		public function execute( parameters:Object ):void
		{		
			filesToDelete = CoreEditorUtil.getCurrentSelection( null, URI );
			
			if ( filesToDelete.length == 1 )
			{
				var uri:URI = URI( filesToDelete[0] );
				var name:String;
				if ( uri.isDirectory() )
				{
					name = uri.getFoldername();
				}
				else
				{
					name = uri.getFilename(false);
				}
				Alert.show( "Confirm delete file resource", 
							"Are you sure you want to delete '" + name + "' from the file system? This action cannot be undone", 
							["Yes", "No"], "Yes",
							null, true,
							closeAlertHandler );
			}
			else
			{
				Alert.show(	"Confirm delete file resource",
							"Are you sure you want to delete these file resources from the file system? This action cannot be undone", 
							["Yes", "No"], "Yes", 
							null, true, closeAlertHandler );
			}
		}
		
		protected function closeAlertHandler( event:AlertEvent ):void
		{
			switch ( event.selectedButton )
			{
				case "Yes" :
					deleteFiles();
					break;
			}
			filesToDelete = null;
		}
		
		protected function deleteFiles():void
		{
			for each ( var uri:URI in filesToDelete )
			{
				var operation:IDeleteFileOperation = CoreApp.fileSystemProvider.deleteFile( uri );
				CoreEditor.operationManager.addOperation(operation);
			}
		}
	}
}