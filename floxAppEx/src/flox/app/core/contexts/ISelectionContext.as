// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.app.core.contexts
{
	import flox.core.data.ArrayCollection;
	public interface ISelectionContext extends IContext
	{
		function get selection():ArrayCollection
	}
}