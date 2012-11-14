// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.app.util
{
	public class VectorUtil
	{
		public static function toArray( vec:Object ):Array
		{
			var L:int = vec.length;
			var array:Array = [];
			for ( var i:int = 0; i < L; ++i )
			{
				array[i] = vec[i];
			}
			return array;
		}
	}
}