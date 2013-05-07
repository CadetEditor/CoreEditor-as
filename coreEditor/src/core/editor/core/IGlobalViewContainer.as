// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.core
{
	[Event( type="core.editor.events.GlobalViewContainerEvent", name="viewAdded" )];
	[Event( type="core.editor.events.GlobalViewContainerEvent", name="viewRemoved" )];
	[Event( type="core.editor.events.GlobalViewContainerEvent", name="editorAdded" )];
	[Event( type="core.editor.events.GlobalViewContainerEvent", name="editorRemoved" )];
	[Event( type="core.editor.events.GlobalViewContainerEvent", name="editorShown" )];
	[Event( type="core.editor.events.GlobalViewContainerEvent", name="editorHidden" )];
		
	public interface IGlobalViewContainer extends IViewContainer
	{
		function setProgress( label:String, progress:Number, indeterminate:Boolean = false ):void
		function clearProgress():void
		function addViewContainer( viewContainer:IViewContainer ):void
		function removeViewContainer( viewContainer:IViewContainer ):void
		function showViewContainer( viewContainer:IViewContainer ):void
	}
}