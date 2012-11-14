// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.contexts
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flox.app.FloxApp;
	import flox.app.core.contexts.IRefreshableContext;
	import flox.app.core.contexts.ISelectionContext;
	import flox.app.core.contexts.IVisualContext;
	import flox.app.entities.URI;
	import flox.core.data.ArrayCollection;
	import flox.editor.FloxEditor;
	import flox.editor.operations.OpenFileOperation;
	import flox.editor.ui.components.FileSystemTree;
				
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
			FloxApp.fileSystemProvider.getDirectoryContents(selectedFolder).execute();
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
			FloxEditor.operationManager.addOperation( new OpenFileOperation( uri, FloxApp.fileSystemProvider, FloxEditor.settingsManager ) );
		}
	}
}