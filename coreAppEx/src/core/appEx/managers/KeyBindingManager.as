// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.managers
{
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	import core.appEx.resources.KeyBinding;
	import core.appEx.entities.KeyModifier;
	import core.appEx.events.KeyBindingManagerEvent;
	import core.app.events.ResourceManagerEvent;
	import core.app.managers.ResourceManager;

	[Event( type="core.appEx.events.KeyBindingManagerEvent", name="keyBindingExecuted" )]

	public class KeyBindingManager extends EventDispatcher
	{
		protected var resourceManager	:ResourceManager;
		protected var commandManager	:CommandManager;
		protected var keyBindings		:Array;
		protected var modifiersDown	:int;
		
		protected var keysDown			:Object = {};
		protected var lastKeyPress		:uint;
		
		public function KeyBindingManager(stage:Stage, resourceManager:ResourceManager, commandManager:CommandManager)
		{
			this.resourceManager = resourceManager;
			this.commandManager = commandManager;
			
			resourceManager.addEventListener(ResourceManagerEvent.RESOURCE_ADDED, resourceAddedHandler);
			
			keyBindings = [];
			keysDown = {};
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler, true);
		}
		
		public function getLastKeyPressed():uint
		{
			return lastKeyPress;
		}
		
		public function isKeyDown( keyCode:uint ):Boolean
		{
			return keysDown[keyCode] == true;
		}
		
		private function resourceAddedHandler( event:ResourceManagerEvent ):void
		{
			if ( event.resource is KeyBinding == false ) return;
			addKeyBinding( KeyBinding(event.resource) );
		}

		private function addKeyBinding( keyBinding:KeyBinding ):void
		{
			if ( keyBindings.indexOf( keyBinding ) != -1 )
			{
				return;
			}
			
			keyBindings.push( keyBinding );
		}
		
		protected function keyDownHandler( event:KeyboardEvent ):void
		{
			keysDown[event.keyCode] = true;
			lastKeyPress = event.keyCode;
			
			if ( event.keyCode == Keyboard.CONTROL ) return;
			if ( event.keyCode == Keyboard.SHIFT ) return;
			if ( event.keyCode == Keyboard.ALTERNATE ) return;
			
			modifiersDown = 0;
			if ( event.ctrlKey ) modifiersDown |= KeyModifier.CTRL;
			if ( event.shiftKey ) modifiersDown |= KeyModifier.SHIFT;
			
			if ( event.target is TextField ) return;
			// Ignore keyboard when a pop-up is visible
			//if ( Application(FlexGlobals.topLevelApplication).systemManager.popUpChildren.numChildren > 0 ) return; 
			
			var matchingKeyBinding:KeyBinding;
			for each( var keyBinding:KeyBinding in keyBindings )
			{
				if ( keyBinding.keyCode == -1 ) continue;
				if ( keyBinding.keyCode != event.keyCode ) continue;
				if ( keyBinding.keyModifier != modifiersDown ) continue;
				if ( event.isDefaultPrevented() ) continue;
				matchingKeyBinding = keyBinding;
				break;
			}
			
			if ( !matchingKeyBinding ) return;
			
			var e:KeyBindingManagerEvent = new KeyBindingManagerEvent( KeyBindingManagerEvent.KEY_BINDING_EXECUTED, keyBinding );
			dispatchEvent( e );
			commandManager.executeCommand(keyBinding.commandID);
			//event.preventDefault();
			//event.stopImmediatePropagation();
		}
		
		protected function keyUpHandler( event:KeyboardEvent ):void
		{
			keysDown[event.keyCode] = false;
		}
	}
}