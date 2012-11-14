// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.app.resources
{
	import flox.app.util.IntrospectionUtil;
	
	public class PropertyInspectorItemEditorFactory implements IFactoryResource
	{
		/**
		 * The id of the editor. This is how the property inspector matches up inspectable properties with an editor.
		 * For example, the metatdata
		 * [Inspectable(editor="ComboBox")]
		 * Will cause the PropertyInspector to look for a PropertyInspectorItemEditorFactory with an id =="ComboBox"
		 */		
		private var _id					:String
		
		/**
		 * The type of the editor to be created by this factory's createInstance() method. 
		 */		
		private var _type				:Class
		
		/**
		 * The name of the property on the editor that contains the value being edited (eg NumericStepper's is "value"))
		 */		
		private var _valueField			:String;
		/**
		 * The name of the property on the editor that should be set with an array of the items being edited. 
		 * This can be null, in which case it is assumed the editor does not need access to the object owning the property being edited.
		 */		
		private var _itemsField			:String;
		/**
		 *  The name of the property on the editor that should be set with the name of the property on the items being edited . 
		 *  This can be null.
		 */		
		private var _itemsPropertyField	:String;
				
		/**
		 * (Optional) If true (default), the property inspector will automatically commit the editor's value to the object being edited. 
		 * Set this to false if you want to handle this entirely within the editor.
		 */		
		public var _autoCommitValue		:Boolean;
		
		public function PropertyInspectorItemEditorFactory( id:String, type:Class, valueField:String, itemsField:String = null, itemsPropertyField:String = null, autoCommitValue:Boolean = true )
		{
			_id = id;
			_type = type;
			_valueField = valueField;
			_itemsField = itemsField;
			_itemsPropertyField = itemsPropertyField;
			_autoCommitValue = autoCommitValue;
		}
		
		public function getLabel():String { return IntrospectionUtil.getClassName( _type ); }
		public function get icon():Class { return null; }
		public function get valueField():String { return _valueField; }
		public function get itemsField():String { return _itemsField; }
		public function get itemsPropertyField():String { return _itemsPropertyField; }
		public function get autoCommitValue():Boolean { return _autoCommitValue; }
		
		// Implement IFactoryResouce
		public function getID():String
		{ 
			return _id;
		}
		
		public function getInstanceType():Class
		{ 
			return _type;
		}
		
		public function getInstance():Object
		{
			var itemEditor:Object = new _type();
			return itemEditor;
		}
	}
}