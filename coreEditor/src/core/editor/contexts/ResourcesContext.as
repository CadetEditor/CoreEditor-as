// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.contexts
{
	import flash.display.DisplayObject;
	
	import core.app.CoreApp;
	import core.appEx.core.contexts.IVisualContext;
	import core.appEx.util.VectorUtil;
	import core.data.ArrayCollection;
	import core.ui.components.List;
	
	public class ResourcesContext implements IVisualContext
	{
		protected var _view	:List;
		
		public function ResourcesContext()
		{
			_view = new List();
			_view.padding = 0;
			_view.showBorder = false;
			
			_view.dataProvider = new ArrayCollection(VectorUtil.toArray(CoreApp.resourceManager.getAllResources()));
		}
		
		public function dispose():void
		{
			
		}
		
		public function get view():DisplayObject { return _view; }
	}
}