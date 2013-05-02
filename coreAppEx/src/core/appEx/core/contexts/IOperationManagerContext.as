// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.core.contexts
{
	import core.appEx.managers.OperationManager;
	
	public interface IOperationManagerContext extends IContext
	{
		function get operationManager():OperationManager
	}
}