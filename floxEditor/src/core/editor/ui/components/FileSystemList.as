package core.editor.ui.components
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import core.app.CoreApp;
	import core.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import core.app.core.managers.fileSystemProviders.operations.IGetDirectoryContentsOperation;
	import core.app.entities.FileSystemNode;
	import core.app.entities.URI;
	import core.app.managers.ResourceManager;
	import core.data.ArrayCollection;
	import core.editor.ui.data.FileSystemTreeDataDescriptor;
	import core.ui.components.List;
	import core.ui.components.ListItemRenderer;
	
	public class FileSystemList extends List
	{
		public var fileSystemProvider		:IFileSystemProvider;
		private var _rootNode				:FileSystemNode;
		private var _resourceManager		:ResourceManager;
		
		public static const DATA_PROVIDER_BEGIN_CHANGE:String = "dataProviderBeginChange";
		public static const DATA_PROVIDER_CHANGED:String = "dataProviderChanged";
		
		private var _tempDP					:Object;
		
		public var validExtensions			:Array;
		
		public function FileSystemList()
		{
			
		}
		
		override protected function init():void
		{
			super.init();
			
			this.doubleClickEnabled = true;
			
			_dataDescriptor = new FileSystemTreeDataDescriptor();
			
			addEventListener( MouseEvent.DOUBLE_CLICK, itemDoubleClickHandler );
			
			fileSystemProvider = CoreApp.fileSystemProvider;
			resourceManager = CoreApp.resourceManager;
		}
		
		public function set resourceManager( value:ResourceManager ):void
		{
			_resourceManager = value;
			dataDescriptor = new FileSystemTreeDataDescriptor(value);
		}
		public function get resourceManager():ResourceManager { return _resourceManager; }
		
		private function itemDoubleClickHandler( event:MouseEvent ):void
		{
			//trace("itemDoubleClickHandler "+event.target);
			
			if ( !fileSystemProvider ) return;
			
			var item:FileSystemNode = ListItemRenderer(event.target).data as FileSystemNode;
			if ( !item ) return;
			if ( item.uri.isDirectory() )
			{
				dataProvider = item;
				
				//if ( item.isPopulated ) return;
				
				selectedFile = null;
				
//				var operation:IGetDirectoryContentsOperation = fileSystemProvider.getDirectoryContents(item.uri);
//				operation.execute();
			} else {
				selectedFile = item.uri;
			}
		}
		
		override public function set dataProvider( value:Object ):void
		{
			dispatchEvent( new Event(DATA_PROVIDER_BEGIN_CHANGE) );
			
			if ( value != null && value is FileSystemNode )
			{
				var item:FileSystemNode = FileSystemNode(value);
				//TODO: Not sure this is the best way to solve the "initial node not populated" problem.
				// Does it matter that the value is set below and this operation is asynchronous?
				if (!item.isPopulated) {
					var operation:IGetDirectoryContentsOperation = fileSystemProvider.getDirectoryContents(item.uri);
					operation.addEventListener( Event.COMPLETE, directoryListingCompleteHandler );
					operation.execute();
					
					_tempDP = value;
					return;
				}
				_rootNode = item;
				//item.children.source = item.children.source.filter(filterFunc);
				value = filteredChildren(item.children);
				//value = item.children;
			}
			
			super.dataProvider = value;
			
			dispatchEvent( new Event(DATA_PROVIDER_CHANGED) );
		}
		
		private function directoryListingCompleteHandler( event:Event ):void
		{
			dataProvider = _tempDP;
		}
		
		private function filteredChildren( aC:ArrayCollection ):ArrayCollection
		{
			var newAC:ArrayCollection = new ArrayCollection();
			
			for ( var i:uint = 0; i < aC.length; i ++ ) {
				var node:FileSystemNode = aC[i];
				
				if ( node.uri.isDirectory() ) {
					newAC.addItem(node);
				} else {
					for ( var j:uint = 0; j < validExtensions.length; j ++ ) {
						var extension:String = validExtensions[j];
						if ( node.extension == extension ) {
							newAC.addItem(node);
							continue;
						}
					}
				}
			}
			
			return newAC;
		}
		
		public function set selectedFile( uri:URI ):void
		{
			if ( uri == null) return;
			if ( _dataProvider == null ) return;
			var node:FileSystemNode = _rootNode.getChildWithPath( uri.path, true );
			if ( !node ) return;
			selectedItems = [node];
		}
		public function get selectedFile():URI
		{
			if ( _selectedItems.length == 0 )
			{
				return null;
			}
			var item:FileSystemNode = _selectedItems[0] as FileSystemNode;
			if ( !item ) return null;
			return new URI(item.path);
		}
		
		public function get selectedFolderURI():URI
		{
//			var uri:URI = selectedFile;
//			if ( !uri ) return null;
//			if ( uri.isDirectory() ) return uri;
//			var parentURI:URI = uri.getParentURI();
//			return parentURI;
			
			if ( !_rootNode ) return null;
			return _rootNode.uri;
		}
		
		public function get rootNode():FileSystemNode
		{
			return _rootNode;
		}
	}
}