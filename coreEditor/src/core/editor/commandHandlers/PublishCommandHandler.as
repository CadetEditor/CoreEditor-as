package core.editor.commandHandlers
{
	import flash.events.Event;
	
	import core.app.core.commandHandlers.ICommandHandler;
	import core.app.resources.CommandHandlerFactory;
	import core.app.validators.ContextValidator;
	import core.editor.CoreEditor;
	import core.editor.contexts.IEditorContext;
	import core.editor.entities.Commands;
	import core.ui.components.Alert;
	import core.ui.events.AlertEvent;
	
	public class PublishCommandHandler implements ICommandHandler
	{
		static public function getFactory():CommandHandlerFactory
		{
			var validators:Array = [ new ContextValidator( CoreEditor.contextManager, IEditorContext ) ];
			return new CommandHandlerFactory( Commands.PUBLISH_FILE, PublishCommandHandler, validators );
		}
		
		public function execute( parameters:Object ):void
		{
			var editorContext:IEditorContext = CoreEditor.contextManager.getLatestContextOfType(IEditorContext);
			if ( editorContext.isNewFile )
			{
				Alert.show(	"Save Before Publishing", "You must save the scene before publishing.", 
					["Ok","Cancel"], "Ok",
					null, true,
					closeAlertHandler );
			}
			else
			{
				editorContext.publish();
			}
		}
		
		protected function closeAlertHandler( event:AlertEvent ):void
		{
			switch ( event.selectedButton )
			{
				case "Ok" :
					CoreEditor.commandManager.executeCommand( Commands.SAVE_FILE_AS );
					break;
			}
		}
	}
}