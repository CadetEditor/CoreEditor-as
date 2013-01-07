// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.ui.panels
{	
	import flox.ui.util.FloxDeserializer;
	
	import flox.ui.components.Button;
	import flox.ui.components.List;
	import flox.ui.components.Panel;

	public class OpenWithPanel extends Panel
	{
		public var list				:List;
		public var okBtn			:Button;
		public var cancelBtn		:Button;
		
		public function OpenWithPanel()
		{
			
		}
		
		override protected function init():void
		{
			super.init();
			
			var xml:XML = 
			<Panel width="524" height="400" label="Select File Template">
				
				<List id="list" width="100%" height="100%"/>
				
				<controlBar>
					<Button label="OK" id="okBtn"/>
					<Button label="Cancel" id="cancelBtn"/>
				</controlBar>
				
			</Panel>
				
			FloxDeserializer.deserialize( xml, this );
			defaultButton = okBtn;
		}
	}
}