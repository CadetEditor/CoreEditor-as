// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.ui.components
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import core.ui.events.ContainerEvent;
	import core.ui.layouts.LayoutAlign;
	import core.ui.util.BindingUtil;
	
	import core.editor.core.IEditorViewContainer;
	import core.editor.core.IViewContainer;
	import core.ui.components.Container;
	import core.ui.components.HBox;
	import core.ui.components.MenuBar;
	import core.ui.components.UIComponent;
	
	public class DefaultEditorViewContainer extends Container implements IViewContainer, IEditorViewContainer
	{
		// Child elements
		private var _menuBar		:MenuBar;
		private var _actionBar		:HBox;
		
		public function DefaultEditorViewContainer()
		{
			
		}
		
		override protected function init():void
		{
			super.init();
			
			padding = 2;
			
			_menuBar = new MenuBar();
			//addRawChild(_menuBar);
			
			_actionBar = new HBox();
			_actionBar.verticalAlign = LayoutAlign.CENTRE;
			_actionBar.visible = false;
			_actionBar.addEventListener(ContainerEvent.CHILD_ADDED, actionBarChildrenChangedHandler);
			_actionBar.addEventListener(ContainerEvent.CHILD_REMOVED, actionBarChildrenChangedHandler);
			_actionBar.height = 28;
			addRawChild(_actionBar);
		}
		
		override protected function validate():void
		{
			super.validate();
			
			//_menuBar.y = _titleBarHeight;
			//_menuBar.width = _width;
			_actionBar.width = _width;
		}
		
		private function actionBarChildrenChangedHandler( event:ContainerEvent ):void
		{
			var shouldActionBarBeVisible:Boolean = _actionBar.numChildren > 0;
			if ( _actionBar.visible == shouldActionBarBeVisible ) return;
			_actionBar.visible = shouldActionBarBeVisible;
			invalidate();
		}
		
		override protected function getChildrenLayoutArea():Rectangle
		{
			var rect:Rectangle = super.getChildrenLayoutArea();
			rect.top += _actionBar.visible ? _actionBar.height : 0;
			return rect;
		}
		
		public function set child( value:DisplayObject ):void
		{
			var existingChild:DisplayObject = child;
			if ( existingChild is UIComponent )
			{
				BindingUtil.unbind( existingChild, "label", this, "label" );
				BindingUtil.unbind( existingChild, "icon", this, "icon" );
			}
			if ( existingChild != null )
			{
				removeChild(existingChild);
			}
			
			if ( value is UIComponent )
			{
				UIComponent( value ).percentWidth = 100;
				UIComponent( value ).percentHeight = 100;
				label = UIComponent( value ).label;
				
				BindingUtil.bind( value, "label", this, "label" );
				BindingUtil.bind( value, "icon", this, "icon" );
			}
			
			if ( value != null )
			{
				addChild( value );
			}
		}
		public function get child():DisplayObject
		{
			if ( numChildren == 0 ) return null;
			return getChildAt(0);
		}
		
		public function get menuBar():MenuBar
		{
			return _menuBar;
		}
		
		public function get actionBar():Container
		{
			return _actionBar;
		}
	}
}