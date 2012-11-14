// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.app.managers.fileSystemProviders.memory
{
	import flash.events.EventDispatcher;
	
	import flox.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import flox.app.core.managers.fileSystemProviders.operations.IFileSystemProviderOperation;
	import flox.app.entities.URI;

	internal class MemoryFileSystemProviderOperation extends EventDispatcher implements IFileSystemProviderOperation
	{
		protected var table					:Object;
		protected var _fileSystemProvider	:IFileSystemProvider
		protected var _uri					:URI;
		
		public function MemoryFileSystemProviderOperation( uri:URI, table:Object, fileSystemProvider:IFileSystemProvider )
		{
			_uri = uri;
			this.table = table;
			_fileSystemProvider = fileSystemProvider;
		}
		
		public function execute():void {}
		public function get label():String { return null; }
		
		public function get uri():URI
		{
			return _uri;
		}
		
		public function get fileSystemProvider():IFileSystemProvider
		{
			return _fileSystemProvider;
		}
	}
}