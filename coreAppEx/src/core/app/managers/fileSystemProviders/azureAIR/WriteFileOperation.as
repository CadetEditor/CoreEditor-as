// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.app.managers.fileSystemProviders.azureAIR
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
	import core.app.core.managers.fileSystemProviders.operations.IWriteFileOperation;
	import core.app.entities.URI;
	import core.app.events.FileSystemErrorCodes;

	internal class WriteFileOperation extends AzureFileSystemProviderOperation implements IWriteFileOperation
	{
		private var loader	:URLLoader;
		private var _bytes	:ByteArray;
		
		public function WriteFileOperation( uri:URI, bytes:ByteArray, endPoint:String, sas:String, fileSystemProvider:AzureFileSystemProviderAIR )
		{
			super(uri, endPoint, sas, fileSystemProvider);
			
			if ( _uri.isDirectory() )
			{
				throw( new Error( "", FileSystemErrorCodes.WRITE_FILE_ERROR ) );
				return;
			}
			
			_bytes = bytes;
		}
		
		override public function execute():void
		{
			var request:URLRequest = new URLRequest();
			request.url = endPoint + _uri.path + "?" + sas;
			request.method = URLRequestMethod.PUT;
			request.requestHeaders = [ new URLRequestHeader("Content-Length", String(_bytes.length)) ];
			request.data = _bytes;
			
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, writeFileCompleteHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, writeFileErrorHandler );
			loader.load( request );
		}
		
		private function writeFileErrorHandler( event:IOErrorEvent ):void
		{
			dispatchEvent( new ErrorEvent( ErrorEvent.ERROR, false, false, "", FileSystemErrorCodes.WRITE_FILE_ERROR ) );
		}
		
		private function writeFileCompleteHandler( event:Event ):void
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