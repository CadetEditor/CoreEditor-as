// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.events
{
	import flash.events.Event;

	public class ContextSelectionValidatorEvent extends Event
	{
		public static const VALID_SELECTION_CHANGED		:String = "validSelectionChanged"
		
		protected var _validSelection		:Array;
		
		public function ContextSelectionValidatorEvent( type:String, validSelection:Array)
		{
			super(type);
			_validSelection = validSelection;
		}
		
		public function get validSelection():Array { return _validSelection; }
	}
}