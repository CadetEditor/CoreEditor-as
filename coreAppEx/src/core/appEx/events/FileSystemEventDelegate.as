// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.events
{
	import flash.events.EventDispatcher;
	
	[Event(type="core.appEx.events.FileSystemEvent", 						name="deleteComplete")]
	[Event(type="core.appEx.events.FileSystemEvent", 						name="createDirectoryComplete")]
	[Event(type="core.appEx.events.FileSystemDataEvent", 					name="readComplete")]
	[Event(type="core.appEx.events.FileSystemDataEvent", 					name="writeComplete")]
	[Event(type="core.appEx.events.FileSystemProgressEvent", 				name="readProgress")]
	[Event(type="core.appEx.events.FileSystemProgressEvent", 				name="writeProgress")]
	[Event(type="core.appEx.events.FileSystemFileExistsEvent", 				name="fileExists")]
	[Event(type="bones.events.FileSystemGetDescriptorEvent", 			name="getDescriptorComplete")]
	[Event(type="core.appEx.events.FileSystemGetDirectoryContentsEvent", 	name="getDirectoryContentsComplete")]
	[Event(type="core.appEx.events.FileSystemErrorEvent", 					name="error")]
	
	[Event( type="bones.events.MetadataEvent", 							name="getMetadataComplete" )]
	[Event( type="bones.events.MetadataEvent", 							name="deleteMetadataComplete" )]
	[Event( type="bones.events.MetadataEvent", 							name="setMetadataComplete" )]
	
	
	public class FileSystemEventDelegate extends EventDispatcher
	{

	}
}