// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.contexts
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import core.ui.components.IUIComponent;
	
	import core.app.entities.URI;

	[Event( type="flash.events.Event", name="change" )]

	public class AbstractEditorContext extends EventDispatcher
	{
		protected var _changed					:Boolean = false;
		protected var _isNewFile				:Boolean = false;
		protected var _uri						:URI;
		
		public function AbstractEditorContext()
		{
			
		}
		
		public function set uri( value:URI ):void
		{
			_uri = value;
			changed = true;
			
			var view:IUIComponent = this["view"] as IUIComponent;
			if ( view )
			{
				if ( _uri )
				{
					view.label = _uri.getFilename(true);
				}
				else
				{
					view.label = "";
				}
			}
		}
		public function get uri():URI { return _uri; }
				
		public function set changed( value:Boolean ):void
		{
			if ( _changed == value ) return;
			_changed = value;
			dispatchEvent( new Event( Event.CHANGE ) );
		}
		public function get changed():Boolean { return _changed; }
		
		public function set isNewFile( value:Boolean ):void
		{
			_isNewFile = value;
		}
		public function get isNewFile():Boolean { return _isNewFile; }
	}
}