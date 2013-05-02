// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.contexts
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import core.app.CoreApp;
	import core.appEx.core.contexts.IRefreshableContext;
	import core.appEx.core.contexts.ISelectionContext;
	import core.appEx.core.contexts.IVisualContext;
	import core.app.entities.URI;
	import core.data.ArrayCollection;
	import core.editor.CoreEditor;
	import core.editor.operations.OpenFileOperation;
	import core.editor.ui.components.FileSystemTree;
				
	public class FileExplorerContext implements IRefreshableContext, ISelectionContext, IVisualContext
	{
		private var _view			:FileSystemTree;
		protected var _selection	:ArrayCollection;
		
		public function FileExplorerContext()
		{
			_view = new FileSystemTree();
			_view.showBorder = false;
			_view.padding = 0;
			
			_view.addEventListener( MouseEvent.DOUBLE_CLICK, doubleClickLaunchHandler );
			_view.addEventListener( Event.CHANGE, treeChangeHandler );
			
			_selection = new ArrayCollection();
		}
		
		public function dispose():void
		{
			_view.removeEventListener( MouseEvent.DOUBLE_CLICK, doubleClickLaunchHandler );
			_view.removeEventListener( Event.CHANGE, treeChangeHandler );
		}
		
		public function get view():DisplayObject { return _view; }
		
		public function get selection():ArrayCollection { return _selection; }
				
		public function refresh():void
		{
			var selectedFolder:URI = _view.selectedFolder;
			if ( !selectedFolder ) return;
			CoreApp.fileSystemProvider.getDirectoryContents(selectedFolder).execute();
		}
		private function treeChangeHandler( event:Event ):void
		{
			if ( _view.selectedFile == null ) return;
			selection.source = [ _view.selectedFile ];
		}
		
		protected function doubleClickLaunchHandler( event:MouseEvent ):void
		{
			var uri:URI = _view.selectedFile;
			if ( !uri ) return;
			if ( uri.isDirectory() ) return;
			CoreEditor.operationManager.addOperation( new OpenFileOperation( uri, CoreApp.fileSystemProvider, CoreEditor.settingsManager ) );
		}
	}
}