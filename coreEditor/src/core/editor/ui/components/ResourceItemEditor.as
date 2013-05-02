// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.ui.components
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
	import core.app.CoreApp;
	import core.appEx.core.contexts.IInspectableContext;
	import core.appEx.core.contexts.IOperationManagerContext;
	import core.app.entities.URI;
	import core.appEx.operations.BindResourceOperation;
	import core.app.operations.UndoableCompoundOperation;
	import core.app.resources.IFactoryResource;
	import core.app.resources.IResource;
	import core.data.ArrayCollection;
	import core.editor.CoreEditor;
	import core.editor.icons.CoreEditorIcons;
	import core.editor.ui.panels.FileSystemListBrowserPanel;
	import core.editor.utils.FileSystemProviderUtil;
	import core.ui.CoreUI;
	import core.ui.components.Button;
	import core.ui.components.Image;
	import core.ui.components.TextStyles;
	import core.ui.components.UIComponent;
	import core.ui.events.ComponentFocusEvent;
	import core.ui.events.ItemEditorEvent;
	import core.ui.util.Scale9GridUtil;
	
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
		
		public var extensions			:ArrayCollection;
		
		public function ResourceItemEditor()
		{
			extensions = new ArrayCollection(["jpg", "png", "3DS"]);
		}
		
		override protected function init():void
		{
			width = 80;
			height = 22;
			
			background = new TextAreaSkin();
			
			if (!background.scale9Grid) {
				Scale9GridUtil.setScale9Grid(background, CoreUI.defaultTextAreaSkinScale9Grid);
			}
			
			addChild(background);
			
			iconImage = new Image();
			iconImage.scaleMode = Image.SCALE_MODE_FILL;
			addChild(iconImage);
			
			labelField = TextStyles.createTextField();
			addChild(labelField);
			
			browseBtn = new Button();
			browseBtn.icon = CoreEditorIcons.Zoom;
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
			var assetsURI:URI = new URI(FileSystemProviderUtil.getProjectDirectoryURI(CoreEditor.currentEditorContextURI).path+CoreApp.externalResourceFolderName);
			
			//TODO: recentURI may be "cadet..." rather than "core...", causing a "Cannot map uri to provider" error.
			var recentURL:String = CoreEditor.settingsManager.getString("core.app.core.managers.fileSystemProviders.MultiFileSystemProvider.recentAssetsFolder");
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
//			var dataProvider:ArrayCollection = new ArrayCollection( SelectResourceOperation.getFilteredResources( CoreApp.resourceManager.getResourcesByURI(assetsURI), [allowedType] ) );
			
			panel = new FileSystemListBrowserPanel(recentURI, assetsURI, extensions.source);
			panel.label = "Select Resource";
			panel.validSelectionIsFolder = false;
			panel.validSelectionIsFile = true;
			panel.validSelectionIsNull = true; // To enable deselection of assets
			
			CoreEditor.viewManager.addPopUp(panel);
			panel.list.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
			panel.okBtn.addEventListener(MouseEvent.CLICK, clickOkHandler);
			panel.cancelBtn.addEventListener(MouseEvent.CLICK, clickCancelHandler);
		}
		
		private function disposePanel():void
		{
			panel.list.removeEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
			panel.okBtn.removeEventListener(MouseEvent.CLICK, clickOkHandler);
			panel.cancelBtn.removeEventListener(MouseEvent.CLICK, clickCancelHandler);
			CoreEditor.viewManager.removePopUp(panel);
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
			//var factoryResource:IFactoryResource = CoreApp.resourceManager.getFactoryForInstance( _value );
			var allowedType:Class = IntrospectionUtil.getPropertyType( itemsBeingEdited[0], propertyOnItemsBeingEdited );
			
			//var context:IEditorContext = IEditorContext(CoreEditor.contextManager.getCurrentContext());
			//trace("CONTEXT URI "+context.uri.path);
			
			//var assetsURI:URI = CoreEditor.getAssetsDirectoryURI();
			var assetsURI:URI = new URI(CoreEditor.getProjectDirectoryURI().path+CoreApp.externalResourceFolderName);
			
			var dataProvider:ArrayCollection = new ArrayCollection( SelectResourceOperation.getFilteredResources( CoreApp.resourceManager.getResourcesByURI(assetsURI), [allowedType] ) );
			
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
		
			//var assetsURI:URI = CoreEditor.getAssetsDirectoryURI();
			var assetsURI:URI = new URI(FileSystemProviderUtil.getProjectDirectoryURI(CoreEditor.currentEditorContextURI).path+CoreApp.externalResourceFolderName);
			
			var resourceID:String = panel.list.selectedFile ? panel.list.selectedFile.path : "";
			if ( resourceID.indexOf(assetsURI.path) != -1 ) {
				resourceID = resourceID.replace(assetsURI.path, "");
			}
			
			trace("RECENT ASSETS FOLDER: OPEN "+panel.list.rootNode.uri.toString());
			CoreEditor.settingsManager.setString("core.app.core.managers.fileSystemProviders.MultiFileSystemProvider.recentAssetsFolder", panel.list.rootNode.uri.toString());
			
			//var factoryResource:IFactoryResource = event.item as IFactoryResource;
			var factoryResource:IFactoryResource = IFactoryResource(CoreApp.resourceManager.getResourceByID(resourceID));
			
			var bindResourcesOperation:UndoableCompoundOperation = new UndoableCompoundOperation();
			bindResourcesOperation.label = "Bind resources";
			
			for ( var i:int = 0; i < itemsBeingEdited.length; i++ )
			{
				var bindResourceOperation:BindResourceOperation = new BindResourceOperation( CoreApp.resourceManager, itemsBeingEdited[i], propertyOnItemsBeingEdited, factoryResource ? factoryResource.getID() : null );
				bindResourcesOperation.addOperation(bindResourceOperation);
			}
			
			var context:IInspectableContext = IInspectableContext(CoreEditor.contextManager.getLatestContextOfType( IInspectableContext ));
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
			
			_value = factoryResource ? factoryResource.getInstance() : null;
			
			invalidate();
		}
		
		private function labelFunction( item:*, host:Object, property:String ):String
		{
			if ( item == null )
			{
				return "<No resource>";
			}
			
			
			var resourceID:String = CoreApp.resourceManager.getResourceIDForBinding(host, property);
			if ( resourceID == null )
			{
				return "<Unknown resource>";
			}
			
			return resourceID;
		}
		
		private function iconFunction( item:*, host:Object, property:String ):*
		{
			if ( item == null ) return null;
			
			var resourceID:String = CoreApp.resourceManager.getResourceIDForBinding(host, property);
			var resource:IResource = CoreApp.resourceManager.getResourceByID(resourceID);
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

/*		public function get validExtensions():ArrayCollection
		{
			return _validExtensions;
		}
		public function set validExtensions( value:ArrayCollection ):void
		{
			_validExtensions = value;
		}*/

	}
}