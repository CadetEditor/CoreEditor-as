// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.operations
{
	import core.app.core.operations.IUndoableOperation;

	public class AddToArrayOperation implements IUndoableOperation
	{
		private var item			:Object;
		private var array			:Array;
		private var index			:int;
		private var host			:Object;
		private var propertyName	:String;
		
		public function AddToArrayOperation( item:Object, array:Array, index:int = -1, host:Object = null, propertyName:String = null )
		{
			this.item = item;
			this.array = array;
			this.index = index;
			this.host = host;
			this.propertyName = propertyName;
		}

		public function execute():void
		{
			if ( index == -1 )
			{
				array.push(item);
			}
			else
			{
				array.splice(index,0,item);
			}
			
			if ( host && propertyName )
			{
				host[propertyName] = array;
			}
		}
		
		public function undo():void
		{
			var index:int = array.indexOf(item);
			array.splice(index,1);
			if ( host && propertyName )
			{
				host[propertyName] = array;
			}
		}
		
		public function get label():String
		{
			return "Add item to array";
		}
	}
}