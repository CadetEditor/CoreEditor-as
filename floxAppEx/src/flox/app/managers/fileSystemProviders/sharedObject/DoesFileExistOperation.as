// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.app.managers.fileSystemProviders.sharedObject
{
	import flash.events.Event;
	import flash.net.SharedObject;
	
	import flox.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import flox.app.core.managers.fileSystemProviders.operations.IDoesFileExistOperation;
	import flox.app.entities.URI;
	import flox.app.util.AsynchronousUtil;

	internal class DoesFileExistOperation extends SharedObjectFileSystemProviderOperation implements IDoesFileExistOperation
	{
		private var _fileExists	:Boolean;
		
		public function DoesFileExistOperation(uri:URI, sharedObject:SharedObject, fileSystemProvider:IFileSystemProvider)
		{
			super(uri, sharedObject, fileSystemProvider);
		}
		
		override public function execute():void
		{
			_fileExists = sharedObject.data[_uri.path] != null;
			AsynchronousUtil.dispatchLater(this, new Event( Event.COMPLETE ));
		}
		
		public function get fileExists():Boolean { return _fileExists; }
	}
}