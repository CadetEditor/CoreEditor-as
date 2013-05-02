// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.ui.data
{
	import core.app.resources.IResource;
	import core.appEx.icons.CoreIcons;
	import core.app.util.IntrospectionUtil;
	import core.data.ArrayCollection;
	import core.ui.data.IDataDescriptor;
	
	public class ResourceDataDescriptor implements IDataDescriptor
	{
		public function ResourceDataDescriptor()
		{
			
		}
		
		public function getChildren(node:Object):ArrayCollection
		{
			return null;
		}
		
		public function hasChildren(node:Object):Boolean
		{
			return false;
		}
		
		public function getLabel( item:Object ):String
		{
			if ( item.hasOwnProperty("label") )
			{
				return item.label;
			}
			
			if ( item is IResource )
			{
				return IResource(item).getID();
			}
			
			return IntrospectionUtil.getClassName(item);
		}
		
		public function getIcon( item:Object ):Object
		{
			if ( item.hasOwnProperty("icon") )
			{
				return item.icon;
			}
			return null;
		}
		
		public function getEnabled( item:Object ):Boolean
		{
			return true;
		}
		
		public function getChangeEventTypes( item:Object ):Array
		{
			return [];
		}
	}
}