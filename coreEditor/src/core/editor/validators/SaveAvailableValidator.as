// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.validators
{
	import flash.events.Event;
	
	import core.editor.CoreEditor;
	import core.editor.contexts.IEditorContext;
	import core.appEx.events.ContextManagerEvent;
	import core.appEx.managers.ContextManager;
	import core.app.validators.AbstractValidator;
	
	public class SaveAvailableValidator extends AbstractValidator
	{
		protected var editorContext		:IEditorContext;
		protected var contextManager	:ContextManager;
		
		public function SaveAvailableValidator( contextManager:ContextManager )
		{
			this.contextManager = contextManager;
			contextManager.addEventListener( ContextManagerEvent.CURRENT_CONTEXT_CHANGED, contextChangedHandler );
		}
		
		override public function dispose():void
		{
			if ( editorContext )
			{
				editorContext.removeEventListener( Event.CHANGE, changeHandler );
				editorContext = null;
			}
			contextManager.removeEventListener( ContextManagerEvent.CURRENT_CONTEXT_CHANGED, contextChangedHandler );
			contextManager = null;
		}
		
		protected function contextChangedHandler( event:ContextManagerEvent ):void
		{
			if ( editorContext )
			{
				editorContext.removeEventListener( Event.CHANGE, changeHandler );
			}
			editorContext = null;
			
			editorContext = CoreEditor.contextManager.getLatestContextOfType(IEditorContext);
			
			if ( editorContext )
			{
				editorContext.addEventListener( Event.CHANGE, changeHandler );
				setState(editorContext.changed || editorContext.isNewFile);
			}
			else
			{
				setState(false);
			}
		}
		
		protected function changeHandler( event:Event ):void
		{
			setState(editorContext.changed);
		}
	}
}