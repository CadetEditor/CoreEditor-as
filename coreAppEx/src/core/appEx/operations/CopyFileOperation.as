// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.operations
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	import core.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import core.app.core.managers.fileSystemProviders.operations.IReadFileOperation;
	import core.app.core.managers.fileSystemProviders.operations.IWriteFileOperation;
	import core.app.core.operations.IAsynchronousOperation;
	import core.app.entities.URI;
	import core.app.events.OperationProgressEvent;


	/**
	 * This Operation reads bytes from the source URI and writes them back out to the destination URI.
	 * @author Jonathan
	 * 
	 */	
	public class CopyFileOperation extends EventDispatcher implements IAsynchronousOperation
	{
		protected var source				:URI;
		protected var destination			:URI;	
		protected var fileSystemProvider	:IFileSystemProvider;
	
		public function CopyFileOperation( source:URI, destination:URI, fileSystemProvider:IFileSystemProvider )
		{
			this.source = source;
			this.destination = destination;
			this.fileSystemProvider = fileSystemProvider;
		}
		
		public function execute():void
		{
			var operation:IReadFileOperation = fileSystemProvider.readFile(source);
			operation.addEventListener(ErrorEvent.ERROR, errorHandler);
			operation.addEventListener(OperationProgressEvent.PROGRESS, progressHandler);
			operation.addEventListener(Event.COMPLETE, readCompleteHandler);
			operation.execute();
		}
		
		protected function errorHandler( event:ErrorEvent ):void
		{
			dispatchEvent( event );
		}
		
		private function progressHandler( event:OperationProgressEvent ):void
		{
			var progress:Number = event.progress;
			progress *= 0.5;
			
			if ( event.target is IWriteFileOperation )
			{
				progress += 0.5;
			}
			
			dispatchEvent( new OperationProgressEvent( OperationProgressEvent.PROGRESS, progress ) );
		}
		
		private function readCompleteHandler( event:Event ):void
		{
			var readFileOperation:IReadFileOperation = IReadFileOperation(event.target);
			var bytes:ByteArray = readFileOperation.bytes;
			var operation:IWriteFileOperation = fileSystemProvider.writeFile(destination, bytes);
			operation.addEventListener(ErrorEvent.ERROR, errorHandler);
			operation.addEventListener(OperationProgressEvent.PROGRESS, progressHandler);
			operation.addEventListener(Event.COMPLETE, writeCompleteHandler);
			operation.execute();
		}
		
		protected function writeCompleteHandler( event:Event ):void
		{
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		public function get label():String { return "Copy file : " + source.path + " to : " + destination.path; }
	}
}