// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package
{
	CONFIG::debug
	public function assert( condition:Boolean, errorMessage:String ):void
	{
		if ( condition ) return;
		throw( new Error( "Assertion failure : " + errorMessage ) );
	}
	
	CONFIG::release
	public function assert( condition:Boolean, errorMessage:String ):void
	{
		
	}
}