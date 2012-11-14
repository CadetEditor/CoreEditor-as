// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.operations
{
	import flash.errors.IllegalOperationError;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	
	import flox.editor.FloxEditor;
	import flox.editor.resources.FileTemplate;
	import flox.editor.utils.FloxEditorUtil;
	import flox.app.core.operations.IOperation;
	import flox.app.managers.ResourceManager;
	import flox.app.util.ArrayUtil;
	import flox.app.util.VectorUtil;
	import org.osmf.utils.URL;
	
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