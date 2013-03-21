// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.ui.components
{
	import core.ui.util.FloxDeserializer;
	
	import core.app.core.operations.IAsynchronousOperation;
	import core.app.events.OperationProgressEvent;
	import core.ui.components.Image;
	import core.ui.components.Label;
	import core.ui.components.ProgressBar;
	import core.ui.components.UIComponent;
	
	public class SplashScreen extends UIComponent
	{
		[Embed( source='../assets/splash_cadet.png' )]
		public static var SplashScreenBitmap	:Class;
		
		// Child elements
		public var image		:Image;
		public var progressBar	:ProgressBar;
		public var loadingLabel	:Label;
		
		// Properties
		private var operation:IAsynchronousOperation
		
		public function SplashScreen()
		{
			
		}
		
		override protected function init():void
		{
			var xml:XML =
			<UIComponent width="640" height="360">
				<Image source="core.editor.ui.components.SplashScreen::SplashScreenBitmap" />
				<ProgressBar id="progressBar" x="10" y="300" width="200" height="10"/>
				<Label id="loadingLabel" x="10" y="280" width="570" height="60" text="Loading..." fontColor="0xFFFFFF" />
			</UIComponent>
			
			FloxDeserializer.deserialize(xml, this);
			//loadingLabel.width = 570;
			loadingLabel.height = 40;
			loadingLabel.resizeToContentWidth = false;
			loadingLabel.resizeToContentHeight = false;
			
			validateNow();
		}
		
		public function setOperation( operation:IAsynchronousOperation ):void
		{
			this.operation = operation;
			operation.addEventListener( OperationProgressEvent.PROGRESS, progressHandler );
		}
		
		private function progressHandler( event:OperationProgressEvent ):void
		{
			progressBar.progress = event.progress;
			loadingLabel.text = operation.label;
		}
	}
}