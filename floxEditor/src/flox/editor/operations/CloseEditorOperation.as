// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.operations
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import flox.ui.components.Alert;
	import flox.ui.events.AlertEvent;
	
	import flox.editor.FloxEditor;
	import flox.editor.contexts.IEditorContext;
	import flox.editor.entities.Commands;
	import flox.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import flox.app.core.operations.IAsynchronousOperation;

	[Event(type="flox.app.events.OperationProgressEvent", name="progress")]
	[Event(type="flash.events.Event", name="complete")]
	[Event( type="flash.events.Event", name="cancel" )]
	
	public class CloseEditorOperation extends EventDispatcher implements IAsynchronousOperation
	{
		private var editorContext		:IEditorContext;
		private var fileSystemProvider	:IFileSystemProvider;
		
		public function CloseEditorOperation( editorContext:IEditorContext, fileSystemProvider:IFileSystemProvider )
		{
			this.editorContext = editorContext;
			this.fileSystemProvider = fileSystemProvider;
		}

		public function execute():void
		{
			if ( editorContext.changed )
			{
				Alert.show( "Save File", "'" + editorContext.uri.getFilename() + "' has been modified. Save changes?", ["Yes","No", "Cancel"], "Yes", null, true, closeAlertHandler );
			}
			else
			{
				removeEditor();
				dispatchEvent( new Event( Event.COMPLETE ) );
			}
		}
		
		private function closeAlertHandler( event:AlertEvent ):void
		{
			if ( event.selectedButton == "Yes" )
			{
				if ( editorContext.isNewFile )
				{
					var operation:SaveFileAsOperation = new SaveFileAsOperation(editorContext);
					operation.addEventListener(Event.COMPLETE, saveFileAsCompleteHandler);
					operation.addEventListener(Event.CANCEL, saveFileAsCancelHandler );
					operation.execute();
					return;
				}
				editorContext.save();
				dispatchEvent( new Event( Event.COMPLETE ) );
			}
			else if ( event.selectedButton == "No" )
			{
				removeEditor();
				dispatchEvent( new Event( Event.COMPLETE ) );
			}
			else
			{
				dispatchEvent( new Event( Event.CANCEL ) );
				dispatchEvent( new Event( Event.COMPLETE ) );
			}
		}
		
		private function saveFileAsCompleteHandler( event:Event ):void
		{
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		private function saveFileAsCancelHandler( event:Event ):void
		{
			dispatchEvent( new Event( Event.CANCEL ) );
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		private function removeEditor():void
		{
			var removeContextOperation:RemoveContextOperation = new RemoveContextOperation( editorContext );
			removeContextOperation.execute();
		}
		
		public function get label():String
		{
			if ( editorContext.uri == null ) return "Close file";
			return "Close file: " + editorContext.uri.getFilename();
		}
	}
}