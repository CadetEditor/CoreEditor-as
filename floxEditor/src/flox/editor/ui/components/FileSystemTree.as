// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.ui.components
{
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
	import flox.ui.components.Tree;
	import flox.ui.events.TreeEvent;

	public class FileSystemTree extends Tree
	{
		public var fileSystemProvider		:IFileSystemProvider;
		private var rootNode				:FileSystemNode;
		private var _resourceManager	:ResourceManager;
		
		public function FileSystemTree()
		{
			
		}
		
		override protected function init():void
		{
			super.init();
						
			this.doubleClickEnabled = true;
			
			_dataDescriptor = new FileSystemTreeDataDescriptor();
			_showRoot = false;
			
			addEventListener( TreeEvent.ITEM_OPEN, itemOpenHandler );
			
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
		
		override public function set dataProvider(value:Object):void
		{
			if ( value != null && value is FileSystemNode == false )
			{
				throw( new Error( "FileSystemTree only supports a FileSystemNode as its dataProvider" ) );
				return;
			}
			
			rootNode = value as FileSystemNode;
			super.dataProvider = rootNode;
			
			
			if ( !value ) return;
			validateNow();
			
			var children:ArrayCollection = FileSystemNode(value).children;
			for ( var i:int = 0; i < children.length; i++ )
			{
				var child:FileSystemNode = children[i];
				setItemOpened(child, true, true);
				
				if ( i == 0 )
				{
					selectedItem = child;
				}
			}
		}
		
		
		/**
		 * Adds functionality for automatically getting a directories's contents from the IFileSystemProvider when opening
		 * a folder node.
		 * TODO: Handle error scenerios
		 * @param event
		 * 
		 */		
		private function itemOpenHandler( event:TreeEvent ):void
		{
			if ( !fileSystemProvider ) return;
			
			var item:FileSystemNode = event.item as FileSystemNode;
			if ( !item ) return;
			if ( item.uri.isDirectory() )
			{
				if ( item.isPopulated ) return;
				
				var operation:IGetDirectoryContentsOperation = fileSystemProvider.getDirectoryContents(item.uri);
				operation.execute();
			}
		}
		
		public function set selectedFile( uri:URI ):void
		{
			if ( _dataProvider == null ) return;
			var node:FileSystemNode = rootNode.getChildWithPath( uri.path, true );
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
		
		public function get selectedFolder():URI
		{
			var uri:URI = selectedFile;
			if ( !uri ) return null;
			if ( uri.isDirectory() ) return uri;
			var parentURI:URI = uri.getParentURI();
			return parentURI;
		}
	}
}