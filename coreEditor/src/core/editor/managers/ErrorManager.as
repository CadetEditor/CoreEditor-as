// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.managers
{
	import flash.events.ErrorEvent;
	import flash.events.UncaughtErrorEvent;
	
	import core.ui.components.Alert;
	
	import core.editor.CoreEditor;
	
	public class ErrorManager
	{
		public function ErrorManager()
		{
			CoreEditor.stage.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
		}
		
		private function uncaughtErrorHandler( event:UncaughtErrorEvent ):void
		{
			var text:String
			if ( event.error is ErrorEvent )
			{
				text = ErrorEvent(event.error).text;
			}
			else if ( event.error is Error )
			{
				text = Error(event.error).message;
			}
			
			Alert.show( text, "An error has occured", ["OK"] );
			trace("Error : " + text);
			throw( new Error( text ) );
		}
		/*
		public function buildErrorReport( error:Error ):String
		{
			var str:String = ""
			str += error.errorID + " " + error.name + "\n";
			str += error.message + "\n\n";
			str += error.getStackTrace() + "\n\n";
			
			return str;
		}
		
		public function sendErrorReport( errorReport:String ):void
		{
			
		}
		
		// TODO - implement FileSystemProviderErrorEvent which also has a uri parameter.
		private function fileSystemErrorHandler( event:ErrorEvent ):void
		{
			if ( event.isDefaultPrevented() ) return;
			var additionalDetail:String = "";
			switch ( event.errorID )
			{
				case FileSystemErrorCodes.CREATE_DIRECTORY_ERROR :
					additionalDetail = "Create directory failed : ";
					break;
			}
			handleErrorEvent( event, additionalDetail );
		}
		
		private function operationErrorHandler( event:ErrorEvent ):void
		{
			if ( event.isDefaultPrevented() ) return;
			handleErrorEvent( event );
		}
		*/
		
		/*
		protected function openWindow():void
		{
			window = new ErrorDialog()
			Bones.view.addPopUp(window);
			window.sendBtn.addEventListener( MouseEvent.CLICK, clickSendHandler );
			window.dontSendBtn.addEventListener( MouseEvent.CLICK, clickDontSendHandler )
			window.errorBtn.addEventListener( MouseEvent.CLICK, clickShowErrorReportHandler );
		}
		
		protected function closeWindow():void
		{
			Bones.view.removePopUp( window );
			window.sendBtn.removeEventListener( MouseEvent.CLICK, clickSendHandler );
			window.dontSendBtn.removeEventListener( MouseEvent.CLICK, clickDontSendHandler )
			window.errorBtn.removeEventListener( MouseEvent.CLICK, clickShowErrorReportHandler );
			window = null
		}
		
		protected function clickSendHandler( event:MouseEvent ):void
		{
			closeWindow();
		}
		
		protected function clickDontSendHandler( event:MouseEvent ):void
		{
			closeWindow();
		}
		
		protected function clickShowErrorReportHandler( event:MouseEvent ):void
		{
			if ( errorReportWindow ) 
			{
				PopUpManager.bringToFront( errorReportWindow );
				return;
			}
			
			errorReportWindow = new ErrorReportWindow();
			Bones.view.addPopUp(errorReportWindow);
			errorReportWindow.addEventListener( CloseEvent.CLOSE, closeErrorReportWindow );
			errorReportWindow.textArea.text = errorReport;
		}
		
		protected function closeErrorReportWindow( event:CloseEvent ):void
		{
			Boens.view.removePopUp( ErrorReportWindow( event.target ) );
			errorReportWindow.removeEventListener( CloseEvent.CLOSE, closeErrorReportWindow );
			errorReportWindow = null;
		}
		*/
		
	}
}