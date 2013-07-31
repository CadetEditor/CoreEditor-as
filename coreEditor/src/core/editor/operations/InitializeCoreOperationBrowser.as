// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.operations
{
	import flash.display.Stage;
	
	import core.editor.core.CoreEditorEnvironment;
	import core.editor.controllers.SettingsControllerBrowser;

	public class InitializeCoreOperationBrowser extends InitializeCoreOperation
	{
		public function InitializeCoreOperationBrowser(stage:Stage, configURL:String)
		{
			super(stage, configURL, CoreEditorEnvironment.BROWSER);
		}
		
		override protected function initControllers():void
		{
			super.initControllers();
			new SettingsControllerBrowser();
		}
	}
}