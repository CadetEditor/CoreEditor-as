// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.managers.fileSystemProviders.azureAIR
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import core.app.core.managers.fileSystemProviders.operations.IGetDirectoryContentsOperation;
	import core.app.entities.URI;
	import core.app.events.FileSystemErrorCodes;
	import core.app.events.OperationProgressEvent;
	import core.app.operations.CompoundOperation;

	internal class DeleteDirectoryOperation extends AzureFileSystemProviderOperation
	{
		private var loader		:URLLoader;
		
		public function DeleteDirectoryOperation(uri:URI, endPoint:String, sas:String, fileSystemProvider:AzureFileSystemProviderAIR )
		{
			super(uri, endPoint, sas, fileSystemProvider);
			if ( _uri.isDirectory() == false )
			{
				throw( new Error( "URI is not a directory.", FileSystemErrorCodes.DELETE_FILE_ERROR ) );
			}
		}
		
		override public function execute():void
		{
			var getDirectoryContentsOperation:IGetDirectoryContentsOperation = _fileSystemProvider.getDirectoryContents(_uri);
			getDirectoryContentsOperation.addEventListener(Event.COMPLETE, getDirectoryContentsCompleteHandler);
			getDirectoryContentsOperation.addEventListener(ErrorEvent.ERROR, errorHandler);
			getDirectoryContentsOperation.execute();
		}
		
		private function errorHandler( event:IOErrorEvent ):void
		{
			dispatchEvent( new ErrorEvent( ErrorEvent.ERROR, false, false, event.text, FileSystemErrorCodes.DELETE_FILE_ERROR ) );
		}
		
		private function getDirectoryContentsCompleteHandler( event:Event ):void
		{
			var getDirectoryContentsOperation:IGetDirectoryContentsOperation = IGetDirectoryContentsOperation( event.target );
			
			var deleteFilesOperation:CompoundOperation = new CompoundOperation();
			for ( var i:int = 0; i < getDirectoryContentsOperation.contents.length; i++ )
			{
				var fileToDelete:URI = getDirectoryContentsOperation.contents[i];
				deleteFilesOperation.addOperation( new DeleteFileOperation( fileToDelete, endPoint, sas, _fileSystemProvider ) );
			}
			
			deleteFilesOperation.addEventListener(ErrorEvent.ERROR, errorHandler);
			deleteFilesOperation.addEventListener(OperationProgressEvent.PROGRESS, progressHandler);
			deleteFilesOperation.addEventListener(Event.COMPLETE, deleteFilesCompleteHandler);
			deleteFilesOperation.execute();
		}
		
		private function progressHandler( event:OperationProgressEvent ):void
		{
			dispatchEvent( event.clone() );
		}
		
		private function deleteFilesCompleteHandler( event:Event ):void
		{
			// Now, after its children have been delete, lets delete the directory itself
			var request:URLRequest = new URLRequest();
			request.url = endPoint + _uri.path + "$$$.$$$" + "?" + sas;
			request.method = URLRequestMethod.DELETE;
			
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, deleteDirectoryCompleteHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler );
			loader.load( request );
		}
		
		private function deleteDirectoryCompleteHandler( event:Event ):void
		{
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		override public function get label():String
		{
			return "Delete Directory : " + _uri.path;
		}
	}
}