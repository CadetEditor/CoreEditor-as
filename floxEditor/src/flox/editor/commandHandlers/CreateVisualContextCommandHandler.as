// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.commandHandlers
{
	import flox.editor.FloxEditor;
	import flox.editor.operations.AddContextOperation;
	import flox.app.core.commandHandlers.ICommandHandler;
	import flox.app.resources.IFactoryResource;
	import flox.app.resources.IResource;
	
	public class CreateVisualContextCommandHandler implements ICommandHandler
	{
		public function CreateVisualContextCommandHandler()
		{
			
		}
		
		public function execute( parameters:Object ):void
		{
			var factory:IFactoryResource = IFactoryResource( parameters.factory );
			FloxEditor.operationManager.addOperation( new AddContextOperation( factory ) );
		}
	}
}