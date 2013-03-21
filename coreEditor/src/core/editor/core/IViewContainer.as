// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.core
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	
	import core.ui.components.Container;
	import core.ui.components.IUIComponent;
	import core.ui.components.MenuBar;

	[Event( name="close", type="flash.events.Close" )]
	
	public interface IViewContainer extends IEventDispatcher, IUIComponent
	{
		function set child( value:DisplayObject ):void
		function get child():DisplayObject
		
		function get menuBar():MenuBar;
		function get actionBar():Container;
	}
}