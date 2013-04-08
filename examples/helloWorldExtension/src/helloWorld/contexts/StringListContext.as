package helloWorld.contexts
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import core.app.CoreApp;
	import core.app.core.contexts.IOperationManagerContext;
	import core.app.entities.URI;
	import core.app.events.OperationManagerEvent;
	import core.app.managers.OperationManager;
	import core.app.operations.ReadFileAndDeserializeOperation;
	import core.app.operations.SerializeAndWriteFileOperation;
	import core.data.ArrayCollection;
	import core.editor.CoreEditor;
	import core.editor.contexts.IEditorContext;
	
	import helloWorld.ui.views.StringListView;
	
	[Event( type="flash.events.Event", name="change" )]
	
	public class StringListContext extends EventDispatcher implements IEditorContext, IOperationManagerContext
	{
		private var _view			:StringListView;
		
		private var _dataProvider		:ArrayCollection;
		
		private var _operationManager	:OperationManager;
		
		private var _uri				:URI;
		private var _changed			:Boolean = false;
		protected var _isNewFile		:Boolean = false;
		
		public function StringListContext()
		{
			_view = new StringListView();
			
			_operationManager = new OperationManager();
			_operationManager.addEventListener(OperationManagerEvent.CHANGE, changeOperationManagerHandler);
			_dataProvider = new ArrayCollection();
			
			_view.dataProvider = _dataProvider;
		}
		
		public function get view():DisplayObject
		{
			return _view;
		}
		
		public function dispose():void
		{
			_operationManager.removeEventListener(OperationManagerEvent.CHANGE, changeOperationManagerHandler);
			_operationManager.dispose();
		}
		
		public function enable():void
		{
			// Do nothing
		}
		
		public function disable():void
		{
			// Do nothing
		}
		
		public function save():void
		{
			var serializeOperation:SerializeAndWriteFileOperation = new SerializeAndWriteFileOperation( _dataProvider, _uri, CoreApp.fileSystemProvider );
			CoreEditor.operationManager.addOperation(serializeOperation);
			changed = false;
		}
		
		public function publish():void
		{
			// Do nothing
		}
		
		public function load():void
		{
			var deserializeOperation:ReadFileAndDeserializeOperation = new ReadFileAndDeserializeOperation( _uri, CoreApp.fileSystemProvider );
			deserializeOperation.addEventListener(Event.COMPLETE, deserializeCompleteHandler);
			CoreEditor.operationManager.addOperation(deserializeOperation); 
		}
		
		private function deserializeCompleteHandler( event:Event ):void
		{
			var deserializeOperation:ReadFileAndDeserializeOperation = ReadFileAndDeserializeOperation(event.target);
			
			// Handle case where the file on disk is empty. This occurs when we're opening a newly created file.
			if ( deserializeOperation.getResult() == null )
			{
				_dataProvider = new ArrayCollection();
			}
			else
			{
				_dataProvider = ArrayCollection( deserializeOperation.getResult() );
			}
			_view.dataProvider = _dataProvider;
			changed = false;
		}
		
		public function set uri( value:URI ):void
		{
			_uri = value;
		}
		
		public function get uri():URI { return _uri; }
		
		public function set changed( value:Boolean ):void
		{
			if ( value == _changed ) return;
			_changed = value;
			dispatchEvent( new Event( Event.CHANGE) );
		}
		
		public function get changed():Boolean { return _changed; }
		
		private function changeOperationManagerHandler( event:OperationManagerEvent ):void
		{
			changed = true;
		}
		
		public function set isNewFile( value:Boolean ):void
		{
			_isNewFile = value;
		}
		public function get isNewFile():Boolean { return _isNewFile; } 
		
		
		public function get dataProvider():ArrayCollection { return _dataProvider; }
		
		public function get operationManager():OperationManager { return _operationManager; }
	}
}