// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.commandHandlers
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	
	import flox.app.FloxApp;
	import flox.app.core.commandHandlers.ICommandHandler;
	import flox.app.entities.FileSystemNode;
	import flox.app.entities.URI;
	import flox.app.operations.LoadURLOperation;
	import flox.app.resources.CommandHandlerFactory;
	import flox.app.resources.FileType;
	import flox.core.data.ArrayCollection;
	import flox.editor.FloxEditor;
	import flox.editor.contexts.FileExplorerContext;
	import flox.editor.contexts.IEditorContext;
	import flox.editor.entities.Commands;
	import flox.editor.operations.GetCompatibleFileTemplatesOperation;
	import flox.editor.operations.NewFileFromFileTemplateOperation;
	import flox.editor.operations.OpenFileOperation;
	import flox.editor.resources.FileTemplate;
	import flox.editor.ui.data.FileSystemTreeDataDescriptor;
	import flox.editor.ui.panels.NewFilePanel;
	import flox.editor.utils.FloxEditorUtil;

	public class NewFileCommandHandler implements ICommandHandler
	{
		static public function getFactory():CommandHandlerFactory
		{
			var descriptor:CommandHandlerFactory = new CommandHandlerFactory( Commands.NEW_FILE, NewFileCommandHandler );
			return descriptor;
		}
		
		public function NewFileCommandHandler() {}
		
		private var panel					:NewFilePanel;
		private var fileTemplate			:FileTemplate;
		private var fileType				:FileType;
		
		public function execute( parameters:Object ):void
		{
			openPanel();
			
			var getCompatibleFileTemplatesOperation:GetCompatibleFileTemplatesOperation = new GetCompatibleFileTemplatesOperation(FloxApp.resourceManager);
			getCompatibleFileTemplatesOperation.execute();
			
			panel.list.dataProvider = new ArrayCollection( getCompatibleFileTemplatesOperation.compatibleFileTemplates );
			panel.list.selectedItem = panel.list.dataProvider[0];
		}
		
		private function clickOkHandler(event:Event):void
		{
			fileTemplate = FileTemplate( panel.list.selectedItem );
			closePanel();
			
			var operation:NewFileFromFileTemplateOperation = new NewFileFromFileTemplateOperation( fileTemplate, FloxApp.resourceManager, FloxApp.fileSystemProvider ); 
			FloxEditor.operationManager.addOperation( operation );
		}
				
		private function clickCancelHandler(event:Event):void
		{
			closePanel()
		}
		
		private function openPanel():void
		{
			panel = new NewFilePanel()
			FloxEditor.viewManager.addPopUp(panel);
			
			panel.okBtn.addEventListener(MouseEvent.CLICK, clickOkHandler);
			panel.cancelBtn.addEventListener(MouseEvent.CLICK, clickCancelHandler);
		}
		
		private function closePanel():void
		{
			if (!panel) return
			
			FloxEditor.viewManager.removePopUp(panel);
			panel.okBtn.removeEventListener(MouseEvent.CLICK, clickOkHandler);
			panel.cancelBtn.removeEventListener(MouseEvent.CLICK, clickCancelHandler);
			panel = null
		}
		
		
		
		
		
		
		
		
		
		
		
	}
}