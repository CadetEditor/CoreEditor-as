// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.app.events
{
	import flash.events.Event;
	
	import core.app.entities.URI;
	
	public class FileSystemEvent extends Event
	{
		public static const DELETE_COMPLETE					:String = "deleteComplete";
		public static const CREATE_DIRECTORY_COMPLETE		:String = "createDirectoryComplete"
		
		private var _uri		:URI;
		
		public function FileSystemEvent(type:String, uri:URI)
		{
			super(type);
			_uri = new URI();
			_uri.copyURI(uri);
		}
		
		override public function clone():Event
		{
			return new FileSystemEvent( type, _uri );
		}
		
		public function get uri():URI { return _uri; }
	}
}