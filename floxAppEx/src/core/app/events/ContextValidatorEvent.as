// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.app.events
{
	import flash.events.Event;
	
	import core.app.core.contexts.IContext;

	public class ContextValidatorEvent extends Event
	{
		public static const CONTEXT_CHANGED	:String = "contextChanged"
		
		protected var _oldContext			:IContext;
		protected var _newContext			:IContext;
		
		public function ContextValidatorEvent( type:String, oldContext:IContext, newContext:IContext )
		{
			super(type);
			_oldContext = oldContext;
			_newContext = newContext;
		}
		
		public function get oldContext():IContext { return _oldContext; }
		public function get newContext():IContext { return _newContext; }
	}
}