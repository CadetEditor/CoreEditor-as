// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.contexts
{
	import flash.events.IEventDispatcher;
	
	import core.appEx.core.contexts.IVisualContext;
	import core.app.entities.URI;
	
	[Event( type="flash.events.Event", name="change" )];
	
	public interface IEditorContext extends IEventDispatcher, IVisualContext
	{
		function get uri():URI;
		function set uri( value:URI ):void;
		function save():void;
		function publish():void;
		function load():void;
		function set changed(value:Boolean):void;
		function get changed():Boolean;
		function set isNewFile(value:Boolean):void;
		function get isNewFile():Boolean;
		function enable():void;
		function disable():void;
	}
}