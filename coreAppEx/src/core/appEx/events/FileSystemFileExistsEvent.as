// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.events
{
	import flash.events.Event;
	
	import core.app.entities.URI;

	public class FileSystemFileExistsEvent extends Event
	{
		public static const FILE_EXISTS					:String = "fileExists";
		
		protected var _uri					:URI;
		protected var _fileExists			:Boolean;
		
		public function FileSystemFileExistsEvent(type:String, uri:URI, fileExists:Boolean)
		{
			super(type);
			_uri = uri;
			_fileExists = fileExists;
		}
		
		override public function clone():Event
		{
			return new FileSystemFileExistsEvent( type, _uri, _fileExists );
		}
		
		public function get uri():URI { return _uri; }
		public function get fileExists():Boolean { return _fileExists; }
	}
}