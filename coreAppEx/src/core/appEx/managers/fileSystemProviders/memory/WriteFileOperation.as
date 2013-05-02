// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.managers.fileSystemProviders.memory
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import core.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import core.app.core.managers.fileSystemProviders.operations.IWriteFileOperation;
	import core.app.entities.URI;
	import core.app.util.AsynchronousUtil;

	internal class WriteFileOperation extends MemoryFileSystemProviderOperation implements IWriteFileOperation
	{
		private var _bytes	:ByteArray;
		
		public function WriteFileOperation(uri:URI, bytes:ByteArray, table:Object, fileSystemProvider:IFileSystemProvider)
		{
			super(uri, table, fileSystemProvider);
			_bytes = bytes;
		}
		
		override public function execute():void
		{
			table[_uri.path] = bytes;
			
			AsynchronousUtil.dispatchLater(this, new Event( Event.COMPLETE ));
		}
		
		public function get bytes():ByteArray { return _bytes; }
	}
}