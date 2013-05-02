// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.managers
{
	import flash.events.EventDispatcher;
		
	import core.appEx.core.contexts.IContext;
	import core.appEx.events.ContextManagerEvent;
	import core.app.util.IntrospectionUtil;
	
	[Event(type="core.appEx.events.ContextManagerEvent", name="currentContextChanged" )];
	[Event(type="core.appEx.events.ContextManagerEvent", name="contextAdded")];
	[Event(type="core.appEx.events.ContextManagerEvent", name="contextRemoved")];
	
	public class ContextManager extends EventDispatcher
	{
		protected var contexts					:Vector.<IContext>;
		protected var history					:Vector.<IContext>;
		protected var currentContext			:IContext;
		
		public function ContextManager()
		{
			contexts = new Vector.<IContext>();
			history = new Vector.<IContext>();
		}
		
		public function addContext( context:IContext ):void
		{
			if ( contexts.indexOf( context ) != -1 ) 
			{
				throw( new Error( "This context has already been added to the ContextManager" ) );
				return;
			}
			contexts.push( context );
			
			dispatchEvent( new ContextManagerEvent( ContextManagerEvent.CONTEXT_ADDED, context ) );
		}
		
		public function removeContext( context:IContext ):void
		{
			if ( contexts.indexOf( context ) == -1 )
			{
				throw ( new Error( "Cannot remove context as it has not beed added to the ContextManager" ) );
				return
			}
			
			contexts.splice( contexts.indexOf( context) , 1 );
			
			while ( history.indexOf( context ) != -1 )
			{
				history.splice( history.indexOf( context ), 1 );
			}
			
			if ( context == currentContext ) 
			{
				if ( history.length == 0 )
				{
					setCurrentContext( null );
				}
				else
				{
					setCurrentContext( history[ history.length-1 ] );
				}
			}
			
			dispatchEvent( new ContextManagerEvent( ContextManagerEvent.CONTEXT_REMOVED, context ) );
		}
		
		public function removeContextFromHistory( context:IContext ):void
		{
			if ( contexts.indexOf( context ) == -1 )
			{
				throw ( new Error( "Cannot remove context from history it has not beed added to the ContextManager" ) );
				return;
			}
			
			while ( history.indexOf( context ) != -1 )
			{
				history.splice( history.indexOf( context ), 1 );
			}
			
			dispatchEvent( new ContextManagerEvent( ContextManagerEvent.CONTEXT_REMOVED_FROM_HISTORY, context ) );
		}
		
		public function getCurrentContext():IContext
		{
			return currentContext;
		}
		
		public function setCurrentContext( value:IContext ):void
		{
			if ( value == currentContext ) return;
			
			if ( value && contexts.indexOf( value ) == -1 )
			{
				throw ( new Error( "This context has not been registered via 'addContext() : " + IntrospectionUtil.getClassPath( value ) ) );
				return;
			}
			
			currentContext = value;
					
			history.push( currentContext );
			
			trace("Current context changed : " + currentContext);
			dispatchEvent( new ContextManagerEvent( ContextManagerEvent.CURRENT_CONTEXT_CHANGED, currentContext ) );
		}
		
		public function getContexts():Vector.<IContext>
		{
			return contexts.slice();
		}
		
		public function getContextsOfType( type:Class ):Vector.<IContext>
		{
			var filterFunc:Function = function( item:*, index:int, vec:Vector.<IContext> ):Boolean
			{
				return item is type;
			}
			return contexts.filter( filterFunc, { type:type } );
		}
		
		
		
		public function getContextHistory():Vector.<IContext> { return history.slice(); }
		
		/**
		 * This function performs a check on all previously activated contexts, and returns the one
		 * that matches the supplied type. This is useful for situations where you wish actions
		 * to still be availble even though the context they act upon is not longer the current one - but still
		 * exists. (For example, focusing away from this text editor in Eclipse will not mean the 'close file (CTRL+W)' action
		 * stops being available).
		 * @param type
		 * @return 
		 * 
		 */		
		public function getLatestContextOfType( type:Class ):*
		{
			if ( type == null ) return null;
			
			for ( var i:int = history.length-1; i > -1; i-- )
			{
				var context:IContext = history[i];
				if ( context is type )
				{
					return context;
				}
			}
			return null;
		}
	}
}