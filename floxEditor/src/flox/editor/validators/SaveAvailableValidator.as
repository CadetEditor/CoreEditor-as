// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.validators
{
	import flash.events.Event;
	
	import flox.editor.FloxEditor;
	import flox.editor.contexts.IEditorContext;
	import flox.app.events.ContextManagerEvent;
	import flox.app.managers.ContextManager;
	import flox.app.validators.AbstractValidator;
	
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
			
			editorContext = FloxEditor.contextManager.getLatestContextOfType(IEditorContext);
			
			if ( editorContext )
			{
				editorContext.addEventListener( Event.CHANGE, changeHandler )
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