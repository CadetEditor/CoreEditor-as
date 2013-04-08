// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.ui.panels
{
	import core.ui.util.CoreDeserializer;
	import core.ui.components.Panel;
	import core.ui.components.TextInput;
	
	public class ErrorReportPanel extends Panel
	{
		public var textArea	:TextInput;
		
		public function ErrorReportPanel()
		{
			
		}
		
		override protected function init():void
		{
			super.init();
			
			var xml:XML =
			<Panel width="500" height="600" label="Error Report" showCloseButton="true">
					<InputField id="textArea" multiline="true" width="100%" height="100%"/>
			</Panel>
				
			CoreDeserializer.deserialize( xml, this );
		}
	}
}