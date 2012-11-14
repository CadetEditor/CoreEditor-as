// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.commandHandlers
{
	import flox.ui.components.Alert;
	
	import flox.editor.FloxEditor;
	import flox.editor.entities.Commands;
	import flox.editor.utils.FloxEditorUtil;
	import flox.app.core.commandHandlers.ICommandHandler;
	import flox.app.resources.CommandHandlerFactory;
	import flox.app.entities.URI;
	import flox.app.validators.ContextSelectionValidator;

	public class CopyFileCommandHandler implements ICommandHandler
	{
		public static function getFactory():CommandHandlerFactory
		{
			var descriptor:CommandHandlerFactory = new CommandHandlerFactory( Commands.COPY, CopyFileCommandHandler );
			descriptor.validators.push( new ContextSelectionValidator( FloxEditor.contextManager, null, true, URI, 1, 1 ) );
			return descriptor;
		}
		
		public function CopyFileCommandHandler() {}

		public function execute(parameters:Object):void
		{
			var uri:URI = FloxEditorUtil.getCurrentSelection( null, URI )[0];
			
			if ( uri.isDirectory() )
			{
				Alert.show("Cannot copy folders.", "Error", ["OK"]);
				return;
			}
			
			FloxEditor.cutClipboard.source = [];
			FloxEditor.copyClipboard.source = [uri];
		}
	}
}