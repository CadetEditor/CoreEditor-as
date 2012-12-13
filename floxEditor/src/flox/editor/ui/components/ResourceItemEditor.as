// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.ui.components
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
	import flox.app.FloxApp;
	import flox.app.core.contexts.IInspectableContext;
	import flox.app.core.contexts.IOperationManagerContext;
	import flox.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import flox.app.entities.URI;
	import flox.app.managers.fileSystemProviders.memory.MemoryFileSystemProvider;
	import flox.app.operations.BindResourceOperation;
	import flox.app.operations.UndoableCompoundOperation;
	import flox.app.resources.IExternalResource;
	import flox.app.resources.IFactoryResource;
	import flox.app.resources.IResource;
	import flox.app.util.IntrospectionUtil;
	import flox.core.data.ArrayCollection;
	import flox.editor.FloxEditor;
	import flox.editor.contexts.IEditorContext;
	import flox.editor.core.FloxEditorEnvironment;
	import flox.editor.icons.FloxEditorIcons;
	import flox.editor.operations.SelectResourceOperation;
	import flox.editor.ui.data.ResourceDataDescriptor;
	import flox.editor.ui.panels.FileSystemListBrowserPanel;
	import flox.editor.utils.FileSystemProviderUtil;
	import flox.ui.components.Button;
	import flox.ui.components.Image;
	import flox.ui.components.List;
	import flox.ui.components.TextStyles;
	import flox.ui.components.UIComponent;
	import flox.ui.events.ComponentFocusEvent;
	import flox.ui.events.ItemEditorEvent;
	import flox.ui.events.ListEvent;
	import flox.ui.managers.PopUpManager;
	
	import flux.skins.TextAreaSkin;

	public class ResourceItemEditor extends UIComponent
	{
		// Properties
		private var _value						:*;
		private var _itemsBeingEdited			:Array;
		private var _propertyOnItemsBeingEdited	:String;
		
		// Child elements
		private var background					:Sprite;
		private var iconImage					:Image;
		private var labelField					:TextField;
		private var browseBtn					:Button;
		//private var list						:List;
		
		private var panel	:FileSystemListBrowserPanel;
		
		private var validExtensions				:Array;
		
		public function ResourceItemEditor()
		{
			validExtensions = ["jpg", "png", "3DS"];
		}
		
		override protected function init():void
		{
			width = 80;
			height = 22;
			
			background = new TextAreaSkin();
			addChild(background);
			
			iconImage = new Image();
			iconImage.scaleMode = Image.SCALE_MODE_FILL;
			addChild(iconImage);
			
			labelField = TextStyles.createTextField();
			addChild(labelField);
			
			browseBtn = new Button();
			browseBtn.icon = FloxEditorIcons.Zoom;
			addChild(browseBtn);
			
			addEventListener(MouseEvent.CLICK, clickHandler);
			addEventListener(ComponentFocusEvent.COMPONENT_FOCUS_OUT, onFocusOut);
		}
		
		override protected function validate():void
		{
			background.width = _width;
			background.height = _height;
			
			browseBtn.width = _height;
			browseBtn.height = _height;
			browseBtn.x = _width - browseBtn.width;
			
			if ( _value )
			{
				iconImage.source = iconFunction(_value, itemsBeingEdited[0], propertyOnItemsBeingEdited);
				labelField.text = labelFunction(_value, itemsBeingEdited[0], propertyOnItemsBeingEdited);
			}
			else
			{
				iconImage.source = null;
				labelField.text = "";
			}
			
			iconImage.x = 2;
			iconImage.y = 2;
			iconImage.width = iconImage.height = _height-4;
			
			labelField.height = labelField.textHeight + 4;
			labelField.x = iconImage.source == null ? 2 : iconImage.x + iconImage.width + 2;
			labelField.width = _width - labelField.x - browseBtn.width;
			labelField.y = (_height - labelField.height) >> 1;
			
			graphics.clear();
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(0,0,_width,_height);
		}
		
		private function openPanel():void
		{
			var assetsURI:URI = new URI(FileSystemProviderUtil.getProjectDirectoryURI(FloxEditor.currentEditorContextURI).path+FloxApp.externalResourceFolderName);
			
			//TODO: recentURI may be "cadet..." rather than "flox...", causing a "Cannot map uri to provider" error.
			var recentURL:String = FloxEditor.settingsManager.getString("flox.app.core.managers.fileSystemProviders.MultiFileSystemProvider.recentAssetsFolder");
			var recentURI:URI;
			if ( recentURL != null ) {
				recentURI = new URI(recentURL);
				
				var related:uint = FileSystemProviderUtil.getRelation(assetsURI, recentURI);
				trace("related "+related+" assetsURI "+assetsURI.path+" recentURI "+recentURI.path);
				// If the stored recentURI is not related to the given assetsURI for this file
				// (e.g. this is a new file which automatically reads from the default assets folder and the
				// stored recentURI points somewhere else) ditch the recentURI.
				if ( related == URI.NOT_RELATED ) {
					recentURI = null;
				}
			}
			
//			var allowedType:Class = IntrospectionUtil.getPropertyType( itemsBeingEdited[0], propertyOnItemsBeingEdited );
//			var dataProvider:ArrayCollection = new ArrayCollection( SelectResourceOperation.getFilteredResources( FloxApp.resourceManager.getResourcesByURI(assetsURI), [allowedType] ) );
			
			panel = new FileSystemListBrowserPanel(recentURI, assetsURI, validExtensions);
			panel.label = "Select Resource";
			panel.validSelectionIsFolder = false;
			panel.validSelectionIsFile = true;
			
			FloxEditor.viewManager.addPopUp(panel);
			panel.list.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
			panel.okBtn.addEventListener(MouseEvent.CLICK, clickOkHandler);
			panel.cancelBtn.addEventListener(MouseEvent.CLICK, clickCancelHandler);
		}
		
		private function disposePanel():void
		{
			panel.list.removeEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
			panel.okBtn.removeEventListener(MouseEvent.CLICK, clickOkHandler);
			panel.cancelBtn.removeEventListener(MouseEvent.CLICK, clickCancelHandler);
			FloxEditor.viewManager.removePopUp(panel);
			panel = null;
		}
		
		private function doubleClickHandler( event:MouseEvent ):void
		{
			if (!panel.list.selectedFile) return;
			
			selectFile();
			disposePanel();	
		}
		private function clickOkHandler( event:MouseEvent ):void
		{
			selectFile();
			disposePanel();	
		}
		private function clickCancelHandler( event:MouseEvent ):void
		{
			disposePanel();
		}
		/*
		private function openList():void
		{
			//var factoryResource:IFactoryResource = FloxApp.resourceManager.getFactoryForInstance( _value );
			var allowedType:Class = IntrospectionUtil.getPropertyType( itemsBeingEdited[0], propertyOnItemsBeingEdited );
			
			//var context:IEditorContext = IEditorContext(FloxEditor.contextManager.getCurrentContext());
			//trace("CONTEXT URI "+context.uri.path);
			
			//var assetsURI:URI = FloxEditor.getAssetsDirectoryURI();
			var assetsURI:URI = new URI(FloxEditor.getProjectDirectoryURI().path+FloxApp.externalResourceFolderName);
			
			var dataProvider:ArrayCollection = new ArrayCollection( SelectResourceOperation.getFilteredResources( FloxApp.resourceManager.getResourcesByURI(assetsURI), [allowedType] ) );
			
//			if ( !list )
//			{
//				list = new List();
//				list.dataDescriptor = new ResourceDataDescriptor();
//				list.addEventListener(ListEvent.ITEM_SELECT, onSelectListItem);
//			}
//			
//			dataProvider.addItemAt({label:"<None>"}, 0);
//			
//			var pt:Point = new Point();
//			pt = localToGlobal(pt);
//			list.dataProvider = dataProvider;
//			list.width = _width;
//			list.height = Math.min( list.itemRendererHeight * dataProvider.length + list.padding * 2, stage.stageHeight - pt.y+_height );
//			list.x = pt.x;
//			list.y = pt.y + _height;
//			
//			PopUpManager.addPopUp(list, false, false);
//			
//			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownStage);
			
		}
		*/
		/*
		private function closeList():void
		{
			if ( !list.stage ) return;
			PopUpManager.removePopUp(list);
		}
		
		private function onMouseDownStage( event:MouseEvent ):void
		{
//			if ( !list.stage ) return;
//			if ( list.hitTestPoint(event.stageX,event.stageY) || hitTestPoint(event.stageX,event.stageY) ) return;
//			if ( hitTestPoint(event.stageX,event.stageY) ) return;
//			closeList();
			
			if ( !panel) return;
			disposePanel();
		}
		*/
		private function onFocusOut( event:ComponentFocusEvent ):void
		{
			//closeList();
			disposePanel();
		}
		
		private function clickHandler( event:MouseEvent ):void
		{
//			if ( list && list.stage )
//			{
//				closeList();
//			}
//			else
//			{
//				openList();
//			}
			
			if ( panel )
			{
				disposePanel();
			}
			else
			{
				openPanel();
			}
		}
		
		//private function onSelectListItem( event:ListEvent ):void
		private function selectFile():void
		{		
			//closeList();
		
			//var assetsURI:URI = FloxEditor.getAssetsDirectoryURI();
			var assetsURI:URI = new URI(FileSystemProviderUtil.getProjectDirectoryURI(FloxEditor.currentEditorContextURI).path+FloxApp.externalResourceFolderName);
			
			var resourceID:String = panel.list.selectedFile.path;
			if ( resourceID.indexOf(assetsURI.path) != -1 ) {
				resourceID = resourceID.replace(assetsURI.path, "");
			}
			
			trace("RECENT ASSETS FOLDER: OPEN "+panel.list.rootNode.uri.toString());
			FloxEditor.settingsManager.setString("flox.app.core.managers.fileSystemProviders.MultiFileSystemProvider.recentAssetsFolder", panel.list.rootNode.uri.toString());
			
			//var factoryResource:IFactoryResource = event.item as IFactoryResource;
			var factoryResource:IFactoryResource = IFactoryResource(FloxApp.resourceManager.getResourceByID(resourceID));
			
			var bindResourcesOperation:UndoableCompoundOperation = new UndoableCompoundOperation();
			bindResourcesOperation.label = "Bind resources";
			
			for ( var i:int = 0; i < itemsBeingEdited.length; i++ )
			{
				var bindResourceOperation:BindResourceOperation = new BindResourceOperation( FloxApp.resourceManager, itemsBeingEdited[i], propertyOnItemsBeingEdited, factoryResource ? factoryResource.getID() : null );
				bindResourcesOperation.addOperation(bindResourceOperation);
			}
			
			var context:IInspectableContext = IInspectableContext(FloxEditor.contextManager.getLatestContextOfType( IInspectableContext ));
			if ( context is IOperationManagerContext )
			{
				IOperationManagerContext(context).operationManager.addOperation(bindResourcesOperation);
			}
			else
			{
				bindResourcesOperation.execute();
			}
			
			dispatchEvent( new ItemEditorEvent( ItemEditorEvent.COMMIT_VALUE, null, null ) );
			
			//valueInvalid = true;
			invalidate();
		}
		
		private function labelFunction( item:*, host:Object, property:String ):String
		{
			if ( item == null )
			{
				return "<No resource>";
			}
			
			
			var resourceID:String = FloxApp.resourceManager.getResourceIDForBinding(host, property);
			if ( resourceID == null )
			{
				return "<Unknown resource>";
			}
			
			return resourceID;
		}
		
		private function iconFunction( item:*, host:Object, property:String ):*
		{
			if ( item == null ) return null;
			
			var resourceID:String = FloxApp.resourceManager.getResourceIDForBinding(host, property);
			var resource:IResource = FloxApp.resourceManager.getResourceByID(resourceID);
			if ( Object(resource).hasOwnProperty( "icon" ) )
			{
				return Object(resource).icon;
			}
			return null;
		}

		public function get itemsBeingEdited():Array
		{
			return _itemsBeingEdited;
		}

		public function set itemsBeingEdited(value:Array):void
		{
			_itemsBeingEdited = value;
			invalidate();
		}

		public function get propertyOnItemsBeingEdited():String
		{
			return _propertyOnItemsBeingEdited;
		}

		public function set propertyOnItemsBeingEdited(value:String):void
		{
			_propertyOnItemsBeingEdited = value;
			invalidate();
		}
		
		public function set value( v:* ):void
		{
			_value = v;
			invalidate();
		}
		
		public function get value():*
		{
			return _value;
		}


	}
}