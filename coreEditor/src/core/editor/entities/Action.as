// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.entities
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import core.app.events.ValidatorEvent;
	import core.appEx.managers.CommandManager;
	import core.appEx.validators.CommandAvailableValidator;
	
	[Event(type="events.Event", name="change")]
	
	/**
	 * An Action is the Model behind a one or more controls in the application View. For instance, the controls for the command 'Undo' may both
	 * be found in the MenuBar Edit-Undo, and also as a button on the toolbar. The state of both of these controls is driven by a single Action.
	 * @author Jonathan Pace
	 * 
	 */	
	public class Action extends EventDispatcher
	{
		protected var _enabled				:Boolean;
		
		private var commandManager	:CommandManager;
		
		public var command					:String = "";
		public var label					:String = "";
		public var toolBarPath				:String = "";
		public var menuPath					:String = "";
		public var icon						:Class;
		public var disabledIcon				:Class;
		public var parameters				:Object = {};
		
		private var commandAvailableValidator:CommandAvailableValidator;
		
		public function Action()
		{
			
		}
		
		public function init( commandManager:CommandManager ):void
		{
			this.commandManager = commandManager;
			commandAvailableValidator = new CommandAvailableValidator( command, commandManager );
			commandAvailableValidator.addEventListener(ValidatorEvent.STATE_CHANGED, commandAvailabilityChangeHandler);
			
			updateState();
		}
		
		public function dispose():void
		{
			commandAvailableValidator.dispose();
			commandAvailableValidator = null;
			commandManager = null;
		}
		
		public function run():void
		{
			commandManager.executeCommand( command, parameters );
		}
		
		public function set enabled( value:Boolean ):void
		{
			_enabled = value;
			dispatchEvent( new Event( Event.CHANGE ) );
		}
		public function get enabled():Boolean { return _enabled; }
						
		private function commandAvailabilityChangeHandler( event:ValidatorEvent ):void
		{
			updateState();
		}
		
		private function updateState():void
		{
			enabled = commandAvailableValidator.state;
		}
	}
}