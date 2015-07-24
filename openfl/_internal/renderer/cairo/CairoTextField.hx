package openfl._internal.renderer.cairo;


import haxe.io.Path;
import haxe.Utf8;
import lime.graphics.cairo.Cairo;
import lime.graphics.cairo.CairoFont;
import lime.graphics.cairo.CairoFontOptions;
import lime.graphics.cairo.CairoImageSurface;
import lime.graphics.cairo.CairoSurface;
import lime.system.System;
import lime.text.TextLayout;
import openfl._internal.renderer.RenderSession;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFormat;

@:access(openfl.display.Graphics)
@:access(openfl.display.BitmapData)
@:access(openfl.text.Font)
@:access(openfl.text.TextField)
@:access(openfl.geom.Matrix)


class CairoTextField {
	
	
	private static var __defaultFonts = new Map<String, Font> ();
	private static var __utf8_endline_code:Int = 10;
	
	
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
					fontList = [ systemFontDirectory + "/freefont/FreeSans.ttf", systemFontDirectory + "/FreeSans.ttf" ];
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
					fontList = [ systemFontDirectory + "/freefont/FreeMono.ttf", systemFontDirectory + "/FreeMono.ttf" ];
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
		fontList = [ systemFontDirectory + "/freefont/FreeSerif.ttf", systemFontDirectory + "/FreeSerif.ttf" ];
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
	
	
	private static function getLineBreaks (textField:TextField):Int {
		
		//returns the number of line breaks in the text
		
		var lines = 0;
		
		Utf8.iter(textField.text, function(char:Int) {
			
			if (char == __utf8_endline_code) {
				
				lines++;
				
			}
			
		});
		
		return lines;
		
	}
	
	
	private static function getLineBreakIndices (textField:TextField):Array<Int> {
		
		//returns the exact character indeces where the line breaks occur
		
		var breaks = [];
		
		var i = 0;
		
		Utf8.iter(textField.text, function(char:Int) {
			
			if (char == __utf8_endline_code) {
				
				breaks.push (i);
				i++;
				
			}
			
		});
		
		return breaks;
		
	}
	
	
	private static function getLineBreaksInRange (textField:TextField, i:Int):Int {
		
		//returns the number of line breaks that occur within a given format range
		
		var lines = 0;
		
		if (textField.__ranges.length > i && i >= 0) {
			
			var range = textField.__ranges[i];
			
			//TODO: this could quite possibly cause crash errors if range indeces are not based on Utf8 character indeces
			
			if (range.start > 0 && range.end < textField.text.length) {
				
				Utf8.iter(textField.text, function(char:Int) {
					
					if (char == __utf8_endline_code) {
						
						lines++;
						
					}
					
				});
				
			}
			
		}
		
		return lines;
		
	}
	
	
	private static function getLineIndices (textField:TextField, line:Int):Array<Int> {
		
		//tells you what the first and last (non-linebreak) character indeces are in a given line
		
		var breaks = getLineBreakIndices (textField);
		var i = 0;
		var first_char = 0;
		var last_char:Int = textField.text.length - 1;
		
		for (br in breaks) {
			
			//if this is the line we care about
			
			if (i == line) {
				
				//the first actual character in our line is the index after this line break
				
				first_char = br + 1;
				
				//if there's another line break left in the list
				
				if (i != breaks.length-1) {
					
					//the last character is the index before the next line break
					//(otherwise it's the last character in the text field)
					
					last_char = breaks[i + 1] - 1;
					
				}
				
			}
			
			i++;
			
		}
		
		return [ first_char, last_char ];
		
	}
	
	
	public static function getLineMetric (textField:TextField, line:Int, metric:TextFieldLineMetric):Float {
		
		if (textField.__ranges == null) {
			
			return getLineMetricSubRangesNull (textField, true, metric);
			
		} else {
			
			return getLineMetricSubRangesNotNull (textField, line, metric);
			
		}
		
	}
	
	
	private static function getLineMetricSubRangesNotNull (textField:TextField, specificLine:Int, metric:TextFieldLineMetric):Float {
		
		//subroutine if ranges are not null
		//TODO: test this more thoroughly
		
		var lineChars = getLineIndices (textField, specificLine);
		
		var m = 0.0;
		var best_m = 0.0;
		
		for (range in textField.__ranges) {
			
			if (range.start >= lineChars[0]) {
				
				var font = getFontInstance (range.format);
				
				if (font != null) {
					
					m = switch (metric) {
						
						case LINE_HEIGHT: getLineMetricSubRangesNotNull (textField, specificLine, ASCENDER) + getLineMetricSubRangesNotNull (textField, specificLine, DESCENDER) + getLineMetricSubRangesNotNull (textField, specificLine, LEADING);
						case ASCENDER: font.ascender / font.unitsPerEM * textField.__textFormat.size;
						case DESCENDER: Math.abs(font.descender / font.unitsPerEM * textField.__textFormat.size);
						case LEADING: textField.__textFormat.leading + 4;
						default: 0;
						
					}
					
				}
				
			}
			
			if (m > best_m) {
				
				best_m = m;
				
			}
			
			m = 0;
			
		}
		
		return best_m;
		
	}
	
	
	private static function getLineMetricSubRangesNull (textField:TextField, singleLine:Bool = false, metric:TextFieldLineMetric):Float {
		
		//subroutine if ranges are null
		
		var font = getFontInstance (textField.__textFormat);
		
		if (font != null) {
			
			return switch (metric) {
				
				case LINE_HEIGHT: getLineMetricSubRangesNull (textField, singleLine, ASCENDER) + getLineMetricSubRangesNull (textField, singleLine, DESCENDER) + getLineMetricSubRangesNull (textField, singleLine, LEADING);
				case ASCENDER: font.ascender / font.unitsPerEM * textField.__textFormat.size;
				case DESCENDER: Math.abs (font.descender / font.unitsPerEM * textField.__textFormat.size);
				case LEADING: textField.__textFormat.leading + 4;
				default: 0;
				
			}
			
		}
		
		return 0;
		
	}
	
	
	public static function getLineWidth (textField:TextField, line:Int):Float {
		
		#if (cpp || neko || nodejs)
		
		//Returns the width of a given line, or if -1 is supplied, the largest width of any single line
		
		var measurements = measureTextSub (textField, false);
		
		var currWidth = 0.0;
		var bestWidth = 0.0;
		
		var linebreaks = getLineBreakIndices (textField);
		var currLine = 0;
		
		for (i in 0...measurements.length) {
			
			var measure = measurements[i];
			
			if (linebreaks.indexOf (i) != -1) { //if this character is a line break
				
				if (currLine == line) { //if we're currently on the desired line
					
					return currWidth; //return the built up width immediately
					
				} else if (line == -1 && currWidth > bestWidth) { //if we are looking at ALL lines, and this width is bigger than the last one
					
					bestWidth = currWidth; //this is the new best width
					
				}
				
				currWidth = 0; //reset current width
				currLine++;
				
			} else {
				
				currWidth += measurements[i]; //keep building up the width
				
			}
			
		}
		
		if (currLine == line) { //we reached end of the loop & this is the line we want
			
			bestWidth = currWidth;
			
		} else if (line == -1 && currWidth > bestWidth) { //looking at ALL lines, and this one's bigger
			
			bestWidth = currWidth;
			
		}
		
		return bestWidth;
		
		#else
		
		return 0;
		
		#end
		
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
		
		return 0;
		
	}
	
	
	public static function measureText (textField:TextField, condense:Bool = true):Array<Float> {
		
		//the "condense" flag, if true, will return the widths of individual text format ranges, if false will return the widths of each character
		//TODO: look into whether this method and others can replace the JS stuff yet or not
		
		return measureTextSub (textField, condense);
		
	}
	
	
	private static function measureTextSub (textField:TextField, condense:Bool):Array<Float> {
		
		//subroutine for measuring text (width)
		
		if (textField.__textLayout == null) {
			
			textField.__textLayout = new TextLayout ();
			
		}
		
		if (textField.__ranges == null) {
			
			return measureTextSubRangesNull (textField, condense);
			
		} else {
			
			return measureTextSubRangesNotNull (textField, condense);
			
		}
		
		return null;
		
	}
	
	
	private static function measureTextSubRangesNotNull (textField:TextField, condense:Bool):Array<Float> {
		
		//subroutine if format ranges are not null
		
		var measurements = [];
		var textLayout = textField.__textLayout;
		
		for (range in textField.__ranges) {
			
			var font = getFontInstance (range.format);
			var width = 0.0;
			
			if (font != null && range.format.size != null) {
				
				textLayout.text = null;
				textLayout.font = font;
				textLayout.size = Std.int (range.format.size);
				textLayout.text = textField.text.substring (range.start, range.end);
				
				for (position in textLayout.positions) {
					
					if (condense) {
						
						width += position.advance.x;
						
					} else {
						
						measurements.push (position.advance.x);
						
					}
					
				}
				
			}
			
			if (condense) {
				
				measurements.push (width);
				
			}
			
		}
		
		return measurements;
		
	}
	
	
	private static function measureTextSubRangesNull (textField:TextField, condense:Bool):Array<Float> {
		
		//subroutine if format ranges are null
		
		var font = getFontInstance (textField.__textFormat);
		var width = 0.0;
		var widths = [];
		var textLayout = textField.__textLayout;
		
		if (font != null && textField.__textFormat.size != null) {
			
			textLayout.text = null;
			textLayout.font = font;
			textLayout.size = Std.int (textField.__textFormat.size);
			textLayout.text = textField.__text;
			
			for (position in textLayout.positions) {
				
				if (condense) {
					
					width += position.advance.x;
					
				} else {
					
					widths.push (position.advance.x);
					
				}
				
			}
			
		}
		
		if (condense) {
			
			widths.push (width);
			
		}
		
		return widths;
		
	}
	
	
	public static function render (textField:TextField, renderSession:RenderSession) {
		
		#if lime_cairo
		if (!textField.__dirty) return;
		
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
		
		var font = getFontInstance (format);
		
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
			
			var text = textField.text;
			
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
				
				renderText (textField, text, textField.__textFormat, 2, bounds );
				
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
		var font = getFontInstance (format);
		
		if (font != null && format.size != null) {
			
			var graphics = textField.__graphics;
			var tlm = textField.getLineMetrics (0);
			
			var x = offsetX;
			var y = 2 + tlm.ascent;
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
				
				tlm = textField.getLineMetrics (line_i);
				x = oldX;
				
				// TODO: Make textField.getLineMetrics ().x match this value
				
				x += switch (format.align) {
					
					case LEFT, JUSTIFY: 0;
					case CENTER: ((textField.width - 4) - getLineWidth (textField, line_i)) / 2;
					case RIGHT: ((textField.width - 4) - getLineWidth (textField, line_i));
					
				}
				
				cairo.moveTo (x, y);
				cairo.showText (line);
				
				y += Math.round (tlm.height);
				line_i++;
				
			}
			
		}
		
		#end
		
	}
	
	
}