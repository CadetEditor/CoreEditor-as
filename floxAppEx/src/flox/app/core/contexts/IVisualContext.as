// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.app.core.contexts
{
	import flash.display.DisplayObject;
	
	public interface IVisualContext extends IContext
	{
		function get view():DisplayObject;
	}
}