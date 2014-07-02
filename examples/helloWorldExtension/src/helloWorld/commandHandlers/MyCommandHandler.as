package helloWorld.commandHandlers
{
	import core.appEx.core.commandHandlers.ICommandHandler;
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