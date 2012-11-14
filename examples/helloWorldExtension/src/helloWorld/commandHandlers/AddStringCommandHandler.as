package helloWorld.commandHandlers
{
	import flox.app.core.commandHandlers.ICommandHandler;
	import flox.editor.FloxEditor;
	
	import helloWorld.contexts.StringListContext;
	
	public class AddStringCommandHandler implements ICommandHandler
	{
		public function AddStringCommandHandler()
		{
		}
		
		public function execute(parameters:Object):void
		{
			var context:StringListContext = FloxEditor.contextManager.getLatestContextOfType(StringListContext);
			
			var length:int = context.dataProvider.length;
			context.dataProvider.addItem("Item " + (length+1));
		}
	}
}