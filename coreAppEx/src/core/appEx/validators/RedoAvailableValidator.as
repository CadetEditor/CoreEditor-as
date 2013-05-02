// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.validators
{
	import core.appEx.core.contexts.IOperationManagerContext;
	import core.appEx.events.ContextManagerEvent;
	import core.appEx.events.OperationManagerEvent;
	import core.appEx.managers.ContextManager;
	import core.appEx.managers.OperationManager;
	import core.app.validators.AbstractValidator;
	
	public class RedoAvailableValidator extends AbstractValidator
	{
		private var contextManager			:ContextManager;
		private var _operationManager		:OperationManager;
		
		public function RedoAvailableValidator( contextManager:ContextManager )
		{
			this.contextManager = contextManager;
			contextManager.addEventListener( ContextManagerEvent.CURRENT_CONTEXT_CHANGED, contextChangedHandler );
			contextChanged();
		}
		
		protected function contextChangedHandler(event:ContextManagerEvent):void
		{
			contextChanged();
		}
		
		override public function dispose():void
		{
			contextManager.removeEventListener( ContextManagerEvent.CURRENT_CONTEXT_CHANGED, contextChangedHandler );
			operationManager = null;
			contextManager = null;
		}
		
		
		private function contextChanged():void
		{
			var context:IOperationManagerContext = IOperationManagerContext( contextManager.getLatestContextOfType( IOperationManagerContext ) );
			if ( !context ) 
			{
				operationManager = null;
				setState(false);
				return;
			}
			operationManager = context.operationManager;
		}
	
		
		private function set operationManager( value:OperationManager ):void
		{
			if (_operationManager == value) return;
			
			if ( _operationManager ) 
			{
				_operationManager.removeEventListener( OperationManagerEvent.CHANGE, historyManagerChangedHandler );
			}
			
			_operationManager = value;
			
			if ( _operationManager ) 
			{
				_operationManager.addEventListener( OperationManagerEvent.CHANGE, historyManagerChangedHandler );
				changed();
			}
		}
		private function get operationManager():OperationManager { return _operationManager; }
		
		
		
		private function historyManagerChangedHandler( event:OperationManagerEvent ):void
		{
			changed();
		}
		
		private function changed():void
		{
			setState(_operationManager.isRedoAvailable());
		}
	}
}