// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.app.events
{
	import flash.events.EventDispatcher;
	
	[Event(type="core.app.events.FileSystemEvent", 						name="deleteComplete")]
	[Event(type="core.app.events.FileSystemEvent", 						name="createDirectoryComplete")]
	[Event(type="core.app.events.FileSystemDataEvent", 					name="readComplete")]
	[Event(type="core.app.events.FileSystemDataEvent", 					name="writeComplete")]
	[Event(type="core.app.events.FileSystemProgressEvent", 				name="readProgress")]
	[Event(type="core.app.events.FileSystemProgressEvent", 				name="writeProgress")]
	[Event(type="core.app.events.FileSystemFileExistsEvent", 				name="fileExists")]
	[Event(type="bones.events.FileSystemGetDescriptorEvent", 			name="getDescriptorComplete")]
	[Event(type="core.app.events.FileSystemGetDirectoryContentsEvent", 	name="getDirectoryContentsComplete")]
	[Event(type="core.app.events.FileSystemErrorEvent", 					name="error")]
	
	[Event( type="bones.events.MetadataEvent", 							name="getMetadataComplete" )]
	[Event( type="bones.events.MetadataEvent", 							name="deleteMetadataComplete" )]
	[Event( type="bones.events.MetadataEvent", 							name="setMetadataComplete" )]
	
	
	public class FileSystemEventDelegate extends EventDispatcher
	{

	}
}