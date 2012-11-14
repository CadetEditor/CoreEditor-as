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
	import flox.app.core.managers.fileSystemProviders.operations.IGetDirectoryContentsOperation;
	import flox.app.entities.URI;
	import flox.app.events.FileSystemErrorCodes;
	import flox.app.events.OperationProgressEvent;
	import flox.app.operations.CompoundOperation;

	internal class DeleteDirectoryOperation extends AzureFileSystemProviderOperation
	{
		private var hostUri	:String;
		
		public function DeleteDirectoryOperation(uri:flox.app.entities.URI, endPoint:String, sas:String, hostUri:String, fileSystemProvider:IFileSystemProvider )
		{
			super(uri, endPoint, sas, fileSystemProvider);
			
			this.hostUri = hostUri;
			
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
			dispatchEvent( new FileSystemErrorEvent( FileSystemErrorEvent.ERROR, _uri, FileSystemErrorCodes.DELETE_FILE_ERROR ) );
		}
		
		private function getDirectoryContentsCompleteHandler( event:Event ):void
		{
			var getDirectoryContentsOperation:IGetDirectoryContentsOperation = IGetDirectoryContentsOperation( event.target );
			
			var deleteFilesOperation:CompoundOperation = new CompoundOperation();
			for ( var i:int = 0; i < getDirectoryContentsOperation.contents.length; i++ )
			{
				var fileToDelete:flox.app.entities.URI = getDirectoryContentsOperation.contents[i];
				deleteFilesOperation.addOperation( new DeleteFileOperation( fileToDelete, endPoint, sas, hostUri, _fileSystemProvider ) );
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
			var request:URLRequest = new URLRequest(hostUri + "/Delete.ashx" );
			var vars:URLVariables = new URLVariables();
			vars.path = _uri.path + "$$$.$$$";
			request.data = vars;
			request.method = URLRequestMethod.POST;
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, completeHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.load(request);
		}
				
		private function completeHandler( event:Event ):void
		{
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		override public function get label():String
		{
			return "Delete Directory : " + _uri.path;
		}
	}
}