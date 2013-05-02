// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.managers.fileSystemProviders.azureAIR
{
	import flash.events.EventDispatcher;
	
	import core.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import core.app.core.managers.fileSystemProviders.operations.IFileSystemProviderOperation;
	import core.app.entities.URI;

	internal class AzureFileSystemProviderOperation extends EventDispatcher implements IFileSystemProviderOperation
	{
		protected var sas					:String;
		protected var endPoint				:String;
		protected var _fileSystemProvider	:AzureFileSystemProviderAIR;
		protected var _uri					:URI;
		
		public function AzureFileSystemProviderOperation( uri:URI, endPoint:String, sas:String, fileSystemProvider:AzureFileSystemProviderAIR )
		{
			this.sas = sas;
			this.endPoint = endPoint;
			_fileSystemProvider = fileSystemProvider;
			_uri = uri;
		}
		
		virtual public function execute():void {}
		virtual public function get label():String { return null; }
		
		public function get uri():URI
		{
			return _uri;
		}
		
		public function get fileSystemProvider():IFileSystemProvider
		{
			return _fileSystemProvider;
		}
	}
}