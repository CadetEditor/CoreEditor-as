// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.commandHandlers
{
	import core.editor.CoreEditor;
	import core.editor.entities.Commands;
	import core.editor.utils.CoreEditorUtil;
	import core.appEx.core.commandHandlers.ICommandHandler;
	import core.appEx.resources.CommandHandlerFactory;
	import core.app.entities.URI;
	import core.appEx.validators.ContextSelectionValidator;

	public class CutFileCommandHandler implements ICommandHandler
	{
		public static function getFactory():CommandHandlerFactory
		{
			var descriptor:CommandHandlerFactory = new CommandHandlerFactory( Commands.CUT, CutFileCommandHandler );
			descriptor.validators.push( new ContextSelectionValidator( CoreEditor.contextManager, null, true,  URI, 1, 1 ) );
			return descriptor;
		}
		
		public function CutFileCommandHandler() {}

		public function execute(parameters:Object):void
		{
			var uri:URI = CoreEditorUtil.getCurrentSelection( null, URI )[0];
			CoreEditor.copyClipboard.source = [];
			CoreEditor.cutClipboard.source = [uri];
		}
	}
}