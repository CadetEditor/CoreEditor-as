// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.ui.panels
{
	import core.ui.util.CoreDeserializer;
	import core.ui.components.Button;
	import core.ui.components.List;
	import core.ui.components.Panel;

	public class SelectResourcePanel extends Panel
	{
		public var list			:List;
		public var selectNoneBtn:Button;
		public var okBtn:Button;
		public var cancelBtn:Button;
		
		public function SelectResourcePanel()
		{
			
		}
		
		override protected function init():void
		{
			super.init();
			
			var xml:XML = 
			<Panel width="460" height="460" label="Resources">
				
				<VBox width="100%" height="100%">
					<List id="list" width="100%" height="100%"/>
					<Button id="selectNoneBtn" label="Select None" />
				</VBox>
				
				<controlBar>
					<Button label="OK" id="okBtn"/>
					<Button label="Cancel" id="cancelBtn"/>
				</controlBar>
				
			</Panel>
				
			CoreDeserializer.deserialize( xml, this );
			defaultButton = okBtn;
		}
	}
}