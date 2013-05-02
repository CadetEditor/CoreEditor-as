// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.core.contexts
{
	import flash.display.DisplayObject;
	
	public interface IVisualContext extends IContext
	{
		function get view():DisplayObject;
	}
}