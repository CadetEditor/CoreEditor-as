// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.commandHandlers
{
	import flash.events.Event;
	
	import flox.app.FloxApp;
	import flox.app.core.commandHandlers.ICommandHandler;
	import flox.app.core.contexts.IContext;
	import flox.app.events.OperationManagerEvent;
	import flox.app.resources.CommandHandlerFactory;
	import flox.editor.FloxEditor;
	import flox.editor.contexts.IEditorContext;
	import flox.editor.entities.Commands;
	import flox.editor.operations.CloseEditorOperation;
	
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
			var contexts:Vector.<IContext> = FloxEditor.contextManager.getContexts();
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
				if ( FloxEditor.operationManager.getOperations().length > 0 )
				{
					FloxEditor.operationManager.addEventListener(OperationManagerEvent.ALL_OPERATIONS_COMPLETE, allOperationsCompleteHandler);
					return;
				}
				FloxEditor.stage.nativeWindow.close();
			}
			else
			{
				var editor:IEditorContext = IEditorContext( editorsToClose.shift() );
				var operation:CloseEditorOperation = new CloseEditorOperation( editor, FloxApp.fileSystemProvider );
				operation.addEventListener(Event.CANCEL, operationCancelHandler);
				operation.addEventListener(Event.COMPLETE, operationCompleteHandler);
				operation.execute();
			}
		}
		
		private function allOperationsCompleteHandler( event:OperationManagerEvent ):void
		{
			FloxEditor.stage.nativeWindow.close();
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