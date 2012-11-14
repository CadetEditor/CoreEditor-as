// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.app.managers.fileSystemProviders.sharedObject
{
	import flash.events.Event;
	import flash.net.SharedObject;
	
	import flox.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import flox.app.core.managers.fileSystemProviders.operations.ICreateDirectoryOperation;
	import flox.app.entities.URI;
	import flox.app.util.AsynchronousUtil;

	internal class CreateDirectoryOperation extends SharedObjectFileSystemProviderOperation implements ICreateDirectoryOperation
	{
		public function CreateDirectoryOperation(uri:URI, sharedObject:SharedObject, fileSystemProvider:IFileSystemProvider)
		{
			super(uri, sharedObject, fileSystemProvider);
		}
		
		override public function execute():void
		{
			sharedObject.data[_uri.path] = {};
			sharedObject.flush();
			AsynchronousUtil.dispatchLater(this, new Event(Event.COMPLETE));
		}
	}
}