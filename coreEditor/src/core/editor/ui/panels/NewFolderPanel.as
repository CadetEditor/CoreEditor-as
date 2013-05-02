// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.ui.panels
{
	import flash.events.Event;
	
	import core.ui.util.CoreDeserializer;
	
	import core.editor.CoreEditor;
	import core.app.util.StringUtil;
	import core.appEx.util.Validation;
	import core.ui.components.Button;
	import core.ui.components.Panel;
	import core.ui.components.TextInput;
	import core.editor.ui.components.FileSystemTree;

	public class NewFolderPanel extends Panel
	{
		public var tree				:FileSystemTree;
		public var okBtn			:Button;
		public var cancelBtn		:Button;
		public var nameInput		:TextInput;
		
		public var validSelectionIsFolder	:Boolean = true;
		public var validSelectionIsFile		:Boolean = false;
		
		public function NewFolderPanel()
		{
			
		}
		
		override protected function init():void
		{
			super.init();
			
			var xml:XML = 
			<Panel width="500" height="500">
				
				<FileSystemTree id="tree" width="100%" height="100%"/>
			
				<HBox width="100%">
					<Label text="Folder Name:" width="100"/>
					<TextInput text="New Folder" maxChars="128" id="nameInput" width="100%" restrict="0-9a-zA-Z_"/>
				</HBox>
				
				<controlBar>
					<Button label="Cancel" id="cancelBtn"/>
					<Button label="OK" id="okBtn"/>
				</controlBar>
				
			</Panel>
				
			CoreDeserializer.deserialize( xml, this, ["core.editor.ui.components"] );
			defaultButton = okBtn;
			nameInput.addEventListener( Event.CHANGE, nameInputChangeHandler );
				
			validateInput();
		}
		
		private function nameInputChangeHandler( event:Event ):void
		{
			nameInput.removeEventListener( Event.CHANGE, nameInputChangeHandler );
			nameInput.text = StringUtil.trim( nameInput.text );
			nameInput.addEventListener( Event.CHANGE, nameInputChangeHandler );
			
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