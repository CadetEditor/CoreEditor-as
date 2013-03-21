// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.ui.panels
{
	import flash.events.Event;
	
	import core.ui.util.FloxDeserializer;
	
	import core.editor.CoreEditor;
	import core.ui.components.Button;
	import core.ui.components.Panel;
	import core.editor.ui.components.FileSystemTree;

	public class FileSystemTreeBrowserPanel extends Panel
	{
		public var tree				:FileSystemTree;
		public var okBtn			:Button;
		public var cancelBtn		:Button;
		
		private var _validSelectionIsFolder	:Boolean = true;
		private var _validSelectionIsFile		:Boolean = false;
		
		public function FileSystemTreeBrowserPanel()
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
				
			FloxDeserializer.deserialize( xml, this, ["core.editor.ui.components"] );
			
			tree.addEventListener( Event.CHANGE, treeChangeHandler );
			defaultButton = okBtn;
			validateInput();
		}
		
		private function treeChangeHandler( event:Event ):void
		{
			validateInput();
		}
		
		private function validateInput():void
		{
			var valid:Boolean = true;
			if ( validSelectionIsFile )
			{
				valid = tree.selectedFile != null && (validSelectionIsFolder || tree.selectedFile.isDirectory() == false);
			}
			if ( valid && validSelectionIsFolder )
			{
				valid = tree.selectedFolder != null;
			}
			
			okBtn.enabled = valid;
		}

		public function get validSelectionIsFolder():Boolean
		{
			return _validSelectionIsFolder;
		}

		public function set validSelectionIsFolder(value:Boolean):void
		{
			_validSelectionIsFolder = value;
			validateInput();
		}

		public function get validSelectionIsFile():Boolean
		{
			return _validSelectionIsFile;
		}

		public function set validSelectionIsFile(value:Boolean):void
		{
			_validSelectionIsFile = value;
			validateInput();
		}


	}
}