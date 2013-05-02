// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.controllers
{
	import core.editor.CoreEditor;
	import core.editor.events.CoreEditorEvent;
	import core.editor.operations.LoadSettingsOperationBrowser;
	import core.editor.operations.SaveSettingsOperationBrowser;
	import core.appEx.events.SettingsManagerEvent;
	import core.appEx.events.SettingsManagerEventKind;
	
	/**
	 * This controller is created during initialisation of the browser deployment of BonesEditor. It determines when the settings file is saved/loaded.
	 * Currently we save the settings everytime they are changed. This is perhaps a little overkill, and it may be better to integrate it with some javascript on
	 * the page that fires when the window is about to be closed.
	 * @author Jonathan
	 * 
	 */	
	public class SettingsControllerBrowser
	{
		public function SettingsControllerBrowser()
		{
			CoreEditor.eventDispatcher.addEventListener(CoreEditorEvent.INIT_COMPLETE, initHandler);
			CoreEditor.settingsManager.addEventListener(SettingsManagerEvent.CHANGE, settingsChangeHandler);
		}
		
		private function initHandler( event:CoreEditorEvent ):void
		{
			var loadSettingsOperation:LoadSettingsOperationBrowser = new LoadSettingsOperationBrowser( CoreEditor.settingsManager, CoreEditor.config.applicationID );
			CoreEditor.operationManager.addOperation(loadSettingsOperation);
		}
		
		private function settingsChangeHandler( event:SettingsManagerEvent ):void
		{
			if ( event.kind == SettingsManagerEventKind.UPDATE )
			{
				var saveSettingsOperation:SaveSettingsOperationBrowser = new SaveSettingsOperationBrowser( CoreEditor.settingsManager, CoreEditor.config.applicationID );
				CoreEditor.operationManager.addOperation(saveSettingsOperation);
			}
		}
	}
}