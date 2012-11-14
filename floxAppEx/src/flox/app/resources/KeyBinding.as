// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.app.resources
{
	import flox.app.icons.FloxIcons;
	
	public class KeyBinding implements IResource
	{
		public var commandID		:String;
		public var description		:String;
		public var keyCode			:int;
		public var keyModifier		:int;
		
		public function KeyBinding( commandID:String, keyCode:int = -1, keyModifier:int = 0, description:String = "" )
		{
			this.commandID = commandID;
			this.description = description;
			this.keyCode = keyCode;
			this.keyModifier = keyModifier;
		}
		
		public function getLabel():String
		{
			return "Key binding";
		}
		
		public function get icon():Class { return FloxIcons.Keyboard; }
		
		// Implement IResouce
		public function getID():String { return "KeyBinding : " + commandID; }
	}
}