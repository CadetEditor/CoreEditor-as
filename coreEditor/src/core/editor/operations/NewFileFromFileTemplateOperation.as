// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.operations
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	
	import core.app.CoreApp;
	import core.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import core.app.core.managers.fileSystemProviders.operations.IWriteFileOperation;
	import core.app.core.operations.IAsynchronousOperation;
	import core.app.entities.URI;
	import core.app.events.OperationProgressEvent;
	import core.appEx.managers.ContextManager;
	import core.app.managers.ResourceManager;
	import core.appEx.operations.LoadURLOperation;
	import core.appEx.resources.FileType;
	import core.app.resources.IResource;
	import core.editor.CoreEditor;
	import core.editor.contexts.IEditorContext;
	import core.editor.resources.FileTemplate;
	
	[Event(type="core.app.events.OperationProgressEvent", name="progress")]
	[Event(type="flash.events.Event", name="complete")]
	[Event(type="flash.events.ErrorEvent", name="error")]
	
	public class NewFileFromFileTemplateOperation extends EventDispatcher implements IAsynchronousOperation
	{
		private var fileTemplate		:FileTemplate;
		private var fileType			:FileType;
		private var resourceManager	:ResourceManager;
		private var contextManager		:ContextManager;
		private var fileSystemProvider	:IFileSystemProvider;
		
		
		public function NewFileFromFileTemplateOperation( fileTemplate:FileTemplate, resourceManager:ResourceManager, fileSystemProvider:IFileSystemProvider )
		{
			this.fileTemplate = fileTemplate;
			this.resourceManager = resourceManager;
			this.contextManager = contextManager;
			this.fileSystemProvider = fileSystemProvider;
		}
		
		public function execute():void
		{
			var operation:LoadURLOperation = new LoadURLOperation( CoreEditor.config.resourceURL + fileTemplate.url );
			operation.addEventListener( Event.COMPLETE, loadTemplateCompleteHandler );
			operation.addEventListener(ErrorEvent.ERROR, loadTemplateErrorHandler );
			operation.addEventListener(OperationProgressEvent.PROGRESS, loadTemplateProgressHandler);
			operation.execute();
		}
		
		private function loadTemplateProgressHandler( event:OperationProgressEvent ):void
		{
			dispatchEvent( new OperationProgressEvent( OperationProgressEvent.PROGRESS, event.progress * 0.5 ) );
		}
		
		private function loadTemplateErrorHandler( event:ErrorEvent ):void
		{
			dispatchEvent( event );
		}
		
		private function loadTemplateCompleteHandler( event:Event ):void
		{
			var operation:LoadURLOperation = LoadURLOperation( event.target );
			
			
			// Once we've loaded the file template, we temporarily write the bytes to memory.
			var result:Object = operation.getResult();
			var bytes:ByteArray;
			
			if ( result is ByteArray )
			{
				bytes = ByteArray(result);
			}
			else if ( result is String )
			{
				bytes = new ByteArray();
				bytes.writeUTFBytes( String(result) );
			}
			else
			{
				dispatchEvent( new ErrorEvent( ErrorEvent.ERROR, false, false, "Unable to convert loaded file template to ByteArray" ) );
				return;
			}
			
			// Find the FileType for this template based on extension.
			var uri:URI = new URI( fileTemplate.url );
			var extension:String = uri.getExtension(true);
			var fileTypes:Vector.<IResource> = resourceManager.getResourcesOfType(FileType);
			for each ( var currentFileType:FileType in fileTypes )
			{
				if ( currentFileType.extension == extension )
				{
					fileType = currentFileType;
					break;
				}
			}
			
			var memoryURI:URI = new URI("memory/fileTemplate." + fileType.extension);
			var writeFileOperation:IWriteFileOperation = fileSystemProvider.writeFile(memoryURI, bytes);
			
			writeFileOperation.addEventListener( Event.COMPLETE, writeFileCompleteHandler );
			writeFileOperation.addEventListener( ErrorEvent.ERROR, writeFileErrorHandler );
			writeFileOperation.execute();
		}
		
		private function writeFileErrorHandler( event:ErrorEvent ):void
		{
			dispatchEvent( new ErrorEvent( ErrorEvent.ERROR, false, false, "Failed to write file template." ) );
		}
		
		private function writeFileCompleteHandler( event:Event ):void
		{
			var writeFileOperation:IWriteFileOperation = IWriteFileOperation(event.target);
			
			var uri:URI = new URI("memory/fileTemplate." + fileType.extension);
			var openFileOperation:OpenFileOperation = new OpenFileOperation( uri, CoreApp.fileSystemProvider, CoreEditor.settingsManager, true, false );
			openFileOperation.addEventListener(Event.COMPLETE, openFileCompleteHandler);
			openFileOperation.addEventListener(OperationProgressEvent.PROGRESS, openFileProgressHandler);
			openFileOperation.execute();
		}
		
		private function openFileProgressHandler( event:OperationProgressEvent ):void
		{
			dispatchEvent( new OperationProgressEvent( OperationProgressEvent.PROGRESS, 0.5 + event.progress * 0.5 ) );
		}
		
		private function openFileCompleteHandler( event:Event ):void
		{
			var openFileOperation:OpenFileOperation = OpenFileOperation(event.target);
			
			var editor:IEditorContext = openFileOperation.getEditorContext();
			if ( editor == null )
			{
				dispatchEvent( new Event( Event.COMPLETE ) );
				return;
			}
			
			editor.uri = new URI( "Untitled." + fileType.extension );
			editor.isNewFile = true;
			editor.changed = true;
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		public function get label():String
		{
			return "New File From File Template";
		}
	}
}