// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.app.operations
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import flox.app.core.operations.IUndoableOperation;
	import flox.app.managers.ResourceManager;
	
	public class BindResourceOperation extends EventDispatcher implements IUndoableOperation
	{
		private var resourceManager	:ResourceManager;
		private var host			:Object;
		private var property		:String;
		private var resourceID		:String;
		
		private var previousResourceID	:String;
		
		public function BindResourceOperation( resourceManager:ResourceManager, host:Object, property:String, resourceID:String )
		{
			this.resourceManager = resourceManager;
			this.host = host;
			this.property = property;
			this.resourceID = resourceID;
			
			previousResourceID = resourceManager.getResourceIDForBinding( host, property );
		}
		
		public function execute():void
		{
			if ( resourceID == null )
			{
				resourceManager.unbindResource( host, property );
			}
			else
			{
				resourceManager.bindResource( resourceID, host, property );
			}
		}
		
		public function undo():void
		{
			if ( previousResourceID == null )
			{
				resourceManager.unbindResource( host, property );
			}
			else
			{
				resourceManager.bindResource( previousResourceID, host, property );
			}
		}
		
		public function get label():String
		{
			return "Bind resource";
		}
	}
}