// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.commandHandlers
{
	import flox.app.FloxApp;
	import flox.app.core.commandHandlers.ICommandHandler;
	import flox.app.entities.URI;
	import flox.app.operations.CompoundOperation;
	import flox.app.resources.CommandHandlerFactory;
	import flox.editor.FloxEditor;
	import flox.editor.contexts.IEditorContext;
	import flox.editor.entities.Commands;
	import flox.editor.operations.CloseEditorOperation;
	import flox.editor.operations.OpenFileOperation;
	import flox.editor.validators.SaveAvailableValidator;
	import flox.ui.components.Alert;
	import flox.ui.events.AlertEvent;
	
	public class RevertFileCommandHandler implements ICommandHandler
	{
		public static function getFactory():CommandHandlerFactory
		{
			return new CommandHandlerFactory( Commands.REVERT, RevertFileCommandHandler, [ new SaveAvailableValidator( FloxEditor.contextManager ) ] );
		}
		
		private var editorContext:IEditorContext;
		
		public function RevertFileCommandHandler()
		{
			
		}

		public function execute( parameters:Object ):void
		{
			editorContext = FloxEditor.contextManager.getLatestContextOfType(IEditorContext);
			
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
			var closeFileOperation:CloseEditorOperation = new CloseEditorOperation( editorContext, FloxApp.fileSystemProvider );
			operation.addOperation(closeFileOperation);
			
			var openFileOperation:OpenFileOperation = new OpenFileOperation( uri, FloxApp.fileSystemProvider, FloxEditor.settingsManager );
			operation.addOperation( openFileOperation );
			
			FloxEditor.operationManager.addOperation(operation);
		}
	}
}