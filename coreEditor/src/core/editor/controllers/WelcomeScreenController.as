// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.controllers
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	import core.app.CoreApp;
	import core.app.entities.URI;
	import core.appEx.events.ContextManagerEvent;
	import core.appEx.resources.FileType;
	import core.app.resources.IResource;
	import core.app.util.AsynchronousUtil;
	import core.data.ArrayCollection;
	import core.editor.CoreEditor;
	import core.editor.contexts.IEditorContext;
	import core.editor.events.CoreEditorEvent;
	import core.editor.icons.CoreEditorIcons;
	import core.editor.operations.GetCompatibleFileTemplatesOperation;
	import core.editor.operations.NewFileFromFileTemplateOperation;
	import core.editor.operations.OpenFileOperation;
	import core.editor.resources.FileTemplate;
	import core.editor.ui.panels.WelcomePanel;
	import core.ui.components.Alert;
	import core.ui.events.ListEvent;

	public class WelcomeScreenController
	{
		private var panel	:WelcomePanel;
		
		public function WelcomeScreenController()
		{
			CoreEditor.eventDispatcher.addEventListener(CoreEditorEvent.INIT_COMPLETE, initHandler);
			CoreEditor.contextManager.addEventListener( ContextManagerEvent.CONTEXT_ADDED, contextAddedHandler );
		}
		
		private function initHandler( event:CoreEditorEvent ):void
		{
			AsynchronousUtil.callLater( openPanel );
		}
		
		private function contextAddedHandler( event:ContextManagerEvent ):void
		{
			if ( event.context is IEditorContext )
			{
				closePanel();
				CoreEditor.contextManager.removeEventListener( ContextManagerEvent.CONTEXT_ADDED, contextAddedHandler );
				CoreEditor.contextManager.addEventListener( ContextManagerEvent.CONTEXT_REMOVED, contextRemovedHandler );
			}
		}
		
		private function contextRemovedHandler( event:ContextManagerEvent ):void
		{
			if ( event.context is IEditorContext == false ) return;
			
			if ( CoreEditor.contextManager.getContextsOfType(IEditorContext).length == 0 )
			{
				CoreEditor.contextManager.addEventListener( ContextManagerEvent.CONTEXT_ADDED, contextAddedHandler );
				CoreEditor.contextManager.removeEventListener( ContextManagerEvent.CONTEXT_REMOVED, contextRemovedHandler );
				
				openPanel();
			}
		}
		
		private function openPanel():void
		{
			if ( panel ) return;
			panel = new WelcomePanel();
			
			CoreEditor.viewManager.addPopUp(panel, false, false);
			resizeStageHandler();
			
			var getCompatibleFileTemplatesOperation:GetCompatibleFileTemplatesOperation = new GetCompatibleFileTemplatesOperation( CoreApp.resourceManager );
			getCompatibleFileTemplatesOperation.execute();
			
			panel.fileTemplateList.dataProvider = new ArrayCollection( getCompatibleFileTemplatesOperation.compatibleFileTemplates );
			
			var fileTypes:Vector.<IResource> = CoreApp.resourceManager.getResourcesOfType( FileType );
			
			var recentFiles:Array = CoreEditor.settingsManager.getArray("recentFiles").slice();
			for ( var i:int = 0; i < recentFiles.length; i++ )
			{
				var recentFilePath:String = recentFiles[i];
				var data:Object = {};
				var uri:URI = new URI( recentFilePath );
				data.label = uri.getFilename(true);
				data.path = recentFilePath;
				
				var found:Boolean = false;
				for each ( var fileType:FileType in fileTypes )
				{
					if ( fileType.extension == uri.getExtension(true) )
					{
						data.icon = fileType.icon;
						found = true;
						break;
					}
				}
				
				if ( !found )
				{
					recentFiles.splice(i,1);
					i--;
					continue;
				}
				recentFiles[i] = data;
			}
			panel.recentFileList.dataProvider = new ArrayCollection( recentFiles );
			
			panel.recentFileList.addEventListener(ListEvent.ITEM_SELECT, selectRecentFileHandler);
			panel.fileTemplateList.addEventListener(ListEvent.ITEM_SELECT, selectFileTemplateHandler);
			panel.stage.addEventListener(Event.RESIZE, resizeStageHandler);
		}
		
		private function closePanel():void
		{
			if ( !panel ) return;
			
			panel.stage.removeEventListener(Event.RESIZE, resizeStageHandler);
			panel.recentFileList.removeEventListener(ListEvent.ITEM_SELECT, selectRecentFileHandler);
			panel.fileTemplateList.removeEventListener(ListEvent.ITEM_SELECT, selectFileTemplateHandler);
			CoreEditor.viewManager.removePopUp(panel);
			panel = null;
		}
		
		private function resizeStageHandler( event:Event = null ):void
		{
			panel.x = ((panel.stage.stageWidth-360) - panel.width) * 0.5;
			panel.y = (panel.stage.stageHeight - panel.height) * 0.5;
		}
		
		private function selectRecentFileHandler( event:ListEvent ):void
		{
			var selectedData:* = panel.recentFileList.selectedItem;
			var openFileOperation:OpenFileOperation = new OpenFileOperation( new URI( selectedData.path ), CoreApp.fileSystemProvider, CoreEditor.settingsManager );
			openFileOperation.addEventListener( ErrorEvent.ERROR, openFileErrorHandler );
			CoreEditor.operationManager.addOperation(openFileOperation);
		}
		
		private function openFileErrorHandler( event:ErrorEvent ):void
		{
			closePanel();
			openPanel();
			
			Alert.show( "Error opening file", event.text, ["OK"], "OK", CoreEditorIcons.Error );
		}
		
		private function selectFileTemplateHandler( event:ListEvent ):void
		{
			var selectedFileTemplate:FileTemplate = FileTemplate(panel.fileTemplateList.selectedItem);
			var operation:NewFileFromFileTemplateOperation = new NewFileFromFileTemplateOperation( selectedFileTemplate, CoreApp.resourceManager, CoreApp.fileSystemProvider );
			CoreEditor.operationManager.addOperation(operation);
		}
	}
}