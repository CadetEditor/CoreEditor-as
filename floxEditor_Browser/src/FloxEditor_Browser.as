// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import core.app.CoreApp;
	import core.editor.operations.InitializeFloxOperationBrowser;
	import core.editor.ui.components.SplashScreen;
	
	[SWF(backgroundColor="#15181A", frameRate="120")]
	public class CoreEditor_Browser extends Sprite
	{
		private var splashScreen		:SplashScreen;
		
		public function CoreEditor_Browser()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			splashScreen = new SplashScreen();
			splashScreen.x = (stage.stageWidth * 0.5) - splashScreen.width * 0.5;
			splashScreen.y = (stage.stageHeight * 0.5) - splashScreen.height * 0.5;
			addChild( splashScreen );
			
			var configURL:String = "config.xml";
			if ( stage.loaderInfo.parameters.configURL != null )
			{
				configURL = loaderInfo.parameters.configURL;
			}
			
			CoreApp.init();
			
			var initOperation:InitializeFloxOperationBrowser = new InitializeFloxOperationBrowser( stage, configURL );
			initOperation.addEventListener(Event.COMPLETE, initCompleteHandler);
			initOperation.execute();
			
			splashScreen.setOperation(initOperation);
		}
		
		private function initCompleteHandler( event:Event ):void
		{
			removeChild(splashScreen);
		}
	}
}