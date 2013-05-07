// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.managers
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import core.app.core.operations.IAsynchronousOperation;
	import core.app.core.operations.IOperation;
	import core.app.core.operations.IUndoableOperation;
	import core.appEx.events.OperationManagerEvent;
	import core.app.events.OperationProgressEvent;
	
	[Event(name="change", 					type="core.appEx.events.OperationManagerEvent")];
	[Event(name="operationAdded", 			type="core.appEx.events.OperationManagerEvent")];
	[Event(name="operationComplete", 		type="core.appEx.events.OperationManagerEvent")];
	[Event(name="operationBegin", 			type="core.appEx.events.OperationManagerEvent")];
	[Event(name="allOperationsComplete", 	type="core.appEx.events.OperationManagerEvent")];
	[Event(name="operationProgress", 		type="core.appEx.events.OperationManagerEvent")];
	
	public class OperationManager extends EventDispatcher
	{
		protected var operations				:Vector.<IOperation>;
		
		// State
		protected var _operationExecuting		:Boolean = false;
		protected var _currentOperation			:IOperation;
		protected var operationTimeTable		:Dictionary;
		
		// Commands
		private var commands					:Vector.<Object>
		private static const GOTO_NEXT			:int = 0;
		private static const GOTO_PREV			:int = 1;
		private static const ADD_OPERATION		:int = 4;
		
		public function OperationManager()
		{
			super();
			operations = new Vector.<IOperation>();
			commands = new Vector.<Object>();
			operationTimeTable = new Dictionary(true);
		}
		
		
		public function dispose():void
		{
			if ( operations ) 
			{
				for each ( var operation:IOperation in operations )
				{
					if ( operation is IAsynchronousOperation )
					{
						IAsynchronousOperation( operation ).removeEventListener( Event.COMPLETE, operationCompleteHandler );
						IAsynchronousOperation( operation ).removeEventListener( Event.COMPLETE, operationUndoCompleteHandler );
					}
				}
				operations = null;
			}
			commands = null;
		}
		
		public function gotoOperation( index:int ):void
		{
			if ( _currentOperation == null ) return;
			
			var currentIndex:int = operations.indexOf(_currentOperation);
			var indexOffset:int = index - currentIndex;
			
			for each ( var command:Object in commands )
			{
				if ( command.id == GOTO_NEXT )
				{
					indexOffset--;
				}
				else if ( command.id == GOTO_PREV )
				{
					indexOffset++;
				}
			}
			
			if ( indexOffset == 0 ) return;
			
			if ( indexOffset < 0 )
			{
				while ( indexOffset < 0 )
				{
					addCommand( { id:GOTO_PREV } );
					indexOffset++;
				}
			}
			else
			{
				while ( indexOffset > 0 )
				{
					addCommand( { id:GOTO_NEXT } );
					indexOffset--;
				}
			}
			
			checkCommands();
		}
		
		public function gotoNextOperation():void
		{
			addCommand( { id:GOTO_NEXT } );
			checkCommands();
		}
		
		public function gotoPreviousOperation():void
		{
			addCommand( { id:GOTO_PREV } );
			checkCommands();
		}
		
		public function addOperation( operation:IOperation, autoExecute:Boolean = true ):void
		{
			addCommand( { id:ADD_OPERATION, operation:operation } );
			if ( autoExecute )
			{
				addCommand( { id : GOTO_NEXT } );
			}
			checkCommands();
		}
		
		public function isUndoAvailable():Boolean
		{
			return operations.indexOf( _currentOperation ) > -1;
		}
		
		public function isRedoAvailable():Boolean
		{
			return operations.indexOf( _currentOperation ) < operations.length-1;
		}
		
		public function getOperations():Vector.<IOperation> { return operations.slice(); }
		public function get numOperations():int { return operations.length; }
		public function get currentOperation():IOperation { return _currentOperation; }
		
		
		private function checkCommands():void
		{
			if ( _operationExecuting ) return;
			if ( commands.length == 0 ) return;
			var command:Object = commands.shift();
			
			var currentIndex:int = operations.indexOf( _currentOperation );
			if ( command.id == GOTO_NEXT )
			{
				if ( currentIndex+1 < operations.length )
				{
					_currentOperation = operations[currentIndex+1];
					executeOperation( _currentOperation );
				}
			}
			else if ( command.id == GOTO_PREV )
			{
				if ( _currentOperation )
				{
					undoOperation( IUndoableOperation( _currentOperation ) );
				}
			}
			else if ( command.id == ADD_OPERATION )
			{
				// Destroy all operations in the future as they are now invalidated
				var i:int = currentIndex+1;
				while ( i < operations.length )
				{
					operations.splice( i, 1 );
				}
				
				operations.push( IOperation( command.operation ) );
				dispatchEvent( new OperationManagerEvent( OperationManagerEvent.OPERATION_ADDED, command.operation ) );
				dispatchEvent( new OperationManagerEvent( OperationManagerEvent.CHANGE ) );
			}
			
			checkCommands();
		}
		
		private function operationComplete( operation:IOperation, undo:Boolean = false ):void
		{
			_operationExecuting = false;
			
			var currentTime:int = flash.utils.getTimer();
			var startTime:int = operationTimeTable[operation];
			var elapsedTime:int = currentTime - startTime;
			delete operationTimeTable[operation];
			
			
			dispatchEvent( new OperationManagerEvent( OperationManagerEvent.OPERATION_COMPLETE, operation ) );
			
			if ( operation is IUndoableOperation == false )
			{
				while ( operations.indexOf( operation ) != -1 )
				{
					operations.splice( 0, 1 );
				}
			}
			
			if ( undo )
			{
				var index:int = operations.indexOf( _currentOperation );
				if ( index == 0 )
				{
					_currentOperation = null;
				}
				else
				{
					_currentOperation = operations[index - 1];
				}
			}
			
			dispatchEvent( new OperationManagerEvent( OperationManagerEvent.CHANGE ) );
			
			if ( commands.length == 0 )
			{
				dispatchEvent( new OperationManagerEvent( OperationManagerEvent.ALL_OPERATIONS_COMPLETE ) );
			}
			
			checkCommands();
		}
		
		private function addCommand( command:Object ):void
		{
			commands.push( command );
		}
		
		private function executeOperation( operation:IOperation ):void
		{
			operationTimeTable[operation] = flash.utils.getTimer();
			
			if ( operation is IAsynchronousOperation )
			{
				var asynchronousOperation:IAsynchronousOperation = IAsynchronousOperation( operation );
				asynchronousOperation.addEventListener( Event.COMPLETE, operationCompleteHandler );
				asynchronousOperation.addEventListener( ErrorEvent.ERROR, operationErrorHandler, false, 10 );
				asynchronousOperation.addEventListener( OperationProgressEvent.PROGRESS, operationProgressHandler );
				_operationExecuting = true;
				dispatchEvent( new OperationManagerEvent( OperationManagerEvent.OPERATION_BEGIN, operation ) );
				//trace("OperationManager. Executing Operation : " + operation.label);
				operation.execute();
				return;
			}
			else
			{
				dispatchEvent( new OperationManagerEvent( OperationManagerEvent.OPERATION_BEGIN, operation ) );
				_operationExecuting = true;
				//trace("OperationManager. Executing Operation : " + operation.label);
				operation.execute();
				_operationExecuting = false;
				operationComplete( operation );
			}
		}
		
		private function undoOperation( operation:IUndoableOperation ):void
		{
			operationTimeTable[operation] = flash.utils.getTimer();
			
			if ( operation is IAsynchronousOperation )
			{
				var asynchronousOperation:IAsynchronousOperation = IAsynchronousOperation( operation );
				asynchronousOperation.addEventListener( Event.COMPLETE, operationUndoCompleteHandler );
				asynchronousOperation.addEventListener( ErrorEvent.ERROR, operationErrorHandler, false, 10 );
				asynchronousOperation.addEventListener( OperationProgressEvent.PROGRESS, operationProgressHandler );
				_operationExecuting = true;
				dispatchEvent( new OperationManagerEvent( OperationManagerEvent.OPERATION_BEGIN, operation ) );
				//trace("OperationManager. Undoing Operation : " + operation.label);
				operation.undo();
				return;
			}
			else
			{
				//trace("OperationManager. Undoing Operation : " + operation.label);
				operation.undo();
				dispatchEvent( new OperationManagerEvent( OperationManagerEvent.OPERATION_COMPLETE, operation ) );
				operationComplete( operation, true );
			}
		}
		
		private function operationUndoCompleteHandler( event:Event ):void
		{
			var operation:IAsynchronousOperation = IAsynchronousOperation( event.target );
			operation.removeEventListener( Event.COMPLETE, operationUndoCompleteHandler );
			operation.removeEventListener( ErrorEvent.ERROR, operationErrorHandler );
			operation.removeEventListener( OperationProgressEvent.PROGRESS, operationProgressHandler );
			_operationExecuting = false;
			operationComplete( operation, true );
		}
		
		private function operationCompleteHandler( event:Event ):void
		{
			var operation:IAsynchronousOperation = IAsynchronousOperation( event.target );
			operation.removeEventListener( Event.COMPLETE, operationUndoCompleteHandler );
			operation.removeEventListener( ErrorEvent.ERROR, operationErrorHandler );
			operation.removeEventListener( OperationProgressEvent.PROGRESS, operationProgressHandler );
			_operationExecuting = false;
			operationComplete( operation );
		}
		
		private function operationErrorHandler( event:ErrorEvent ):void
		{
			event.stopImmediatePropagation();
			
			var operation:IAsynchronousOperation = IAsynchronousOperation( event.target );
			operation.removeEventListener( Event.COMPLETE, operationUndoCompleteHandler );
			operation.removeEventListener( ErrorEvent.ERROR, operationErrorHandler );
			operation.removeEventListener( OperationProgressEvent.PROGRESS, operationProgressHandler );
			_operationExecuting = false;
			operationComplete( operation );

			operation.dispatchEvent( event );
		}
		
		private function operationProgressHandler( event:OperationProgressEvent ):void
		{
			dispatchEvent( new OperationManagerEvent( OperationManagerEvent.OPERATION_PROGRESS, IOperation( event.target ), event.progress ) );
		}
	}
}