// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.ui.panels
{
	import flash.events.Event;
	
	import core.ui.util.FloxDeserializer;
	
	import core.editor.CoreEditor;
	import core.app.util.StringUtil;
	import core.app.util.Validation;
	import core.ui.components.Button;
	import core.ui.components.Panel;
	import core.ui.components.TextInput;
	import core.editor.ui.components.FileSystemTree;
	
	public class SaveAsFilePanel extends Panel
	{
		public var tree				:FileSystemTree;
		public var okBtn			:Button;
		public var cancelBtn		:Button;
		public var nameInput		:TextInput;
		
		public var validSelectionIsFolder	:Boolean = true;
		public var validSelectionIsFile		:Boolean = false;
		
		public function SaveAsFilePanel()
		{
			
		}
		
		override protected function init():void
		{
			super.init();
			
			var xml:XML = 
				<Panel width="500" height="500" label="Save As">
					<VBox width="100%" height="100%">
						<FileSystemTree id="tree" width="100%" height="100%"/>
						<HBox height="28" width="100%">
							<Label text="File Name:" height="20" y="2"/>
							<TextInput maxChars="128" id="nameInput" width="100%" restrict="0-9a-zA-Z_" />
						</HBox>
					</VBox>
					
					<controlBar>
						<Button label="Save" id="okBtn"/>
						<Button label="Cancel" id="cancelBtn"/>
					</controlBar>
				</Panel>
			
			FloxDeserializer.deserialize( xml, this, ["core.editor.ui.components"] );
			
			nameInput.addEventListener( Event.CHANGE, changeTextHandler );
			tree.addEventListener( Event.CHANGE, changeTreeHandler );
			defaultButton = okBtn;
			
			validateInput();
		}
		
		private function changeTextHandler( event:Event ):void
		{
			nameInput.removeEventListener( Event.CHANGE, changeTextHandler );
			nameInput.text = StringUtil.trim( nameInput.text );
			nameInput.addEventListener( Event.CHANGE, changeTextHandler );
			validateInput();
		}
		
		private function changeTreeHandler( event:Event ):void
		{
			nameInput.text = StringUtil.trim( tree.selectedFile.getFilename(true) );
			validateInput();
		}
		
		public function validateInput():void
		{
			var folderIsSelected:Boolean = tree.selectedFolder != null;
			var isValidFilename:Boolean = Validation.isValidFilename( nameInput.text );
			okBtn.enabled = isValidFilename && folderIsSelected;
		}
	}
}