// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.commandHandlers
{
	import flash.events.Event;
	
	import flox.app.FloxApp;
	import flox.app.core.commandHandlers.ICommandHandler;
	import flox.app.core.managers.fileSystemProviders.operations.IDoesFileExistOperation;
	import flox.app.core.operations.IAsynchronousOperation;
	import flox.app.entities.URI;
	import flox.app.operations.CopyFileOperation;
	import flox.app.operations.MoveFileOperation;
	import flox.app.resources.CommandHandlerFactory;
	import flox.app.validators.CollectionValidator;
	import flox.app.validators.CompoundValidator;
	import flox.app.validators.ContextSelectionValidator;
	import flox.editor.FloxEditor;
	import flox.editor.entities.Commands;
	import flox.editor.utils.FloxEditorUtil;
	import flox.ui.components.Alert;

	public class PasteFileCommandHandler implements ICommandHandler
	{
		private var sourceURI		:URI;
		private var destinationURI	:URI;
		
		static public function getFactory():CommandHandlerFactory
		{
			var descriptor:CommandHandlerFactory = new CommandHandlerFactory( Commands.PASTE, PasteFileCommandHandler );
			descriptor.validators.push( new ContextSelectionValidator( FloxEditor.contextManager, null, true, URI, 1, 1 ) );
			
			var compoundValidator:CompoundValidator = new CompoundValidator();
			compoundValidator.operation = CompoundValidator.OR;
			
			var copyClipboardValidator:CollectionValidator = new CollectionValidator( FloxEditor.copyClipboard, URI, 1, 1 );
			compoundValidator.addValidator(copyClipboardValidator);
			var cutClipboardValidator:CollectionValidator = new CollectionValidator( FloxEditor.cutClipboard, URI, 1, 1 );
			compoundValidator.addValidator(cutClipboardValidator);
			
			descriptor.validators.push( compoundValidator );
			
			return descriptor;
		}
		
		public function PasteFileCommandHandler() {}

		public function execute(parameters:Object):void
		{
			sourceURI = FloxEditor.cutClipboard.length ? FloxEditor.cutClipboard[0] : FloxEditor.copyClipboard[0];
			
			destinationURI = FloxEditorUtil.getCurrentSelection( null, URI )[0];
			destinationURI.chdir(sourceURI.getFilename());
			
			var doesFileExistOperation:IDoesFileExistOperation = FloxApp.fileSystemProvider.doesFileExist(destinationURI);
			doesFileExistOperation.addEventListener(Event.COMPLETE, doesFileExistCompleteHandler);
			FloxEditor.operationManager.addOperation(doesFileExistOperation);
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
			if ( FloxEditor.cutClipboard.length != 0 )
			{
				operation = new MoveFileOperation( sourceURI, destinationURI, FloxApp.fileSystemProvider );
			}
			else
			{
				operation = new CopyFileOperation( sourceURI, destinationURI, FloxApp.fileSystemProvider );
			}
			FloxEditor.operationManager.addOperation(operation);
		}
		
	}
}