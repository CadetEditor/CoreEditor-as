// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.controllers
{
	import flash.display.NativeWindow;
	import flash.events.Event;
	
	import core.editor.CoreEditor;
	import core.editor.entities.Commands;
	import core.editor.events.CoreEditorEvent;
	
	/**
	 * This controller is only created when the AIR version of the BonesEditor is initialised (See core.editor.operations.InitialiseBonesOperationAIR)
	 * It provides the behaviour expected of a Window when using a custom chrome (minimise, maximise, title bar dragging ect).
	 * @author Jonathan
	 * 
	 */	
	public class SystemWindowControllerAIR
	{
		private var nativeWindow			:NativeWindow;
				
		public function SystemWindowControllerAIR()
		{
			nativeWindow = CoreEditor.stage.nativeWindow;
			nativeWindow.addEventListener(Event.CLOSING, closingNativeWindowHandler);
		}
		
		private function closingNativeWindowHandler( event:Event ):void
		{
			event.preventDefault();
			CoreEditor.eventDispatcher.dispatchEvent( new CoreEditorEvent( CoreEditorEvent.CLOSE ) );
			CoreEditor.commandManager.executeCommand( Commands.CLOSE_APPLICATION );
		}
	}
}