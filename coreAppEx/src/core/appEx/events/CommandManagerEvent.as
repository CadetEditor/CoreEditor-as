// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.events
{
	import flash.events.Event;
	
	public class CommandManagerEvent extends Event
	{
		public static const COMMAND_AVAILABILITY_CHANGE	:String = "commandAvailabilityChange";
		
		private var _commandID		:String;
		private var _available		:Boolean;
		
		public function CommandManagerEvent(type:String, commandID:String, available:Boolean)
		{
			super(type);
			_commandID = commandID;
			_available = available;
		}
		
		override public function clone() : Event
		{
			return new CommandManagerEvent( type, _commandID, _available );
		}
		
		public function get commandID():String { return _commandID; }
		public function get available():Boolean { return _available; }
	}
}