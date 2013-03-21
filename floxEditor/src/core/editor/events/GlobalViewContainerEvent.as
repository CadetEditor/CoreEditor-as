// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.events
{
	import flash.events.Event;
	
	import core.editor.core.IViewContainer;

	public class GlobalViewContainerEvent extends Event
	{
		public static const VIEW_ADDED			:String = "viewAdded";
		public static const VIEW_REMOVED		:String = "viewRemoved";
		public static const EDITOR_ADDED		:String = "editorAdded";
		public static const EDITOR_REMOVED		:String = "editorRemoved";
		public static const EDITOR_SHOWN		:String = "editorShown";
		public static const EDITOR_HIDDEN		:String = "editorHidden";
		
		
		private var _view		:IViewContainer;
		
		public function GlobalViewContainerEvent( type:String, view:IViewContainer )
		{
			super(type);
			_view = view;
		}
		
		public function get view():IViewContainer { return _view; }
	}
}