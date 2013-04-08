// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.ui.panels
{
	import core.ui.util.CoreDeserializer;
	import core.ui.components.Button;
	import core.ui.components.Panel;
	import core.ui.components.TextInput;

	public class ErrorPanel extends Panel
	{
		public var infoField		:TextInput;
		public var errorBtn			:Button;
		public var sendBtn			:Button;
		public var dontSendBtn 		:Button;
		
		public function ErrorPanel()
		{
			
		}
		
		override protected function init():void
		{
			super.init();
			
			var xml:XML = 
			<Panel width="460" height="480" label="Bones">
				
				<VBox width="100%" height="100%">
					<TextArea text="Bones has encountered a problem. We are very sorry for the inconvenience.&#xa;&#xa;You should save your work and restart BonesEditor. Bones may continue to function after this, but may have further problems if you do not restart the program.&#xa;&#xa;We have created an error report which will help us to improve BonesEditor. We will treat this report as confidential and anonymous. No personal data will be transmitted other than what you provide to us." 
								editable="false"
								resizeToContent="true"/>
					<Label text="What were you doing when the problem happened?"/>
					<InputField id="infoField" height="70" multiline="true"/>
			
			
					<HBox width="100%" resizeToContent="true">
						<Label text="Email address (options):"/>
						<InputField id="emailField" width="100%"/>
					</HBox>
			
					<Button label="To see the error report, click here" id="errorBtn"/>
			
				</VBox>
			
				<controlBar>
					<Button label="Don't Send" id="sendBtn"/>
					<Button label="Send" id="dontSendBtn"/>
				</controlBar>
				
			</Panel>
				
			CoreDeserializer.deserialize( xml, this );
			defaultButton = sendBtn;
		}
	}
}