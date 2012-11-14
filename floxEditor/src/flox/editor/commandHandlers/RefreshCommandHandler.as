// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.commandHandlers
{
	import flox.editor.FloxEditor;
	import flox.editor.entities.Commands;
	import flox.app.core.commandHandlers.ICommandHandler;
	import flox.app.core.contexts.IRefreshableContext;
	import flox.app.resources.CommandHandlerFactory;
	import flox.app.validators.ContextValidator;
	
	public class RefreshCommandHandler implements ICommandHandler
	{
		static public function getFactory():CommandHandlerFactory
		{
			var descriptor:CommandHandlerFactory = new CommandHandlerFactory( Commands.REFRESH, RefreshCommandHandler )
			descriptor.validators.push( new ContextValidator( FloxEditor.contextManager, IRefreshableContext ) );
			return descriptor;
		}
		
		public function RefreshCommandHandler() {}
		
		public function execute( parameters:Object ):void
		{
			var context:IRefreshableContext = FloxEditor.contextManager.getLatestContextOfType(IRefreshableContext);
			context.refresh();
		}
	}
}