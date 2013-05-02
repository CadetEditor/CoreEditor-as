// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.operations
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import core.app.core.operations.IAsynchronousOperation;
	import core.appEx.icons.CoreIcons;
	import core.app.managers.ResourceManager;
	import core.app.resources.FactoryResource;
	import core.app.util.IntrospectionUtil;
	import core.app.util.swfClassExplorer.SwfClassExplorer;
	import core.app.util.swfClassExplorer.data.Traits;

	/**
	 * This operation uses the SwfClassExplorer class to parse through the bytes of a SWF. For each class deifnition it finds
	 * it adds a Factory to the ResourceManager.
	 * This operation is usually used to parse a SWF exported from the Flash IDE. Each item in the library with an export ID will
	 * be found by this operation and added as a resource. For this reason the operation also has some behaviour to auto
	 * assign an appropriate icon to the Factory depending on what type of library class it is (ie MovieClip, Sound etc).
	 * @author Jonathan
	 * 
	 */	
	public class LoadSWFAssetResourcesOperation extends EventDispatcher implements IAsynchronousOperation
	{
		private var swfBytes		:ByteArray;
		private var resourceManager	:ResourceManager;
		private var appDomain		:ApplicationDomain;
		
		public function LoadSWFAssetResourcesOperation( swfBytes:ByteArray, resourceManager:ResourceManager)
		{
			this.swfBytes = swfBytes;
			this.resourceManager = resourceManager;
		}
		
		public function execute():void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
			var context:LoaderContext = new LoaderContext();
			context.applicationDomain = appDomain = ApplicationDomain.currentDomain;
			try
			{
				context["allowLoadBytesCodeExecution"] = true;
			}
			catch( e:Error ) {}
			loader.loadBytes(swfBytes, context);
		}
		
		private function loadCompleteHandler( event:Event ):void
		{
			var classPaths:Vector.<String> = SwfClassExplorer.getClassNames(swfBytes);
			for each ( var classPath:String in classPaths )
			{
				var type:Class = Class( appDomain.getDefinition(classPath) );
				
				var icon:Class;
				var constructorParams:Array = null;
				if ( IntrospectionUtil.doesTypeExtend(type, BitmapData) )
				{
					icon = CoreIcons.Bitmap;
					constructorParams = [0,0];
				}
				else if ( IntrospectionUtil.doesTypeExtend(type, DisplayObject) )
				{
					icon = CoreIcons.MovieClip;
				}
				else if ( IntrospectionUtil.doesTypeExtend(type, Sound) )
				{
					icon = CoreIcons.Sound;
				}
				
				var factory:FactoryResource = new FactoryResource( type, IntrospectionUtil.getClassName(type), icon, constructorParams );
				resourceManager.addResource(factory);
			}
			
			dispatchEvent( new Event(Event.COMPLETE) );
		}
		
		public function get label():String
		{
			return "Load SWF Asset Resources";
		}
	}
}