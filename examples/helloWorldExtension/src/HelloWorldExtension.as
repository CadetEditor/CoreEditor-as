package 
{
	import flash.display.Sprite;
	
	import flox.app.FloxApp;
	import flox.app.entities.KeyModifier;
	import flox.app.resources.CommandHandlerFactory;
	import flox.app.resources.FactoryResource;
	import flox.app.resources.FileType;
	import flox.app.resources.KeyBinding;
	import flox.app.validators.ContextValidator;
	import flox.editor.FloxEditor;
	import flox.editor.resources.ActionFactory;
	import flox.editor.resources.EditorFactory;
	
	import helloWorld.commandHandlers.AddStringCommandHandler;
	import helloWorld.commandHandlers.MyCommandHandler;
	import helloWorld.contexts.HelloWorldContext;
	import helloWorld.contexts.StringListContext;
	import helloWorld.entities.Commands;
	import helloWorld.ui.views.HelloWorldView;
	
	//TODO: App doesn't close when close (top right) is clicked.
	public class HelloWorldExtension extends Sprite
	{
		[Embed( source="../../../floxEditor/src/flox/editor/icons/Resource.png" )]
		public static const ResourceIcon:Class;
		
		[Embed(source='../../../floxEditor/src/flox/editor/icons/Text.png')]				
		private var TextIcon:Class;
		
		public function HelloWorldExtension()
		{
			// HelloWorldContext Example
			FloxApp.resourceManager.addResource( new FactoryResource( HelloWorldContext, "Hello World" ) );
			
			// Didn't appear in menu bar at top of view...
			//FloxApp.resourceManager.addResource( new ActionFactory( HelloWorldContext, Commands.MY_COMMAND, "My Action", "myActions", "Actions/MyActions" ) );
			FloxApp.resourceManager.addResource( new ActionFactory( HelloWorldContext, Commands.MY_COMMAND, "My Action", "myActions", "Actions/MyActions", ResourceIcon ) );
			
			FloxApp.resourceManager.addResource( new CommandHandlerFactory( Commands.MY_COMMAND, MyCommandHandler ) );
			
			FloxApp.resourceManager.addResource( new KeyBinding( Commands.MY_COMMAND, 77, KeyModifier.CTRL ) );
			
			//FloxEditor.commandManager.executeCommand(Commands.MY_COMMAND);
			
			
			// StringListContext Example
			FloxApp.resourceManager.addResource( new FileType( "String List File", "strlist", TextIcon ) );
			
			//FloxApp.resourceManager.addResource( new FactoryResource( StringListContext, "String List" ) );
			FloxApp.resourceManager.addResource( new EditorFactory( StringListContext, "String List", "strlist", TextIcon ) );
			
			var commandHandlerFactory:CommandHandlerFactory = new CommandHandlerFactory( Commands.ADD_STRING, AddStringCommandHandler );
			commandHandlerFactory.validators.push( new ContextValidator( FloxEditor.contextManager, StringListContext ) );
			FloxApp.resourceManager.addResource( commandHandlerFactory );
			
			FloxApp.resourceManager.addResource( new ActionFactory( StringListContext, Commands.ADD_STRING, "Add String", "myActions" ) );
			
			
		}
	}
}