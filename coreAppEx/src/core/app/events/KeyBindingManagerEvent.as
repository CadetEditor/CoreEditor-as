// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.app.events
{
	import flash.events.Event;
	
	import core.app.resources.KeyBinding;
	
	public class KeyBindingManagerEvent extends Event
	{
		public static const KEY_BINDING_EXECUTED	:String = "keyBindingExecuted";
		
		private var _keyBinding		:KeyBinding;
		
		public function KeyBindingManagerEvent( type:String, keyBinding:KeyBinding )
		{
			super( type, false, false );
			_keyBinding = keyBinding;
		}
		
		public function get keyBinding():KeyBinding { return _keyBinding; }
	}
}