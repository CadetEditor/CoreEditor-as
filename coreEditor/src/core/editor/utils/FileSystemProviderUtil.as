package core.editor.utils
{
	import core.app.CoreApp;
	import core.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import core.app.core.managers.fileSystemProviders.ILocalFileSystemProvider;
	import core.app.entities.URI;
	import core.appEx.managers.fileSystemProviders.memory.MemoryFileSystemProvider;
	import core.editor.CoreEditor;
	import core.editor.core.CoreEditorEnvironment;

	public class FileSystemProviderUtil
	{
		static public function getProjectDirectoryURI(cadetFileURI:URI):URI
		{
			var projectURI:URI = cadetFileURI.getParentURI();
			var provider:IFileSystemProvider = CoreApp.fileSystemProvider.getFileSystemProviderForURI(cadetFileURI);
			
			// If reading from memory (i.e. we're editing an unsaved template file) default to "Documents/Cadet2D"
			if ( provider is MemoryFileSystemProvider ) {
				if ( CoreEditor.environment == CoreEditorEnvironment.AIR ) {
					provider = CoreApp.fileSystemProvider.getFileSystemProviderForURI(new URI("cadet.local/"));//+CoreApp.externalResourceFolderName));
					var localFSP:ILocalFileSystemProvider = ILocalFileSystemProvider(provider); 
					var defaultDirPath:String = localFSP.defaultDirectoryURI.path;
					if ( defaultDirPath.indexOf( localFSP.rootDirectoryURI.path ) != -1 ) {
						defaultDirPath = defaultDirPath.replace( localFSP.rootDirectoryURI.path, "" );
					}
					projectURI = new URI("cadet.local"+defaultDirPath+"/");
				}
				else if ( CoreEditor.environment == CoreEditorEnvironment.BROWSER ) {
					projectURI = new URI("cadet.url/");			
				}
			} else {
				if ( CoreEditor.environment == CoreEditorEnvironment.AIR ) {
					projectURI = cadetFileURI.getParentURI();
				}
				else if ( CoreEditor.environment == CoreEditorEnvironment.BROWSER ) {
					projectURI = new URI("cadet.url/");				
				}				
			}
			
			return projectURI;
		}
		
		// Returns the relationship of the secondary URI (uriB) to the primary URI (uriA):
		// CHILD means uriB is the child of uriA
		// PARENT means uriB is the parent of uriA
		static public function getRelation(uriA:URI, uriB:URI, caseSensitive:Boolean = false):int
		{
			var providerA:IFileSystemProvider = CoreApp.fileSystemProvider.getFileSystemProviderForURI(uriA);
			var providerB:IFileSystemProvider = CoreApp.fileSystemProvider.getFileSystemProviderForURI(uriB);
			
			if ( providerA != providerB ) {
				return URI.NOT_RELATED;
			}
			
			
			if (compareStr(uriA.path, uriB.path, caseSensitive))
				return URI.EQUAL;
			
			// Special case check.  If we are here, the scheme, authority,
			// and port match, and it is not a relative path, but the
			// paths did not match.  There is a special case where we
			// could have:
			//		http://something.com/
			//		http://something.com
			// Technically, these are equal.  So lets, check for this case.
			var uriAPath:String = uriA.path;
			var uriBPath:String = uriB.path;
			
			if ( (uriAPath == "/" || uriBPath == "/") &&
				(uriAPath == "" || uriBPath == "") )
			{
				// We hit the special case.  These two are equal.
				return URI.EQUAL;
			}
			
			// Ok, the paths do not match, but one path may be a parent/child
			// of the other.  For example, we may have:
			//		http://something.com/path/to/homepage/
			//		http://something.com/path/to/homepage/images/logo.gif
			// In this case, the first is a parent of the second (or the second
			// is a child of the first, depending on which you compare to the
			// other).  To make this comparison, we must split the path into
			// its component parts (split the string on the '/' path delimiter).
			// We then compare the 
			var uriAParts:Array, uriBParts:Array;
			var uriAPart:String, uriBPart:String;
			var i:int;
			
			uriAParts = uriAPath.split("/");
			uriBParts = uriBPath.split("/");
			
			if (uriAParts.length > uriBParts.length)
			{
				uriBPart = uriBParts[uriBParts.length - 1];
				if (uriBPart.length > 0)
				{
					// if the last part is not empty, the passed URI is
					// not a directory.  There is no way the passed URI
					// can be a parent.
					return URI.NOT_RELATED;
				}
				else
				{
					// Remove the empty trailing part
					uriBParts.pop();
				}
				
				// This may be a child of the one passed in
				for (i = 0; i < uriBParts.length; i++)
				{
					uriAPart = uriAParts[i];
					uriBPart = uriBParts[i];
					
					if (compareStr(uriAPart, uriBPart, caseSensitive) == false)
						return URI.NOT_RELATED;
				}
				
				return URI.CHILD;
			}
			else if (uriAParts.length < uriBParts.length)
			{
				uriAPart = uriAParts[uriAParts.length - 1];
				if (uriAPart.length > 0)
				{
					// if the last part is not empty, this URI is not a
					// directory.  There is no way this object can be
					// a parent.
					return URI.NOT_RELATED;
				}
				else
				{
					// Remove the empty trailing part
					uriAParts.pop();
				}
				
				// This may be the parent of the one passed in
				for (i = 0; i < uriAParts.length; i++)
				{
					uriAPart = uriAParts[i];
					uriBPart = uriBParts[i];
					
					if (compareStr(uriAPart, uriBPart, caseSensitive) == false)
						return URI.NOT_RELATED;
				}
				
				return URI.PARENT;
			}
			else
			{
				// Both URI's have the same number of path components, but
				// it failed the equivelence check above.  This means that
				// the two URI's are not related.
				return URI.NOT_RELATED;
			}
			
			// If we got here, the scheme and authority are the same,
			// but the paths pointed to two different locations that
			// were in different parts of the file system tree
			return URI.NOT_RELATED;			
		}
		
		/**
		 * @private
		 * Helper function to compare strings.
		 * 
		 * @return true if the two strings are identical, false otherwise.
		 */
		static protected function compareStr(str1:String, str2:String,
											 sensitive:Boolean = true) : Boolean
		{
			if (sensitive == false)
			{
				str1 = str1.toLowerCase();
				str2 = str2.toLowerCase();
			}
			
			return (str1 == str2)
		}
	}
}







