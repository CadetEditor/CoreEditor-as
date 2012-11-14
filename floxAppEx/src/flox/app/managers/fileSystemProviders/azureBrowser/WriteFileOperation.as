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
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	import flox.app.events.FileSystemErrorEvent;
	
	import flox.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import flox.app.core.managers.fileSystemProviders.operations.IWriteFileOperation;
	import flox.app.entities.URI;
	import flox.app.events.FileSystemErrorCodes;

	internal class WriteFileOperation extends AzureFileSystemProviderOperation implements IWriteFileOperation
	{
		private static var uid		:int = 0;
		
		private var _bytes	:ByteArray;
		private var hostUri	:String;
		
		public function WriteFileOperation( uri:flox.app.entities.URI, bytes:ByteArray, endPoint:String, sas:String, hostUri:String, fileSystemProvider:IFileSystemProvider )
		{
			super(uri, endPoint, sas, fileSystemProvider);
			
			this.hostUri = hostUri;
			
			if ( _uri.isDirectory() )
			{
				throw( new Error( "", FileSystemErrorCodes.WRITE_FILE_ERROR ) );
				return;
			}
			
			_bytes = bytes;
		}
		
		override public function execute():void
		{
			_bytes.position = 0;
			
			var request:URLRequest = new URLRequest(hostUri + "/Upload.ashx?path=" + _uri.path );
			request.requestHeaders.push( new URLRequestHeader("Content-type", "application/octet-stream") );
			request.data = _bytes;
			request.method = URLRequestMethod.POST;
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, completeHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.load(request);
		}
		
		private function errorHandler( event:ErrorEvent ):void
		{
			dispatchEvent( new FileSystemErrorEvent( FileSystemErrorEvent.ERROR, _uri, FileSystemErrorCodes.WRITE_FILE_ERROR ) );
		}
		
		private function completeHandler( event:Event ):void
		{
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		public function get bytes():ByteArray { return _bytes; }
		
		override public function get label():String
		{
			return "Write File : " + _uri.path;
		}
	}
}