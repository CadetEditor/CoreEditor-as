// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.operations
{
	import flash.net.SharedObject;
	
	import flox.app.core.operations.IOperation;
	import flox.app.managers.SettingsManager;

	public class SaveSettingsOperationBrowser implements IOperation
	{
		private var settingsManager		:SettingsManager;
		private var applicationID		:String;
		
		public function SaveSettingsOperationBrowser( settingsManager:SettingsManager, applicationID:String )
		{
			this.settingsManager = settingsManager;
			this.applicationID = applicationID;
		}
		
		public function execute():void
		{
			var sharedObject:SharedObject = SharedObject.getLocal("org.bonesframework." + applicationID + ".settings");
			
			sharedObject.data.xml = settingsManager.save().toXMLString();
		}
		
		public function get label():String { return "Save settings"; }
	}
}