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
	
	import core.app.core.managers.fileSystemProviders.operations.IDeleteFileOperation;
	import core.app.entities.URI;
	import core.app.events.OperationProgressEvent;

	internal class DeleteFileOperation extends AzureFileSystemProviderOperation implements IDeleteFileOperation
	{
		private var loader		:URLLoader;
		
		public function DeleteFileOperation( uri:URI, endPoint:String, sas:String, fileSystemProvider:AzureFileSystemProviderAIR )
		{
			super(uri, endPoint, sas, fileSystemProvider);
		}
		
		override public function execute():void
		{
			if ( _uri.isDirectory() )
			{
				var deleteDirectoryOperation:DeleteDirectoryOperation = new DeleteDirectoryOperation(_uri, endPoint, sas, _fileSystemProvider);
				deleteDirectoryOperation.addEventListener(ErrorEvent.ERROR, errorHandler);
				deleteDirectoryOperation.addEventListener(OperationProgressEvent.PROGRESS, progressHandler),
				deleteDirectoryOperation.addEventListener(Event.COMPLETE, deleteCompleteHandler);
				deleteDirectoryOperation.execute();
			}
			else
			{
				var request:URLRequest = new URLRequest();
				request.url = endPoint + _uri.path + "?" + sas;
				request.method = URLRequestMethod.DELETE;
				
				loader = new URLLoader();
				loader.addEventListener(Event.COMPLETE, deleteCompleteHandler);
				loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler );
				loader.load( request );
				
			}
		}
		
		private function deleteCompleteHandler( event:Event ):void
		{
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		
		private function errorHandler( event:ErrorEvent ):void
		{
			dispatchEvent( event );
		}
		
		private function progressHandler( event:OperationProgressEvent ):void
		{
			dispatchEvent( event );
		}
		
		override public function get label():String
		{
			return "Delete file : " + _uri.path;
		}
	}
}