// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.events
{
	import flash.events.Event;
	
	import core.app.core.operations.IOperation;

	public class OperationManagerEvent extends Event
	{
		static public const CHANGE					:String = "change";
		static public const OPERATION_ADDED			:String = "operationAdded";
		static public const ALL_OPERATIONS_COMPLETE	:String = "allOperationsComplete";
		static public const OPERATION_BEGIN			:String = "operationBegin";
		static public const OPERATION_COMPLETE		:String = "operationComplete";
		static public const OPERATION_PROGRESS		:String = "operationProgress";
		
		protected var _operation	:IOperation;
		protected var _progress		:Number;
		
		public function OperationManagerEvent( type:String, operation:IOperation = null, progress:Number = 0 )
		{
			super(type);
			_operation = operation;
			_progress = progress;
		}
		
		override public function clone():Event
		{
			return new OperationManagerEvent( type, _operation, _progress );
		}
		
		public function get operation():IOperation { return _operation; }
		public function get progress():Number { return _progress; }
	}
}