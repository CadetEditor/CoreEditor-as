// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.commandHandlers
{
	import flash.events.Event;
	
	import core.app.CoreApp;
	import core.app.core.commandHandlers.ICommandHandler;
	import core.app.core.managers.fileSystemProviders.operations.IDoesFileExistOperation;
	import core.app.core.operations.IAsynchronousOperation;
	import core.app.entities.URI;
	import core.app.operations.CopyFileOperation;
	import core.app.operations.MoveFileOperation;
	import core.app.resources.CommandHandlerFactory;
	import core.app.validators.CollectionValidator;
	import core.app.validators.CompoundValidator;
	import core.app.validators.ContextSelectionValidator;
	import core.editor.CoreEditor;
	import core.editor.entities.Commands;
	import core.editor.utils.CoreEditorUtil;
	import core.ui.components.Alert;

	public class PasteFileCommandHandler implements ICommandHandler
	{
		private var sourceURI		:URI;
		private var destinationURI	:URI;
		
		static public function getFactory():CommandHandlerFactory
		{
			var descriptor:CommandHandlerFactory = new CommandHandlerFactory( Commands.PASTE, PasteFileCommandHandler );
			descriptor.validators.push( new ContextSelectionValidator( CoreEditor.contextManager, null, true, URI, 1, 1 ) );
			
			var compoundValidator:CompoundValidator = new CompoundValidator();
			compoundValidator.operation = CompoundValidator.OR;
			
			var copyClipboardValidator:CollectionValidator = new CollectionValidator( CoreEditor.copyClipboard, URI, 1, 1 );
			compoundValidator.addValidator(copyClipboardValidator);
			var cutClipboardValidator:CollectionValidator = new CollectionValidator( CoreEditor.cutClipboard, URI, 1, 1 );
			compoundValidator.addValidator(cutClipboardValidator);
			
			descriptor.validators.push( compoundValidator );
			
			return descriptor;
		}
		
		public function PasteFileCommandHandler() {}

		public function execute(parameters:Object):void
		{
			sourceURI = CoreEditor.cutClipboard.length ? CoreEditor.cutClipboard[0] : CoreEditor.copyClipboard[0];
			
			destinationURI = CoreEditorUtil.getCurrentSelection( null, URI )[0];
			destinationURI.chdir(sourceURI.getFilename());
			
			var doesFileExistOperation:IDoesFileExistOperation = CoreApp.fileSystemProvider.doesFileExist(destinationURI);
			doesFileExistOperation.addEventListener(Event.COMPLETE, doesFileExistCompleteHandler);
			CoreEditor.operationManager.addOperation(doesFileExistOperation);
		}
		
		
		
		private function doesFileExistCompleteHandler( event:Event ):void
		{
			var doesFileExistOperation:IDoesFileExistOperation = IDoesFileExistOperation(event.target);
			if ( doesFileExistOperation.fileExists )
			{
				Alert.show("A file with this name already exists at this location.", "Error", ["OK"]);
				return;
			}
			else
			{
				pasteFile();
			}
		}
		
		private function pasteFile():void
		{
			var operation:IAsynchronousOperation;
			if ( CoreEditor.cutClipboard.length != 0 )
			{
				operation = new MoveFileOperation( sourceURI, destinationURI, CoreApp.fileSystemProvider );
			}
			else
			{
				operation = new CopyFileOperation( sourceURI, destinationURI, CoreApp.fileSystemProvider );
			}
			CoreEditor.operationManager.addOperation(operation);
		}
		
	}
}