// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.app.managers.fileSystemProviders.azureBrowser
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flox.app.events.FileSystemErrorEvent;
	
	import flox.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import flox.app.core.managers.fileSystemProviders.operations.IDeleteFileOperation;
	import flox.app.entities.URI;
	import flox.app.events.FileSystemErrorCodes;
	import flox.app.events.OperationProgressEvent;

	internal class DeleteFileOperation extends AzureFileSystemProviderOperation implements IDeleteFileOperation
	{
		private var hostUri	:String;
		
		public function DeleteFileOperation( uri:flox.app.entities.URI, endPoint:String, sas:String, hostUri:String, fileSystemProvider:IFileSystemProvider )
		{
			super(uri, endPoint, sas, fileSystemProvider);
			this.hostUri = hostUri;
		}
		
		override public function execute():void
		{
			if ( _uri.isDirectory() )
			{
				var deleteDirectoryOperation:DeleteDirectoryOperation = new DeleteDirectoryOperation(_uri, endPoint, sas, hostUri, _fileSystemProvider);
				deleteDirectoryOperation.addEventListener(ErrorEvent.ERROR, errorHandler);
				deleteDirectoryOperation.addEventListener(OperationProgressEvent.PROGRESS, progressHandler),
				deleteDirectoryOperation.addEventListener(Event.COMPLETE, completeHandler);
				deleteDirectoryOperation.execute();
			}
			else
			{
				var request:URLRequest = new URLRequest(hostUri + "/Delete.ashx" );
				request.method = URLRequestMethod.POST;
				var vars:URLVariables = new URLVariables();
				vars.path = _uri.path;
				request.data = vars;
			
				var loader:URLLoader = new URLLoader();
				loader.addEventListener(Event.COMPLETE, completeHandler);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
				loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				loader.load(request);
			}
		}
		
		private function completeHandler( event:Event ):void
		{
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		private function errorHandler( event:ErrorEvent ):void
		{
			dispatchEvent( new FileSystemErrorEvent( FileSystemErrorEvent.ERROR, _uri, FileSystemErrorCodes.DELETE_FILE_ERROR ) );
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