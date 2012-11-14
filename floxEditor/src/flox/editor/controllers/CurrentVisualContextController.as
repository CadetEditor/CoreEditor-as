// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.controllers
{
	import flash.display.DisplayObject;
	import flash.events.FocusEvent;
	
	import flox.ui.components.UIComponent;
	import flox.ui.events.ComponentFocusEvent;
	import flox.ui.managers.FocusManager;
	
	import flox.editor.FloxEditor;
	import flox.editor.core.IViewContainer;
	import flox.app.core.contexts.IContext;
	import flox.app.core.contexts.IVisualContext;
	
	/**
	 * This controller implements behaviour that determines which VisualContext is regarded as the 'current' context.
	 * Currently, this controller ties in the concept of the 'current' context with the Control Flex thinks is 'focused'.
	 * So far, this simple approach seems to be working nicely, as we inherit a lot of Flex's leg-work to determine where the
	 * user's focus is directed.
	 * @author Jonathan
	 * 
	 */	
	public class CurrentVisualContextController
	{
		public function CurrentVisualContextController()
		{
			FocusManager.getInstance().addEventListener( ComponentFocusEvent.COMPONENT_FOCUS_IN, componentFocusInHandler );
		}
		
		private function componentFocusInHandler( event:ComponentFocusEvent ):void
		{
			var component:DisplayObject = event.relatedComponent;
			
			var contexts:Vector.<IContext> = FloxEditor.contextManager.getContextsOfType(IVisualContext);
			
			while ( component )
			{
				for each ( var context:IVisualContext in contexts )
				{
					var container:IViewContainer = FloxEditor.viewManager.getContainerForContext(context);
					if ( container == component )
					{
						FloxEditor.contextManager.setCurrentContext( context );
						return;
					}
				}
				
				component = component.parent as DisplayObject;
			}
		}
	}
}