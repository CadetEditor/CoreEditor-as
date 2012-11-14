// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.operations
{
	import flash.display.Stage;
	
	import flox.editor.controllers.SettingsControllerBrowser;
	import flox.editor.core.FloxEditorEnvironment;
	import flox.editor.utils.FloxEditorUtil;

	public class InitializeFloxOperationBrowser extends InitializeFloxOperation
	{
		public function InitializeFloxOperationBrowser(stage:Stage, configURL:String)
		{
			super(stage, configURL, FloxEditorEnvironment.BROWSER);
		}
		
		override protected function initControllers():void
		{
			super.initControllers();
			new SettingsControllerBrowser();
		}
	}
}