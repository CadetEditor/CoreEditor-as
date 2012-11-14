// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.commandHandlers
{
	import flox.editor.FloxEditor;
	import flox.editor.entities.Commands;
	import flox.editor.utils.FloxEditorUtil;
	import flox.app.core.commandHandlers.ICommandHandler;
	import flox.app.resources.CommandHandlerFactory;
	import flox.app.entities.URI;
	import flox.app.validators.ContextSelectionValidator;

	public class CutFileCommandHandler implements ICommandHandler
	{
		public static function getFactory():CommandHandlerFactory
		{
			var descriptor:CommandHandlerFactory = new CommandHandlerFactory( Commands.CUT, CutFileCommandHandler );
			descriptor.validators.push( new ContextSelectionValidator( FloxEditor.contextManager, null, true,  URI, 1, 1 ) );
			return descriptor;
		}
		
		public function CutFileCommandHandler() {}

		public function execute(parameters:Object):void
		{
			var uri:URI = FloxEditorUtil.getCurrentSelection( null, URI )[0];
			FloxEditor.copyClipboard.source = [];
			FloxEditor.cutClipboard.source = [uri];
		}
	}
}