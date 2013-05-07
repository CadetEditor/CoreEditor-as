// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.managers
{
	import flash.events.EventDispatcher;
	
	import core.appEx.events.SettingsManagerEvent;
	import core.appEx.events.SettingsManagerEventKind;
	
	[Event( type="core.appEx.events.SettingsManagerEvent", name="change" )]
	
	public class SettingsManager extends EventDispatcher
	{
		private var defaultPreferencesTable	:Object;
		private var preferenceTable			:Object;
		
		public function SettingsManager()
		{
			defaultPreferencesTable = {};
			preferenceTable = {};
		}
		
		public function load( xml:XML ):void
		{
			deserialize( xml );
			dispatchEvent( new SettingsManagerEvent( SettingsManagerEvent.CHANGE, SettingsManagerEventKind.REFRESH ) );
		}
		
		public function save():XML
		{
			return serialize();
		}
		
		public function setArray( id:String, value:Array, isDefault:Boolean = false ):void
		{
			setValue( id, value.slice(), isDefault );
		}
		
		public function getArray( id:String ):Array
		{
			var array:Array = getValue( id ) as Array;
			return array == null ? [] : array.slice();
		}
		
		public function setBoolean(id:String, value:Boolean, isDefault:Boolean = false):void
		{
			setValue(id, value ? "1" : "0", isDefault);
		}
		public function getBoolean(id:String):Boolean
		{
			return getValue(id) == "1";
		}
		
		public function setString(id:String, value:String, isDefault:Boolean = false):void
		{
			setValue(id, value, isDefault);
		}
		public function getString(id:String):String
		{
			var value:Object = getValue(id);
			if (value == null) return null;
			return String(value);
		}
		
		public function setNumber(id:String, value:Number, isDefault:Boolean = false):void
		{
			setValue(id, String(value), isDefault);
		}
		public function getNumber(id:String):Number
		{
			var number:Number = Number(getValue(id));
			return number;
		}
		
		private function setValue(id:String, value:Object, isDefault:Boolean = false):void
		{
			if (value == null)
			{
				preferenceTable[id] = null;
				delete preferenceTable[id];
				return;
			}
			var table:Object = isDefault ? defaultPreferencesTable : preferenceTable;
			table[id] = value;
			
			dispatchEvent( new SettingsManagerEvent( SettingsManagerEvent.CHANGE, SettingsManagerEventKind.UPDATE, id, value ) );
		}
		private function getValue(id:String):Object
		{
			var value:Object = preferenceTable[id];
			if (value == null)
			{
				value = defaultPreferencesTable[id];
			}
			return value;
		}
				
		private function serialize():XML
		{
			var xml:XML = <xml/>;
			for ( var prop:String in preferenceTable )
			{
				var value:Object = preferenceTable[prop];
				var split:Array = prop.split( "." );
				var node:XML = xml;
				for ( var i:int = 0; i < split.length; i++ )
				{
					var nodeName:String = split[i];
					var newNode:XML = node.child( nodeName )[0];
					if ( !newNode )
					{
						newNode = XML( "<" + nodeName + "/>" );
						node.appendChild( newNode );
					}
					
					node = newNode;
				}
				
				if ( value is Array )
				{
					var array:Array = value as Array;
					for ( i = 0; i < array.length; i++ )
					{
						var childValue:String = String(array[i]);
						node.appendChild( new XML( "<child><![CDATA[" + childValue + "]]></child>" ) );
					}
				}
				else
				{
					node.setChildren( new XML( "<![CDATA[" + value + "]]>" ) );
				}
				
			}
			return xml;
		}
		
		private function deserialize(xml:XML):void
		{
			defaultPreferencesTable = {};
			preferenceTable = {};
			parseLevel( xml, "" );
		}
		
		private function parseLevel(xml:XML, path:String):void
		{
			for ( var i:int = 0; i < xml.children().length(); i++ )
			{
				var child:XML = xml.children()[i];
				var newPath:String = path == "" ? child.name() : path + "." + child.name();
				if ( child.nodeKind() == "text" )
				{
					preferenceTable[path] = String( child );
					continue;
				}
				// Check if it needs deserialising as an array
				else if ( child.child.length() > 0 )
				{
					var array:Array = preferenceTable[newPath] = [];
					for ( var j:int = 0; j < child.child.length(); j++ )
					{
						var childArrayNode:XML = child.child[j];
						array[j] = String( childArrayNode );
					}
					continue;
				}
				
				parseLevel( child, newPath );
			}
		}
	}
}