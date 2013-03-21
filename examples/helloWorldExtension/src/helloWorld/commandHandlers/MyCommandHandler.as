package helloWorld.commandHandlers
{
	import core.app.core.commandHandlers.ICommandHandler;
	import core.ui.components.Alert;

	public class MyCommandHandler implements ICommandHandler
	{
		public function MyCommandHandler()
		{
			
		}
		
		public function execute(parameters:Object):void
		{
			Alert.show("Alert", "Hello World", ["OK"]);
		}
	}
}