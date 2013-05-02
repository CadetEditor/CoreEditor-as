// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.events
{
	import flash.events.Event;

	public class SettingsManagerEvent extends Event
	{
		public static const CHANGE			:String = "change";
		
		private var _kind		:String;
		private var _key		:String;
		private var _value		:*;
		
		public function SettingsManagerEvent(type:String, kind:String, key:String = null, value:* = null)
		{
			super(type);
			_kind = kind;
			_key = key;
			_value = value;
		}
		
		public function get kind():String { return _kind; }
		public function get key():String { return _key; }
		public function get value():* { return _value; }
		
	}
}