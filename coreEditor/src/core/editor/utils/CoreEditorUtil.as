// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.utils
{
	import core.app.CoreApp;
	import core.app.core.contexts.IContext;
	import core.app.core.contexts.ISelectionContext;
	import core.app.resources.IResource;
	import core.app.resources.ITargetedResource;
	import core.app.util.ArrayUtil;
	import core.app.util.IntrospectionUtil;
	import core.editor.CoreEditor;
	
	public class CoreEditorUtil
	{
		static public function getCurrentSelection( contextType:Class, selectionType:Class ):Array
		{
			if ( contextType == null ) contextType = ISelectionContext;
			var context:IContext = CoreEditor.contextManager.getLatestContextOfType(contextType);
			if ( context is ISelectionContext == false ) return [];
			if ( selectionType == null ) selectionType = Object;
			return ArrayUtil.filterByType( ISelectionContext( context ).selection.source, selectionType );
		}
		
		
		static public function getTargetedResources( target:* ):Array
		{
			var resources:Vector.<IResource> = CoreApp.resourceManager.getResourcesOfType(ITargetedResource);
			
			var results:Array = [];
			for ( var i:int = 0; i < resources.length; i++ )
			{
				var resource:ITargetedResource = ITargetedResource(resources[i]);
				if ( IntrospectionUtil.isRelatedTo( target, resource.target ) )
				{
					results.push(resource);
				}
			}
			return results;
		}
	}
}