// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.events
{
	import flash.events.Event;

	public class CoreEditorEvent extends Event
	{
		public static const EXTENSIONS_LOAD_BEGIN	:String = "extensionsLoadBegin";
		public static const EXTENSIONS_LOAD_COMPLETE:String = "extensionsLoadComplete";
		public static const INIT_COMPLETE			:String = "initComplete";
		public static const CLOSE					:String = "close";
		
		public function CoreEditorEvent(type:String)
		{
			super(type);
		}
	}
}