// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.commandHandlers
{
	import core.editor.CoreEditor;
	import core.editor.operations.AddContextOperation;
	import core.app.core.commandHandlers.ICommandHandler;
	import core.app.resources.IFactoryResource;
	import core.app.resources.IResource;
	
	public class CreateVisualContextCommandHandler implements ICommandHandler
	{
		public function CreateVisualContextCommandHandler()
		{
			
		}
		
		public function execute( parameters:Object ):void
		{
			var factory:IFactoryResource = IFactoryResource( parameters.factory );
			CoreEditor.operationManager.addOperation( new AddContextOperation( factory ) );
		}
	}
}