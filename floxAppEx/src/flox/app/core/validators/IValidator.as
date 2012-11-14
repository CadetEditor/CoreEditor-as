// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.app.core.validators
{
	import flash.events.IEventDispatcher;
	
	[Event(type="flox.app.events.ValidatorEvent", name="stateChanged")]
	
	public interface IValidator extends IEventDispatcher
	{
		function dispose():void
		function get state():Boolean
	}
}