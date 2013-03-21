package 
{
	import flash.display.Sprite;
	
	import core.app.CoreApp;
	import core.app.entities.KeyModifier;
	import core.app.resources.CommandHandlerFactory;
	import core.app.resources.FactoryResource;
	import core.app.resources.FileType;
	import core.app.resources.KeyBinding;
	import core.app.validators.ContextValidator;
	import core.editor.CoreEditor;
	import core.editor.resources.ActionFactory;
	import core.editor.resources.EditorFactory;
	
	import helloWorld.commandHandlers.AddStringCommandHandler;
	import helloWorld.commandHandlers.MyCommandHandler;
	import helloWorld.contexts.HelloWorldContext;
	import helloWorld.contexts.StringListContext;
	import helloWorld.entities.Commands;
	import helloWorld.ui.views.HelloWorldView;
	
	//TODO: App doesn't close when close (top right) is clicked.
	public class HelloWorldExtension extends Sprite
	{
		[Embed( source="../../../coreEditor/src/core/editor/icons/Resource.png" )]
		public static const ResourceIcon:Class;
		
		[Embed(source='../../../coreEditor/src/core/editor/icons/Text.png')]				
		private var TextIcon:Class;
		
		public function HelloWorldExtension()
		{
			// HelloWorldContext Example
			CoreApp.resourceManager.addResource( new FactoryResource( HelloWorldContext, "Hello World" ) );
			
			// Didn't appear in menu bar at top of view...
			//CoreApp.resourceManager.addResource( new ActionFactory( HelloWorldContext, Commands.MY_COMMAND, "My Action", "myActions", "Actions/MyActions" ) );
			CoreApp.resourceManager.addResource( new ActionFactory( HelloWorldContext, Commands.MY_COMMAND, "My Action", "myActions", "Actions/MyActions", ResourceIcon ) );
			
			CoreApp.resourceManager.addResource( new CommandHandlerFactory( Commands.MY_COMMAND, MyCommandHandler ) );
			
			CoreApp.resourceManager.addResource( new KeyBinding( Commands.MY_COMMAND, 77, KeyModifier.CTRL ) );
			
			//CoreEditor.commandManager.executeCommand(Commands.MY_COMMAND);
			
			
			// StringListContext Example
			CoreApp.resourceManager.addResource( new FileType( "String List File", "strlist", TextIcon ) );
			
			//CoreApp.resourceManager.addResource( new FactoryResource( StringListContext, "String List" ) );
			CoreApp.resourceManager.addResource( new EditorFactory( StringListContext, "String List", "strlist", TextIcon ) );
			
			var commandHandlerFactory:CommandHandlerFactory = new CommandHandlerFactory( Commands.ADD_STRING, AddStringCommandHandler );
			commandHandlerFactory.validators.push( new ContextValidator( CoreEditor.contextManager, StringListContext ) );
			CoreApp.resourceManager.addResource( commandHandlerFactory );
			
			CoreApp.resourceManager.addResource( new ActionFactory( StringListContext, Commands.ADD_STRING, "Add String", "myActions" ) );
			
			
		}
	}
}