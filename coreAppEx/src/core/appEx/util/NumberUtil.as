// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.util
{
	public class NumberUtil
	{
		static public function snapToInterval( value:Number, interval:Number ):Number
		{
			var overshoot:Number = value % interval;
			return overshoot < interval*0.5 ? value - overshoot : value + (interval-overshoot);
		}
	}
}