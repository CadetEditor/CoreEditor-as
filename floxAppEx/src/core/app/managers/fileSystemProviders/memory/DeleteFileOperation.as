// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.app.managers.fileSystemProviders.memory
{
	import flash.events.Event;
	
	import core.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import core.app.core.managers.fileSystemProviders.operations.IDeleteFileOperation;
	import core.app.entities.URI;
	import core.app.util.AsynchronousUtil;

	internal class DeleteFileOperation extends MemoryFileSystemProviderOperation implements IDeleteFileOperation
	{
		public function DeleteFileOperation(uri:URI, table:Object, fileSystemProvider:IFileSystemProvider)
		{
			super(uri, table, fileSystemProvider);
		}
		
		override public function execute():void
		{
			table[_uri.path] = null;
			if ( _uri.isDirectory() )
			{
				for ( var path:String in table )
				{
					if ( path.indexOf(_uri.path) != -1 )
					{
						table[_uri.path] = null;
					}
				}
			}
			
			AsynchronousUtil.dispatchLater(this, new Event( Event.COMPLETE ));
		}
	}
}