// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.controllers
{
	import flox.editor.FloxEditor;
	import flox.editor.events.FloxEditorEvent;
	import flox.editor.operations.LoadSettingsOperationBrowser;
	import flox.editor.operations.SaveSettingsOperationBrowser;
	import flox.app.events.SettingsManagerEvent;
	import flox.app.events.SettingsManagerEventKind;
	
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
			FloxEditor.eventDispatcher.addEventListener(FloxEditorEvent.INIT_COMPLETE, initHandler);
			FloxEditor.settingsManager.addEventListener(SettingsManagerEvent.CHANGE, settingsChangeHandler);
		}
		
		private function initHandler( event:FloxEditorEvent ):void
		{
			var loadSettingsOperation:LoadSettingsOperationBrowser = new LoadSettingsOperationBrowser( FloxEditor.settingsManager, FloxEditor.config.applicationID );
			FloxEditor.operationManager.addOperation(loadSettingsOperation);
		}
		
		private function settingsChangeHandler( event:SettingsManagerEvent ):void
		{
			if ( event.kind == SettingsManagerEventKind.UPDATE )
			{
				var saveSettingsOperation:SaveSettingsOperationBrowser = new SaveSettingsOperationBrowser( FloxEditor.settingsManager, FloxEditor.config.applicationID );
				FloxEditor.operationManager.addOperation(saveSettingsOperation);
			}
		}
	}
}