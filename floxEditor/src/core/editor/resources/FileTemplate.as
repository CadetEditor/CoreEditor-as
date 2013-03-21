// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.resources
{
	import flash.utils.getDefinitionByName;
	
	import core.app.resources.IResource;

	public class FileTemplate implements IResource
	{
		public var _label			:String;
		public var description		:String;
		public var url				:String;
		private var _iconClassPath	:String;
		
		private var _icon			:Class;
		
		public function FileTemplate()
		{
			
		}
		
		public function getLabel():String
		{
			return _label;
		}
		
		public function deserialise(xml:XML):void
		{
			_label = String(xml.label[0].text());
			description = String(xml.description[0].text());
			url = String(xml.url[0].text());
			iconClassPath = String(xml.icon[0].text());
		}
		
		public function get iconClassPath():String
		{
			return _iconClassPath;
		}
		public function set iconClassPath( value:String ):void
		{
			_iconClassPath = value;
			
			if ( iconClassPath.indexOf("::") ) {
				var arr:Array = iconClassPath.split("::");
				var icons:Class = getDefinitionByName(arr[0]) as Class;
				_icon = icons[arr[1]];
			} else {
				_icon = getDefinitionByName(iconClassPath) as Class;
			}
		}
		
		public function get icon():Class
		{
			return _icon;
/*			try
			{
				return getDefinitionByName(iconClassPath) as Class;
			}
			catch( e:Error ) {}
			return null;*/
		}
		
		/////////////////////////////////////////////////
		// Implement IResource
		/////////////////////////////////////////////////
		public function getID():String
		{
			return _label;
		}
	}
}