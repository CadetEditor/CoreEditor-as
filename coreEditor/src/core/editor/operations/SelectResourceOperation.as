// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.operations
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	import core.editor.ui.panels.SelectResourcePanel;
	import core.data.ArrayCollection;
	import core.editor.ui.data.ResourceDataDescriptor;
	
	import core.editor.CoreEditor;
	import core.app.core.operations.IAsynchronousOperation;
	import core.app.resources.IFactoryResource;
	import core.app.resources.IResource;
	import core.app.util.IntrospectionUtil;
	import core.appEx.util.VectorUtil;
	
	[Event(type="core.app.events.OperationProgressEvent", name="progress")];
	[Event(type="flash.events.Event", name="complete")];
	[Event(type="flash.events.Event", name="cancel")];
	[Event(type="flash.events.ErrorEvent", name="error")];
	
	public class SelectResourceOperation extends EventDispatcher implements IAsynchronousOperation
	{
		private var panel					:SelectResourcePanel;
		private var resources				:Vector.<IResource>;
		private var _selectedResource		:IResource;
		private var intialSelectedResource	:IResource;
		private var allowedTypes			:Array;
		private var dissallowedTypes			:Array;
		
		public function SelectResourceOperation(resources:Vector.<IResource>, intialSelectedResource:IResource=null, allowedTypes:Array = null, dissallowedTypes:Array = null)
		{
			this.resources = resources;
			this.intialSelectedResource = intialSelectedResource;
			this.allowedTypes = allowedTypes || [];
			this.dissallowedTypes = dissallowedTypes || [];
		}
		
		public function execute():void
		{
			openPanel();
		}
		
		private function clickOkHandler( event:MouseEvent ):void
		{
			if ( panel.list.selectedItem )
			{
				_selectedResource = IResource(panel.list.selectedItem);
			}
			else
			{
				_selectedResource = null;
			}
			
			closePanel();
			dispatchEvent( new Event(Event.COMPLETE) );
			
		}
		
		private function clickCancelHandler( event:MouseEvent ):void
		{
			_selectedResource = null;
			closePanel();
			dispatchEvent( new Event(Event.CANCEL) );
		}
		
		private function clickSelectNoneHandler( event:MouseEvent ):void
		{
			_selectedResource = null;
			panel.list.selectedItem = null;
		}
		
		public function get selectedResource():IResource
		{
			return _selectedResource;
		}
		
		private function openPanel():void
		{
			panel = new SelectResourcePanel();
			CoreEditor.viewManager.addPopUp(panel);
			
			panel.list.dataProvider = new ArrayCollection(getFilteredResources(resources, allowedTypes, dissallowedTypes));
			panel.list.dataDescriptor = new ResourceDataDescriptor();
			
			if ( intialSelectedResource )
			{
				try
				{
					panel.list.selectedItem = intialSelectedResource;
				}
				catch ( e:Error ) {}
			}
			
			panel.okBtn.addEventListener(MouseEvent.CLICK, clickOkHandler);
			panel.cancelBtn.addEventListener(MouseEvent.CLICK, clickCancelHandler);
			panel.selectNoneBtn.addEventListener(MouseEvent.CLICK, clickSelectNoneHandler);
		}
		
		private function closePanel():void
		{
			panel.okBtn.removeEventListener(MouseEvent.CLICK, clickOkHandler);
			panel.cancelBtn.removeEventListener(MouseEvent.CLICK, clickCancelHandler);
			panel.selectNoneBtn.removeEventListener(MouseEvent.CLICK, clickSelectNoneHandler);
			
			CoreEditor.viewManager.removePopUp(panel);
			panel = null;
		}
		
		public function get label():String
		{
			return "Select Resource";
		}
		
		
		public static function getFilteredResources( resources:Vector.<IResource>, allowedTypes:Array = null, dissallowedTypes:Array = null ):Array
		{
			filterAllowedTypes = allowedTypes || [];
			filterDisallowedTypes = dissallowedTypes || [];
			var array:Array = VectorUtil.toArray(resources);
			
			return array.filter( filterFunc );
		}
		
		private static var filterAllowedTypes:Array;
		private static var filterDisallowedTypes:Array;
		
		private static function filterFunc( item:*, index:int, array:Array ):Boolean
		{
			if ( item is IFactoryResource )
			{
				item = IFactoryResource(item).getInstanceType();
			}
			
			var found:Boolean = false;
			for each ( var allowedType:Class in filterAllowedTypes )
			{
				if ( IntrospectionUtil.isRelatedTo(item, allowedType) )
				{
					found = true;
					break;
				}
			}
			
			if ( !found ) return false;
			
			for each ( var disallowedType:Class in filterDisallowedTypes )
			{
				if ( IntrospectionUtil.isRelatedTo(item, disallowedType) )
				{
					return false;
				}
			}
			
			return true;
		}
	}
}