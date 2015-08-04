package openfl._internal.renderer.cairo;


import haxe.io.Path;
import lime.graphics.cairo.Cairo;
import lime.graphics.cairo.CairoFont;
import lime.graphics.cairo.CairoFontOptions;
import lime.graphics.cairo.CairoImageSurface;
import lime.graphics.cairo.CairoSurface;
import lime.system.System;
import lime.text.TextLayout;
import openfl._internal.renderer.RenderSession;
import openfl._internal.text.TextEngine;
import openfl._internal.text.TextFieldLineMetric;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.text.Font;
import openfl.text.TextFormat;

@:access(openfl._internal.text.TextEngine)
@:access(openfl.display.Graphics)
@:access(openfl.display.BitmapData)
@:access(openfl.text.Font)
@:access(openfl.text.TextField)
@:access(openfl.geom.Matrix)


class CairoTextField {
	
	
	private static var __defaultFonts = new Map<String, Font> ();
	
	
	private static function findFont (name:String):Font {
		
		#if (cpp || neko || nodejs)
		
		for (registeredFont in Font.__registeredFonts) {
			
			if (registeredFont == null) continue;
			
			if (registeredFont.fontName == name || (registeredFont.__fontPath != null && (registeredFont.__fontPath == name || Path.withoutDirectory (registeredFont.__fontPath) == name))) {
				
				return registeredFont;
				
			}
			
		}
		
		var font = Font.fromFile (name);
		
		if (font != null) {
			
			Font.__registeredFonts.push (font);
			return font;
			
		}
		
		#end
		
		return null;
		
	}
	
	
	public static function getFontInstance (format:TextFormat):Font {
		
		#if (cpp || neko || nodejs)
		
		var instance = null;
		var fontList = null;
		
		if (format != null && format.font != null) {
			
			if (__defaultFonts.exists (format.font)) {
				
				return __defaultFonts.get (format.font);
				
			}
			
			instance = findFont (format.font);
			if (instance != null) return instance;
			
			var systemFontDirectory = System.fontsDirectory;
			
			switch (format.font) {
				
				case "_sans":
					
					#if windows
					if (format.bold) {
						
						if (format.italic) {
							
							fontList = [ systemFontDirectory + "/arialbi.ttf" ];
							
						} else {
							
							fontList = [ systemFontDirectory + "/arialbd.ttf" ];
							
						}
						
					} else {
						
						if (format.italic) {
							
							fontList = [ systemFontDirectory + "/ariali.ttf" ];
							
						} else {
							
							fontList = [ systemFontDirectory + "/arial.ttf" ];
							
						}
						
					}
					#elseif (mac || ios)
					fontList = [ systemFontDirectory + "/Arial Black.ttf", systemFontDirectory + "/Arial.ttf", systemFontDirectory + "/Helvetica.ttf" ];
					#elseif linux
					fontList = [ new sys.io.Process('fc-match', ['sans', '-f%{file}']).stdout.readLine() ];
					#elseif android
					fontList = [ systemFontDirectory + "/DroidSans.ttf" ];
					#elseif blackberry
					fontList = [ systemFontDirectory + "/arial.ttf" ];
					#end
				
				case "_serif":
					
					// pass through
				
				case "_typewriter":
					
					#if windows
					if (format.bold) {
						
						if (format.italic) {
							
							fontList = [ systemFontDirectory + "/courbi.ttf" ];
							
						} else {
							
							fontList = [ systemFontDirectory + "/courbd.ttf" ];
							
						}
						
					} else {
						
						if (format.italic) {
							
							fontList = [ systemFontDirectory + "/couri.ttf" ];
							
						} else {
							
							fontList = [ systemFontDirectory + "/cour.ttf" ];
							
						}
						
					}
					#elseif (mac || ios)
					fontList = [ systemFontDirectory + "/Courier New.ttf", systemFontDirectory + "/Courier.ttf" ];
					#elseif linux
					fontList = [ new sys.io.Process('fc-match', ['mono', '-f%{file}']).stdout.readLine() ];
					#elseif android
					fontList = [ systemFontDirectory + "/DroidSansMono.ttf" ];
					#elseif blackberry
					fontList = [ systemFontDirectory + "/cour.ttf" ];
					#end
				
				default:
					
					fontList = [ systemFontDirectory + "/" + format.font ];
				
			}
			
			if (fontList != null) {
				
				for (font in fontList) {
					
					instance = findFont (font);
					
					if (instance != null) {
						
						__defaultFonts.set (format.font, instance);
						return instance;
						
					}
					
				}
				
			}
			
			instance = findFont ("_serif");
			if (instance != null) return instance;
			
		}
		
		var systemFontDirectory = System.fontsDirectory;
		
		#if windows
		if (format.bold) {
			
			if (format.italic) {
				
				fontList = [ systemFontDirectory + "/georgiaz.ttf" ];
				
			} else {
				
				fontList = [ systemFontDirectory + "/georgiab.ttf" ];
				
			}
			
		} else {
			
			if (format.italic) {
				
				fontList = [ systemFontDirectory + "/geogiai.ttf" ];
				
			} else {
				
				fontList = [ systemFontDirectory + "/georgia.ttf" ];
				
			}
			
		}
		#elseif (mac || ios)
		fontList = [ systemFontDirectory + "/Georgia.ttf", systemFontDirectory + "/Times.ttf", systemFontDirectory + "/Times New Roman.ttf" ];
		#elseif linux
		fontList = [ new sys.io.Process('fc-match', ['serif', '-f%{file}']).stdout.readLine() ];
		#elseif android
		fontList = [ systemFontDirectory + "/DroidSerif-Regular.ttf", systemFontDirectory + "NotoSerif-Regular.ttf" ];
		#elseif blackberry
		fontList = [ systemFontDirectory + "/georgia.ttf" ];
		#else
		fontList = [];
		#end
		
		for (font in fontList) {
			
			instance = findFont (font);
			
			if (instance != null) {
				
				__defaultFonts.set (format.font, instance);
				return instance;
				
			}
			
		}
		
		__defaultFonts.set (format.font, null);
		
		#end
		
		return null;
		
	}
	
	
	public static function render (textEngine:TextEngine, renderSession:RenderSession) {
		
		#if lime_cairo
		if (!textEngine.__dirty) return;
		
		var bounds = textEngine.bounds;
		var format = textEngine.getTextFormat ();
		
		var graphics = textEngine.textField.__graphics;
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
		
		var font = getFontInstance (format);
		
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
			
			var text = textEngine.text;
			
			if (textEngine.displayAsPassword) {
				
				var length = text.length;
				var mask = "";
				
				for (i in 0...length) {
					
					mask += "*";
					
				}
				
				text = mask;
				
			}
			
			textEngine.updateLayout ();
			var measurements = textEngine.layout.lineWidth;
			
			if (textEngine.__ranges == null) {
				
				renderText (textEngine, text, textEngine.__textFormat, 2, 0, bounds);
				
			} else {
				
				var currentIndex = 0;
				var range;
				var offsetX = 2.0;
				var offsetY = 2.0;
				
				var nextLineBreak = -1;
				var lineBreakIndex = 0;
				
				if (textEngine.layout.lineBreaks.length > 0) {
					
					nextLineBreak = textEngine.layout.lineBreaks[0];
					
				}
				
				var startIndex = 0;
				var endIndex = 0;
				
				for (i in 0...textEngine.__ranges.length) {
					
					range = textEngine.__ranges[i];
					
					endIndex = (range.end > nextLineBreak || nextLineBreak == -1) ? range.end : nextLineBreak;
					
					renderText (textEngine, text.substring (startIndex, endIndex), range.format, offsetX, offsetY, bounds);
					offsetX += measurements[i];
					
					startIndex = endIndex + 1;
					
					if (range.end >= nextLineBreak && nextLineBreak != -1) {
						
						offsetY += textEngine.layout.lineAscent[lineBreakIndex] + textEngine.layout.lineDescent[lineBreakIndex] + textEngine.layout.lineLeading[lineBreakIndex];
						
						lineBreakIndex++;
						
						if (lineBreakIndex < textEngine.layout.lineBreaks.length) {
							
							nextLineBreak = textEngine.layout.lineBreaks[lineBreakIndex];
							
						} else {
							
							nextLineBreak = -1;
							
						}
						
					}
					
				}
				
			}
			
		}
		
