// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.operations
{
	import flash.net.SharedObject;
	
	import core.app.core.operations.IOperation;
	import core.appEx.managers.SettingsManager;

	public class LoadSettingsOperationBrowser implements IOperation
	{
		private var settingsManager		:SettingsManager;
		private var applicationID		:String;
		
		public function LoadSettingsOperationBrowser( settingsManager:SettingsManager, applicationID:String )
		{
			this.settingsManager = settingsManager;
			this.applicationID = applicationID;
		}
		
		public function execute():void
		{
			var sharedObject:SharedObject = SharedObject.getLocal("org.bonesframework." + applicationID + ".settings");
			if ( sharedObject.data.xml == null ) return;
			var xml:XML = XML( sharedObject.data.xml );
			settingsManager.load(xml);
		}
		
		public function get label():String { return "Load settings"; }
	}
}