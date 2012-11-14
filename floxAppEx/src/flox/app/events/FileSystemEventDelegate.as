// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.app.events
{
	import flash.events.EventDispatcher;
	
	[Event(type="flox.app.events.FileSystemEvent", 						name="deleteComplete")]
	[Event(type="flox.app.events.FileSystemEvent", 						name="createDirectoryComplete")]
	[Event(type="flox.app.events.FileSystemDataEvent", 					name="readComplete")]
	[Event(type="flox.app.events.FileSystemDataEvent", 					name="writeComplete")]
	[Event(type="flox.app.events.FileSystemProgressEvent", 				name="readProgress")]
	[Event(type="flox.app.events.FileSystemProgressEvent", 				name="writeProgress")]
	[Event(type="flox.app.events.FileSystemFileExistsEvent", 				name="fileExists")]
	[Event(type="bones.events.FileSystemGetDescriptorEvent", 			name="getDescriptorComplete")]
	[Event(type="flox.app.events.FileSystemGetDirectoryContentsEvent", 	name="getDirectoryContentsComplete")]
	[Event(type="flox.app.events.FileSystemErrorEvent", 					name="error")]
	
	[Event( type="bones.events.MetadataEvent", 							name="getMetadataComplete" )]
	[Event( type="bones.events.MetadataEvent", 							name="deleteMetadataComplete" )]
	[Event( type="bones.events.MetadataEvent", 							name="setMetadataComplete" )]
	
	
	public class FileSystemEventDelegate extends EventDispatcher
	{

	}
}