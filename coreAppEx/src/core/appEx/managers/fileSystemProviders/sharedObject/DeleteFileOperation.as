// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.managers.fileSystemProviders.sharedObject
{
	import flash.events.Event;
	import flash.net.SharedObject;
	
	import core.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import core.app.core.managers.fileSystemProviders.operations.IDeleteFileOperation;
	import core.app.entities.URI;
	import core.app.util.AsynchronousUtil;

	internal class DeleteFileOperation extends SharedObjectFileSystemProviderOperation implements IDeleteFileOperation
	{
		public function DeleteFileOperation(uri:URI, sharedObject:SharedObject, fileSystemProvider:IFileSystemProvider)
		{
			super(uri, sharedObject, fileSystemProvider);
		}
		
		override public function execute():void
		{
			sharedObject.data[_uri.path] = null;
			if ( _uri.isDirectory() )
			{
				for ( var path:String in sharedObject.data )
				{
					if ( path.indexOf(_uri.path) != -1 )
					{
						sharedObject.data[_uri.path] = null;
					}
				}
			}
			sharedObject.flush();
			
			AsynchronousUtil.dispatchLater(this, new Event( Event.COMPLETE ));
		}
	}
}