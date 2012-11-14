// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.commandHandlers
{
	import flox.editor.FloxEditor;
	import flox.editor.contexts.IEditorContext;
	import flox.editor.entities.Commands;
	import flox.editor.operations.SaveFileAsOperation;
	import flox.app.core.commandHandlers.ICommandHandler;
	import flox.app.resources.CommandHandlerFactory;
	import flox.app.validators.ContextValidator;
	
	
	public class SaveFileAsCommandHandler implements ICommandHandler
	{
		static public function getFactory():CommandHandlerFactory
		{
			return new CommandHandlerFactory( Commands.SAVE_FILE_AS, SaveFileAsCommandHandler, [ new ContextValidator( FloxEditor.contextManager, IEditorContext ) ] );
		}
		
		public function SaveFileAsCommandHandler()
		{
			
		}
		
		public function execute( parameters:Object ):void
		{
			var editorContext:IEditorContext = IEditorContext(FloxEditor.contextManager.getLatestContextOfType(IEditorContext));
			var operation:SaveFileAsOperation = new SaveFileAsOperation( editorContext );
			operation.execute();
		}
	}
}