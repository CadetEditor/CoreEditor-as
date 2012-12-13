// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.ui.panels
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flox.app.FloxApp;
	import flox.app.entities.FileSystemNode;
	import flox.app.entities.URI;
	import flox.app.util.StringUtil;
	import flox.app.util.Validation;
	import flox.editor.FloxEditor;
	import flox.editor.icons.FloxEditorIcons;
	import flox.editor.ui.components.FileSystemList;
	import flox.editor.ui.components.FileSystemTree;
	import flox.ui.components.Button;
	import flox.ui.components.HBox;
	import flox.ui.components.Label;
	import flox.ui.components.TextArea;
	import flox.ui.components.TextInput;
	import flox.ui.util.FloxDeserializer;
	
	//import flux.skins.ToolbarButtonSkin;
	
	public class SaveAsFileListPanel extends FileSystemListBrowserPanel
	{
		public var nameInput		:TextInput;
		
		public function SaveAsFileListPanel( uri:URI, rootURI:URI = null, validExtensions:Array = null )
		{
			super( uri, rootURI, validExtensions );
		}
		
		override protected function init():void
		{
			super.init();

			okBtn.label = "Save";
			
//			<HBox height="28" width="100%">
//				<Label text="File Name:" height="20" y="2"/>
//				<TextInput maxChars="128" id="nameInput" width="100%" restrict="0-9a-zA-Z_" />
//			</HBox>
			
			var hBox:HBox = new HBox();
			hBox.height = 28;
			hBox.percentWidth = 100;
			vBox.addChild(hBox);
			
			var label:Label = new Label();
			label.text = "File Name:";
			label.height = 20;
			label.y = 2;
			hBox.addChild(label);
			
			nameInput = new TextInput();
			nameInput.maxChars = 128;
			nameInput.percentWidth = 100;
			nameInput.restrict = "0-9a-zA-Z_";
			hBox.addChild(nameInput);
			
			nameInput.addEventListener( Event.CHANGE, changeTextHandler );
			
			validateInput();
		}

		override protected function listChangeHandler( event:Event ):void
		{
			nameInput.text = StringUtil.trim( list.selectedFile.getFilename(true) );
			
			super.listChangeHandler(event);
		}

		private function changeTextHandler( event:Event ):void
		{
			nameInput.removeEventListener( Event.CHANGE, changeTextHandler );
			nameInput.text = StringUtil.trim( nameInput.text );
			nameInput.addEventListener( Event.CHANGE, changeTextHandler );
			validateInput();
		}
		
		override protected function validateInput():void
		{
			if (!nameInput) return;
			
			var folderIsSelected:Boolean = list.selectedFolderURI != null;
			var isValidFilename:Boolean = Validation.isValidFilename( nameInput.text );
			okBtn.enabled = isValidFilename && folderIsSelected;
			
			validateFolderPath();
			validateUpButton();
			validateBackButton();
		}
	}
}