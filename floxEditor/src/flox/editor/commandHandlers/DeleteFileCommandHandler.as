// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.commandHandlers
{
	import flox.app.FloxApp;
	import flox.app.core.commandHandlers.ICommandHandler;
	import flox.app.core.managers.fileSystemProviders.operations.IDeleteFileOperation;
	import flox.app.entities.URI;
	import flox.app.resources.CommandHandlerFactory;
	import flox.app.validators.ContextSelectionValidator;
	import flox.editor.FloxEditor;
	import flox.editor.entities.Commands;
	import flox.editor.utils.FloxEditorUtil;
	import flox.ui.components.Alert;
	import flox.ui.events.AlertEvent;
	
	public class DeleteFileCommandHandler implements ICommandHandler
	{
		static public function getFactory():CommandHandlerFactory
		{
			var descriptor:CommandHandlerFactory = new CommandHandlerFactory( Commands.DELETE, DeleteFileCommandHandler );
			descriptor.validators.push( new ContextSelectionValidator( FloxEditor.contextManager, null, true, URI ) );
			return descriptor;
		}
		
		public function DeleteFileCommandHandler() {}
		
		
		protected var filesToDelete		:Array
		public function execute( parameters:Object ):void
		{		
			filesToDelete = FloxEditorUtil.getCurrentSelection( null, URI );
			
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
				var operation:IDeleteFileOperation = FloxApp.fileSystemProvider.deleteFile( uri );
				FloxEditor.operationManager.addOperation(operation);
			}
		}
	}
}