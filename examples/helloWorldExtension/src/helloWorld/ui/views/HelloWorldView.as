package helloWorld.ui.views
{
	import flox.ui.components.TextArea;
	
	public class HelloWorldView extends TextArea
	{
		public function HelloWorldView()
		{
			
		}
		
		override protected function init():void
		{
			super.init();
			_percentWidth = _percentHeight = 100;
		}
	}
}