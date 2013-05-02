// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.managers.fileSystemProviders.sharedObject
{
	import flash.events.Event;
	import flash.net.SharedObject;
	
	import core.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import core.app.core.managers.fileSystemProviders.operations.ICreateDirectoryOperation;
	import core.app.entities.URI;
	import core.app.util.AsynchronousUtil;

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