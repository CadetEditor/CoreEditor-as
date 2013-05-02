// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.commandHandlers
{
	import core.editor.CoreEditor;
	import core.editor.entities.Commands;
	import core.appEx.core.commandHandlers.ICommandHandler;
	import core.appEx.core.contexts.IRefreshableContext;
	import core.appEx.resources.CommandHandlerFactory;
	import core.appEx.validators.ContextValidator;
	
	public class RefreshCommandHandler implements ICommandHandler
	{
		static public function getFactory():CommandHandlerFactory
		{
			var descriptor:CommandHandlerFactory = new CommandHandlerFactory( Commands.REFRESH, RefreshCommandHandler )
			descriptor.validators.push( new ContextValidator( CoreEditor.contextManager, IRefreshableContext ) );
			return descriptor;
		}
		
		public function RefreshCommandHandler() {}
		
		public function execute( parameters:Object ):void
		{
			var context:IRefreshableContext = CoreEditor.contextManager.getLatestContextOfType(IRefreshableContext);
			context.refresh();
		}
	}
}