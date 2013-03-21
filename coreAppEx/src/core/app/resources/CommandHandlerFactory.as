// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.app.resources
{
	import core.app.core.commandHandlers.ICommandHandler;
	import core.app.icons.FloxIcons;
	import core.app.util.IntrospectionUtil;
	
	public class CommandHandlerFactory implements IFactoryResource
	{
		private var _type			:Class;
		private var _command		:String;
		private var _validators		:Array;
		
		public function CommandHandlerFactory( command:String, type:Class, validators:Array = null )
		{
			_command = command;
			_type = type;
			if ( !validators ) validators = [];
			_validators = validators;
		}
		
		public function getLabel():String
		{
			return "Command Handler Factory";
		}
		
		public function get icon():Class { return FloxIcons.CommandHandler; }
		public function get command():String { return _command; }
		public function get validators():Array { return _validators; }
		
		// Implement IFactoryResource
		public function getID():String 
		{ 
			return IntrospectionUtil.getClassName( _type );
		}
		
		public function getInstanceType():Class
		{
			return _type;
		}
		
		public function getInstance():Object
		{
			return ICommandHandler( new _type() );
		}
	}
}