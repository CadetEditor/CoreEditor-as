// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.resources
{
	import core.app.resources.IResource;

	public interface ITargetedResource extends IResource
	{
		function get target():Class;
	}
}