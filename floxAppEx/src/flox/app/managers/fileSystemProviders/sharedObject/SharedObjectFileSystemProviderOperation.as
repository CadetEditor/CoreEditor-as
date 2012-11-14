// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.app.managers.fileSystemProviders.sharedObject
{
	import flash.events.EventDispatcher;
	import flash.net.SharedObject;
	
	import flox.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import flox.app.core.managers.fileSystemProviders.operations.IFileSystemProviderOperation;
	import flox.app.entities.URI;

	internal class SharedObjectFileSystemProviderOperation extends EventDispatcher implements IFileSystemProviderOperation
	{
		protected var sharedObject			:SharedObject;
		protected var _fileSystemProvider	:IFileSystemProvider
		protected var _uri					:URI;
		
		public function SharedObjectFileSystemProviderOperation( uri:URI, sharedObject:SharedObject, fileSystemProvider:IFileSystemProvider )
		{
			_uri = uri;
			this.sharedObject = sharedObject;
			_fileSystemProvider = fileSystemProvider;
		}
		
		virtual public function execute():void {}
		virtual public function get label():String { return null; }
		
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