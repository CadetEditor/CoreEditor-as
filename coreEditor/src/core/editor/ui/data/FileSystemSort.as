// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.ui.data
{
	import core.app.entities.FileSystemNode;

	public class FileSystemSort
	{
		public function FileSystemSort()
		{
			
		}
		
		private static function compareFunction( a:Object, b:Object, fields:Array = null ):int
		{
			var nodeA:FileSystemNode = FileSystemNode(a);
			var nodeB:FileSystemNode = FileSystemNode(b);
			
			var directoryA:Boolean = nodeA.uri.isDirectory();
			var directoryB:Boolean = nodeB.uri.isDirectory();
			
			if ( directoryA && !directoryB ) return -1;
			if ( directoryB && !directoryA ) return 1;
			
			var array:Array = [];
			array.push(nodeA);
			array.push(nodeB);
			array.sortOn("filename");
			if ( array[0] == nodeA )
			{
				return -1;
			}
			else return 1;
		}
		
	}
}