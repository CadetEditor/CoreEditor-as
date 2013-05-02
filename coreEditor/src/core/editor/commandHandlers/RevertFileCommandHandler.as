// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.commandHandlers
{
	import core.app.CoreApp;
	import core.appEx.core.commandHandlers.ICommandHandler;
	import core.app.entities.URI;
	import core.app.operations.CompoundOperation;
	import core.appEx.resources.CommandHandlerFactory;
	import core.editor.CoreEditor;
	import core.editor.contexts.IEditorContext;
	import core.editor.entities.Commands;
	import core.editor.operations.CloseEditorOperation;
	import core.editor.operations.OpenFileOperation;
	import core.editor.validators.SaveAvailableValidator;
	import core.ui.components.Alert;
	import core.ui.events.AlertEvent;
	
	public class RevertFileCommandHandler implements ICommandHandler
	{
		public static function getFactory():CommandHandlerFactory
		{
			return new CommandHandlerFactory( Commands.REVERT, RevertFileCommandHandler, [ new SaveAvailableValidator( CoreEditor.contextManager ) ] );
		}
		
		private var editorContext:IEditorContext;
		
		public function RevertFileCommandHandler()
		{
			
		}

		public function execute( parameters:Object ):void
		{
			editorContext = CoreEditor.contextManager.getLatestContextOfType(IEditorContext);
			
			Alert.show( "Revert", 
						"Are you sure you want to revert to '" + editorContext.uri.getFilename() + "'? All changes will be lost", 
						["Yes", "No"], "Yes",
						null, true,
						closeAlertHandler );
		}
		
		private function closeAlertHandler( event:AlertEvent ):void
		{
			switch ( event.selectedButton )
			{
				case "Yes" :
					
					performRevert();
					break;
			}
			editorContext = null;
		}
		
		private function performRevert():void
		{
			var uri:URI = editorContext.uri;
			var operation:CompoundOperation = new CompoundOperation();
			operation.label = "Revert file : " + uri.path;
			
			editorContext.changed = false;
			var closeFileOperation:CloseEditorOperation = new CloseEditorOperation( editorContext, CoreApp.fileSystemProvider );
			operation.addOperation(closeFileOperation);
			
			var openFileOperation:OpenFileOperation = new OpenFileOperation( uri, CoreApp.fileSystemProvider, CoreEditor.settingsManager );
			operation.addOperation( openFileOperation );
			
			CoreEditor.operationManager.addOperation(operation);
		}
	}
}