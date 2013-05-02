// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.managers.fileSystemProviders.azureAIR
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	
	import core.app.core.managers.fileSystemProviders.operations.ICreateDirectoryOperation;
	import core.app.entities.URI;
	import core.app.events.FileSystemErrorCodes;

	internal class CreateDirectoryOperation extends AzureFileSystemProviderOperation implements ICreateDirectoryOperation
	{
		private var loader	:URLLoader;
		
		public function CreateDirectoryOperation( uri:URI, endPoint:String, sas:String, fileSystemProvider:AzureFileSystemProviderAIR )
		{
			super(uri, endPoint, sas, fileSystemProvider);
			
			if ( _uri.isDirectory() == false )
			{
				throw( new Error( "", FileSystemErrorCodes.CREATE_DIRECTORY_ERROR ) );
				return;
			}
		}
		
		override public function execute():void
		{
			var request:URLRequest = new URLRequest();
			request.url = endPoint + uri.path + "$$$.$$$" + "?" + sas;
			request.method = URLRequestMethod.PUT;
			request.requestHeaders = [ new URLRequestHeader("Content-Length", "0") ];
			
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, createDirectoryCompleteHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, createDirectoryErrorHandler );
			loader.load( request );
		}
		
		private function createDirectoryErrorHandler( event:IOErrorEvent ):void
		{
			dispatchEvent( new ErrorEvent( ErrorEvent.ERROR, false, false, event.text, FileSystemErrorCodes.CREATE_DIRECTORY_ERROR ) );
		}
		
		private function createDirectoryCompleteHandler( event:Event ):void
		{
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		override public function get label():String
		{
			return "Create Directory : " + _uri.path;
		}
	}
}