// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.validators
{
	import core.appEx.core.contexts.IContext;
	import core.appEx.core.validators.IMetricValidator;
	import core.appEx.events.ContextManagerEvent;
	import core.appEx.events.ContextValidatorEvent;
	import core.appEx.managers.ContextManager;
	import core.app.util.IntrospectionUtil;
	import core.app.validators.AbstractValidator;
	
	[Event(name="contextChanged", type="core.appEx.events.ContextValidatorEvent")];
	
	public class ContextValidator extends AbstractValidator implements IMetricValidator
	{
		protected var contextManager	:ContextManager;
		protected var _contextType		:Class;
		protected var _context			:IContext;
		protected var _isCurrent		:Boolean;
		
		/**
		 * 
		 * @param contextManager
		 * @param contextType	The type of context you want this validator to check against. Can be null if you don't care.
		 * @param isCurrent		If true, the validator will only check against the currently focused context. Otherwise it will
		 * 						check against the most recently focused context of type 'contextType'.
		 * 
		 */		
		public function ContextValidator( contextManager:ContextManager, contextType:Class, isCurrent:Boolean = false )
		{
			this.contextManager = contextManager;
			_contextType = contextType;
			_isCurrent = isCurrent;
			contextManager.addEventListener( ContextManagerEvent.CURRENT_CONTEXT_CHANGED, contextChangedHandler );
			contextManager.addEventListener( ContextManagerEvent.CONTEXT_REMOVED, contextChangedHandler );
			contextManager.addEventListener( ContextManagerEvent.CONTEXT_REMOVED_FROM_HISTORY, contextChangedHandler );
			
			updateState();
		}
		
		public function getContext():IContext { return _context; }
		
		override public function dispose():void
		{
			contextManager.removeEventListener( ContextManagerEvent.CURRENT_CONTEXT_CHANGED, contextChangedHandler );
			contextManager.removeEventListener( ContextManagerEvent.CONTEXT_REMOVED, contextChangedHandler );
			contextManager.removeEventListener( ContextManagerEvent.CONTEXT_REMOVED_FROM_HISTORY, contextChangedHandler );
			
			contextManager = null;
			_contextType = null;
		}
		
		public function set contextType( value:Class ):void
		{
			_contextType = value;
			updateState();
		}
		public function get contextType():Class { return _contextType; }
		
		protected function contextChangedHandler( event:ContextManagerEvent ):void
		{
			updateState();
		}
		
		protected function updateState():void
		{
			var newContext:IContext
			if ( _isCurrent )
			{
				newContext = contextManager.getCurrentContext();
				if ( newContext is _contextType == false )
				{
					newContext = null;
				}
			}
			else	
			{
				newContext = contextManager.getLatestContextOfType( _contextType );
			}
			if ( newContext == _context ) return;
			_context = newContext;
			setState(_context != null);
			dispatchEvent( new ContextValidatorEvent( ContextValidatorEvent.CONTEXT_CHANGED, _context, newContext ) );
		}
		
		/**
		 * Implements IMetricValidator. This function returns a score between 0-1.
		 * This score indicates how closely matched the validated context is to
		 * the input 'contextType'. So for instance a MovieClip would get a lower score
		 * if it was being compared with DisplayObject, than if it was being compared to Sprite.
		 * It also takes into account how recently the context has been in focus.
		 * @return 
		 * 
		 */		
		public function get metric():Number
		{
			if ( !_state ) return 0;
			
			var context:IContext = contextManager.getLatestContextOfType(_contextType );
			var contextIndex:int = contextManager.getContextHistory().indexOf(context);
			
			if ( contextIndex == -1 ) return 0;
			
			contextIndex = (contextManager.getContextHistory().length-1) - contextIndex;
			
			var historyMetric:Number =  1 / (1+contextIndex);
			var typeMetric:Number = 1 / (1+IntrospectionUtil.getDistanceToSuperType( _context, _contextType ));
			
			// Weight the score to be biased towards matching the context closely
			var metric:Number = 0.75 * historyMetric + 0.25 * typeMetric;
			
			return metric;
		}
	}
}