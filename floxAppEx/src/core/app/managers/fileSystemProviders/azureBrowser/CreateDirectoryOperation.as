// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.app.managers.fileSystemProviders.azureBrowser
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
	
	import core.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import core.app.core.managers.fileSystemProviders.operations.ICreateDirectoryOperation;
	import core.app.entities.URI;
	import core.app.events.FileSystemErrorCodes;

	internal class CreateDirectoryOperation extends AzureFileSystemProviderOperation implements ICreateDirectoryOperation
	{
		private var hostUri	:String;
		
		public function CreateDirectoryOperation( uri:URI, endPoint:String, sas:String, hostUri:String, fileSystemProvider:IFileSystemProvider )
		{
			super(uri, endPoint, sas, fileSystemProvider);
			
			this.hostUri = hostUri;
			
			if ( _uri.isDirectory() == false )
			{
				throw( new Error( "", FileSystemErrorCodes.CREATE_DIRECTORY_ERROR ) );
				return;
			}
		}
		
		override public function execute():void
		{
			var request:URLRequest = new URLRequest(hostUri + "/Upload.ashx?path=" + _uri.path + "$$$.$$$" );
			request.requestHeaders.push( new URLRequestHeader("Content-type", "application/octet-stream") );
			request.data = new ByteArray();
			request.method = URLRequestMethod.POST;
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, completeHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.load(request);
		}
		
		private function errorHandler( event:ErrorEvent ):void
		{
			dispatchEvent( event );
		}
		
		private function completeHandler( event:Event ):void
		{
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		override public function get label():String
		{
			return "Create Directory : " + _uri.path;
		}
	}
}