// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.commandHandlers
{
	import flox.editor.FloxEditor;
	import flox.editor.entities.Commands;
	import flox.app.core.commandHandlers.ICommandHandler;
	import flox.app.core.contexts.IOperationManagerContext;
	import flox.app.resources.CommandHandlerFactory;
	import flox.app.validators.RedoAvailableValidator;

	public class RedoCommandHandler implements ICommandHandler
	{
		static public function getFactory():CommandHandlerFactory
		{
			var descriptor:CommandHandlerFactory = new CommandHandlerFactory( Commands.REDO, RedoCommandHandler );
			descriptor.validators.push( new RedoAvailableValidator( FloxEditor.contextManager ) );
			return descriptor;
		}
		
		public function RedoCommandHandler() {}
		
		public function execute( parameters:Object ):void
		{
			var context:IOperationManagerContext = FloxEditor.contextManager.getLatestContextOfType(IOperationManagerContext);
			context.operationManager.gotoNextOperation();
		}
	}
}