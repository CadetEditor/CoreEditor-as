// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.app.managers.fileSystemProviders.memory
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import flox.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import flox.app.core.managers.fileSystemProviders.operations.IReadFileOperation;
	import flox.app.entities.URI;
	import flox.app.events.FileSystemErrorCodes;
	import flox.app.events.FileSystemErrorEvent;
	import flox.app.util.AsynchronousUtil;

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