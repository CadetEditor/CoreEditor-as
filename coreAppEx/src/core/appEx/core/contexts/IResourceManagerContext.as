// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.core.contexts
{
	import core.app.managers.ResourceManager;
	
	public interface IResourceManagerContext extends IContext
	{
		function get resourceManager():ResourceManager
	}
}