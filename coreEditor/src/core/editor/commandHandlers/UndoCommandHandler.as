// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.commandHandlers
{
	import core.editor.CoreEditor;
	import core.editor.entities.Commands;
	import core.app.core.commandHandlers.ICommandHandler;
	import core.app.core.contexts.IOperationManagerContext;
	import core.app.resources.CommandHandlerFactory;
	import core.app.validators.UndoAvailableValidator;

	public class UndoCommandHandler implements ICommandHandler
	{
		static public function getFactory():CommandHandlerFactory
		{
			var descriptor:CommandHandlerFactory = new CommandHandlerFactory( Commands.UNDO, UndoCommandHandler );
			descriptor.validators.push( new UndoAvailableValidator( CoreEditor.contextManager ) );
			return descriptor;
		}
		
		public function UndoCommandHandler() {}
		
		public function execute( parameters:Object ):void
		{
			var context:IOperationManagerContext = CoreEditor.contextManager.getLatestContextOfType(IOperationManagerContext);
			context.operationManager.gotoPreviousOperation();
		}
	}
}