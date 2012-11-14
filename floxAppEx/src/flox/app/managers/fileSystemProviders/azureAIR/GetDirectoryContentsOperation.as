// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.app.managers.fileSystemProviders.azureAIR
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import flox.app.core.managers.fileSystemProviders.operations.IGetDirectoryContentsOperation;
	import flox.app.entities.URI;
	import flox.app.events.FileSystemErrorCodes;

	internal class GetDirectoryContentsOperation extends AzureFileSystemProviderOperation implements IGetDirectoryContentsOperation
	{
		private var loader		:URLLoader;
		private var _contents	:Vector.<URI>;
		
		public function GetDirectoryContentsOperation( uri:URI, endPoint:String, sas:String, fileSystemProvider:AzureFileSystemProviderAIR )
		{
			super(uri, endPoint, sas, fileSystemProvider);
			
			if ( _uri.isDirectory() == false && _uri.path != "" )
			{
				throw( new Error( "URI is not a directory", FileSystemErrorCodes.GET_DIRECTORY_CONTENTS_ERROR ) );
				return;
			}
		}
		
		override public function execute():void
		{
			var folderName:String = uri.getFoldername();
			
			var request:URLRequest = new URLRequest();
			var variables:URLVariables = new URLVariables();
			variables.restype = "container";
			variables.comp = "list";
			variables.prefix = _uri.path;
			variables.delimiter = "/";
			request.url = endPoint + "?" + variables.toString() + "&" + sas;
			request.method = URLRequestMethod.GET;
			
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, getDirectoryContentsCompleteHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, getDirectoryContentsErrorHandler );
			loader.load( request );
		}
		
		private function getDirectoryContentsErrorHandler( event:IOErrorEvent ):void
		{
			dispatchEvent( new ErrorEvent( ErrorEvent.ERROR, false, false, event.text, FileSystemErrorCodes.GET_DIRECTORY_CONTENTS_ERROR ) );
		}
		
		private function getDirectoryContentsCompleteHandler( event:Event ):void
		{
			var response:XML = XML( loader.data );
			_contents = new Vector.<URI>();
			for ( var i:int = 0; i < response.Blobs.children().length(); i++ )
			{
				var blob:XML = response.Blobs.children()[i];
				var blobName:String = blob.Name.text();
				blobName = blobName.replace("$$$.$$$", "");
				
				blobName = blobName.replace(_uri.path, "");
				if ( blobName == "" ) continue;
				
				var newURI:URI = new URI( _uri.path + blobName )
				contents.push( newURI );
			}
			
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		public function get contents():Vector.<URI> { return _contents; }
		
		override public function get label():String
		{
			return "Get Directory Contents : " + _uri.path;
		}
	}
}