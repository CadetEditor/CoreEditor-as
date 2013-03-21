package helloWorld.ui.views
{
	import core.ui.components.List;
	
	public class StringListView extends List
	{
		
		public function StringListView()
		{
			
		}
		
		override protected function init():void
		{
			super.init();
			_percentWidth = _percentHeight = 100;
		}
	}
}