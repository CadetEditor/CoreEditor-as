// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.operations
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	import core.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import core.app.core.managers.fileSystemProviders.operations.IDeleteFileOperation;
	import core.app.entities.URI;

	public class MoveFileOperation extends CopyFileOperation
	{
		public function MoveFileOperation(source:URI, destination:URI, fileSystemProvider:IFileSystemProvider)
		{
			super(source, destination, fileSystemProvider);
		}
		
		
		override protected function writeCompleteHandler( event:Event ):void
		{
			var operation:IDeleteFileOperation = fileSystemProvider.deleteFile(source);
			operation.addEventListener( ErrorEvent.ERROR, errorHandler);
			operation.addEventListener(Event.COMPLETE, deleteCompleteHandler);
		}
		
		private function deleteCompleteHandler( event:Event ):void
		{
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		override public function get label():String { return "Move file : " + source.path + "to : " + destination.path; }
	}
}