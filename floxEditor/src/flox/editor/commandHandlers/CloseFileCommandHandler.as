// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.commandHandlers
{
	import flox.app.FloxApp;
	import flox.app.core.commandHandlers.ICommandHandler;
	import flox.app.core.contexts.IVisualContext;
	import flox.app.resources.CommandHandlerFactory;
	import flox.app.validators.ContextValidator;
	import flox.editor.FloxEditor;
	import flox.editor.contexts.IEditorContext;
	import flox.editor.core.IViewContainer;
	import flox.editor.entities.Commands;
	import flox.editor.operations.CloseEditorOperation;
	
	public class CloseFileCommandHandler implements ICommandHandler
	{
		public static function getFactory():CommandHandlerFactory
		{
			var descriptor:CommandHandlerFactory = new CommandHandlerFactory( Commands.CLOSE_FILE, CloseFileCommandHandler );
			descriptor.validators.push( new ContextValidator( FloxEditor.contextManager, IEditorContext ) );
			return descriptor;
		}
		
		public function CloseFileCommandHandler() {}
		
		public function execute( parameters:Object ):void
		{
			var editorContext:IEditorContext = FloxEditor.contextManager.getLatestContextOfType(IEditorContext);
			var closeFileOperation:CloseEditorOperation = new CloseEditorOperation( editorContext, FloxApp.fileSystemProvider );
			closeFileOperation.execute();
		}
	}
}