package openfl._internal.renderer.cairo;

import lime.graphics.cairo.Cairo;
import lime.graphics.cairo.CairoFont;
import lime.graphics.cairo.CairoFontOptions;
import lime.graphics.cairo.CairoImageSurface;
import lime.graphics.cairo.CairoSurface;
import openfl._internal.renderer.RenderSession;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl._internal.text.TextUtil;

@:access(openfl.display.Graphics)
@:access(openfl.display.BitmapData)
@:access(openfl.text.Font)
@:access(openfl.text.TextField)
@:access(openfl.geom.Matrix)


class CairoTextField {
	
	
	/**
	 * Returns a font object that matches the given TextFormat
	 * @param	format
	 * @return
	 */
	
	public static function getFontInstance (format:TextFormat):Font {
		
		return TextUtil.getFontInstance(format);
		
	}
	
	
	/**
	 * Get a line metric
	 * @param	textField	the textField you want information about
	 * @param	line	the line you want information about
	 * @param	metric	a constant from TextFieldLineMetric (ASCENDER, DESCENDER, LINE_HEIGHT, etc)
	 * @return
	 */
	
	public static function getLineMetric (textField:TextField, line:Int, metric:TextFieldLineMetric):Float {
		
		return TextUtil.getLineMetric(textField, line, metric);
		
	}
	
	
	/**
	 * Returns the width of a given line, of if -1 is supplied, the largets width of any single line
	 * @param	textField
	 * @param	line
	 * @return
	 */
	
	public static function getLineWidth (textField:TextField, line:Int):Float {
	
		return TextUtil.getLineWidth(textField, line, true);
	
	}
	
	
	public static function getTextHeight (textField:TextField):Float {
		
		//sum the heights of all the lines, but don't count the leading of the last line
		//TODO: might need robustness check for pathological cases (multiple format ranges) -- would need to change how line heights are calculated
		
		var th = 0.0;
		
		for (i in 0...textField.numLines) {
			
			th += getLineMetric (textField, i, ASCENDER) + getLineMetric (textField, i, DESCENDER);
			
			if (i != textField.numLines - 1) {
				
				th += getLineMetric (textField, i, LEADING);
				
			}
			
		}
		
		return th;
		
	}
	
	
	public static function getTextWidth (textField:TextField, text:String):Float {
		
		return textField.textWidth;
		
	}
	
	/**
	 * Returns an array of widths in the text
	 * @param	textField the textField you want to measure
	 * @param	condense TRUE: returns widths of individual text format ranges, FALSE: returns widths of each character
	 * @return
	 */
	
	public static function measureText (textField:TextField, condense:Bool = true):Array<Float> {
		
		return TextUtil.measureText(textField, condense);
		
	}
	
	
	public static function render (textField:TextField, renderSession:RenderSession) {
		
		#if lime_cairo
		if (!textField.__dirty) return;
		
		if (textField.wordWrap && (textField.__dirtyWrap || textField.__dirtyBounds)) {
			
			TextUtil.wrapText(textField);
			textField.__dirtyWrap = false;
			
		}
		
		var bounds = textField.bounds;
		var format = textField.getTextFormat ();
		
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
		
		var font = TextUtil.getFontInstance (format);
		
		if (textField.__cairoFont != null) {
			
			if (textField.__cairoFont.font != font) {
				
				textField.__cairoFont.destroy ();
				textField.__cairoFont = null;
				
			}
			
		}
		
		if (textField.__cairoFont == null) {
			
			textField.__cairoFont = new CairoFont (font);
			
		}
		
		cairo.setFontFace (textField.__cairoFont);
		cairo.rectangle (0.5, 0.5, Std.int (textField.width) - 1, Std.int (textField.height) - 1);
		
		if (!textField.background) {
			
			cairo.operator = SOURCE;
			cairo.setSourceRGBA (1, 1, 1, 0);
			cairo.paint ();
			cairo.operator = OVER;
			
		} else {
			
			var color = textField.backgroundColor;
			var r = ((color & 0xFF0000) >>> 16) / 0xFF;
			var g = ((color & 0x00FF00) >>> 8) / 0xFF;
			var b = (color & 0x0000FF) / 0xFF;
			
			cairo.setSourceRGB (r, g, b);
			cairo.fillPreserve ();
			
		}
		
		if (textField.border) {
			
			var color = textField.borderColor;
			var r = ((color & 0xFF0000) >>> 16) / 0xFF;
			var g = ((color & 0x00FF00) >>> 8) / 0xFF;
			var b = (color & 0x0000FF) / 0xFF;
			
			cairo.setSourceRGB (r, g, b);
			cairo.lineWidth = 1;
			cairo.stroke ();
			
		}
		
		if (textField.__text != null && textField.__text != "") {
			
			var text = TextUtil.getRenderableText(textField);
			
			if (textField.displayAsPassword) {
				
				var length = text.length;
				var mask = "";
				
				for (i in 0...length) {
					
					mask += "*";
					
				}
				
				text = mask;
				
			}
			
			var measurements = measureText (textField);
			
			if (textField.__ranges == null) {
				
				renderText (textField, text, textField.__textFormat, 2, bounds);
				
			} else {
				
				var currentIndex = 0;
				var range;
				var offsetX = 2.0;
				
				for (i in 0...textField.__ranges.length) {
					
					range = textField.__ranges[i];
					
					renderText (textField, text.substring (range.start, range.end), range.format, offsetX, bounds);
					offsetX += measurements[i];
					
				}
				
			}
			
		}
		
		graphics.__bitmap.__image.dirty = true;
		textField.__dirty = false;
		graphics.__dirty = false;
		
		#end
		
	}
	
	
	private static function renderText (textField:TextField, text:String, format:TextFormat, offsetX:Float, bounds:Rectangle):Void {
		
		#if lime_cairo
		var font = TextUtil.getFontInstance (format);
		
		if (font != null && format.size != null) {
			
			var graphics = textField.__graphics;
			
			var ascent = getLineMetric(textField, 0, ASCENDER);
			
			var x = offsetX;
			var y = 2 + ascent;
			var size = Std.int (format.size);
			
			var lines = text.split ("\n");
			
			var line_i = 0;
			var oldX = x;
			
			var cairo = textField.__graphics.__cairo;
			cairo.setFontSize (size);
			
			var color = format.color;
			var r = ((color & 0xFF0000) >>> 16) / 0xFF;
			var g = ((color & 0x00FF00) >>> 8) / 0xFF;
			var b = (color & 0x0000FF) / 0xFF;
			
			cairo.setSourceRGB (r, g, b);
			
			for (line in lines) {
			
				var lineHeight = getLineMetric(textField, line_i, LINE_HEIGHT);
				x = oldX;
				
				x += TextUtil.getMargin(textField, line_i);
				
				cairo.moveTo (x, y);
				cairo.showText (line);
				
				y += Math.round (lineHeight);
				line_i++;
				
			}
			
		}
		
		#end
		
	}
	
	
}
