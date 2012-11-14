// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.app.managers.fileSystemProviders.memory
{
	import flash.events.Event;
	
	import flox.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import flox.app.core.managers.fileSystemProviders.operations.IDeleteFileOperation;
	import flox.app.entities.URI;
	import flox.app.util.AsynchronousUtil;

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