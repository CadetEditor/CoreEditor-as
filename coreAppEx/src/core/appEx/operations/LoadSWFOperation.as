// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.operations
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import core.app.core.operations.IAsynchronousOperation;
	import core.app.events.OperationProgressEvent;

	[Event(type="core.app.events.OperationProgressEvent", name="progress")]
	[Event(type="flash.events.Event", name="complete")]
	[Event(type="flash.events.ErrorEvent", name="error")]

	public class LoadSWFOperation extends EventDispatcher implements IAsynchronousOperation
	{
		private var url					:String;
		private var applicationDomain	:ApplicationDomain;
		private var result				:Loader;
		
		public function LoadSWFOperation( url:String, applicationDomain:ApplicationDomain = null )
		{
			this.url = url;
			this.applicationDomain = applicationDomain;
		}
		
		public function getResult():Loader { return result; }
		
		public function execute():void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
			loader.load( new URLRequest( url ), new LoaderContext( false, applicationDomain ) );
		}
		
		private function progressHandler( event:ProgressEvent ):void
		{
			trace("LoadSWFOperation.progressHandler() :" + label + ", " + event.bytesLoaded + ", " + event.bytesTotal);
			dispatchEvent( new OperationProgressEvent( OperationProgressEvent.PROGRESS, event.bytesLoaded/event.bytesTotal ) );
		}
		
		private function errorHandler( event:ErrorEvent ):void
		{
			dispatchEvent( event.clone() );
		}
		
		private function loadCompleteHandler( event:Event ):void
		{
			var loaderInfo:LoaderInfo = LoaderInfo(event.target);
			result = loaderInfo.loader;
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		public function get label():String
		{
			return "Load SWF '" + url + "'";
		}
	}
}