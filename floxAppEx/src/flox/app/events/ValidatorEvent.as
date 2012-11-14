// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.app.events
{
	import flash.events.Event;

	public class ValidatorEvent extends Event
	{
		public static const	STATE_CHANGED	:String = "stateChanged"
		
		private var _state		:Boolean;
		
		public function ValidatorEvent(type:String, state:Boolean)
		{
			super(type);
			_state = state;
		}
		
		override public function clone():Event
		{
			return new ValidatorEvent( type, _state );
		}
		
		public function get state():Boolean { return _state; }
		
	}
}