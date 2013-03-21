// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.app.events
{
	import flash.events.Event;

	public class CollectionValidatorEvent extends Event
	{
		public static const VALID_ITEMS_CHANGED	:String = "validItemsChanged";
		
		private var _validItems	:Array;
		
		public function CollectionValidatorEvent(type:String, validItems:Array)
		{
			super(type);
			_validItems = validItems;
		}
		
		override public function clone():Event
		{
			return new CollectionValidatorEvent( type, _validItems );
		}
		
		public function get validItems():Array { return _validItems; }
	}
}