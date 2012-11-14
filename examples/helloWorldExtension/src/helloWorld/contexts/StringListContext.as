package helloWorld.contexts
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import flox.app.FloxApp;
	import flox.app.core.contexts.IOperationManagerContext;
	import flox.app.entities.URI;
	import flox.app.events.OperationManagerEvent;
	import flox.app.managers.OperationManager;
	import flox.app.operations.ReadFileAndDeserializeOperation;
	import flox.app.operations.SerializeAndWriteFileOperation;
	import flox.core.data.ArrayCollection;
	import flox.editor.FloxEditor;
	import flox.editor.contexts.IEditorContext;
	
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
			var serializeOperation:SerializeAndWriteFileOperation = new SerializeAndWriteFileOperation( _dataProvider, _uri, FloxApp.fileSystemProvider );
			FloxEditor.operationManager.addOperation(serializeOperation);
			changed = false;
		}
		
		public function load():void
		{
			var deserializeOperation:ReadFileAndDeserializeOperation = new ReadFileAndDeserializeOperation( _uri, FloxApp.fileSystemProvider );
			deserializeOperation.addEventListener(Event.COMPLETE, deserializeCompleteHandler);
			FloxEditor.operationManager.addOperation(deserializeOperation); 
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