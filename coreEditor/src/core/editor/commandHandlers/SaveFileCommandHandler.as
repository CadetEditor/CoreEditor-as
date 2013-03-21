// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.commandHandlers
{
	import core.editor.CoreEditor;
	import core.editor.contexts.IEditorContext;
	import core.editor.entities.Commands;
	import core.editor.validators.SaveAvailableValidator;
	import core.app.core.commandHandlers.ICommandHandler;
	import core.app.resources.CommandHandlerFactory;
	
	
	public class SaveFileCommandHandler implements ICommandHandler
	{
		static public function getFactory():CommandHandlerFactory
		{
			return new CommandHandlerFactory( Commands.SAVE_FILE, SaveFileCommandHandler, [ new SaveAvailableValidator( CoreEditor.contextManager ) ] );
		}
		
		public function execute( parameters:Object ):void
		{
			var editorContext:IEditorContext = CoreEditor.contextManager.getLatestContextOfType(IEditorContext);
			if ( editorContext.isNewFile )
			{
				CoreEditor.commandManager.executeCommand( Commands.SAVE_FILE_AS );
			}
			else
			{
				editorContext.save();
			}
		}
	}
}