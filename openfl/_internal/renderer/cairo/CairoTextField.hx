package openfl._internal.renderer.cairo;


import lime.graphics.cairo.Cairo;
import lime.graphics.cairo.CairoAntialias;
import lime.graphics.cairo.CairoFontFace;
import lime.graphics.cairo.CairoFontOptions;
import lime.graphics.cairo.CairoFTFontFace;
import lime.graphics.cairo.CairoHintMetrics;
import lime.graphics.cairo.CairoHintStyle;
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
				
				graphics.__cairo = null;
				cairo = null;
				
			}
			
		}
		
		if (bounds.width <= 0 || bounds.height <= 0) return;
		
		if (cairo == null) {
			
			var bitmap = new BitmapData (Math.ceil (bounds.width), Math.ceil (bounds.height), true, 0);
			var surface = bitmap.getSurface ();
			graphics.__cairo = new Cairo (surface);
			
			graphics.__bitmap = bitmap;
			graphics.__bounds = new Rectangle (bounds.x, bounds.y, bounds.width, bounds.height);
			
			cairo = graphics.__cairo;
			
			var options = new CairoFontOptions ();
			
			if (textEngine.antiAliasType == ADVANCED && textEngine.gridFitType == PIXEL) {
				
				options.hintStyle = CairoHintStyle.NONE;
				options.hintMetrics = CairoHintMetrics.OFF;
				options.antialias = CairoAntialias.NONE;
				
			} else {
				
				options.hintStyle = CairoHintStyle.DEFAULT;
				options.hintMetrics = CairoHintMetrics.OFF;
				options.antialias = CairoAntialias.GOOD;
				
			}
			
			cairo.fontOptions = options;
			
		}
		
		if (textEngine.border) {
			
			cairo.rectangle (0.5, 0.5, Std.int (bounds.width - 1), Std.int (bounds.height - 1));
			
		} else {
			
			cairo.rectangle (0, 0, bounds.width, bounds.height);
			
		}
		
		if (!textEngine.background) {
			
			cairo.operator = CLEAR;
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
			
			cairo.rectangle (0, 0, bounds.width - (textField.border ? 1 : 0), bounds.height - (textField.border ? 1 : 0));
			cairo.clip ();
			
			var text = textEngine.text;
			
			//if (textEngine.displayAsPassword) {
				//
				//var length = text.length;
				//var mask = "";
				//
				//for (i in 0...length) {
					//
					//mask += "*";
					//
				//}
				//
				//text = mask;
				//
			//}
			
			var scrollX = -textField.scrollH;
			var scrollY = 0.0;
			
			for (i in 0...textField.scrollV - 1) {
				
				scrollY -= textEngine.lineHeights[i];
				
			}
			
			var color, r, g, b, font, size, advance;
			
			for (group in textEngine.layoutGroups) {
				
				if (group.lineIndex < textField.scrollV - 1) continue;
				if (group.lineIndex > textField.scrollV + textEngine.bottomScrollV - 2) break;
				
				color = group.format.color;
				r = ((color & 0xFF0000) >>> 16) / 0xFF;
				g = ((color & 0x00FF00) >>> 8) / 0xFF;
				b = (color & 0x0000FF) / 0xFF;
				
				cairo.setSourceRGB (r, g, b);
				
				font = TextEngine.getFontInstance (group.format);
				
				if (font != null && group.format.size != null) {
					
					if (textEngine.__cairoFont != null) {
						
						if (textEngine.__font != font) {
							
							textEngine.__cairoFont = null;
							
						}
						
					}
					
					if (textEngine.__cairoFont == null) {
						
						textEngine.__font = font;
						textEngine.__cairoFont = CairoFTFontFace.create (font, 0);
						
					}
					
					cairo.fontFace = textEngine.__cairoFont;
					
					size = Std.int (group.format.size);
					cairo.setFontSize (size);
					
					cairo.moveTo (group.offsetX + scrollX, group.offsetY + group.ascent + scrollY);
					cairo.showText (text.substring (group.startIndex, group.endIndex));
					
					if (textField.__caretIndex > -1 && textEngine.selectable) {
						
						if (textField.__selectionIndex == textField.__caretIndex) {
							
							if (textField.__showCursor && group.startIndex <= textField.__caretIndex && group.endIndex >= textField.__caretIndex) {
								
								advance = 0.0;
								
								for (i in 0...(textField.__caretIndex - group.startIndex)) {
									
									if (group.advances.length <= i) break;
									advance += group.advances[i];
									
								}
								
								cairo.moveTo (Math.floor (group.offsetX + advance) + 0.5, group.offsetY + 0.5);
								cairo.lineWidth = 1;
								cairo.lineTo (Math.floor (group.offsetX + advance) + 0.5, group.offsetY + group.height - 1);
								cairo.stroke ();
								
							}
							
						} else if ((group.startIndex <= textField.__caretIndex && group.endIndex >= textField.__caretIndex) || (group.startIndex <= textField.__selectionIndex && group.endIndex >= textField.__selectionIndex)) {
							
							var selectionStart = Std.int (Math.min (textField.__selectionIndex, textField.__caretIndex));
							var selectionEnd = Std.int (Math.max (textField.__selectionIndex, textField.__caretIndex));
							
							if (group.startIndex > selectionStart) {
								
								selectionStart = group.startIndex;
								
							}
							
							if (group.endIndex < selectionEnd) {
								
								selectionEnd = group.endIndex;
								
							}
							
							var start, end;
							
							start = textField.getCharBoundaries (selectionStart);
							
							if (selectionEnd >= textEngine.text.length) {
								
								end = textField.getCharBoundaries (textEngine.text.length - 1);
								end.x += end.width + 2;
								
							} else {
								
								end = textField.getCharBoundaries (selectionEnd);
								
							}
							
							if (start != null && end != null) {
								
								cairo.setSourceRGB (0, 0, 0);
								cairo.rectangle (start.x, start.y, end.x - start.x, group.height);
								cairo.fill ();
								cairo.setSourceRGB (1, 1, 1);
								
								// TODO: draw only once
								
								cairo.moveTo (scrollX + start.x, group.offsetY + group.ascent + scrollY);
								cairo.showText (text.substring (selectionStart, selectionEnd));
								
							}
							
						}
						
					}
					
				}
				
			}
			
		}
		
		graphics.__bitmap.image.dirty = true;
		textField.__dirty = false;
		graphics.__dirty = false;
		
		#end
		
	}
	
	
}