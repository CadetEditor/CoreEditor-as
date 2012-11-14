/*********************************************************************************
 * 
 *        Class: ColorConversion
 * 
 *       Author: Tyler Beck
 * 
 *  Description: Color Functions - rgb and hsb are between 0 and 1
 * 
 *********************************************************************************
 * 
 * Copyright © 2007-2008 Tyler Beck
 * The contents of this file are licensed under the 
 * Creative Commons Attribution-Share Alike 3.0 License 
 * (http://creativecommons.org/licenses/by-sa/3.0/)
 * 
 * DO NOT REMOVE THIS NOTICE 
 * 
 ********************************************************************************/

package flox.app.util
{

	public class ColorUtil
	{
		public static function blend( colorA:uint, colorB:uint, ratio:Number ):uint
		{
			var rA:uint = colorA >> 16;
			var gA:uint = (colorA | 0x00FF00) >> 8;
			var bA:uint = (colorA | 0x0000FF);
			
			var rB:uint = colorB >> 16;
			var gB:uint = (colorB | 0x00FF00) >> 8;
			var bB:uint = (colorB | 0x0000FF);
			
			var r:uint = ratio*rA + (1-ratio)*rB;
			var g:uint = ratio*gA + (1-ratio)*gB;
			var b:uint = ratio*bA + (1-ratio)*bB;
			
			return r << 16 | g << 8 | b;
		}
		
		
        public static function rgb2uint(r:Number, g:Number, b:Number):uint
        {
			//make sure values are in range
            r = (r < 0) ? 0 : r;
            r = (r > 1) ? 1 : r;
            g = (g < 0) ? 0 : g;
            g = (g > 1) ? 1 : g;
            b = (b < 0) ? 0 : b;
            b = (b > 1) ? 1 : b;
            
            var u:uint = uint((Math.round(r*255))<<16) | uint((Math.round(g*255))<<8) | uint(Math.round(b*255));
			
			return u;
		}
		
        public static function rgb2hsl(r:Number, g:Number, b:Number):Array
        {
            var hue:Number = 0;
            var saturation:Number = 0;
            var brightness:Number = 0;
            
            //make sure values are in range
            r = (r < 0) ? 0 : r;
            r = (r > 1) ? 1 : r;
            g = (g < 0) ? 0 : g;
            g = (g > 1) ? 1 : g;
            b = (b < 0) ? 0 : b;
            b = (b > 1) ? 1 : b;
            
            //set brightness
            var colorMax:Number = (r > g) ? ((b > r) ? b : r) : ((b > g) ? b : g);
            var colorMin:Number = (r < g) ? ((b < r) ? b : r) : ((b < g) ? b : g);
            brightness = colorMax;
            
            //set saturation
            if (colorMax != 0)
                saturation = (colorMax - colorMin)/colorMax;

            //set hue
            if (saturation > 0)
            {
                var red:Number   = (colorMax - r)/(colorMax - colorMin);
                var green:Number = (colorMax - g)/(colorMax - colorMin);
                var blue:Number  = (colorMax - b)/(colorMax - colorMin);
                if (r == colorMax)
                    hue = blue - green;
                    
                else if (g == colorMax)
                    hue = 2 + red - blue;
                    
                else
                    hue = 4 + green - red;
                    
                hue = hue / 6;
                
            }
            
            return [ hue, saturation, brightness ];
        }
 		      
        public static function rgb2hex(r:Number, g:Number, b:Number):String
       	{
       		var uint:uint = rgb2uint( r, g, b );
       		
       		var str:String = uint.toString( 16 );
       		while ( str.length < 6 )
       		{
       			str = "0" + str;
       		}
       		return str.toUpperCase();
       	}
            
        public static function hsl2rgb(h:Number, s:Number, b:Number):Array
        {   
            //make sure values are in range
            h = (h < 0) ? 0 : h;
            h = (h > 1) ? 1 : h;
            s = (s < 0) ? 0 : s;
            s = (s > 1) ? 1 : s;
            b = (b < 0) ? 0 : b;
            b = (b > 1) ? 1 : b;
            
            var red:Number = 0;
            var green:Number = 0;
            var blue:Number = 0;
            
            if (s == 0) 
            {
                red = b;
                green = red;
                blue = red;
            } 
            else 
            {
                var _h:Number = (h - Math.floor(h)) * 6;
                var _f:Number =  _h - Math.floor(_h);
  
                var _p:Number = b * (1.0 - s);
                var _q:Number = b * (1.0 - s * _f);
                var _t:Number = b * (1.0 - (s * (1 - _f)));
            
                switch(Math.floor(_h)) 
                {
                    case 0:
                       	red = b; 
                       	green = _t; 
                       	blue = _p;
                    	break;
                    case 1:
                        red = _q; 
                        green = b; 
                        blue = _p;
                        break;
                    case 2:
                        red = _p; 
                        green = b; 
                        blue = _t;
                        break;
                    case 3:
                        red = _p; 
                        green = _q; 
                        blue = b;
                        break;
                    case 4:
                        red = _t; 
                        green = _p; 
                        blue = b;
                        break;
                    case 5:
                        red = b; 
                        green = _p; 
                        blue = _q;
                        break;
                }
            }
            return [red,green,blue];
        }
                
 		public static function hsl2uint(h:Number, s:Number, b:Number):uint
 		{
 			var rgb:Array = hsl2rgb(h,s,b);
 			
 			return rgb2uint(rgb[0],rgb[1],rgb[2]);
 		}
 		      
 		public static function hsl2hex(h:Number, s:Number, b:Number):String
 		{
 			var rgb:Array = hsl2rgb(h,s,b);
 			
 			return rgb2hex(rgb[0],rgb[1],rgb[2]);
 		}
 		        
        public static function uint2rgb(value:uint):Array
       	{
			//make sure value is in range
			value = (value > 0xFFFFFF) ? 0xFFFFFF : value;
			value = (value < 0x000000) ? 0x000000 : value;		
			
			var red:Number = ((value>>16)&0xFF)/255;
			var green:Number = ((value>>8)&0xFF)/255;
			var blue:Number = ((value)&0xFF)/255;
			
			return [red,green,blue];
       	}
       
 		public static function uint2hsl(value:uint):Array 
 		{
  			var rgb:Array = uint2rgb(value);
 			
 			return rgb2hsl(rgb[0],rgb[1],rgb[2]);			
 		}
 		
 		public static function uint2hex(value:uint):String 
 		{
  			var rgb:Array = uint2rgb(value);
 			
 			return rgb2hex(rgb[0],rgb[1],rgb[2]);			
 		}
            
        public static function hex2uint(value:String):uint
       	{	
			return uint("0x"+value);
       	}
		          
        public static function hex2rgb(value:String):Array
       	{	
			return uint2rgb(hex2uint(value));
       	}
        
        public static function hex2hsl(value:String):Array
       	{	
			return uint2hsl(hex2uint(value));
       	}
       	
       	public static function distanceBetween( value1:uint, value2:uint ):Number
       	{
       		var hsl1:Array = uint2hsl( value1 );
       		var hsl2:Array = uint2hsl( value2 );
       		
       		var h1:Number = Math.min(hsl1[0], hsl2[0]);
       		var h2:Number = Math.max(hsl1[0], hsl2[0]);
       		
       		var h:Number = Math.min( h2 - h1, h1-(h2-1) );
       		
       		var s:Number = hsl2[1] - hsl1[1];
       		var l:Number = hsl2[2] - hsl1[2];
       		
       		return Math.sqrt(h*h+s*s+l*l);
       	}
 	}
}
          