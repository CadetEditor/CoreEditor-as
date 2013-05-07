// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.events
{
	import flash.events.Event;
	
	import core.appEx.core.contexts.IContext;

	public class ContextManagerEvent extends Event
	{
		static public const CURRENT_CONTEXT_CHANGED			:String = "currentContextChanged";
		static public const CONTEXT_ADDED					:String = "contextAdded";
		static public const CONTEXT_REMOVED					:String = "contextRemoved";
		static public const CONTEXT_REMOVED_FROM_HISTORY	:String = "contextRemovedFromHistory";
		
		
		private var _context				:IContext;
		
		public function ContextManagerEvent(type:String, context:IContext)
		{
			super(type);
			_context = context;
		}
		
		public function get context():IContext { return _context; }
		
		
	}
}