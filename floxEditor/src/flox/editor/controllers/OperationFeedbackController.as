// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.controllers
{
	import flash.display.Stage;
	import flash.events.ErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import flox.core.data.ArrayCollection;
	import flox.ui.managers.CursorManager;
	import flux.cursors.BusyCursor;
	
	import flox.editor.FloxEditor;
	import flox.app.core.contexts.IOperationManagerContext;
	import flox.app.core.operations.IAsynchronousOperation;
	import flox.app.events.ContextManagerEvent;
	import flox.app.events.OperationManagerEvent;
	import flox.app.managers.OperationManager;
	
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
			
			FloxEditor.operationManager.addEventListener( OperationManagerEvent.OPERATION_BEGIN, operationBeginHandler );
			FloxEditor.operationManager.addEventListener( OperationManagerEvent.OPERATION_COMPLETE, operationCompleteHandler );
			FloxEditor.operationManager.addEventListener( ErrorEvent.ERROR, operationErrorHandler );
			FloxEditor.operationManager.addEventListener( OperationManagerEvent.OPERATION_PROGRESS, operationProgressHandler );
			
			FloxEditor.contextManager.addEventListener( ContextManagerEvent.CONTEXT_ADDED, contextAddedHandler );
			FloxEditor.contextManager.addEventListener( ContextManagerEvent.CONTEXT_REMOVED, contextRemovedHandler );
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
				FloxEditor.viewManager.setProgress( event.operation.label, 0, true );
			}
			
			updateCursor();
		}
		
		protected function operationCompleteHandler( event:OperationManagerEvent ):void
		{
			if ( event.operation is IAsynchronousOperation == false ) return;
						
			var index:int = operations.getItemIndex(event.operation);
			if ( index == -1 )
			{
				FloxEditor.viewManager.clearProgress();
				return;
			}
			
			operations.removeItemAt( index );
			updateCursor();
			
			if ( operations.length > 0 )
			{
				FloxEditor.viewManager.setProgress( operations[0].label, 0, true );
			}
			else
			{
				FloxEditor.viewManager.clearProgress();
			}
		}
		
		protected function operationProgressHandler( event:OperationManagerEvent ):void
		{
			if ( operations.length == 0 ) return;
			if ( event.operation == operations[0] )
			{
				FloxEditor.viewManager.setProgress( event.operation.label, event.progress );
			}
		}
				
		private function operationErrorHandler( event:ErrorEvent ):void
		{
			FloxEditor.viewManager.clearProgress();
			operations.source = [];
		}
		
		private function updateCursor():void
		{
			var stage:Stage = FloxEditor.stage;
			
			if ( operations.length > 0 && ! busy)
			{
				CursorManager.setCursor(BusyCursor);
				FloxEditor.viewManager.application.enabled = false;
				busy = true;
				stage.addEventListener(KeyboardEvent.KEY_DOWN, cancelKeyDownHandler, true, 10);
			}
			else if ( busy )
			{
				CursorManager.setCursor(null);
				FloxEditor.viewManager.application.enabled = true;
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