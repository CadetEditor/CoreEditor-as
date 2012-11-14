// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.app.managers.fileSystemProviders.memory
{
	import flash.events.Event;
	
	import flox.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import flox.app.core.managers.fileSystemProviders.operations.ICreateDirectoryOperation;
	import flox.app.entities.URI;
	import flox.app.util.AsynchronousUtil;

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