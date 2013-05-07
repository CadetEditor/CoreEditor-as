// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.util
{
	import core.app.util.StringUtil;
	
	public class Validation
	{
		static public function isEmptyString( value:String ):Boolean
		{
			value = StringUtil.trim( value );
			return value == "";
		}
		
		static public function isValidFilename( value:String ):Boolean
		{
			if ( value == "" ) return false;
			var regExp:RegExp = new RegExp( '[\?"\\/*:<>]|' );
			return regExp.test( value );
		}
		
		static public function isEmail(value:String):Boolean
		{
			var regEx:RegExp = new RegExp("^([0-9a-zA-Z]+[-._+&])*[0-9a-zA-Z_]+@([-0-9a-zA-Z]+[.])+[a-zA-Z]{2,6}$");
			return regEx.test(value);
		}
	}
}