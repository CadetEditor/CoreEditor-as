package flox.editor.ui.panels
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flox.app.FloxApp;
	import flox.app.core.managers.fileSystemProviders.operations.ITraverseToDirectoryOperation;
	import flox.app.entities.FileSystemNode;
	import flox.app.entities.URI;
	import flox.editor.icons.FloxEditorIcons;
	import flox.editor.ui.components.FileSystemList;
	import flox.ui.components.Button;
	import flox.ui.components.HBox;
	import flox.ui.components.Panel;
	import flox.ui.components.TextArea;
	import flox.ui.components.VBox;
	import flox.ui.util.FloxDeserializer;
	
	public class FileSystemListBrowserPanel extends Panel
	{
		public var vBox				:VBox;
		public var actionBar		:HBox;
		public var backBtn			:Button;
		public var upBtn			:Button;
		public var folderPath		:TextArea;
		public var list				:FileSystemList;
		public var okBtn			:Button;
		public var cancelBtn		:Button;
		
		private var _validSelectionIsFolder	:Boolean = true;
		private var _validSelectionIsFile	:Boolean = false;
	
		private var initURI:URI;
		private var rootURI:URI;
		
		private var history:Array;
		private var dontAdToHistory:Boolean;
		private var validExtensions:Array;
		
		public function FileSystemListBrowserPanel( uri:URI = null, rootURI:URI = null, validExtensions:Array = null )
		{
			if (!validExtensions) validExtensions = [];
			this.validExtensions = validExtensions;
			
			var node:FileSystemNode = FloxApp.fileSystemProvider.fileSystem;//.children[0];
			
			if (rootURI)	this.rootURI = rootURI;
			else			this.rootURI = node.uri;
			
			if (!uri) 		uri = new URI( rootURI.path );
			
			
			initURI = uri;
			
			history = [];
			
			super();
		}
		
		override protected function init():void
		{
			super.init();
			
			var xml:XML = 
				<Panel width="500" height="500">
					<VBox id="vBox" width="100%" height="100%">
						<HBox id="actionBar" width="100%" height="28">
							<Button id="backBtn" width="28" height="28" toolTip="Back"/>
							<Button id="upBtn" width="28" height="28" toolTip="Up"/>
							<TextArea id="folderPath" width="100%" height="100%"/>
						</HBox>
						<FileSystemList id="list" width="100%" height="100%"/>
					</VBox>
					<controlBar>
						<Button label="OK" id="okBtn"/>
						<Button label="Cancel" id="cancelBtn"/>
					</controlBar>				
				</Panel>
			
			FloxDeserializer.deserialize( xml, this, ["flox.editor.ui.components"] );
			
			list.validExtensions = validExtensions;
			
			upBtn.icon = FloxEditorIcons.OpenFile;
			upBtn.addEventListener(MouseEvent.CLICK, clickUpBtnHandler);
			
			backBtn.icon = FloxEditorIcons.Undo;
			backBtn.addEventListener(MouseEvent.CLICK, backBtnClickHandler);
			
			defaultButton = okBtn;
			
			var node:FileSystemNode = FloxApp.fileSystemProvider.fileSystem.getChildWithPath( initURI.path, true );
			
			trace("initURI "+initURI.path+" node "+node+" root "+FloxApp.fileSystemProvider.fileSystem.children[0].uri.path);
			
			if ( node == null ) {
				var traverseOperation:ITraverseToDirectoryOperation = FloxApp.fileSystemProvider.traverseToDirectory(initURI);
				traverseOperation.addEventListener( Event.COMPLETE, traverseCompleteHandler );
				traverseOperation.execute();
			} else {
				initialiseList( node );
			}
		}
		
		private function initialiseList( node:FileSystemNode ):void
		{
			list.dataProvider = node;
			list.addEventListener( Event.CHANGE, listChangeHandler );
			list.addEventListener( MouseEvent.DOUBLE_CLICK, itemDoubleClickHandler );
			list.addEventListener(FileSystemList.DATA_PROVIDER_BEGIN_CHANGE, dataProviderBeginChangeHandler );
			list.addEventListener(FileSystemList.DATA_PROVIDER_CHANGED, dataProviderChangedHandler );
			validateInput();			
		}
		
		private function traverseCompleteHandler( event:Event ):void
		{
			var node:FileSystemNode = FloxApp.fileSystemProvider.fileSystem.getChildWithPath( initURI.path, true );
			initialiseList( node );
		}
		
		private function clickUpBtnHandler( event:MouseEvent ):void
		{
			var rootNode:FileSystemNode = list.rootNode;
			if (rootNode.parent) {
				list.dataProvider = rootNode.parent;
				validateInput();
			}
		}
		
		private function backBtnClickHandler( event:MouseEvent ):void
		{
			dontAdToHistory = true;
			var node:FileSystemNode = history.pop();
			list.dataProvider = node;
		}
		
		protected function listChangeHandler( event:Event ):void
		{
			validateInput();
		}
		
		private function itemDoubleClickHandler( event:MouseEvent ):void
		{
			validateInput();
		}
		private function dataProviderBeginChangeHandler( event:Event ):void
		{
			if (!dontAdToHistory) {
				history.push( list.rootNode );
			}
			dontAdToHistory = false;
		}
		private function dataProviderChangedHandler( event:Event ):void
		{
			validateInput();
		}
		
		protected function validateInput():void
		{
			var valid:Boolean = true;
			if ( validSelectionIsFile )
			{
				valid = list.selectedFile != null && (validSelectionIsFolder || list.selectedFile.isDirectory() == false);
			}
			if ( valid && validSelectionIsFolder )
			{
				valid = list.selectedFolderURI != null;
			}
			
			okBtn.enabled = valid;
			
			validateFolderPath();
			validateUpButton();
			validateBackButton();
		}
		
		protected function validateFolderPath():void
		{
			if (!list.rootNode) return;
			
			var str:String = list.rootNode.uri.path;
			var maxLength:uint = 60;
			if ( str.length > maxLength )
				str = "..."+str.substring(str.length-maxLength, str.length);
			
			folderPath.text = str;
		}
		protected function validateUpButton():void
		{
			if (list.selectedFolderURI && list.selectedFolderURI.path == rootURI.path) {
				upBtn.enabled = false;
			} else {
				upBtn.enabled = true;
			}
		}
		protected function validateBackButton():void
		{
			if ( history.length ) {
				backBtn.enabled = true;
			} else {
				backBtn.enabled = false;
			}
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






