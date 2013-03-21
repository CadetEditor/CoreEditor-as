// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.app.managers.fileSystemProviders.azureBrowser
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.net.URLLoader;
	
	import core.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import core.app.core.managers.fileSystemProviders.operations.IDoesFileExistOperation;
	import core.app.core.managers.fileSystemProviders.operations.IGetDirectoryContentsOperation;
	import core.app.entities.URI;
	import core.app.events.FileSystemErrorCodes;
	import core.app.events.FileSystemErrorEvent;

	internal class DoesFileExistOperation extends AzureFileSystemProviderOperation implements IDoesFileExistOperation
	{
		private var _fileExists	:Boolean;
		
		public function DoesFileExistOperation( uri:URI, endPoint:String, sas:String, fileSystemProvider:IFileSystemProvider )
		{
			super(uri, endPoint, sas, fileSystemProvider);
		}
		
		override public function execute():void
		{
			var folder:URI = _uri.getParentURI();
			
			var getDirectoryContentsOperation:IGetDirectoryContentsOperation = _fileSystemProvider.getDirectoryContents(folder);
			getDirectoryContentsOperation.addEventListener(Event.COMPLETE, doesFileExistCompleteHandler);
			getDirectoryContentsOperation.addEventListener(ErrorEvent.ERROR, doesFileExistErrorHandler);
			getDirectoryContentsOperation.execute();
		}
		
		private function doesFileExistErrorHandler( event:ErrorEvent ):void
		{
			dispatchEvent( new FileSystemErrorEvent( FileSystemErrorEvent.ERROR, _uri, FileSystemErrorCodes.DOES_FILE_EXIST_ERROR ) );
		}
		
		private function doesFileExistCompleteHandler( event:Event ):void
		{
			var contents:Vector.<URI> = IGetDirectoryContentsOperation(event.target).contents;
			
			_fileExists = false;
			for each ( var childURI:URI in contents )
			{
				if ( childURI.path == _uri.path )
				{
					_fileExists = true;
					break;
				}
			}
			
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		public function get fileExists():Boolean { return _fileExists; }
		
		override public function get label():String
		{
			return "Does File Exist : " + _uri.path;
		}
	}
}