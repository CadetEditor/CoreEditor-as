// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.ui.panels
{
	import flash.events.Event;
	
	import flox.app.FloxApp;
	import flox.editor.FloxEditor;
	import flox.editor.ui.components.FileSystemTree;
	import flox.ui.components.Button;
	import flox.ui.components.Panel;
	import flox.ui.util.FloxDeserializer;

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
				
			FloxDeserializer.deserialize( xml, this, ["flox.editor.ui.components"] );
				
			tree.resourceManager = FloxApp.resourceManager;
			tree.fileSystemProvider = FloxApp.fileSystemProvider;
			tree.dataProvider = FloxApp.fileSystemProvider.fileSystem;
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