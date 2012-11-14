// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.core
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	
	import flox.ui.components.Container;
	import flox.ui.components.IUIComponent;
	import flox.ui.components.MenuBar;

	[Event( name="close", type="flash.events.Close" )]
	
	public interface IViewContainer extends IEventDispatcher, IUIComponent
	{
		function set child( value:DisplayObject ):void
		function get child():DisplayObject
		
		function get menuBar():MenuBar;
		function get actionBar():Container;
	}
}