// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.validators
{
	import flash.events.EventDispatcher;
	
	import core.app.core.validators.IValidator;
	import core.app.events.ValidatorEvent;
	
	// This state validator's state is determined by the state of the validators added
	// as children. Various operations are support - 
	// AND - all child state validator's state must be true for the state of this to be true
	// OR - any child state validator's state can be true for the state of this to be true
	// XOR - any child state validator's state can be true, but not all, for the state of this to be true
	
	[Event(type="core.app.events.ValidatorEvent", name="stateChanged")]
	
	public class CompoundValidator extends EventDispatcher implements IValidator
	{
		public static const AND			:int = 0;
		public static const OR			:int = 1;
		public static const XOR			:int = 2;
		
		private var _validators			:Array;
		protected var _operation		:int = 0;
		protected var _state			:Boolean = true;
		
		public function CompoundValidator()
		{
			_validators = [];
		}
		
		public function dispose():void
		{
			while ( _validators.length > 0 ) 
			{
				removeValidator( _validators[0] );
			}
			_validators = null;
		}
		
		public function set operation( value:int ):void
		{
			_operation = value;
			validateState();
		}
		public function get operation():int { return _operation; }
		
		public function addValidator( validator:IValidator ):void
		{
			if (_validators.indexOf(validator) != -1) return;
			
			_validators.push( validator );
			validator.addEventListener( ValidatorEvent.STATE_CHANGED, stateChangedHandler );
			validateState();
		}

		public function removeValidator( validator:IValidator ):void
		{
			if ( _validators.indexOf( validator ) == -1 ) return;
			
			_validators.splice( _validators.indexOf( validator ), 1 );
			validator.removeEventListener( ValidatorEvent.STATE_CHANGED, stateChangedHandler );
			validateState();
		}

		private function stateChangedHandler( event:ValidatorEvent ):void
		{
			validateState();
		}
		
		protected function validateState():void
		{
			var oldState:Boolean = _state;
			var XORFlag:Boolean = false;
			
			_state = _operation == AND;
			for each ( var validator:IValidator in _validators )
			{
				if ( _operation == AND )
				{
					if ( validator.state == false ) 
					{
						_state = false;
						break;
					}
				}
				else if ( _operation == OR )
				{
					_state = _state || validator.state;
					if ( _state ) break;
				}
				else if ( _operation == XOR )
				{
					if ( validator.state == false ) 
					{
						XORFlag = true;
					}
					else
					{
						_state = true;
					}
				}
			}
			
			if ( XORFlag ) _state = false;
			
			if ( _state == oldState ) return;
			dispatchEvent( new ValidatorEvent( ValidatorEvent.STATE_CHANGED, _state ) );
		}
		
		public function get state():Boolean { return _state; }
		
		public function get validators():Array { return _validators.slice(); }
	}
}