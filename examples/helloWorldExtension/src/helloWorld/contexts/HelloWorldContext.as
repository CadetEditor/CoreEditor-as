package helloWorld.contexts
{
	import flash.display.DisplayObject;
	
	import flox.app.core.contexts.IVisualContext;
	
	import helloWorld.ui.views.HelloWorldView;
	
	public class HelloWorldContext implements IVisualContext
	{
		private var _view		:HelloWorldView;
		
		public function HelloWorldContext()
		{
			_view = new HelloWorldView();
			
			_view.text = "Hello World";
		}
		
		public function get view():DisplayObject
		{
			return _view;
		}

		public function dispose():void
		{
		}
	}
}