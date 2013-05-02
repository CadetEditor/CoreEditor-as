// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.ui.data
{
	import core.app.CoreApp;
	import core.app.entities.FileSystemNode;
	import core.app.entities.URI;
	import core.appEx.icons.CoreIcons;
	import core.app.managers.ResourceManager;
	import core.app.resources.ExternalBitmapDataResource;
	import core.appEx.resources.FileType;
	import core.app.resources.IResource;
	import core.data.ArrayCollection;
	import core.ui.data.IDataDescriptor;
	
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
			var resources:Vector.<IResource> = CoreApp.resourceManager.getResourcesByURI(item.uri);
			
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
					return CoreIcons.Drive;
				}
				
				return CoreIcons.Folder;
				//var open:Boolean = isItemOpen( item );
				//return open ? FolderOpenIcon : FolderIcon;;
			}
			return CoreIcons.File;
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