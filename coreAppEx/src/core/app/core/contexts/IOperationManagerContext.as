// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.app.core.contexts
{
	import core.app.managers.OperationManager;
	
	public interface IOperationManagerContext extends IContext
	{
		function get operationManager():OperationManager
	}
}