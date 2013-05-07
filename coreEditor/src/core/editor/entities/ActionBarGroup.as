// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.entities
{
	import flash.display.DisplayObject;
	
	public class ActionBarGroup
	{
		protected var _id		:String;
		protected var items		:Array;
		
		public function ActionBarGroup(id:String)
		{
			_id = id;
			items = [];
		}
		
		public function destroy():void
		{
			items = null;
		}
		
		public function hasItem(item:DisplayObject):Boolean
		{
			return items.indexOf(item) != -1;
		}
		
		public function getItem(index:int):DisplayObject
		{
			return items[index];
		}
		
		
		public function removeItem(item:DisplayObject):void
		{
			items.splice(items.indexOf(item), 1);
		}
		
		public function addItem(item:DisplayObject, index:int):void
		{
			if (index == -1) {
				index = items.length;
			}
			items.splice(index, 0, item);
		}
		
		public function get numItems():int { return items.length; }
		
		public function get id():String { return _id; }
	}
}