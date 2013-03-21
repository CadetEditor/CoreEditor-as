// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.commandHandlers
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	
	import core.app.CoreApp;
	import core.app.core.commandHandlers.ICommandHandler;
	import core.app.entities.FileSystemNode;
	import core.app.entities.URI;
	import core.app.operations.LoadURLOperation;
	import core.app.resources.CommandHandlerFactory;
	import core.app.resources.FileType;
	import core.data.ArrayCollection;
	import core.editor.CoreEditor;
	import core.editor.contexts.FileExplorerContext;
	import core.editor.contexts.IEditorContext;
	import core.editor.entities.Commands;
	import core.editor.operations.GetCompatibleFileTemplatesOperation;
	import core.editor.operations.NewFileFromFileTemplateOperation;
	import core.editor.operations.OpenFileOperation;
	import core.editor.resources.FileTemplate;
	import core.editor.ui.data.FileSystemTreeDataDescriptor;
	import core.editor.ui.panels.NewFilePanel;
	import core.editor.utils.CoreEditorUtil;

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
			
			var getCompatibleFileTemplatesOperation:GetCompatibleFileTemplatesOperation = new GetCompatibleFileTemplatesOperation(CoreApp.resourceManager);
			getCompatibleFileTemplatesOperation.execute();
			
			panel.list.dataProvider = new ArrayCollection( getCompatibleFileTemplatesOperation.compatibleFileTemplates );
			panel.list.selectedItem = panel.list.dataProvider[0];
		}
		
		private function clickOkHandler(event:Event):void
		{
			fileTemplate = FileTemplate( panel.list.selectedItem );
			closePanel();
			
			var operation:NewFileFromFileTemplateOperation = new NewFileFromFileTemplateOperation( fileTemplate, CoreApp.resourceManager, CoreApp.fileSystemProvider ); 
			CoreEditor.operationManager.addOperation( operation );
		}
				
		private function clickCancelHandler(event:Event):void
		{
			closePanel()
		}
		
		private function openPanel():void
		{
			panel = new NewFilePanel()
			CoreEditor.viewManager.addPopUp(panel);
			
			panel.okBtn.addEventListener(MouseEvent.CLICK, clickOkHandler);
			panel.cancelBtn.addEventListener(MouseEvent.CLICK, clickCancelHandler);
		}
		
		private function closePanel():void
		{
			if (!panel) return
			
			CoreEditor.viewManager.removePopUp(panel);
			panel.okBtn.removeEventListener(MouseEvent.CLICK, clickOkHandler);
			panel.cancelBtn.removeEventListener(MouseEvent.CLICK, clickCancelHandler);
			panel = null
		}
		
		
		
		
		
		
		
		
		
		
		
	}
}