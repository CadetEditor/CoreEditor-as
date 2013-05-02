// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.util
{
	public class VectorUtil
	{
		public static function toArray( vector:Object ):Array
		{
			var L:int = vector.length;
			var array:Array = [];
			for ( var i:int = 0; i < L; ++i ) {
				array[i] = vector[i];
			}
			return array;
		}
		
		public static function arrayToVector( array:Array, vector:Object ):Object
		{
			for ( var i:uint = 0; i < array.length; i ++ ) {
				vector[i] = array[i];
			}
			return vector;
		}
	}
}