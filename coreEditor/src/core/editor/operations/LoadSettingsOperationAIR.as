// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.operations
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import core.app.core.operations.IAsynchronousOperation;
	import core.app.events.OperationProgressEvent;
	import core.appEx.managers.SettingsManager;
	import core.app.util.AsynchronousUtil;

	[Event(type="core.app.events.OperationProgressEvent", name="progress")];
	[Event(type="flash.events.Event", name="complete")];
	[Event(type="flash.events.ErrorEvent", name="error")];

	public class LoadSettingsOperationAIR extends EventDispatcher implements IAsynchronousOperation
	{
		private var settingsManager	:SettingsManager;
		private var filename			:String;
		
		public function LoadSettingsOperationAIR( settingsManager:SettingsManager, filename:String )
		{
			this.settingsManager = settingsManager;
			this.filename = filename;
		}
		
		public function execute():void
		{
			var file:File = File.applicationStorageDirectory.resolvePath(filename);
			if ( file.exists == false )
			{
				AsynchronousUtil.dispatchLater( this, new Event(Event.COMPLETE) );
				return;
			}
			var fileStream:FileStream = new FileStream();
			fileStream.addEventListener( ProgressEvent.PROGRESS, readProgressHandler );
			fileStream.addEventListener( Event.COMPLETE, readCompleteHandler );
			fileStream.addEventListener( IOErrorEvent.IO_ERROR, readErrorHandler );
			fileStream.openAsync(file, FileMode.READ);
		}
		
		private function readProgressHandler( event:ProgressEvent ):void
		{
			dispatchEvent( new OperationProgressEvent( OperationProgressEvent.PROGRESS, event.bytesLoaded/event.bytesTotal ) );
		}
		
		private function readErrorHandler( event:IOErrorEvent ):void
		{
			dispatchEvent( event.clone() );
		}
		
		private function readCompleteHandler( event:Event ):void
		{
			var fileStream:FileStream = event.target as FileStream;
			
			var bytes:ByteArray = new ByteArray();
			fileStream.readBytes( bytes, 0, fileStream.bytesAvailable );
			fileStream.close();
			
			var xmlString:String = bytes.readUTFBytes(bytes.length);
			var xml:XML = XML(xmlString);
			
			settingsManager.load(xml);
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
				
		public function get label():String { return "Load settings"; }
	}
}