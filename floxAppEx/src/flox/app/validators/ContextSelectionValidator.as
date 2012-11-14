// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.app.validators
{
	import flox.app.core.contexts.IContext;
	import flox.app.core.contexts.ISelectionContext;
	import flox.app.events.CollectionValidatorEvent;
	import flox.app.events.ContextSelectionValidatorEvent;
	import flox.app.events.ContextValidatorEvent;
	import flox.app.events.ValidatorEvent;
	import flox.app.managers.ContextManager;
	
	[Event(type="flox.app.events.ContextSelectionValidatorEvent", name="validSelectionChanged")]
	[Event(type="flox.app.events.ContextValidatorEvent", name="contextChanged" )]
	
	public class ContextSelectionValidator extends ContextValidator
	{
		protected var collectionValidator	:CollectionValidator;
		
		public function ContextSelectionValidator( contextManager:ContextManager, contextType:Class = null, isCurrent:Boolean = false, selectionType:Class = null, minSelected:uint = 1, maxSelected:uint = uint.MAX_VALUE )
		{
			super( contextManager, contextType, isCurrent );
			
			if ( contextType == null ) _contextType = ISelectionContext;
			if ( selectionType == null ) selectionType = Object;
			
			collectionValidator = new CollectionValidator( null, selectionType, minSelected, maxSelected );
			collectionValidator.addEventListener(ValidatorEvent.STATE_CHANGED, collectionValidatorStageChangeHandler);
			collectionValidator.addEventListener(CollectionValidatorEvent.VALID_ITEMS_CHANGED, validItemsChangedHandler);
				
			updateState();
		}
		
		override public function dispose():void
		{
			super.dispose();
			collectionValidator.dispose();
			collectionValidator = null;
		}
		
		
		private function validItemsChangedHandler( event:CollectionValidatorEvent ):void
		{
			updateState();
			dispatchEvent( new ContextSelectionValidatorEvent( ContextSelectionValidatorEvent.VALID_SELECTION_CHANGED, event.validItems ) );
		}
		
		private var supressHandler:Boolean = false;
		private function collectionValidatorStageChangeHandler( event:ValidatorEvent ):void
		{
			if ( supressHandler ) return;
			updateState();
		}
		
		public function getValidSelection():Array
		{
			return collectionValidator.getValidItems();
		}
		
		override protected function updateState():void
		{
			var newContext:IContext = contextManager.getLatestContextOfType( _contextType );
			
			if ( !collectionValidator )
			{
				setState(state);
			}
			else if ( newContext is _contextType )
			{
				supressHandler = true;
				collectionValidator.collection = ISelectionContext( newContext ).selection;
				supressHandler = false;
				setState(collectionValidator.state);
			}
			else
			{
				supressHandler = true;
				collectionValidator.collection = null;
				supressHandler = false;
				setState(false);
			}
			
			
			if ( newContext != _context ) 
			{
				var oldContext:IContext = _context;
				_context = newContext;
				dispatchEvent( new ContextValidatorEvent( ContextValidatorEvent.CONTEXT_CHANGED, oldContext, newContext ) );
			}
		}
	}
}