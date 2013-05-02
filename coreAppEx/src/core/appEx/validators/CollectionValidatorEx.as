// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.validators
{
	import core.data.ArrayCollection;
	import core.events.ArrayCollectionEvent;
	import core.app.events.CollectionValidatorEvent;
	import core.app.util.ArrayUtil;
	import core.app.validators.AbstractValidator;
	
	[Event( type="core.app.events.CollectionValidatorEvent", name="validItemsChanged" )]
	
	public class CollectionValidatorEx extends AbstractValidator
	{
		public static const AND		:String = "and";
		public static const OR		:String = "or";
			
		protected var _collection	:ArrayCollection;
		protected var _validTypes	:Array;
		protected var _min			:uint;
		protected var _max			:uint;
		protected var _compareMode	:String;
		protected var oldCollection	:Array
		
		public function CollectionValidatorEx( collection:ArrayCollection = null, validTypes:Array = null, min:uint = 1, max:uint = uint.MAX_VALUE, compareMode:String = AND )
		{
			oldCollection = [];
			
			this.collection = collection;
			this.validTypes = validTypes;
			this.min = min;
			this.max = max;
			this.compareMode = compareMode;
		}
		
		override public function dispose():void
		{
			if ( _collection )
			{
				_collection.removeEventListener(ArrayCollectionEvent.CHANGE, collectionChangeHandler);
			}
			_collection = null;
			_validTypes = null;
			super.dispose();
		}
		
		public function set collection( value:ArrayCollection ):void
		{
			if ( value == _collection ) return;
			if ( value == null )
			{
				value = new ArrayCollection();
			}
			
			if ( _collection )
			{
				_collection.removeEventListener(ArrayCollectionEvent.CHANGE, collectionChangeHandler);
			}
			_collection = value;
			if ( _collection )
			{
				_collection.addEventListener(ArrayCollectionEvent.CHANGE, collectionChangeHandler);
			}
			updateState();
		}
		public function get collection():ArrayCollection { return _collection; }
		
		private function collectionChangeHandler( event:ArrayCollectionEvent ):void
		{
			updateState();
		}
		
		public function set validTypes( value:Array ):void
		{
			if ( value == null ) value = [];
			_validTypes = value;
			updateState();
		}
		public function get validTypes():Array { return _validTypes; }
		
		public function set compareMode( value:String ):void
		{
			if ( value != OR && value != AND ) return;
			_compareMode = value;
			updateState();
		}
		public function get compareMode():String { return _compareMode; }
		
		public function set min( value:uint ):void
		{
			_min = value;
			updateState();
		}
		public function get min():uint { return _min; }
		
		public function set max( value:uint ):void
		{
			_max = value;
			updateState();
		}
		public function get max():uint { return _max; }
		
		
		public function getValidItems():Array
		{
			if ( !_collection ) return [];
			var validItems:Array = [];
			var validItemsLength:int = 0;
			const L:int = _collection.length;
			for ( var i:int = 0; i < L; i++ )
			{
				var item:* = _collection[i];
				
				var matchesAllTypes:Boolean = true;
				var matchesAtLeastOneType:Boolean = false;
				for each ( var type:Class in _validTypes )
				{
					if ( item is type == false )
					{
						matchesAllTypes = false;
					}
					else
					{
						matchesAtLeastOneType = true;
					}
				}
				
				if ( _compareMode == AND && matchesAllTypes == false ) continue;
				if ( _compareMode == OR && matchesAtLeastOneType == false ) continue;
				
				validItems[validItemsLength++] = item;
			}
			
			if ( validItemsLength < _min ) return [];
			if ( validItemsLength > _max ) return [];
			
			return validItems;
		}
		
		public function get _validItems():Array { return getValidItems(); }
		
		protected function updateState():void
		{
			var validItems:Array = getValidItems();
			
			if ( validItems.length == 0 )
			{
				setState(false);
			}
			else
			{
				setState(true);
			}
			
			if( ArrayUtil.compare( oldCollection, validItems ) == false )
			{
				oldCollection = validItems;
				dispatchEvent( new CollectionValidatorEvent( CollectionValidatorEvent.VALID_ITEMS_CHANGED, validItems ) );
			}
		}
	}
}