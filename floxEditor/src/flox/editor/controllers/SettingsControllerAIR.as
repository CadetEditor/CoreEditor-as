// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.controllers
{
	import flox.editor.FloxEditor;
	import flox.editor.events.FloxEditorEvent;
	import flox.editor.operations.LoadSettingsOperationAIR;
	import flox.editor.operations.SaveSettingsOperationAIR;
	
	/**
	 * This controller is created during initialisation of the AIR deployment of BonesEditor. It determines when the settings file is saved/loaded. 
	 * @author Jonathan
	 * 
	 */	
	public class SettingsControllerAIR
	{
		public function SettingsControllerAIR()
		{
			FloxEditor.eventDispatcher.addEventListener(FloxEditorEvent.INIT_COMPLETE, initHandler);
			FloxEditor.eventDispatcher.addEventListener(FloxEditorEvent.CLOSE, closeHandler);
		}
		
		private function initHandler( event:FloxEditorEvent ):void
		{
			var loadSettingsOperation:LoadSettingsOperationAIR = new LoadSettingsOperationAIR( FloxEditor.settingsManager, "preferences.xml" );
			FloxEditor.operationManager.addOperation(loadSettingsOperation);
		}
		
		private function closeHandler( event:FloxEditorEvent ):void
		{
			var saveSettingsOperation:SaveSettingsOperationAIR = new SaveSettingsOperationAIR( FloxEditor.settingsManager, "preferences.xml" );
			FloxEditor.operationManager.addOperation(saveSettingsOperation);
		}
	}
}