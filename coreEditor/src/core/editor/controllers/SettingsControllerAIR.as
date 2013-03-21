// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.controllers
{
	import core.editor.CoreEditor;
	import core.editor.events.CoreEditorEvent;
	import core.editor.operations.LoadSettingsOperationAIR;
	import core.editor.operations.SaveSettingsOperationAIR;
	
	/**
	 * This controller is created during initialisation of the AIR deployment of BonesEditor. It determines when the settings file is saved/loaded. 
	 * @author Jonathan
	 * 
	 */	
	public class SettingsControllerAIR
	{
		public function SettingsControllerAIR()
		{
			CoreEditor.eventDispatcher.addEventListener(CoreEditorEvent.INIT_COMPLETE, initHandler);
			CoreEditor.eventDispatcher.addEventListener(CoreEditorEvent.CLOSE, closeHandler);
		}
		
		private function initHandler( event:CoreEditorEvent ):void
		{
			var loadSettingsOperation:LoadSettingsOperationAIR = new LoadSettingsOperationAIR( CoreEditor.settingsManager, "preferences.xml" );
			CoreEditor.operationManager.addOperation(loadSettingsOperation);
		}
		
		private function closeHandler( event:CoreEditorEvent ):void
		{
			var saveSettingsOperation:SaveSettingsOperationAIR = new SaveSettingsOperationAIR( CoreEditor.settingsManager, "preferences.xml" );
			CoreEditor.operationManager.addOperation(saveSettingsOperation);
		}
	}
}