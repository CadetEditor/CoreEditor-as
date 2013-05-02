// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.operations
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.OutputProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import core.app.core.operations.IAsynchronousOperation;
	import core.app.events.OperationProgressEvent;
	import core.appEx.managers.SettingsManager;

	public class SaveSettingsOperationAIR extends EventDispatcher implements IAsynchronousOperation
	{
		private var settingsManager		:SettingsManager;
		private var filename			:String;
		
		public function SaveSettingsOperationAIR( settingsManager:SettingsManager, filename:String )
		{
			this.settingsManager = settingsManager;
			this.filename = filename;
		}
		
		public function execute():void
		{
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes( settingsManager.save().toXMLString() );
			
			var file:File = File.applicationStorageDirectory.resolvePath(filename);
			var fileStream:FileStream = new FileStream();
			fileStream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, progressHandler );
			fileStream.addEventListener( IOErrorEvent.IO_ERROR, errorHandler );
			fileStream.openAsync(file, FileMode.WRITE);
			fileStream.writeBytes( bytes, 0, bytes.length );
		}
		
		private function progressHandler( event:Event ):void
		{
			var outputProgressEvent:OutputProgressEvent = OutputProgressEvent(event);
			var fileStream:FileStream = FileStream( event.target );
			if ( outputProgressEvent.bytesPending == 0 )
			{
				fileStream.close();
				dispatchEvent( new Event( Event.COMPLETE ) );
			}
			else
			{
				dispatchEvent( new OperationProgressEvent( OperationProgressEvent.PROGRESS, (outputProgressEvent.bytesTotal-outputProgressEvent.bytesPending) / outputProgressEvent.bytesTotal ) );
			}
		}
		
		private function errorHandler( event:IOErrorEvent ):void
		{
			dispatchEvent( event.clone() );
		}
		
		private function writeCompleteHandler( event:Event ):void
		{
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		public function get label():String { return "Save settings"; }
	}
}