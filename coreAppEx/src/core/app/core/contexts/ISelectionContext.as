// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.app.core.contexts
{
	import core.data.ArrayCollection;
	public interface ISelectionContext extends IContext
	{
		function get selection():ArrayCollection
	}
}