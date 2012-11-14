// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.ui.components
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import flux.components.ListItemRendererRollOverSkin;
	
	import flox.editor.resources.FileTemplate;
	import flox.ui.components.IItemRenderer;
	import flox.ui.components.Image;
	import flox.ui.components.List;
	import flox.ui.components.TextStyles;
	import flox.ui.components.UIComponent;

	public class FileTemplateItemRenderer extends UIComponent implements IItemRenderer
	{
		// Properties
		private var _selected			:Boolean = false;
		private var _down				:Boolean = false;
		private var _over				:Boolean = false;
		
		// Child elements
		private var skin				:MovieClip;
		private var titleField			:TextField;
		private var descriptionField	:TextField;
		private var iconImage			:Image;
		
		// Internal vars
		private var _data				:Object;
		private var _list				:List;
		
		public function FileTemplateItemRenderer()
		{
			
		}
		
		////////////////////////////////////////////////
		// Protected methods
		////////////////////////////////////////////////
		
		override protected function init():void
		{
			skin = new ListItemRendererRollOverSkin();
			addChild(skin);
			
			titleField = TextStyles.createTextField(true);
			addChild(titleField);
			
			descriptionField = TextStyles.createTextField(false);
			descriptionField.multiline = true;
			descriptionField.wordWrap = true;
			addChild(descriptionField);
			
			iconImage = new Image();
			addChild(iconImage);
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			
			_height = 60;
		}
		
		override protected function validate():void
		{
			if ( _selected )
			{
				skin.gotoAndPlay( _down ? "SelectedDown" : (_over ? "SelectedOver" : "SelectedUp") );
			}
			else
			{
				skin.gotoAndPlay( _down ? "Down" : (_over ? "Over" : "Up") );
			}
			
			iconImage.validateNow();
			//iconImage.y = (_height - iconImage.height) >> 1;
			
			titleField.x = iconImage.width + 4;
			titleField.height = titleField.textHeight + 4;
			titleField.width = _width - titleField.x;
			
			descriptionField.x = titleField.x;
			descriptionField.width = titleField.width;
			descriptionField.y = titleField.height;
			descriptionField.height = _height - descriptionField.y;
			
			skin.width = _width;
			skin.height = _height;
		}
		
		////////////////////////////////////////////////
		// Event handlers
		////////////////////////////////////////////////
		
		private function mouseDownHandler( event:MouseEvent ):void
		{
			_down = true;
			invalidate();
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		private function mouseUpHandler( event:MouseEvent ):void
		{
			_down = false;
			invalidate();
		}
		
		private function rollOverHandler( event:MouseEvent ):void
		{
			_over = true;
			invalidate();
		}
		
		private function rollOutHandler( event:MouseEvent ):void
		{
			_over = false;
			invalidate();
		}
		
		////////////////////////////////////////////////
		// Getters/Setters
		////////////////////////////////////////////////	
		
		public function set selected( value:Boolean ):void
		{
			_selected = value;
			invalidate();
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set down( value:Boolean ):void
		{
			_down = value;
			invalidate();
		}
		
		public function get down():Boolean
		{
			return _down;
		}
		
		public function set list( value:List ):void
		{
			_list = value;
			invalidate();
		}
		
		public function get list():List
		{
			return _list;
		}
		
		public function set data( value:Object ):void
		{
			_data = value;
			
			var fileTemplate:FileTemplate = _data as FileTemplate;
			if ( fileTemplate )
			{
				titleField.text = fileTemplate.getLabel();
				descriptionField.text = fileTemplate.description;
				iconImage.source = fileTemplate.icon;
			}
			else
			{
				titleField.text = "";
				descriptionField.text = "";
				iconImage.source = null;
			}
			
			invalidate();
		}
		
		public function get data():Object
		{
			return _data;
		}
	}
}