// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.app.resources
{

	public class FileType implements IResource
	{
		protected var _label				:String
		protected var _icon					:Class;
		protected var _extension			:String;
		protected var _command				:String;			// Optionally, you can provide a command that will be called when the user chooses to create a new file of this type.
		
		public function FileType( label:String, 
								  extension:String, 
								  icon:Class = null,
								  command:String = null )
		{
			_label = label;
			_extension = extension;
			_icon = icon;
			_command = command;
		}
		
		public function getLabel():String { return _label; }
		
		public function get icon():Class { return _icon; }
		
		public function get extension():String { return _extension; }
		
		public function get command():String { return _command; }
		
		// Implement IResource
		public function getID():String
		{
			return "FileType : " + _extension;
		}
	}
}