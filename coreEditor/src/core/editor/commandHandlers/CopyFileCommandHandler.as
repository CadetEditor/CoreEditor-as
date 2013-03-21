// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.commandHandlers
{
	import core.ui.components.Alert;
	
	import core.editor.CoreEditor;
	import core.editor.entities.Commands;
	import core.editor.utils.CoreEditorUtil;
	import core.app.core.commandHandlers.ICommandHandler;
	import core.app.resources.CommandHandlerFactory;
	import core.app.entities.URI;
	import core.app.validators.ContextSelectionValidator;

	public class CopyFileCommandHandler implements ICommandHandler
	{
		public static function getFactory():CommandHandlerFactory
		{
			var descriptor:CommandHandlerFactory = new CommandHandlerFactory( Commands.COPY, CopyFileCommandHandler );
			descriptor.validators.push( new ContextSelectionValidator( CoreEditor.contextManager, null, true, URI, 1, 1 ) );
			return descriptor;
		}
		
		public function CopyFileCommandHandler() {}

		public function execute(parameters:Object):void
		{
			var uri:URI = CoreEditorUtil.getCurrentSelection( null, URI )[0];
			
			if ( uri.isDirectory() )
			{
				Alert.show("Cannot copy folders.", "Error", ["OK"]);
				return;
			}
			
			CoreEditor.cutClipboard.source = [];
			CoreEditor.copyClipboard.source = [uri];
		}
	}
}