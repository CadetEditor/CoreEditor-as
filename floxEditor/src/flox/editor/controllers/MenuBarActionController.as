// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.controllers
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import flox.ui.components.MenuBar;
	import flox.core.data.ArrayCollection;
	import flox.ui.events.SelectEvent;
	
	import flox.editor.entities.Action;
	import flox.editor.icons.FloxEditorIcons;
	

	/**
	 * This controller provides the functionality of generating a dataprovider for a MenuBar component based upon a
	 * list of actions. This class is used by IViewContainer's to delegate out the work of keeping their
	 * MenuBar in sync with the Action's targeted at their children.
	 * @author Jonathan Pace
	 */	
	public class MenuBarActionController
	{
		private var menuBar				:MenuBar;
		private var actionDictionary	:Dictionary;
		private var menuItemDictionary	:Dictionary;
		private var dataProvider		:MenuItem;
		
		public function MenuBarActionController( menuBar:MenuBar )
		{
			this.menuBar = menuBar;
			
			actionDictionary = new Dictionary();
			menuItemDictionary = new Dictionary();
			
			dataProvider = new MenuItem();
			
			menuBar.addEventListener(SelectEvent.SELECT, selectItemHandler);
			menuBar.dataProvider = dataProvider.children;
		}
		
		public function dispose():void
		{
			menuBar.removeEventListener(SelectEvent.SELECT, selectItemHandler);
			actionDictionary = null;
			menuItemDictionary = null
			dataProvider = null;
		}
		
		public function addAction( action:Action ):void
		{
			if ( action.menuPath == null || action.menuPath == "" ) return;
			
			var menuItem:MenuItem = new MenuItem();
			
			var path:String = cleanPath(action.menuPath);
			var pathSplit:Array = path.split("/");
			var menuGroup:String = pathSplit.splice(pathSplit.length-1,1)[0];
			menuItem.label = action.label;
			pathSplit.push(action.label);
			menuItem.enabled = action.enabled
			menuItem.groupName = menuGroup
			menuItem.icon = action.icon || FloxEditorIcons.Blank;
			
			// Associate this menuItem with the action via a dictionary
			actionDictionary[menuItem] = action;
			menuItemDictionary[action] = menuItem;
			
			insertMenuItem( menuItem, dataProvider, pathSplit );
			
			action.addEventListener(Event.CHANGE, changeActionHandler);
		}
		
		private function selectItemHandler( event:SelectEvent ):void
		{
			var menuItem:MenuItem = MenuItem( event.selectedItem );
			var action:Action = actionDictionary[menuItem];
			action.run();
		}
		
		private function changeActionHandler( event:Event ):void
		{
			var action:Action = Action(event.target);
			var menuItem:MenuItem = menuItemDictionary[action];
			
			menuItem.enabled = action.enabled;
			
			
			// Update visual
		}
		
		private function insertMenuItem( menuItem:MenuItem, parent:MenuItem, splitPath:Array ):void
		{
			if ( splitPath.length == 1 )
			{
				var action:Action = actionDictionary[menuItem];
				if ( action.command == null ) return;
				parent.children.addItem(menuItem);
				return;
			}
			
			var currentLabel:String = splitPath[0];
			splitPath.splice(0,1);
			
			var nextItem:MenuItem;
			for ( var i:int = 0; i < parent.children.length; i++ )
			{
				var child:MenuItem = MenuItem(parent.children[i]);
				if ( child.label == currentLabel )
				{
					nextItem = child;
					break;
				}
			}
			
			if ( nextItem == null )
			{
				nextItem = new MenuItem();
				nextItem.label = currentLabel;
				parent.children.addItem(nextItem);
			}
			insertMenuItem( menuItem, nextItem, splitPath );
		}
		
		private function cleanPath( value:String ):String
		{
			while (value.indexOf("\\") != -1)
			{
				value = value.replace("\\", "/");
			}
			
			var split:Array = value.split("/");
			var newValue:String = "";
			for (var i:int = 0; i < split.length; i++)
			{
				var chunk:String = split[i];
				if (chunk != "/" && chunk != "")
				{
					newValue += chunk + "/";
				}
			}
			
			if (newValue.charAt(newValue.length-1) == "/") 
			{
				newValue = newValue.substr(0, newValue.length-1);
			}
			
			if (newValue.charAt(0) == "/") 
			{
				newValue = newValue.substr(1, newValue.length-1);
			}
			
			return newValue
		}

	}
}

import flash.events.EventDispatcher;

import flox.core.data.ArrayCollection;
import flox.core.events.PropertyChangeEvent;

internal class MenuItem extends EventDispatcher
{
	public var label			:String;
	public var icon				:Class;
	public var children			:ArrayCollection;
	
	private var _enabled			:Boolean = true;
	public var groupName		:String;
	
	public function MenuItem()
	{
		children = new ArrayCollection();
	}

	public function get enabled():Boolean
	{
		return _enabled;
	}

	public function set enabled(value:Boolean):void
	{
		_enabled = value;
		dispatchEvent( new PropertyChangeEvent( "propertyChange_enabled", null, _enabled ) );
	}
}