// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.app.managers.fileSystemProviders.memory
{
	import flash.events.Event;
	
	import core.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import core.app.core.managers.fileSystemProviders.operations.ICreateDirectoryOperation;
	import core.app.entities.URI;
	import core.app.util.AsynchronousUtil;

	internal class CreateDirectoryOperation extends MemoryFileSystemProviderOperation implements ICreateDirectoryOperation
	{
		public function CreateDirectoryOperation(uri:URI, table:Object, fileSystemProvider:IFileSystemProvider)
		{
			super(uri, table, fileSystemProvider);
		}
		
		override public function execute():void
		{
			table[_uri.path] = {};
			AsynchronousUtil.dispatchLater(this, new Event(Event.COMPLETE));
		}
	}
}