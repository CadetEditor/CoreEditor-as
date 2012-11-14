// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.app.core.contexts
{
	import flox.app.managers.ResourceManager;
	
	public interface IResourceManagerContext extends IContext
	{
		function get resourceManager():ResourceManager
	}
}