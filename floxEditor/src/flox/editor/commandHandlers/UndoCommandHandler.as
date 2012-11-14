// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.commandHandlers
{
	import flox.editor.FloxEditor;
	import flox.editor.entities.Commands;
	import flox.app.core.commandHandlers.ICommandHandler;
	import flox.app.core.contexts.IOperationManagerContext;
	import flox.app.resources.CommandHandlerFactory;
	import flox.app.validators.UndoAvailableValidator;

	public class UndoCommandHandler implements ICommandHandler
	{
		static public function getFactory():CommandHandlerFactory
		{
			var descriptor:CommandHandlerFactory = new CommandHandlerFactory( Commands.UNDO, UndoCommandHandler );
			descriptor.validators.push( new UndoAvailableValidator( FloxEditor.contextManager ) );
			return descriptor;
		}
		
		public function UndoCommandHandler() {}
		
		public function execute( parameters:Object ):void
		{
			var context:IOperationManagerContext = FloxEditor.contextManager.getLatestContextOfType(IOperationManagerContext);
			context.operationManager.gotoPreviousOperation();
		}
	}
}