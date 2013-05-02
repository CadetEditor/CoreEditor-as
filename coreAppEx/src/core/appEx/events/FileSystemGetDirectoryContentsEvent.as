// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.events
{
	import flash.events.Event;
	
	import core.app.entities.URI;
	
	public class FileSystemGetDirectoryContentsEvent extends Event
	{
		public static const GET_DIRECTORY_CONTENTS_COMPLETE	:String = "getDirectoryContentsComplete";
		
		private var _uri		:URI;
		private var _contents	:Array;
		
		public function FileSystemGetDirectoryContentsEvent(type:String, uri:URI, contents:Array)
		{
			super(type);
			_uri = new URI();
			_uri.copyURI(uri);
			_contents = contents;
		}
		
		override public function clone():Event
		{
			return new FileSystemGetDirectoryContentsEvent( type, _uri, _contents );
		}
		
		public function get uri():URI { return _uri; }
		public function get contents():Array { return _contents.slice(); }
	}
}