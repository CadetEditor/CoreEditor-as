// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.commandHandlers
{
	import flox.editor.FloxEditor;
	import flox.editor.contexts.IEditorContext;
	import flox.editor.entities.Commands;
	import flox.editor.validators.SaveAvailableValidator;
	import flox.app.core.commandHandlers.ICommandHandler;
	import flox.app.resources.CommandHandlerFactory;
	
	
	public class SaveFileCommandHandler implements ICommandHandler
	{
		static public function getFactory():CommandHandlerFactory
		{
			return new CommandHandlerFactory( Commands.SAVE_FILE, SaveFileCommandHandler, [ new SaveAvailableValidator( FloxEditor.contextManager ) ] );
		}
		
		public function execute( parameters:Object ):void
		{
			var editorContext:IEditorContext = FloxEditor.contextManager.getLatestContextOfType(IEditorContext);
			if ( editorContext.isNewFile )
			{
				FloxEditor.commandManager.executeCommand( Commands.SAVE_FILE_AS );
			}
			else
			{
				editorContext.save();
			}
		}
	}
}