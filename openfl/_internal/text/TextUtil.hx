package openfl._internal.text;

import haxe.Utf8;
import haxe.io.Path;
import lime.text.TextLayout;
import lime.system.System;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl._internal.renderer.canvas.CanvasTextField;
import openfl._internal.renderer.cairo.CairoTextField;

/**
 * ...
 * @author larsiusprime
 */

@:access(openfl.text.Font)
@:access(openfl.text.TextField)

class TextUtil
{
	public static inline var __utf8_tab_code:Int = 9;
	public static inline var __utf8_endline_code:Int = 10;
	public static inline var __utf8_space_code:Int = 32;
	public static inline var __utf8_hyphen_code:Int = 0x2D;
	
	private static var __defaultFonts = new Map<String, Font> ();
	
	/**
	 * Returns a font object that matches the given TextFormat
	 * @param	format
	 * @return
	 */
	
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
				
				fontList = [ systemFontDirectory + "/timesbi.ttf" ];
				
			} else {
				
				fontList = [ systemFontDirectory + "/timesbd.ttf" ];
				
			}
			
		} else {
			
			if (format.italic) {
				
				fontList = [ systemFontDirectory + "/timesi.ttf" ];
				
			} else {
				
				fontList = [ systemFontDirectory + "/times.ttf" ];
				
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
	
	/**
	 * Returns the number of line breaks in the text
	 * @param	textField
	 * @return
	 */
	
	public static function getLineBreaks (textField:TextField):Int {
		
		var lines = 0;
		
		Utf8.iter(textField.text, function(char:Int) {
			
			if (char == __utf8_endline_code) {
				
				lines++;
				
			}
			
		});
		
		return lines;
	}
	
	/**
	 * Returns the number of line breaks that occur within a given format range
	 * @param	textField
	 * @param	i
	 * @return
	 */
	
	public static function getLineBreaksInRange (textField:TextField, i:Int):Int {
		
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
	
	/**
	 * Returns the first and last (non-linebreak) character indeces in a given line
	 * @param	textField
	 * @param	line
	 * @return
	 */
	
	public static function getLineIndices (textField:TextField, line:Int):Array<Int> {
		
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
	
	/**
	 * Returns the exact character indices where the line breaks occur
	 * @param	textField
	 * @return
	 */
	
	public static function getLineBreakIndices (textField:TextField):Array<Int> {
		
		var breaks = [];
		
		var i = 0;
		
		Utf8.iter(textField.text, function(char:Int) {
			
			if (char == __utf8_endline_code) {
				
				breaks.push (i);
				
			}
			
			i++;
			
		});
		
		return breaks;
		
	}
	
	/**
	 * Get a line metric
	 * @param	textField	the textField you want information about
	 * @param	line	the line you want information about
	 * @param	metric	a constant from TextFieldLineMetric (ASCENDER, DESCENDER, LINE_HEIGHT etc)
	 * @return
	 */
	
	public static function getLineMetric (textField:TextField, line:Int, metric:TextFieldLineMetric):Float {
		
		if (textField.__ranges == null) {
			
			return getLineMetricSubRangesNull (textField, true, metric);
			
		} else {
			
			return getLineMetricSubRangesNotNull (textField, line, metric);
			
		}
		
	}
	
	/**
	 * Returns the width of a given line, of if -1 is supplied, the largest width of any single line
	 * @param	textField
	 * @param	line
	 * @return
	 */
	
	public static function getLineWidth (textField:TextField, line:Int):Float {
		
		#if (cpp || neko || nodejs)
		
		var measurements = measureTextSub (textField, false);
		
		var currWidth = 0.0;
		var bestWidth = 0.0;
		
		var linebreaks = TextUtil.getLineBreakIndices (textField);
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
	
	/**
	 * Gets the starting horizontal point of the leftmost character
	 * @param	textField	textField you want to measure
	 * @param	lineIndex	line you want to get the margin for
	 * @param	lineWidth	if you've already know lineWidth, provide it here to skip a duplicate calculation
	 * @return
	 */
	
	public static function getMargin (textField:TextField, lineIndex:Int, lineWidth:Float=-1):Float {
		
		if (lineWidth < 0) {
		
			#if (js && html5)
			
			lineWidth = CanvasTextField.getLineWidth (textField, lineIndex);
			
			#else
			
			lineWidth = CairoTextField.getLineWidth (textField, lineIndex);
			
			#end
		}
		
		var margin = switch (textField.__textFormat.align) {
			
			case LEFT, JUSTIFY: 2;
			case RIGHT: (textField.width - lineWidth) - 2;
			case CENTER: (textField.width - lineWidth) / 2;
			
		}
		
		return margin;
	}
	
	/**
	 * Return the text you're actually going to render, taking wordWrap into account
	 * @param	textField
	 * @return
	 */
	public static function getRenderableText (textField:TextField):String {
		
		if (textField.wordWrap) {
			
			if (textField.__textWrap != null && textField.__textWrap != "") {
			
				return textField.__textWrap;
			
			}
		}
		
		return textField.text;
	}
	
	
	/**
	 * Returns an array of the starting indeces of all the words in the text field.
	 * Word boundaries are detected after whitespace and hyphens
	 * @param	textField
	 * @return
	 */
	
	public static function getWordIndices (textField:TextField):Array<Int> {
		
		var lastChar:Int = -1;
		var words = [];
		var i:Int = 0;
		
		Utf8.iter(textField.text, function(char:Int) {
			
			if (char != lastChar) {
				
				//If the last character is not the same as this
				//and the last character was whitespace/hyphen
				//and this character is not one of those
				
				if ((lastChar == __utf8_endline_code ||
				     lastChar == __utf8_space_code   ||
				     lastChar == __utf8_tab_code     ||
				     lastChar == __utf8_hyphen_code)
					&&
					(char != __utf8_endline_code  &&
					 char != __utf8_space_code    &&
					 char != __utf8_tab_code      &&
					 char != __utf8_hyphen_code))
				{
					words.push(i);
				}
				
			}
			
			lastChar = char;
			
			i++;
			
		});
		
		return words;
	}
	
	
	public static function wrapText (textField:TextField) {
	
		//if the text does not need wrapping, return early
		if (!textField.__dirtyWrap && !textField.__dirtyBounds) {
			
			return;
			
		}
		
		var width = textField.width;
		var text = textField.text;
		var orig = text;
		
		var done = false;
		var numLines = textField.numLines;
		var i = 0;
		
		while(!done) {
			
			//Measure the current line
			
			var lw = getLineWidth(textField, i);
			var lineWidth:Float = Math.ceil(lw + 4);
			var j:Int = 0;
			
			//Get an array of all the word boundaries
			var words = getWordIndices(textField);
			
			if (text.indexOf("Alive and going") != -1) {
				
				trace("lineWidth = " + lineWidth + " VS " + width);
				
			}
			
			//if the measured line width is wider than the text boundary:
			while (lineWidth >= width) {
			
				if (words.length > j) {
					
					//try to insert an endline just before the LAST word in the entire text field
					var index = words[words.length - (1 + j)];
					
					var a = text.substr(0, index);
					var b = text.substr(index, (text.length - index));
					
					var c = a + "\n" + b;
					
					//update text field and measure it again
					textField.__text = c;
					
					//if we're still too long, try the next last word, etc, steadily working back towards the start
					lineWidth = getLineWidth(textField, i);
					j++;
					
					//if we fixed it, that means we added another line:
					if (lineWidth <= width)
					{
						numLines++;
					}
				}
				else {
					
					break;
					
				}
			}
			
			//start with the state of the text from the last line:
			text = textField.text;
			i++;
			
			//end the loop when we've gone all the way:
			done = (i > numLines);
		}
		
		//set text back to normal, but set wrapped version in __textWrap variable for later use
		textField.__textWrap = text;
		textField.__dirtyWrap = false;
		textField.__text = orig;
	}
	
	/**
	 * Returns an array of widths in the text
	 * @param	textField the textField you want to measure
	 * @param	condense TRUE: returns widths of individual text format ranges, FALSE: returns widths of each character
	 * @return
	 */
	
	public static function measureText (textField:TextField, condense:Bool = true):Array<Float> {
		
		//TODO: look into whether this method and others can replace the JS stuff yet or not
		
		return measureTextSub(textField, condense);
		
	}
	
	
	/*****************/
	
	
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
	
	
	private static function getLineMetricSubRangesNotNull (textField:TextField, specificLine:Int, metric:TextFieldLineMetric):Float {
		
		//subroutine if ranges are not null
		//TODO: test this more thoroughly
		
		var lineChars = TextUtil.getLineIndices (textField, specificLine);
		
		var m = 0.0;
		var best_m = 0.0;
		
		for (range in textField.__ranges) {
			
			if (range.start >= lineChars[0]) {
				
				var font = getFontInstance (range.format);
				
				if (font != null) {
					
					m = switch (metric) {
						
						case LINE_HEIGHT: Math.round(getLineMetricSubRangesNotNull (textField, specificLine, ASCENDER) + getLineMetricSubRangesNotNull (textField, specificLine, DESCENDER) + getLineMetricSubRangesNotNull (textField, specificLine, LEADING));
						case ASCENDER: Math.round(font.ascender / font.unitsPerEM * textField.__textFormat.size);
						case DESCENDER: Math.round(Math.abs(font.descender / font.unitsPerEM * textField.__textFormat.size));
						case LEADING: textField.__textFormat.leading;
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
				
				case LINE_HEIGHT: Math.round(getLineMetricSubRangesNull (textField, singleLine, ASCENDER) + getLineMetricSubRangesNull (textField, singleLine, DESCENDER) + getLineMetricSubRangesNull (textField, singleLine, LEADING));
				case ASCENDER: Math.round(font.ascender / font.unitsPerEM * textField.__textFormat.size);
				case DESCENDER: Math.round(Math.abs (font.descender / font.unitsPerEM * textField.__textFormat.size));
				case LEADING: textField.__textFormat.leading;
				default: 0;
				
			}
			
		}
		
		return 0;
		
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
				textLayout.text = getRenderableText(textField).substring (range.start, range.end);
				
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
}