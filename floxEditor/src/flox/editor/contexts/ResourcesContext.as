// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.contexts
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import flox.app.FloxApp;
	import flox.app.core.contexts.IVisualContext;
	import flox.app.util.VectorUtil;
	import flox.core.data.ArrayCollection;
	import flox.ui.components.List;
	import flox.ui.components.Tree;
	
	public class ResourcesContext implements IVisualContext
	{
		protected var _view	:List;
		
		public function ResourcesContext()
		{
			_view = new List();
			_view.padding = 0;
			_view.showBorder = false;
			
			_view.dataProvider = new ArrayCollection(VectorUtil.toArray(FloxApp.resourceManager.getAllResources()));
		}
		
		public function dispose():void
		{
			
		}
		
		public function get view():DisplayObject { return _view; }
	}
}