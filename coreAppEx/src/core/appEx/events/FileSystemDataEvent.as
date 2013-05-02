// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.events
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import core.app.entities.URI;

	public class FileSystemDataEvent extends Event
	{
		public static const READ_COMPLETE				:String = "readComplete"
		public static const WRITE_COMPLETE				:String = "writeComplete"
		
		protected var _bytes			:ByteArray
		protected var _uri				:URI
		
		public function FileSystemDataEvent(type:String, uri:URI = null, bytes:ByteArray = null)
		{
			super(type);
			_bytes = bytes;
			_uri = new URI();
			_uri.copyURI( uri );
		}
		
		override public function clone():Event
		{
			return new FileSystemDataEvent( type, uri, bytes );
		}
		
		public function get bytes():ByteArray { return _bytes }
		public function get uri():URI { return _uri }
	}
}