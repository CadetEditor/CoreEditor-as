// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.ui.panels
{
	import flash.events.Event;
	
	import flox.ui.util.FloxDeserializer;
	
	import flox.editor.FloxEditor;
	import flox.ui.components.Canvas;
	import flox.ui.components.List;
	import flox.editor.ui.components.FileTemplateItemRenderer;
	import flox.editor.ui.components.RecentFileItemRenderer;

	public class WelcomePanel extends Canvas
	{
		[Embed( source='../assets/welcomeHeader.png' )]
		public var WelcomeHeaderBitmap	:Class;
		
		public var recentFileList	:List;
		public var fileTemplateList	:List;
		
		public function WelcomePanel()
		{
			
		}
		
		override protected function init():void
		{
			super.init();
			
			var xml:XML = 
			<Canvas width="650" height="460" >
				<Image source="flox.editor.ui.panels.WelcomePanel_WelcomeHeaderBitmap" width="100%" height="104"/>
				<HBox width="100%" height="100%" paddingLeft="12" paddingRight="12" paddingTop="12" paddingBottom="24" spacing="20">
					<VBox width="100%" height="100%" spacing="12">
						<Label text="Open a Recent Item"/>
						<HRule width="100%"/>
						<List width="100%" height="100%" id="recentFileList" showBorder="false" padding="0" />
					</VBox>
					
					<!--<VRule height="100%"/>-->
					
					<VBox width="100%" height="100%" spacing="12">
						<Label text="New from Template"/>
						<HRule width="100%"/>
						<List width="100%" height="100%" id="fileTemplateList" showBorder="false" itemRendererClass="flox.editor.ui.components.FileTemplateItemRenderer" padding="0"/>
					</VBox>
				</HBox>
				
				<layout>
					<VerticalLayout spacing="16" />
				</layout>
			</Canvas>
			
			FloxDeserializer.deserialize( xml, this );
			recentFileList.itemRendererClass = RecentFileItemRenderer;
			fileTemplateList.itemRendererClass = FileTemplateItemRenderer;
		}
	}
}