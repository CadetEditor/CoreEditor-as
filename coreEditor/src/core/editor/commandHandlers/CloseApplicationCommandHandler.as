// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.commandHandlers
{
	import flash.events.Event;
	
	import core.app.CoreApp;
	import core.appEx.core.commandHandlers.ICommandHandler;
	import core.appEx.core.contexts.IContext;
	import core.appEx.events.OperationManagerEvent;
	import core.appEx.resources.CommandHandlerFactory;
	import core.editor.CoreEditor;
	import core.editor.contexts.IEditorContext;
	import core.editor.entities.Commands;
	import core.editor.operations.CloseEditorOperation;
	
	public class CloseApplicationCommandHandler implements ICommandHandler
	{
		public static function getFactory():CommandHandlerFactory
		{
			return new CommandHandlerFactory( Commands.CLOSE_APPLICATION, CloseApplicationCommandHandler );
		}
		
		private var editorsToClose	:	Array;
		private var operationCanceled	:Boolean = false;
		private var executing			:Boolean = false;
		
		public function execute( parameters:Object ):void
		{
			if ( executing )
			{
				return;
			}
			
			executing = true;
			
			editorsToClose = [];
			var contexts:Vector.<IContext> = CoreEditor.contextManager.getContexts();
			for ( var i:int = 0; i < contexts.length; i++ )
			{
				var context:IContext = contexts[i];
				if ( context is IEditorContext )
				{
					editorsToClose.push( context );
				}
			}
			
			closeEditors();
		}
		
		private function closeEditors():void
		{
			if ( editorsToClose.length == 0 )
			{
				if ( CoreEditor.operationManager.getOperations().length > 0 )
				{
					CoreEditor.operationManager.addEventListener(OperationManagerEvent.ALL_OPERATIONS_COMPLETE, allOperationsCompleteHandler);
					return;
				}
				CoreEditor.stage.nativeWindow.close();
			}
			else
			{
				var editor:IEditorContext = IEditorContext( editorsToClose.shift() );
				var operation:CloseEditorOperation = new CloseEditorOperation( editor, CoreApp.fileSystemProvider );
				operation.addEventListener(Event.CANCEL, operationCancelHandler);
				operation.addEventListener(Event.COMPLETE, operationCompleteHandler);
				operation.execute();
			}
		}
		
		private function allOperationsCompleteHandler( event:OperationManagerEvent ):void
		{
			CoreEditor.stage.nativeWindow.close();
			executing = false;
		}
		
		private function operationCancelHandler( event:Event ):void
		{
			operationCanceled = true;
			executing = false;
		}
		
		private function operationCompleteHandler( event:Event ):void
		{
			if ( operationCanceled )
			{
				executing = false;
				return;
			}
			closeEditors();
		}
	}
}