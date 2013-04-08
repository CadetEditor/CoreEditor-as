// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.ui.panels
{
	import flash.events.Event;
	
	import core.app.CoreApp;
	import core.editor.ui.components.FileSystemTree;
	import core.ui.components.Button;
	import core.ui.components.Panel;
	import core.ui.util.CoreDeserializer;

	public class SelectFilePanel extends Panel
	{
		public var tree				:FileSystemTree;
		public var okBtn			:Button;
		public var cancelBtn		:Button;
		
		public var validSelectionIsFolder	:Boolean = true;
		public var validSelectionIsFile		:Boolean = false;
		
		public function SelectFilePanel()
		{
			
		}
		
		override protected function init():void
		{
			super.init();
			
			var xml:XML = 
			<Panel width="500" height="500">
				
				<FileSystemTree id="tree" width="100%" height="100%"/>
			
				<controlBar>
					<Button label="OK" id="okBtn"/>
					<Button label="Cancel" id="cancelBtn"/>
				</controlBar>
				
			</Panel>
				
			CoreDeserializer.deserialize( xml, this, ["core.editor.ui.components"] );
				
			tree.resourceManager = CoreApp.resourceManager;
			tree.fileSystemProvider = CoreApp.fileSystemProvider;
			tree.dataProvider = CoreApp.fileSystemProvider.fileSystem;
			tree.addEventListener( Event.CHANGE, treeChangeHandler );
			defaultButton = okBtn;
			validateInput();
		}
		
		private function treeChangeHandler( event:Event ):void
		{
			validateInput();
		}
		
		public function validateInput():void
		{
			okBtn.enabled = tree.selectedFile != null;
		}
	}
}