// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.operations
{
	import flox.editor.FloxEditor;
	import flox.editor.contexts.IEditorContext;
	import flox.app.core.contexts.IContext;
	import flox.app.core.contexts.IVisualContext;
	import flox.app.core.operations.IOperation;

	public class RemoveContextOperation implements IOperation
	{
		private var context		:IContext;
		
		public function RemoveContextOperation( context:IContext )
		{
			this.context = context;
		}

		public function execute():void
		{
			// TODO: Rob moved this above so disableRenderer() is called before enabledRenderer()
			context.dispose();
			
			if ( context is IVisualContext )
			{
				var visualContext:IVisualContext = IVisualContext(context);
				FloxEditor.viewManager.removeVisualContext(visualContext);
			}
			FloxEditor.contextManager.removeContext(context);
			//context.dispose();
		}
		
		public function dispose():void
		{
			context = null;
		}
		
		public function get label():String
		{
			return "Remove Context";
		}
		
	}
}