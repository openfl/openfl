package openfl._internal.renderer.cairo;


import lime.graphics.cairo.Cairo;
import lime.graphics.cairo.CairoFont;
import lime.graphics.cairo.CairoFontOptions;
import lime.graphics.cairo.CairoImageSurface;
import openfl._internal.renderer.RenderSession;
import openfl._internal.text.TextEngine;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.text.TextFormat;

@:access(openfl.display.BitmapData)
@:access(openfl.display.Graphics)
@:access(openfl.text.TextField)


class CairoTextField {
	
	
	public static function render (textField:TextField, renderSession:RenderSession) {
		
		#if lime_cairo
		if (!textField.__dirty) return;
		
		textField.__updateLayout ();
		
		var textEngine = textField.__textEngine;
		var bounds = textEngine.bounds;
		
		var graphics = textField.__graphics;
		var cairo = graphics.__cairo;
		
		if (cairo != null) {
			
			var surface:CairoImageSurface = cast cairo.target;
			
			if (Math.ceil (bounds.width) != surface.width || Math.ceil (bounds.height) != surface.height) {
				
				cairo.destroy ();
				cairo = null;
				
			}
			
		}
		
		if (cairo == null) {
			
			var bitmap = new BitmapData (Math.ceil (bounds.width), Math.ceil (bounds.height), true);
			var surface = bitmap.getSurface ();
			graphics.__cairo = new Cairo (surface);
			surface.destroy ();
			
			graphics.__bitmap = bitmap;
			graphics.__bounds = new Rectangle (bounds.x, bounds.y, bounds.width, bounds.height);
			
			cairo = graphics.__cairo;
			
			var options = new CairoFontOptions ();
			options.hintStyle = FULL;
			options.hintMetrics = ON;
			options.antialias = GOOD;
			cairo.setFontOptions (options);
			
		}
		
		cairo.rectangle (0.5, 0.5, Std.int (textEngine.width) - 1, Std.int (textEngine.height) - 1);
		
		if (!textEngine.background) {
			
			cairo.operator = SOURCE;
			cairo.setSourceRGBA (1, 1, 1, 0);
			cairo.paint ();
			cairo.operator = OVER;
			
		} else {
			
			var color = textEngine.backgroundColor;
			var r = ((color & 0xFF0000) >>> 16) / 0xFF;
			var g = ((color & 0x00FF00) >>> 8) / 0xFF;
			var b = (color & 0x0000FF) / 0xFF;
			
			cairo.setSourceRGB (r, g, b);
			cairo.fillPreserve ();
			
		}
		
		if (textEngine.border) {
			
			var color = textEngine.borderColor;
			var r = ((color & 0xFF0000) >>> 16) / 0xFF;
			var g = ((color & 0x00FF00) >>> 8) / 0xFF;
			var b = (color & 0x0000FF) / 0xFF;
			
			cairo.setSourceRGB (r, g, b);
			cairo.lineWidth = 1;
			cairo.stroke ();
			
		}
		
		if (textEngine.text != null && textEngine.text != "") {
			
			cairo.rectangle (2, 2, textEngine.width - 4, textEngine.height - 4);
			cairo.clip ();
			
			var text = textEngine.text;
			
			if (textEngine.displayAsPassword) {
				
				var length = text.length;
				var mask = "";
				
				for (i in 0...length) {
					
					mask += "*";
					
				}
				
				text = mask;
				
			}
			
			for (group in textEngine.layoutGroups) {
				
				renderText (textField, text.substring (group.startIndex, group.endIndex), group.format, group.offsetX, group.offsetY + group.ascent, bounds);
				
			}
			
		}
		
		graphics.__bitmap.__image.dirty = true;
		textField.__dirty = false;
		graphics.__dirty = false;
		
		#end
		
	}
	
	
	private static function renderText (textField:TextField, text:String, format:TextFormat, offsetX:Float, offsetY:Float, bounds:Rectangle):Void {
		
		#if lime_cairo
		var textEngine = textField.__textEngine;
		var cairo = textField.__graphics.__cairo;
		
		var color = format.color;
		var r = ((color & 0xFF0000) >>> 16) / 0xFF;
		var g = ((color & 0x00FF00) >>> 8) / 0xFF;
		var b = (color & 0x0000FF) / 0xFF;
		
		cairo.setSourceRGB (r, g, b);
		
		var font = TextEngine.getFontInstance (format);
		
		if (font != null && format.size != null) {
			
			if (textEngine.__cairoFont != null) {
				
				if (textEngine.__cairoFont.font != font) {
					
					textEngine.__cairoFont.destroy ();
					textEngine.__cairoFont = null;
					
				}
				
			}
			
			if (textEngine.__cairoFont == null) {
				
				textEngine.__cairoFont = new CairoFont (font);
				
			}
			
			cairo.setFontFace (textEngine.__cairoFont);
			
			var size = Std.int (format.size);
			cairo.setFontSize (size);
			
			cairo.moveTo (offsetX, offsetY);
			cairo.showText (text);
			
		}
		#end
		
	}
	
	
}