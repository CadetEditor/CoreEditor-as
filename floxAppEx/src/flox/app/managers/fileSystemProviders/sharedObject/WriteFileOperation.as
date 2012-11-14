// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.app.managers.fileSystemProviders.sharedObject
{
	import flash.events.Event;
	import flash.net.SharedObject;
	import flash.utils.ByteArray;
	
	import flox.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import flox.app.core.managers.fileSystemProviders.operations.IWriteFileOperation;
	import flox.app.entities.URI;
	import flox.app.util.AsynchronousUtil;

	internal class WriteFileOperation extends SharedObjectFileSystemProviderOperation implements IWriteFileOperation
	{
		private var _bytes	:ByteArray;
		
		public function WriteFileOperation(uri:URI, bytes:ByteArray, sharedObject:SharedObject, fileSystemProvider:IFileSystemProvider)
		{
			super(uri, sharedObject, fileSystemProvider);
			_bytes = bytes;
		}
		
		override public function execute():void
		{
			sharedObject.data[_uri.path] = bytes;
			sharedObject.flush();
			
			AsynchronousUtil.dispatchLater(this, new Event( Event.COMPLETE ));
		}
		
		public function get bytes():ByteArray { return _bytes; }
	}
}