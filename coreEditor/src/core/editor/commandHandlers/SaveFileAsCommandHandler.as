// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.commandHandlers
{
	import core.editor.CoreEditor;
	import core.editor.contexts.IEditorContext;
	import core.editor.entities.Commands;
	import core.editor.operations.SaveFileAsOperation;
	import core.app.core.commandHandlers.ICommandHandler;
	import core.app.resources.CommandHandlerFactory;
	import core.app.validators.ContextValidator;
	
	
	public class SaveFileAsCommandHandler implements ICommandHandler
	{
		static public function getFactory():CommandHandlerFactory
		{
			return new CommandHandlerFactory( Commands.SAVE_FILE_AS, SaveFileAsCommandHandler, [ new ContextValidator( CoreEditor.contextManager, IEditorContext ) ] );
		}
		
		public function SaveFileAsCommandHandler()
		{
			
		}
		
		public function execute( parameters:Object ):void
		{
			var editorContext:IEditorContext = IEditorContext(CoreEditor.contextManager.getLatestContextOfType(IEditorContext));
			var operation:SaveFileAsOperation = new SaveFileAsOperation( editorContext );
			operation.execute();
		}
	}
}