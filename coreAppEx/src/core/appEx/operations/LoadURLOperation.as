// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.operations
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import core.app.core.operations.IAsynchronousOperation;
	import core.app.events.OperationProgressEvent;

	[Event(type="core.app.events.OperationProgressEvent", name="progress")]
	[Event(type="flash.events.Event", name="complete")]
	[Event(type="flash.events.ErrorEvent", name="error")]

	public class LoadURLOperation extends EventDispatcher implements IAsynchronousOperation
	{
		private var url		:String;
		private var result	:Object;
		
		public function LoadURLOperation( url:String )
		{
			this.url = url
		}
		
		public function getResult():Object { return result; }
		
		public function execute():void
		{
			var loader:URLLoader = new URLLoader(new URLRequest(url));
			loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.addEventListener(Event.COMPLETE, loadCompleteHandler);
		}
		
		private function progressHandler( event:ProgressEvent ):void
		{
			dispatchEvent( new OperationProgressEvent( OperationProgressEvent.PROGRESS, event.bytesTotal/event.bytesTotal ) );
		}
		
		private function errorHandler( event:ErrorEvent ):void
		{
			dispatchEvent( new ErrorEvent( ErrorEvent.ERROR, false, false, event.text ) );
		}
		
		private function loadCompleteHandler( event:Event ):void
		{
			var loader:URLLoader = URLLoader( event.target );
			result = loader.data;
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		public function get label():String
		{
			return "Load URL " + url;
		}
	}
}