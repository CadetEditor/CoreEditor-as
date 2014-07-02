package helloWorld.commandHandlers
{
	import core.appEx.core.commandHandlers.ICommandHandler;
	import core.editor.CoreEditor;
	
	import helloWorld.contexts.StringListContext;
	
	public class AddStringCommandHandler implements ICommandHandler
	{
		public function AddStringCommandHandler()
		{
		}
		
		public function execute(parameters:Object):void
		{
			var context:StringListContext = CoreEditor.contextManager.getLatestContextOfType(StringListContext);
			
			var length:int = context.dataProvider.length;
			context.dataProvider.addItem("Item " + (length+1));
		}
	}
}