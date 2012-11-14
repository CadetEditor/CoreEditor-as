// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.app.core.contexts
{
	import flox.app.managers.OperationManager;
	
	public interface IOperationManagerContext extends IContext
	{
		function get operationManager():OperationManager
	}
}