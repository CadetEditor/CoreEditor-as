// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.app.managers.fileSystemProviders.memory
{
	import flash.events.Event;
	
	import flox.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import flox.app.core.managers.fileSystemProviders.operations.IDoesFileExistOperation;
	import flox.app.entities.URI;
	import flox.app.util.AsynchronousUtil;

	internal class DoesFileExistOperation extends MemoryFileSystemProviderOperation implements IDoesFileExistOperation
	{
		private var _fileExists	:Boolean;
		
		public function DoesFileExistOperation(uri:URI, table:Object, fileSystemProvider:IFileSystemProvider)
		{
			super(uri, table, fileSystemProvider);
		}
		
		override public function execute():void
		{
			_fileExists = table[_uri.path] != null;
			AsynchronousUtil.dispatchLater(this, new Event( Event.COMPLETE ));
		}
		
		public function get fileExists():Boolean { return _fileExists; }
	}
}