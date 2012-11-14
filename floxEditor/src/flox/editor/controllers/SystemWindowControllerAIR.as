// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.controllers
{
	import flash.display.NativeWindow;
	import flash.display.NativeWindowDisplayState;
	import flash.events.Event;
	
	import flox.editor.FloxEditor;
	import flox.editor.entities.Commands;
	import flox.editor.events.FloxEditorEvent;
	
	/**
	 * This controller is only created when the AIR version of the BonesEditor is initialised (See flox.editor.operations.InitialiseBonesOperationAIR)
	 * It provides the behaviour expected of a Window when using a custom chrome (minimise, maximise, title bar dragging ect).
	 * @author Jonathan
	 * 
	 */	
	public class SystemWindowControllerAIR
	{
		private var nativeWindow			:NativeWindow;
				
		public function SystemWindowControllerAIR()
		{
			nativeWindow = FloxEditor.stage.nativeWindow;
			nativeWindow.addEventListener(Event.CLOSING, closingNativeWindowHandler);
		}
		
		private function closingNativeWindowHandler( event:Event ):void
		{
			event.preventDefault();
			FloxEditor.eventDispatcher.dispatchEvent( new FloxEditorEvent( FloxEditorEvent.CLOSE ) );
			FloxEditor.commandManager.executeCommand( Commands.CLOSE_APPLICATION );
		}
	}
}