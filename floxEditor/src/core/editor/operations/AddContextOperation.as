// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.operations
{
	import core.ui.util.BindingUtil;
	
	import core.editor.CoreEditor;
	import core.editor.contexts.IEditorContext;
	import core.editor.core.IViewContainer;
	import core.app.core.contexts.IContext;
	import core.app.core.contexts.IVisualContext;
	import core.app.core.operations.IOperation;
	import core.app.resources.IFactoryResource;
	import core.app.resources.IResource;
	import core.app.util.IntrospectionUtil;
	
	public class AddContextOperation implements IOperation
	{
		private var factory			:IFactoryResource;
		private var _context		:IContext;
		
		public function AddContextOperation( factory:IFactoryResource )
		{
			this.factory = factory;
		}
		
		public function execute():void
		{
			// Ensure that we don't add more than one IVIsualContext unless it is an IEditorContext
			if ( IntrospectionUtil.isRelatedTo( factory.getInstanceType(), IVisualContext ) && IntrospectionUtil.isRelatedTo( factory.getInstanceType(), IEditorContext ) == false )
			{
				var existingVisualContexts:Vector.<IContext> = CoreEditor.contextManager.getContextsOfType(IVisualContext);
				for each ( var visualContext:IVisualContext in existingVisualContexts )
				{
					// We've found an existing IVisualContext - tell the viewmanager to switch focus to this, then exit.
					if ( visualContext is factory.getInstanceType() )
					{
						_context = visualContext;
						CoreEditor.viewManager.showVisualContext( visualContext );
						CoreEditor.contextManager.setCurrentContext( visualContext );
						return;
					}
				}
			}
			
			_context = IContext( factory.getInstance() );
			CoreEditor.contextManager.addContext( context );
			if ( _context is IVisualContext )
			{
				visualContext = IVisualContext(_context);
				
				if ( visualContext.view.hasOwnProperty("label") )
				{
					visualContext.view["label"] = factory.getLabel();
				}
				if ( visualContext.view.hasOwnProperty("icon") && Object(factory).hasOwnProperty("icon") )
				{
					visualContext.view["icon"] = factory["icon"];
				}
				CoreEditor.viewManager.addVisualContext(visualContext);
			}
			
			
			CoreEditor.contextManager.setCurrentContext(context);
		}
		
		public function get context():IContext { return _context; }
				
		public function get label():String
		{
			return "Show View";
		}
	}
}