// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.events
{
	import flash.events.Event;
	
	import core.app.entities.URI;
	
	public class FileSystemProgressEvent extends Event
	{
		public static const READ_PROGRESS				:String = "readProgress";
		public static const WRITE_PROGRESS				:String = "writeProgress";
		
		protected var _currentBytes			:Number;
		protected var _totalBytes			:Number;
		protected var _uri					:URI;
		
		public function FileSystemProgressEvent(type:String, uri:URI, currentBytes:Number, totalBytes:Number)
		{
			super(type);
			_uri = new URI();
			_uri.copyURI(uri);
			_currentBytes = currentBytes;
			_totalBytes = totalBytes;
		}
		
		override public function clone():Event
		{
			return new FileSystemProgressEvent( type, _uri, _currentBytes, _totalBytes );
		}
		
		public function get currentBytes():Number { return _currentBytes; }
		public function get totalBytes():Number { return _totalBytes; }
		public function get uri():URI { return _uri; }
	}
}