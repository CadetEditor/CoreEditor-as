// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.operations
{
	import flash.net.URLLoader;
	
	import core.editor.resources.FileTemplate;
	import core.app.core.operations.IOperation;
	import core.app.managers.ResourceManager;
	
	public class LoadFileTemplatesOperation implements IOperation
	{
		private var resourceManager		:ResourceManager;
		private var templatesXML		:XMLList;
		private var loader				:URLLoader;
		
		public function LoadFileTemplatesOperation( resourceManager:ResourceManager, templatesXML:XMLList )
		{
			this.resourceManager = resourceManager;
			this.templatesXML = templatesXML;
		}
		
		public function execute():void
		{
			for ( var i:int = 0; i < templatesXML.length(); i++ )
			{
				var templateXML:XML = templatesXML[i];
				var fileTemplate:FileTemplate = new FileTemplate();
				fileTemplate.deserialise(templateXML);
				
				resourceManager.addResource( fileTemplate );
			}
		}
		
		public function get label():String
		{
			return "Loading File Templates...";
		}
	}
}