// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.utils
{
	import flox.app.FloxApp;
	import flox.app.core.contexts.IContext;
	import flox.app.core.contexts.ISelectionContext;
	import flox.app.resources.IResource;
	import flox.app.resources.ITargetedResource;
	import flox.app.util.ArrayUtil;
	import flox.app.util.IntrospectionUtil;
	import flox.editor.FloxEditor;
	
	public class FloxEditorUtil
	{
		static public function getCurrentSelection( contextType:Class, selectionType:Class ):Array
		{
			if ( contextType == null ) contextType = ISelectionContext;
			var context:IContext = FloxEditor.contextManager.getLatestContextOfType(contextType);
			if ( context is ISelectionContext == false ) return [];
			if ( selectionType == null ) selectionType = Object;
			return ArrayUtil.filterByType( ISelectionContext( context ).selection.source, selectionType );
		}
		
		
		static public function getTargetedResources( target:* ):Array
		{
			var resources:Vector.<IResource> = FloxApp.resourceManager.getResourcesOfType(ITargetedResource);
			
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