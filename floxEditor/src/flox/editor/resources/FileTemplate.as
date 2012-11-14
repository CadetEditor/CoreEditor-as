// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.resources
{
	import flash.utils.getDefinitionByName;
	
	import flox.app.entities.URI;
	import flox.app.resources.IResource;

	public class FileTemplate implements IResource
	{
		public var _label			:String;
		public var description		:String;
		public var url				:String;
		public var iconClassPath	:String;
		
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
		
		public function get icon():Class
		{
			try
			{
				return getDefinitionByName(iconClassPath) as Class;
			}
			catch( e:Error ) {}
			return null;
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