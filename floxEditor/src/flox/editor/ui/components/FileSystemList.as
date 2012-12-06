package flox.editor.ui.components
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flox.app.FloxApp;
	import flox.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import flox.app.core.managers.fileSystemProviders.operations.IGetDirectoryContentsOperation;
	import flox.app.entities.FileSystemNode;
	import flox.app.entities.URI;
	import flox.app.managers.ResourceManager;
	import flox.app.resources.FileType;
	import flox.app.resources.IResource;
	import flox.core.data.ArrayCollection;
	import flox.editor.ui.data.FileSystemTreeDataDescriptor;
	import flox.ui.components.List;
	import flox.ui.components.ListItemRenderer;
	import flox.ui.events.ListEvent;
	
	import mx.controls.listClasses.IListItemRenderer;
	
	public class FileSystemList extends List
	{
		public var fileSystemProvider		:IFileSystemProvider;
		private var _rootNode				:FileSystemNode;
		private var _resourceManager		:ResourceManager;
		
		public static const DATA_PROVIDER_BEGIN_CHANGE:String = "dataProviderBeginChange";
		public static const DATA_PROVIDER_CHANGED:String = "dataProviderChanged";
		
		public function FileSystemList()
		{
			
		}
		
		override protected function init():void
		{
			super.init();
			
			this.doubleClickEnabled = true;
			
			_dataDescriptor = new FileSystemTreeDataDescriptor();
			
			addEventListener( MouseEvent.DOUBLE_CLICK, itemDoubleClickHandler );
			
			fileSystemProvider = FloxApp.fileSystemProvider;
			resourceManager = FloxApp.resourceManager;
		}
		
		public function set resourceManager( value:ResourceManager ):void
		{
			_resourceManager = value;
			var fileTypes:Vector.<IResource> = value.getResourcesOfType(FileType);
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
				
				if ( item.isPopulated ) return;
				
				selectedFile = null;
				
				var operation:IGetDirectoryContentsOperation = fileSystemProvider.getDirectoryContents(item.uri);
				operation.execute();
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
					operation.execute();
				}
				_rootNode = item;
				value = item.children;
			}
			
			super.dataProvider = value;
			
			dispatchEvent( new Event(DATA_PROVIDER_CHANGED) );
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