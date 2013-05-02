// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.app.managers.fileSystemProviders.memory
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	import core.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import core.app.core.managers.fileSystemProviders.operations.*;
	import core.app.entities.URI;
	import core.app.events.FileSystemProviderEvent;
	import core.app.events.OperationProgressEvent;
	
	[Event( type="core.app.events.FileSystemProviderEvent", name="operationBegin" )]	
	
	public class MemoryFileSystemProvider extends EventDispatcher implements IFileSystemProvider
	{
		private var _id		:String;
		private var _label	:String;
		
		private var table		:Object;
		
		public function MemoryFileSystemProvider( id:String, label:String )
		{
			_id = id;
			_label = label;
			table = {};
		}
		
		private function initOperation( operation:IFileSystemProviderOperation ):void
		{
			operation.addEventListener(ErrorEvent.ERROR, passThroughHandler );
			operation.addEventListener(OperationProgressEvent.PROGRESS, passThroughHandler);
			operation.addEventListener(Event.COMPLETE, passThroughHandler);
			dispatchEvent( new FileSystemProviderEvent( FileSystemProviderEvent.OPERATION_BEGIN, this, operation ) );
		}
		
		private function passThroughHandler( event:Event ):void
		{
			dispatchEvent( event );
		}
		
		public function readFile( uri:URI ):IReadFileOperation
		{
			var operation:ReadFileOperation = new ReadFileOperation( uri, table, this );
			initOperation( operation );
			return operation;
		}
		
		public function writeFile( uri:URI, bytes:ByteArray ):IWriteFileOperation
		{
			var operation:WriteFileOperation = new WriteFileOperation( uri, bytes, table, this );
			initOperation( operation );
			return operation;
		}
		
		public function createDirectory( uri:URI ):ICreateDirectoryOperation
		{
			var operation:CreateDirectoryOperation = new CreateDirectoryOperation( uri, table, this );
			initOperation( operation );
			return operation;
		}
		
		public function getDirectoryContents( uri:URI ):IGetDirectoryContentsOperation
		{
			var operation:GetDirectoryContentsOperation = new GetDirectoryContentsOperation( uri, table, this );
			initOperation( operation );
			return operation;
		}
		public function deleteFile( uri:URI ):IDeleteFileOperation
		{
			var operation:DeleteFileOperation = new DeleteFileOperation( uri, table, this );
			initOperation( operation );
			return operation;
		}
		
		public function doesFileExist( uri:URI ):IDoesFileExistOperation
		{
			var operation:DoesFileExistOperation = new DoesFileExistOperation( uri, table, this );
			initOperation( operation );
			return operation;
		}
		
		public function traverseToDirectory(uri:URI):ITraverseToDirectoryOperation
		{
//			var operation:TraverseToDirectoryOperation = new TraverseToDirectoryOperation( _rootDirectory, uri, this );
//			initOperation( operation );
//			return operation;
			throw( new Error("Operation needs to be implemented") );
			return null;
		}
		
		public function traverseAllDirectories(uri:URI):ITraverseAllDirectoriesOperation
		{
			throw( new Error("Operation needs to be implemented") );
			return null;
		}
		
		public function get id():String { return _id; }
		public function get label():String { return _label; }
	}
}