// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.operations
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import core.editor.resources.FileTemplate;
	import core.app.core.operations.IOperation;
	import core.appEx.resources.FileType;
	import core.app.resources.IResource;
	import core.app.entities.URI;
	import core.app.managers.ResourceManager;
	import core.appEx.util.VectorUtil;
	
	public class GetCompatibleFileTemplatesOperation extends EventDispatcher implements IOperation
	{
		private var resourceManager				:ResourceManager;
		private var _compatibleFileTemplates	:Vector.<IResource>;
		
		public function GetCompatibleFileTemplatesOperation( resourceManager:ResourceManager )
		{
			this.resourceManager = resourceManager;
		}
		
		public function execute():void
		{
			// Grab all FileTemplate resources
			_compatibleFileTemplates = resourceManager.getResourcesOfType(FileTemplate);
			
			// Filter out any templates without associated file types
			var fileTypes:Vector.<IResource> = resourceManager.getResourcesOfType(FileType);
			for ( var i:int = 0; i < _compatibleFileTemplates.length; i++ )
			{
				var fileTemplate:FileTemplate = FileTemplate(_compatibleFileTemplates[i]);
				var extension:String = new URI( fileTemplate.url ).getExtension(true);
				var found:Boolean = false;
				for each ( var currentFileType:FileType in fileTypes )
				{
					
					if ( currentFileType.extension == extension )
					{
						found = true;
						break;
					}
				}
				
				if ( !found )
				{
					_compatibleFileTemplates.splice(i,1);
					i--;
				}
			}
		}
		
		public function get compatibleFileTemplates():Array
		{
			return VectorUtil.toArray(_compatibleFileTemplates.concat());
		}
		
		public function get label():String
		{
			return "Get Compatible File Templates";
		}
	}
}