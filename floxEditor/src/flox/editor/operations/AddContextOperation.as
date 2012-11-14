// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.operations
{
	import flox.ui.util.BindingUtil;
	
	import flox.editor.FloxEditor;
	import flox.editor.contexts.IEditorContext;
	import flox.editor.core.IViewContainer;
	import flox.app.core.contexts.IContext;
	import flox.app.core.contexts.IVisualContext;
	import flox.app.core.operations.IOperation;
	import flox.app.resources.IFactoryResource;
	import flox.app.resources.IResource;
	import flox.app.util.IntrospectionUtil;
	
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
				var existingVisualContexts:Vector.<IContext> = FloxEditor.contextManager.getContextsOfType(IVisualContext);
				for each ( var visualContext:IVisualContext in existingVisualContexts )
				{
					// We've found an existing IVisualContext - tell the viewmanager to switch focus to this, then exit.
					if ( visualContext is factory.getInstanceType() )
					{
						_context = visualContext;
						FloxEditor.viewManager.showVisualContext( visualContext );
						FloxEditor.contextManager.setCurrentContext( visualContext );
						return;
					}
				}
			}
			
			_context = IContext( factory.getInstance() );
			FloxEditor.contextManager.addContext( context );
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
				FloxEditor.viewManager.addVisualContext(visualContext);
			}
			
			
			FloxEditor.contextManager.setCurrentContext(context);
		}
		
		public function get context():IContext { return _context; }
				
		public function get label():String
		{
			return "Show View";
		}
	}
}