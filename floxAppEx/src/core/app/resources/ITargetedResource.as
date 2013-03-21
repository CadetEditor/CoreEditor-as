// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.app.resources
{

	public interface ITargetedResource extends IResource
	{
		function get target():Class;
	}
}