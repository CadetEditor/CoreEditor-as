// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.app.validators
{
	import core.app.events.CommandManagerEvent;
	import core.app.managers.CommandManager;

	public class CommandAvailableValidator extends AbstractValidator
	{
		private var commandManager		:CommandManager;
		private var commandID					:String;
		
		public function CommandAvailableValidator( commandID:String, commandManager:CommandManager )
		{
			this.commandID = commandID;
			this.commandManager = commandManager;
			
			commandManager.addEventListener( CommandManagerEvent.COMMAND_AVAILABILITY_CHANGE, commandAvailabilityChangeHandler );
			setState(commandManager.isCommandHandled(commandID));
		}
		
		override public function dispose():void
		{
			commandManager.removeEventListener( CommandManagerEvent.COMMAND_AVAILABILITY_CHANGE, commandAvailabilityChangeHandler );
			commandManager = null;
		}
		
		private function commandAvailabilityChangeHandler( event:CommandManagerEvent ):void
		{
			if ( event.commandID != commandID ) return;
			setState(event.available);
		}
	}
}