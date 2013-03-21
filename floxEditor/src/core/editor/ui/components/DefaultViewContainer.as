// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.ui.components
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import core.ui.events.ContainerEvent;
	import core.ui.events.SelectEvent;
	import core.ui.layouts.LayoutAlign;
	import core.ui.util.BindingUtil;
	
	import core.editor.core.IViewContainer;
	import core.ui.components.CollapsiblePanel;
	import core.ui.components.Container;
	import core.ui.components.HBox;
	import core.ui.components.MenuBar;
	import core.ui.components.UIComponent;
	
	public class DefaultViewContainer extends CollapsiblePanel implements IViewContainer
	{
		// Properties
		private var _resizable		:Boolean = true;
		
		// Child elements
		private var _menuBar		:MenuBar;
		private var _actionBar		:HBox;
		
		public function DefaultViewContainer()
		{
			
		}
		
		override protected function init():void
		{
			super.init();
			
			_menuBar = new MenuBar();
			//addRawChild(_menuBar);
			
			showCloseButton = true;
			
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
			_actionBar.x = titleField.x + titleField.textWidth + 6;
			_actionBar.width = _width - _actionBar.x - (_width-closeBtn.x);
			_actionBar.y = (_titleBarHeight - actionBar.height) >> 1;
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
			//rect.top += _actionBar.visible ? _actionBar.height : 0;
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