		graphics.__bitmap.__image.dirty = true;
		textEngine.__dirty = false;
		graphics.__dirty = false;
		
		#end
		
	}
	
	
	private static function renderText (textEngine:TextEngine, text:String, format:TextFormat, offsetX:Float, offsetY:Float, bounds:Rectangle):Void {
		
		#if lime_cairo
		var font = getFontInstance (format);
		
		if (font != null && format.size != null) {
			
			var graphics = textEngine.textField.__graphics;
			
			textEngine.updateLayout ();
			
			var x = offsetX;
			var y = offsetY;
			var size = Std.int (format.size);
			
			textEngine.updateLayout ();
			
			//var lines = text.split ("\n");
			
			//var line_i = 0;
			var oldX = x;
			
			var cairo = textEngine.textField.__graphics.__cairo;
			cairo.setFontSize (size);
			
			var color = format.color;
			var r = ((color & 0xFF0000) >>> 16) / 0xFF;
			var g = ((color & 0x00FF00) >>> 8) / 0xFF;
			var b = (color & 0x0000FF) / 0xFF;
			
			cairo.setSourceRGB (r, g, b);
			
			
			
			//for (line in layout.numLines) {
				
				//tlm = textEngine.getLineMetrics (line_i);
				x = oldX;
				
				// TODO: Make textEngine.getLineMetrics ().x match this value
				
				//x += switch (format.align) {
					//
					//case LEFT, JUSTIFY: 0;
					//case CENTER: ((textEngine.width - 4) - textEngine.layout.lineWidth[lineIndex]) / 2;
					//case RIGHT: ((textEngine.width - 4) - textEngine.layout.lineWidth[lineIndex]);
					//
				//}
				
				cairo.moveTo (x, y);
				cairo.showText (text);
				
				//y += textEngine.layout.lineAscent[lineIndex] + textEngine.layout.lineDescent[lineIndex] + textEngine.layout.lineLeading[lineIndex];
				//line_i++;
				
			//}
			
		}
		
		#end
		
	}
	
	
}