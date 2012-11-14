package helloWorld.commandHandlers
{
	import flox.app.core.commandHandlers.ICommandHandler;
	import flox.ui.components.Alert;

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