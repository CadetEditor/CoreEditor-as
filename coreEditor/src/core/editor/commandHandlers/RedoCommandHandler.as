// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.commandHandlers
{
	import core.editor.CoreEditor;
	import core.editor.entities.Commands;
	import core.appEx.core.commandHandlers.ICommandHandler;
	import core.appEx.core.contexts.IOperationManagerContext;
	import core.appEx.resources.CommandHandlerFactory;
	import core.appEx.validators.RedoAvailableValidator;

	public class RedoCommandHandler implements ICommandHandler
	{
		static public function getFactory():CommandHandlerFactory
		{
			var descriptor:CommandHandlerFactory = new CommandHandlerFactory( Commands.REDO, RedoCommandHandler );
			descriptor.validators.push( new RedoAvailableValidator( CoreEditor.contextManager ) );
			return descriptor;
		}
		
		public function RedoCommandHandler() {}
		
		public function execute( parameters:Object ):void
		{
			var context:IOperationManagerContext = CoreEditor.contextManager.getLatestContextOfType(IOperationManagerContext);
			context.operationManager.gotoNextOperation();
		}
	}
}