// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.resources
{
	import core.editor.entities.Action;
	import core.appEx.entities.Parameter;
	import core.app.resources.IFactoryResource;
	import core.appEx.resources.ITargetedResource;

	public class ActionFactory implements ITargetedResource, IFactoryResource
	{
		private var _label			:String;
		private var _icon			:Class;
		
		public var command			:String;
		public var toolBarPath		:String;
		public var menuPath			:String;
		public var toolTip			:String;
		public var parameters		:Array;
		
		private var _target	:Class;
		
		public function ActionFactory( target:Class, command:String, label:String = "", toolBarPath:String = "", menuPath:String = "", icon:Class = null )
		{
			_label = label;
			this.command = command;
			_target = target;
			this.toolBarPath = toolBarPath;
			this.menuPath = menuPath;
			this.toolTip = toolTip;
			_icon = icon;
			
			parameters = [];
		}
		
		public function getLabel():String 
		{ 
			return _label != "" ? _label : "ActionFactory : " + command;
		}
		
		public function get icon():Class
		{ 
			return _icon; 
		}
		
		/////////////////////////////////////////////////
		// Implement IResourceFactory
		/////////////////////////////////////////////////
		
		public function getID():String
		{
			return getLabel();
		}
		
		public function getInstanceType():Class
		{ 
			return Action;
		}
		
		public function getInstance():Object
		{
			var action:Action = new Action();
			action.label = _label;
			action.command = command;
			action.toolBarPath = toolBarPath;
			action.menuPath = menuPath;
			action.icon = icon;
			for each ( var parameter:Parameter in parameters )
			{
				action.parameters[parameter.name] = parameter.value;
			}
			return action;
		}
		
		/////////////////////////////////////////////////
		// Implement ITargetedResource
		/////////////////////////////////////////////////
		
		public function get target():Class
		{
			return _target;
		}
	}
}