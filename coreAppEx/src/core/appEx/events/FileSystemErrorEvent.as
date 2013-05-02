// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.events
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	import core.app.entities.URI;
	import core.app.events.FileSystemErrorCodes;

	public class FileSystemErrorEvent extends ErrorEvent
	{
		// Event Types
		public static const ERROR							:String = "error";
		
		
		
		private var _uri			:URI;
		private var _errorCode		:int;
		
		public function FileSystemErrorEvent(type:String, uri:URI, errorCode:int=0)
		{
			super(type, false, false, getErrorText(errorCode, uri));
			_uri = uri;
			_errorCode = errorCode;
		}
		
		override public function clone():Event
		{
			return new FileSystemErrorEvent( FileSystemErrorEvent.ERROR, _uri, _errorCode );
		}
		
		public function get uri():URI { return _uri; }
		public function get errorCode():int { return _errorCode; }
		
		private static function getErrorText( errorCode:int, uri:URI ):String
		{
			switch( errorCode )
			{
				case FileSystemErrorCodes.CREATE_DIRECTORY_ERROR : return "Create directory error : " + uri.path;
				case FileSystemErrorCodes.DELETE_FILE_ERROR : return "Delete file error : " + uri.path;
				case FileSystemErrorCodes.DIRECTORY_ALREADY_EXISTS : return "Directory already exists : " + uri.path;
				case FileSystemErrorCodes.DIRECTORY_DOES_NOT_EXIST : return "Directory does not exist : " + uri.path;
				case FileSystemErrorCodes.DOES_FILE_EXIST_ERROR : return "Does file exist error : " + uri.path;
				case FileSystemErrorCodes.FILE_DOES_NOT_EXIST : return "File does not exist : " + uri.path;
				case FileSystemErrorCodes.GENERIC_ERROR : return "Generic error : " + uri.path;
				case FileSystemErrorCodes.GET_DIRECTORY_CONTENTS_ERROR : return "Get directory contents error : " + uri.path;
				case FileSystemErrorCodes.NOT_A_DIRECTORY : return "Not a directory : " + uri.path;
				case FileSystemErrorCodes.READ_FILE_ERROR : return "Read file error : " + uri.path;
				case FileSystemErrorCodes.WRITE_FILE_ERROR : return "Write file error : " + uri.path;
			}
			
			return null;
		}
		
	}
}