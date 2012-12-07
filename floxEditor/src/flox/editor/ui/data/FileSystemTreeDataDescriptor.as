// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.ui.data
{
	import flox.app.FloxApp;
	import flox.app.entities.FileSystemNode;
	import flox.app.entities.URI;
	import flox.app.icons.FloxIcons;
	import flox.app.managers.ResourceManager;
	import flox.app.resources.ExternalBitmapDataResource;
	import flox.app.resources.FileType;
	import flox.app.resources.IResource;
	import flox.core.data.ArrayCollection;
	import flox.ui.data.IDataDescriptor;
	
	public class FileSystemTreeDataDescriptor implements IDataDescriptor
	{
		static private var fileTypes		:Vector.<IResource>;
		
		public function FileSystemTreeDataDescriptor( resourceManager:ResourceManager = null )
		{
			if ( resourceManager && !fileTypes )
			{
				fileTypes = resourceManager.getResourcesOfType(FileType);
				var types:Vector.<IResource> = fileTypes;
			}
		}
		
		public function getChildren(item:Object):ArrayCollection
		{
			var children:ArrayCollection = item.children;
			return children;
		}
		
		public function hasChildren(node:Object):Boolean
		{
			var fileSystemNode:FileSystemNode = FileSystemNode(node);
			return fileSystemNode.uri.isDirectory();
		}
		
		public function getIcon( item:Object ):Object
		{
			//TODO: This is reaaaally unperformant...
			var resources:Vector.<IResource> = FloxApp.resourceManager.getResourcesByURI(item.uri);
			
			for each ( var resource:IResource in resources ) {
				if ( resource is ExternalBitmapDataResource ) {
					if ( ExternalBitmapDataResource(resource).icon ) {
						return ExternalBitmapDataResource(resource).icon;
					}
				}
			}
			
			if ( item.uri.isDirectory() == false )
			{
				for each ( var fileType:FileType in fileTypes )
				{
					if ( fileType.extension == item.uri.getExtension(true) )
					{
						return fileType.icon;
					}
				} 
			}
			else
			{
				var parentURI:URI = item.uri.getParentURI();
				if ( parentURI.path == "" )
				{
					return FloxIcons.Drive;
				}
				
				return FloxIcons.Folder;
				//var open:Boolean = isItemOpen( item );
				//return open ? FolderOpenIcon : FolderIcon;;
			}
			return FloxIcons.File;
		}
		
		public function getLabel( item:Object ):String
		{
			if ( item.label != null && item.label != "" ) return item.label;
			if ( item.uri.isDirectory() )
			{
				var split:Array = item.uri.path.split("/");
				return split[split.length-2];
			}
			return item.uri.getFilename();//true);
		}
		
		public function getEnabled( item:Object ):Boolean
		{
			return true;
		}
		
		public function getChangeEventTypes( item:Object ):Array
		{
			return [];
		}
	}
}