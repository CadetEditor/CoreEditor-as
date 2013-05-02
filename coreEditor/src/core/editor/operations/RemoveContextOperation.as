// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.operations
{
	import core.editor.CoreEditor;
	import core.appEx.core.contexts.IContext;
	import core.appEx.core.contexts.IVisualContext;
	import core.app.core.operations.IOperation;

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
				CoreEditor.viewManager.removeVisualContext(visualContext);
			}
			CoreEditor.contextManager.removeContext(context);
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