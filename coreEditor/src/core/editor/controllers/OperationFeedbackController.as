// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.controllers
{
	import flash.display.Stage;
	import flash.events.ErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import core.data.ArrayCollection;
	import core.ui.managers.CursorManager;
	import flux.cursors.BusyCursor;
	
	import core.editor.CoreEditor;
	import core.app.core.contexts.IOperationManagerContext;
	import core.app.core.operations.IAsynchronousOperation;
	import core.app.events.ContextManagerEvent;
	import core.app.events.OperationManagerEvent;
	import core.app.managers.OperationManager;
	
	/**
	 * This controller is responsible for monitoring the BonesEditor.operationManager for operations being added, completed and removed.
	 * It provides visual feedback by using the setProgress() and clearProgress() methods on the IGlobalBonesView interface.
	 * It also shows the 'busy' cursor while an operation is in progress.
	 * @author Jonathan
	 * 
	 */	
	public class OperationFeedbackController
	{
		private var operations				:ArrayCollection;
		private var busy					:Boolean = false;
		
		public function OperationFeedbackController()
		{
			operations = new ArrayCollection();
			
			CoreEditor.operationManager.addEventListener( OperationManagerEvent.OPERATION_BEGIN, operationBeginHandler );
			CoreEditor.operationManager.addEventListener( OperationManagerEvent.OPERATION_COMPLETE, operationCompleteHandler );
			CoreEditor.operationManager.addEventListener( ErrorEvent.ERROR, operationErrorHandler );
			CoreEditor.operationManager.addEventListener( OperationManagerEvent.OPERATION_PROGRESS, operationProgressHandler );
			
			CoreEditor.contextManager.addEventListener( ContextManagerEvent.CONTEXT_ADDED, contextAddedHandler );
			CoreEditor.contextManager.addEventListener( ContextManagerEvent.CONTEXT_REMOVED, contextRemovedHandler );
		}
		
		protected function contextAddedHandler( event:ContextManagerEvent ):void
		{
			if ( event.context is IOperationManagerContext == false ) return;
			var operationManager:OperationManager = IOperationManagerContext( event.context ).operationManager;
			operationManager.addEventListener( OperationManagerEvent.OPERATION_BEGIN, operationBeginHandler );
			operationManager.addEventListener( OperationManagerEvent.OPERATION_COMPLETE, operationCompleteHandler );
			operationManager.addEventListener(OperationManagerEvent.OPERATION_PROGRESS, operationProgressHandler);
		}
		
		protected function contextRemovedHandler( event:ContextManagerEvent ):void
		{
			if ( event.context is IOperationManagerContext == false ) return;
			var operationManager:OperationManager = IOperationManagerContext( event.context ).operationManager;
			operationManager.removeEventListener( OperationManagerEvent.OPERATION_BEGIN, operationBeginHandler );
			operationManager.removeEventListener( OperationManagerEvent.OPERATION_COMPLETE, operationCompleteHandler );
			operationManager.removeEventListener(OperationManagerEvent.OPERATION_PROGRESS, operationProgressHandler);
		}
		
		protected function operationBeginHandler( event:OperationManagerEvent ):void
		{
			if ( event.operation is IAsynchronousOperation == false ) return;
			
			operations.addItem( event.operation );
			
			if ( operations.length == 1 )
			{
				CoreEditor.viewManager.setProgress( event.operation.label, 0, true );
			}
			
			updateCursor();
		}
		
		protected function operationCompleteHandler( event:OperationManagerEvent ):void
		{
			if ( event.operation is IAsynchronousOperation == false ) return;
						
			var index:int = operations.getItemIndex(event.operation);
			if ( index == -1 )
			{
				CoreEditor.viewManager.clearProgress();
				return;
			}
			
			operations.removeItemAt( index );
			updateCursor();
			
			if ( operations.length > 0 )
			{
				CoreEditor.viewManager.setProgress( operations[0].label, 0, true );
			}
			else
			{
				CoreEditor.viewManager.clearProgress();
			}
		}
		
		protected function operationProgressHandler( event:OperationManagerEvent ):void
		{
			if ( operations.length == 0 ) return;
			if ( event.operation == operations[0] )
			{
				CoreEditor.viewManager.setProgress( event.operation.label, event.progress );
			}
		}
				
		private function operationErrorHandler( event:ErrorEvent ):void
		{
			CoreEditor.viewManager.clearProgress();
			operations.source = [];
		}
		
		private function updateCursor():void
		{
			var stage:Stage = CoreEditor.stage;
			
			if ( operations.length > 0 && ! busy)
			{
				CursorManager.setCursor(BusyCursor);
				CoreEditor.viewManager.application.enabled = false;
				busy = true;
				stage.addEventListener(KeyboardEvent.KEY_DOWN, cancelKeyDownHandler, true, 10);
			}
			else if ( busy )
			{
				CursorManager.setCursor(null);
				CoreEditor.viewManager.application.enabled = true;
				busy = false;
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, cancelKeyDownHandler, true);
			}
		}
		
		private function cancelKeyDownHandler( event:KeyboardEvent ):void
		{
			event.preventDefault();
			event.stopImmediatePropagation();
		}
		
	}
}