// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.commandHandlers
{
	import core.app.CoreApp;
	import core.app.core.commandHandlers.ICommandHandler;
	import core.app.core.contexts.IVisualContext;
	import core.app.resources.CommandHandlerFactory;
	import core.app.validators.ContextValidator;
	import core.editor.CoreEditor;
	import core.editor.contexts.IEditorContext;
	import core.editor.core.IViewContainer;
	import core.editor.entities.Commands;
	import core.editor.operations.CloseEditorOperation;
	
	public class CloseFileCommandHandler implements ICommandHandler
	{
		public static function getFactory():CommandHandlerFactory
		{
			var descriptor:CommandHandlerFactory = new CommandHandlerFactory( Commands.CLOSE_FILE, CloseFileCommandHandler );
			descriptor.validators.push( new ContextValidator( CoreEditor.contextManager, IEditorContext ) );
			return descriptor;
		}
		
		public function CloseFileCommandHandler() {}
		
		public function execute( parameters:Object ):void
		{
			var editorContext:IEditorContext = CoreEditor.contextManager.getLatestContextOfType(IEditorContext);
			var closeFileOperation:CloseEditorOperation = new CloseEditorOperation( editorContext, CoreApp.fileSystemProvider );
			closeFileOperation.execute();
		}
	}
}