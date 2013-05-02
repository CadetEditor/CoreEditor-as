// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.managers.fileSystemProviders.azureAIR
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
	import core.app.core.managers.fileSystemProviders.operations.IReadFileOperation;
	import core.app.entities.URI;
	import core.app.events.FileSystemErrorCodes;

	internal class ReadFileOperation extends AzureFileSystemProviderOperation implements IReadFileOperation
	{
		private var loader	:URLLoader;
		private var _bytes	:ByteArray;
		
		public function ReadFileOperation( uri:URI, endPoint:String, sas:String, fileSystemProvider:AzureFileSystemProviderAIR )
		{
			super(uri, endPoint, sas, fileSystemProvider);
		}
		
		override public function execute():void
		{
			var request:URLRequest = new URLRequest();
			request.url = endPoint + _uri.path + "?" + sas;
			request.method = URLRequestMethod.GET;
			
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, readFileCompleteHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, readFileErrorHandler );
			loader.load( request );
		}
		
		private function readFileErrorHandler( event:IOErrorEvent ):void
		{
			dispatchEvent( new ErrorEvent( ErrorEvent.ERROR, false, false, "", FileSystemErrorCodes.READ_FILE_ERROR ) );
		}
		
		private function readFileCompleteHandler( event:Event ):void
		{
			_bytes = ByteArray( loader.data );
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		override public function get label():String
		{
			return "Read File : " + _uri.path;
		}
		
		public function get bytes():ByteArray
		{
			return _bytes;
		}
	}
}