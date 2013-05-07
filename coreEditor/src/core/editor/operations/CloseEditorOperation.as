// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.operations
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import core.appEx.core.contexts.IVisualContext;
	import core.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import core.app.core.operations.IAsynchronousOperation;
	import core.editor.CoreEditor;
	import core.editor.contexts.IEditorContext;
	import core.ui.components.Alert;
	import core.ui.events.AlertEvent;

	[Event(type="core.app.events.OperationProgressEvent", name="progress")];
	[Event(type="flash.events.Event", name="complete")];
	[Event( type="flash.events.Event", name="cancel" )];
	
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
					var operation:SaveFileAsOperation = new SaveFileAsOperation(editorContext, true);
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
			
			//TODO: Rob moved this as CloseFileCommandHandler wasn't taking the pause to interact into account.
			// After closing the editor, switch focus to the most recently editor context
			var latestEditorContext:IVisualContext = CoreEditor.contextManager.getLatestContextOfType(IEditorContext);
			if ( latestEditorContext )
			{
				CoreEditor.contextManager.setCurrentContext(latestEditorContext);
				CoreEditor.viewManager.showVisualContext(latestEditorContext);
			}
		}
		
		public function get label():String
		{
			if ( editorContext.uri == null ) return "Close file";
			return "Close file: " + editorContext.uri.getFilename();
		}
	}
}