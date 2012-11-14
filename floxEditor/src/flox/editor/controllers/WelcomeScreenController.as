// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.controllers
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	import flox.app.FloxApp;
	import flox.app.entities.URI;
	import flox.app.events.ContextManagerEvent;
	import flox.app.icons.FloxIcons;
	import flox.app.resources.FileType;
	import flox.app.resources.IResource;
	import flox.app.util.AsynchronousUtil;
	import flox.core.data.ArrayCollection;
	import flox.editor.FloxEditor;
	import flox.editor.contexts.IEditorContext;
	import flox.editor.events.FloxEditorEvent;
	import flox.editor.icons.FloxEditorIcons;
	import flox.editor.operations.GetCompatibleFileTemplatesOperation;
	import flox.editor.operations.NewFileFromFileTemplateOperation;
	import flox.editor.operations.OpenFileOperation;
	import flox.editor.resources.FileTemplate;
	import flox.editor.ui.panels.WelcomePanel;
	import flox.ui.components.Alert;
	import flox.ui.events.ListEvent;
	import flox.ui.events.SelectEvent;

	public class WelcomeScreenController
	{
		private var panel	:WelcomePanel;
		
		public function WelcomeScreenController()
		{
			FloxEditor.eventDispatcher.addEventListener(FloxEditorEvent.INIT_COMPLETE, initHandler);
			FloxEditor.contextManager.addEventListener( ContextManagerEvent.CONTEXT_ADDED, contextAddedHandler );
		}
		
		private function initHandler( event:FloxEditorEvent ):void
		{
			AsynchronousUtil.callLater( openPanel );
		}
		
		private function contextAddedHandler( event:ContextManagerEvent ):void
		{
			if ( event.context is IEditorContext )
			{
				closePanel();
				FloxEditor.contextManager.removeEventListener( ContextManagerEvent.CONTEXT_ADDED, contextAddedHandler );
				FloxEditor.contextManager.addEventListener( ContextManagerEvent.CONTEXT_REMOVED, contextRemovedHandler );
			}
		}
		
		private function contextRemovedHandler( event:ContextManagerEvent ):void
		{
			if ( event.context is IEditorContext == false ) return;
			
			if ( FloxEditor.contextManager.getContextsOfType(IEditorContext).length == 0 )
			{
				FloxEditor.contextManager.addEventListener( ContextManagerEvent.CONTEXT_ADDED, contextAddedHandler );
				FloxEditor.contextManager.removeEventListener( ContextManagerEvent.CONTEXT_REMOVED, contextRemovedHandler );
				
				openPanel();
			}
		}
		
		private function openPanel():void
		{
			if ( panel ) return;
			panel = new WelcomePanel();
			
			FloxEditor.viewManager.addPopUp(panel, false, false);
			resizeStageHandler();
			
			var getCompatibleFileTemplatesOperation:GetCompatibleFileTemplatesOperation = new GetCompatibleFileTemplatesOperation( FloxApp.resourceManager );
			getCompatibleFileTemplatesOperation.execute();
			
			panel.fileTemplateList.dataProvider = new ArrayCollection( getCompatibleFileTemplatesOperation.compatibleFileTemplates );
			
			var fileTypes:Vector.<IResource> = FloxApp.resourceManager.getResourcesOfType( FileType );
			
			var recentFiles:Array = FloxEditor.settingsManager.getArray("recentFiles").slice();
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
			FloxEditor.viewManager.removePopUp(panel);
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
			var openFileOperation:OpenFileOperation = new OpenFileOperation( new URI( selectedData.path ), FloxApp.fileSystemProvider, FloxEditor.settingsManager );
			openFileOperation.addEventListener( ErrorEvent.ERROR, openFileErrorHandler );
			FloxEditor.operationManager.addOperation(openFileOperation);
		}
		
		private function openFileErrorHandler( event:ErrorEvent ):void
		{
			closePanel();
			openPanel();
			
			Alert.show( "Error opening file", event.text, ["OK"], "OK", FloxEditorIcons.Error );
		}
		
		private function selectFileTemplateHandler( event:ListEvent ):void
		{
			var selectedFileTemplate:FileTemplate = FileTemplate(panel.fileTemplateList.selectedItem);
			var operation:NewFileFromFileTemplateOperation = new NewFileFromFileTemplateOperation( selectedFileTemplate, FloxApp.resourceManager, FloxApp.fileSystemProvider );
			FloxEditor.operationManager.addOperation(operation);
		}
	}
}