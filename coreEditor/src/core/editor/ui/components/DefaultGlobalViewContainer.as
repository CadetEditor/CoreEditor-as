// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.ui.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import core.ui.components.VDividedBox;
	import core.ui.events.ContainerEvent;
	import core.ui.events.IndexChangeEvent;
	import core.ui.events.TabNavigatorEvent;
	import core.ui.layouts.VerticalLayout;
	
	import core.editor.core.IEditorViewContainer;
	import core.editor.core.IGlobalViewContainer;
	import core.editor.core.IViewContainer;
	import core.editor.events.GlobalViewContainerEvent;
	import core.ui.components.Container;
	import core.ui.components.HBox;
	import core.ui.components.MenuBar;
	import core.ui.components.ProgressBar;
	import core.ui.components.ScrollPane;
	import core.ui.components.TabNavigator;

	public class DefaultGlobalViewContainer extends Container implements IGlobalViewContainer
	{
		// Child elements
		private var _menuBar			:MenuBar;
		private var _actionBar			:HBox;
		private var editorContainer		:TabNavigator;
		private var viewContainer		:VDividedBox;
		private var progressBar			:ProgressBar;
		
		public function DefaultGlobalViewContainer()
		{
			
		}
		
		////////////////////////////////////////////////
		// Public methods
		////////////////////////////////////////////////
		
		// Implement IViewContainer
		
		public function set child( value:DisplayObject ):void {}
		public function get child():DisplayObject
		{
			return null
		}
		
		public function get menuBar():MenuBar
		{
			return _menuBar;
		}
		
		public function get actionBar():Container
		{
			return _actionBar;
		}
		
		
		public function setProgress( label:String, progress:Number, indeterminate:Boolean = false  ):void
		{
			progressBar.progress = progress;
			progressBar.indeterminate = progress == -1;
			progressBar.visible = true;
		}
		
		public function clearProgress():void
		{
			progressBar.progress = 0;
			progressBar.indeterminate = false;
			progressBar.visible = false;
		}
		
		// Implement IGlobalViewContainer
		
		public function addViewContainer( container:IViewContainer ):void
		{
			if ( container is IEditorViewContainer )
			{
				container.percentWidth = 100;
				container.percentHeight = 100;
				editorContainer.addChild(DisplayObject(container));
				dispatchEvent( new GlobalViewContainerEvent( GlobalViewContainerEvent.EDITOR_ADDED, container ) );
			}
			else
			{
				container.percentWidth = 100;
				container.height = 260;
				viewContainer.addChild(DisplayObject(container));
				container.addEventListener(Event.CLOSE, closeContainerHandler);
				dispatchEvent( new GlobalViewContainerEvent( GlobalViewContainerEvent.VIEW_ADDED, container ) );
			}
		}
		
		public function removeViewContainer( container:IViewContainer ):void
		{
			if ( container is IEditorViewContainer )
			{
				editorContainer.removeChild(DisplayObject(container));
				dispatchEvent( new GlobalViewContainerEvent( GlobalViewContainerEvent.EDITOR_REMOVED, container ) );
			}
			else
			{
				viewContainer.removeChild(DisplayObject(container));
				container.removeEventListener(Event.CLOSE, closeContainerHandler);
				dispatchEvent( new GlobalViewContainerEvent( GlobalViewContainerEvent.VIEW_REMOVED, container ) );
			}
		}
		
		public function showViewContainer( container:IViewContainer ):void
		{
			if ( container is IEditorViewContainer )
			{
				var index:int = editorContainer.getChildIndex(DisplayObject(container));
				editorContainer.visibleIndex = index;
				dispatchEvent( new GlobalViewContainerEvent( GlobalViewContainerEvent.EDITOR_SHOWN, container ) );
			}
			else
			{
				DefaultViewContainer(container).opened = true;
			}
		}
		
		////////////////////////////////////////////////
		// Protected methods
		////////////////////////////////////////////////
		
		override protected function init():void
		{
			super.init();
			
			padding = 0;
			
			layout = new VerticalLayout();
			
			_menuBar = new MenuBar();
			addRawChild(_menuBar);
			
			_actionBar = new HBox();
			_actionBar.height = 28;
			_actionBar.addEventListener(ContainerEvent.CHILD_ADDED, actionBarChangeHandler);
			_actionBar.addEventListener(ContainerEvent.CHILD_REMOVED, actionBarChangeHandler);
			addRawChild(_actionBar);
			
			var hBox:HBox = new HBox();
			hBox.percentWidth = 100;
			hBox.percentHeight = 100;
			hBox.spacing = 4;
			addChild(hBox);
			
			editorContainer = new TabNavigator();
			editorContainer.percentWidth = 100;
			editorContainer.percentHeight = 100;
			editorContainer.addEventListener(IndexChangeEvent.INDEX_CHANGE, changeVisibleTabHandler);
			editorContainer.addEventListener(TabNavigatorEvent.CLOSE_TAB, closeTabHandler);
			hBox.addChild(editorContainer);
			
			var scrollPane:ScrollPane = new ScrollPane();
			scrollPane.width = 360;
			scrollPane.percentHeight = 100;
			hBox.addChild(scrollPane);
			
			viewContainer = new VDividedBox();
			viewContainer.percentWidth = 100;
			viewContainer.percentHeight = 100;
			viewContainer.resizeToContentHeight = true;
			scrollPane.addChild(viewContainer);
			
			progressBar = new ProgressBar();
			progressBar.percentWidth = 100;
			addChild(progressBar);
			
			clearProgress();
		}
		
		override protected function validate():void
		{
			super.validate();
			
			_menuBar.width = _width;
			_actionBar.width = _width;
			_actionBar.y = _menuBar.height;
		}
		
		override protected function getChildrenLayoutArea():Rectangle
		{
			var rect:Rectangle = super.getChildrenLayoutArea();
			rect.top += _menuBar.height + 8;
			if ( actionBar.numChildren > 0 )
			{
				rect.top += actionBar.height;
			}
			return rect;
		}
		
		////////////////////////////////////////////////
		// Event handlers
		////////////////////////////////////////////////
		
		private function actionBarChangeHandler( event:ContainerEvent ):void
		{
			invalidate();
		}
		
		private function closeContainerHandler( event:Event ):void
		{
			dispatchEvent( event );
		}
		
		private function closeTabHandler( event:TabNavigatorEvent ):void
		{
			var container:IViewContainer = IViewContainer(editorContainer.getChildAt(event.tabIndex));
			container.dispatchEvent(new Event(Event.CLOSE));
		}
		
		private function changeVisibleTabHandler( event:IndexChangeEvent ):void
		{
			if ( event.oldIndex > -1 )
			{
				try
				{
					var hiddenEditor:IViewContainer = IViewContainer( editorContainer.getChildAt(event.oldIndex) );
					dispatchEvent( new GlobalViewContainerEvent( GlobalViewContainerEvent.EDITOR_HIDDEN, hiddenEditor ) );
				}
				catch( e:Error ) {}
			}
			
			if ( event.newIndex > -1 )
			{
				var shownEditor:IViewContainer = IViewContainer( editorContainer.getChildAt(event.newIndex) );
				dispatchEvent( new GlobalViewContainerEvent( GlobalViewContainerEvent.EDITOR_SHOWN, shownEditor ) );
			}
		}
	}
}