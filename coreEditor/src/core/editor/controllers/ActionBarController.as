// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.controllers
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import core.ui.components.Container;
	import core.ui.components.Button;
	import core.ui.components.VRule;
	import flux.skins.ToolbarButtonSkin;
	
	import core.editor.entities.Action;
	import core.editor.entities.ActionBarGroup;
	import core.app.icons.FloxIcons;
	
	/**
	 * This controller provides the functionality of creating a button for each Action, and adding it to the supplied container (the 'actionbar')
	 * Typically this container would be a HBox, but this class only requires that it extends the Container class.
	 * @author Jonathan Pace
	 */	
	public class ActionBarController
	{
		private var actionBar		:Container;
		
		private var actions			:Array;
		private var groups			:Array;
		private var buttonStyleName	:String;
		
		private var actionDictionary	:Dictionary;
		private var buttonDictionary	:Dictionary;
		
		public function ActionBarController( actionBar:Container, buttonStyleName:String = null )
		{
			this.actionBar = actionBar;
			this.buttonStyleName = buttonStyleName;
			
			actions = [];
			groups = [];
			
			actionDictionary = new Dictionary();
			buttonDictionary = new Dictionary();
		}
		
		public function dispose():void
		{
			
		}
		
		public function addAction( action:Action ):void
		{
			if ( action.toolBarPath == null || action.toolBarPath == "" ) return;
			
			if ( actions.indexOf(action) != -1 ) return;
			
			var button:Button = new Button(flux.skins.ToolbarButtonSkin);
			button.icon = action.icon == null ? FloxIcons.NoIcon : action.icon;
			button.width = 28
			button.height = 28
			button.toolTip = action.label
			
			button.addEventListener(MouseEvent.CLICK, clickButtonHandler);
			action.addEventListener(Event.CHANGE, changeActionHandler);
			
			var group:ActionBarGroup = addGroup( action.toolBarPath );
			group.addItem( button, -1 );
			layout();
						
			// Associate this button with the action via a dictionary
			actionDictionary[button] = action;
			buttonDictionary[action] = button;
			
			actions.push(action);
		}
		
		public function removeAction( action:Action ):void
		{
			var button:Button = buttonDictionary[action];
			if ( !button ) return;
			
			button.removeEventListener( MouseEvent.CLICK, clickButtonHandler );
			action.removeEventListener(Event.CHANGE, changeActionHandler);
			
			for each (var group:ActionBarGroup in groups) 
			{
				if ( group.hasItem( button ) )
				{
					group.removeItem( button );
					if ( group.numItems == 0 )
					{
						removeGroup( group );
					}
					break
				}
			}
			
			layout();
			delete actionDictionary[button];
			delete buttonDictionary[action];
			
			actions.splice(actions.indexOf(action),1);
		}
		
		private function clickButtonHandler( event:MouseEvent ):void
		{
			var action:Action = actionDictionary[Button(event.target)];
			action.run();
		}
		
		private function changeActionHandler( event:Event ):void
		{
			updateButtonFromAction( Action( event.target ) );
		}
		
		private function updateButtonFromAction( action:Action ):void
		{
			var button:Button = buttonDictionary[action];
			button.enabled = action.enabled;
		}
				
		protected function addGroup( id:String, index:int = -1 ):ActionBarGroup
		{
			// Check if group already exists
			for each ( var group:ActionBarGroup in groups ) 
			{
				if ( group.id == id ) return group;
			}
			
			if ( index == -1 ) 
			{
				index = groups.length;
			}
			
			var newGroup:ActionBarGroup = new ActionBarGroup( id );
			groups.splice( index, 0, newGroup );
			
			return newGroup;
		}
		
		protected function removeGroup( group:ActionBarGroup ):void
		{
			var index:int = groups.indexOf( group );
			if ( index == -1 ) return;
			groups.splice( index,1 );
			group.destroy();
		}
		
		protected function layout():void
		{
			for each ( var button:Button in buttonDictionary )
			{
				actionBar.removeChild(button);
			}
			
			for ( var i:int = 0; i < groups.length; i++ )
			{
				var group:ActionBarGroup = groups[i]
				
				for ( var j:int = 0; j < group.numItems; j++ )
				{
					var item:DisplayObject = group.getItem(j);
					actionBar.addChild( item );
				}
				
				if ( i != groups.length -1 ) 
				{
					var vRule:VRule = new VRule();
					vRule.height = 28;
					actionBar.addChild(vRule);
				}
			}
			
			actionBar.validateNow();
		}
	}
}