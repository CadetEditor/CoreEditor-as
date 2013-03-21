// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.app.managers.fileSystemProviders.memory
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import core.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import core.app.core.managers.fileSystemProviders.operations.IReadFileOperation;
	import core.app.entities.URI;
	import core.app.events.FileSystemErrorCodes;
	import core.app.events.FileSystemErrorEvent;
	import core.app.util.AsynchronousUtil;

	internal class ReadFileOperation extends MemoryFileSystemProviderOperation implements IReadFileOperation
	{
		private var _bytes		:ByteArray;
		
		public function ReadFileOperation(uri:URI, table:Object, fileSystemProvider:IFileSystemProvider)
		{
			super(uri, table, fileSystemProvider);
		}
		
		override public function execute():void
		{
			_bytes =  table[_uri.path];
			
			if ( bytes == null )
			{
				//AsynchronousUtil.dispatchLater(this, new FileSystemErrorEvent( FileSystemErrorEvent.ERROR, _uri, FileSystemErrorCodes.READ_FILE_ERROR));
				AsynchronousUtil.dispatchLater(this, new ErrorEvent( ErrorEvent.ERROR, false, false, "Read File Error"));
				return;
			}
			
			_bytes.position = 0;
			
			AsynchronousUtil.dispatchLater(this, new Event( Event.COMPLETE ));
		}
		
		override public function get label():String
		{
			return "Read File : " + _uri.path;
		}
		
		public function get bytes():ByteArray { return _bytes; }
	}
}