package openfl._internal.text;


import lime.text.TextLayout in NativeLayout;
import openfl._internal.renderer.cairo.CairoTextField;
import openfl._internal.renderer.dom.DOMTextField;
import haxe.Utf8;

#if (js && html5)
import js.Browser;
#end

@:access(openfl._internal.text.TextEngine)
@:access(openfl.text.TextField)


class TextLayout {
	
	
	private static var __utf8_endline_code:Int = 10;
	
	private var handle:NativeLayout;
	
	
	public function new () {
		
		
		
	}
	
	
	private function getLineBreaks (textEngine:TextEngine):Int {
		
		//returns the number of line breaks in the text
		
		var lines = 0;
		
		Utf8.iter(textEngine.text, function(char:Int) {
			
			if (char == __utf8_endline_code) {
				
				lines++;
				
			}
			
		});
		
		return lines;
		
	}
	
	
	private function getLineBreakIndices (textEngine:TextEngine):Array<Int> {
		
		//returns the exact character indeces where the line breaks occur
		
		var breaks = [];
		
		var i = 0;
		
		Utf8.iter(textEngine.text, function(char:Int) {
			
			if (char == __utf8_endline_code) {
				
				breaks.push (i);
				i++;
				
			}
			
		});
		
		return breaks;
		
	}
	
	
	private function getLineBreaksInRange (textEngine:TextEngine, i:Int):Int {
		
		//returns the number of line breaks that occur within a given format range
		
		var lines = 0;
		
		if (textEngine.__ranges.length > i && i >= 0) {
			
			var range = textEngine.__ranges[i];
			
			//TODO: this could quite possibly cause crash errors if range indeces are not based on Utf8 character indeces
			
			if (range.start > 0 && range.end < textEngine.text.length) {
				
				Utf8.iter(textEngine.text, function(char:Int) {
					
					if (char == __utf8_endline_code) {
						
						lines++;
						
					}
					
				});
				
			}
			
		}
		
		return lines;
		
	}
	
	
	private function getLineIndices (textEngine:TextEngine, line:Int):Array<Int> {
		
		//tells you what the first and last (non-linebreak) character indeces are in a given line
		
		var breaks = getLineBreakIndices (textEngine);
		var i = 0;
		var first_char = 0;
		var last_char:Int = textEngine.text.length - 1;
		
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
	
	
	public function getLineMetric (textEngine:TextEngine, line:Int, metric:TextFieldLineMetric):Float {
		
		if (textEngine.__ranges == null) {
			
			return getLineMetricSubRangesNull (textEngine, true, metric);
			
		} else {
			
			return getLineMetricSubRangesNotNull (textEngine, line, metric);
			
		}
		
	}
	
	
	private function getLineMetricSubRangesNotNull (textEngine:TextEngine, specificLine:Int, metric:TextFieldLineMetric):Float {
		
		//subroutine if ranges are not null
		//TODO: test this more thoroughly
		
		var lineChars = getLineIndices (textEngine, specificLine);
		
		var m = 0.0;
		var best_m = 0.0;
		
		for (range in textEngine.__ranges) {
			
			if (range.start >= lineChars[0]) {
				
				var font = CairoTextField.getFontInstance (range.format);
				
				if (font != null) {
					
					m = switch (metric) {
						
						case LINE_HEIGHT: getLineMetricSubRangesNotNull (textEngine, specificLine, ASCENDER) + getLineMetricSubRangesNotNull (textEngine, specificLine, DESCENDER) + getLineMetricSubRangesNotNull (textEngine, specificLine, LEADING);
						case ASCENDER: font.ascender / font.unitsPerEM * textEngine.__textFormat.size;
						case DESCENDER: Math.abs(font.descender / font.unitsPerEM * textEngine.__textFormat.size);
						case LEADING: textEngine.__textFormat.leading + 4;
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
	
	
	private function getLineMetricSubRangesNull (textEngine:TextEngine, singleLine:Bool = false, metric:TextFieldLineMetric):Float {
		
		//subroutine if ranges are null
		
		var font = CairoTextField.getFontInstance (textEngine.__textFormat);
		
		if (font != null) {
			
			return switch (metric) {
				
				case LINE_HEIGHT: getLineMetricSubRangesNull (textEngine, singleLine, ASCENDER) + getLineMetricSubRangesNull (textEngine, singleLine, DESCENDER) + getLineMetricSubRangesNull (textEngine, singleLine, LEADING);
				case ASCENDER: font.ascender / font.unitsPerEM * textEngine.__textFormat.size;
				case DESCENDER: Math.abs (font.descender / font.unitsPerEM * textEngine.__textFormat.size);
				case LEADING: textEngine.__textFormat.leading + 4;
				default: 0;
				
			}
			
		}
		
		return 0;
		
	}
	
	
	public function getLineWidth (textEngine:TextEngine, line:Int):Float {
		
		#if (js && html5)
		
		if (textEngine.textField.__context == null) {
			
			textEngine.textField.__canvas = cast Browser.document.createElement ("canvas");
			textEngine.textField.__context = textEngine.textField.__canvas.getContext ("2d");
			
		}
		
		var linebreaks = getLineBreakIndices (textEngine);
		
		var context = textEngine.textField.__context;
		context.font = DOMTextField.getFont (textEngine.__textFormat);
		
		if (line == -1) {
			
			var longest = 0.0;
			
			for (i in 0...linebreaks.length) {
				
				longest = Math.max (longest, context.measureText (textEngine.text.substring (i == 0 ? 0 : (linebreaks[i - 1] + 1), linebreaks[i])).width);
				
			}
			
			longest = Math.max (longest, context.measureText (textEngine.text.substring (linebreaks.length == 0 ? 0 : (linebreaks[linebreaks.length - 1] + 1))).width);
			
			return longest;
			
		} else {
			
			return context.measureText (textEngine.text.substring (line == 0 ? 0 : (linebreaks[line - 1] + 1))).width;
			
		}
		
		#elseif (cpp || neko || nodejs)
		
		//Returns the width of a given line, or if -1 is supplied, the largest width of any single line
		
		var measurements = measureTextSub (textEngine, false);
		
		var currWidth = 0.0;
		var bestWidth = 0.0;
		
		var linebreaks = getLineBreakIndices (textEngine);
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
	
	
	public function getTextHeight (textEngine:TextEngine):Float {
		
		//sum the heights of all the lines, but don't count the leading of the last line
		//TODO: might need robustness check for pathological cases (multiple format ranges) -- would need to change how line heights are calculated
		
		var th = 0.0;
		
		for (i in 0...textEngine.getNumLines ()) {
			
			th += getLineMetric (textEngine, i, ASCENDER) + getLineMetric (textEngine, i, DESCENDER);
			
			if (i != textEngine.getNumLines () - 1) {
				
				th += getLineMetric (textEngine, i, LEADING);
				
			}
			
		}
		
		return th;
		
	}
	
	
	public function getTextWidth (textEngine:TextEngine, text:String):Float {
		
		#if (js && html5) 
		
		if (textEngine.textField.__context == null) {
			
			textEngine.textField.__canvas = cast Browser.document.createElement ("canvas");
			textEngine.textField.__context = textEngine.textField.__canvas.getContext ("2d");
			
		}
		
		textEngine.textField.__context.font = DOMTextField.getFont (textEngine.__textFormat);
		textEngine.textField.__context.textAlign = 'left';
		
		return textEngine.textField.__context.measureText (text).width;
		
		#else
		
		return 0;
		
		#end
		
	}
	
	
	public function measureText (textEngine:TextEngine, condense:Bool = true):Array<Float> {
		
		#if (js && html5)
		
		if (textEngine.textField.__context == null) {
			
			textEngine.textField.__canvas = cast Browser.document.createElement ("canvas");
			textEngine.textField.__context = textEngine.textField.__canvas.getContext ("2d");
			
		}
		
		if (textEngine.__ranges == null) {
			
			textEngine.textField.__context.font = DOMTextField.getFont (textEngine.__textFormat);
			return [ textEngine.textField.__context.measureText (textEngine.text).width ];
			
		} else {
			
			var measurements = [];
			
			for (range in textEngine.__ranges) {
				
				textEngine.textField.__context.font = DOMTextField.getFont (range.format);
				measurements.push (textEngine.textField.__context.measureText (textEngine.text.substring (range.start, range.end)).width);
				
			}
			
			return measurements;
			
		}
		
		#else
		
		//the "condense" flag, if true, will return the widths of individual text format ranges, if false will return the widths of each character
		//TODO: look into whether this method and others can replace the JS stuff yet or not
		
		return measureTextSub (textEngine, condense);
		
		#end
		
	}
	
	
	private function measureTextSub (textEngine:TextEngine, condense:Bool):Array<Float> {
		
		//subroutine for measuring text (width)
		
		if (handle == null) {
			
			handle = new NativeLayout ();
			
		}
		
		if (textEngine.__ranges == null) {
			
			return measureTextSubRangesNull (textEngine, condense);
			
		} else {
			
			return measureTextSubRangesNotNull (textEngine, condense);
			
		}
		
		return null;
		
	}
	
	
	private function measureTextSubRangesNotNull (textEngine:TextEngine, condense:Bool):Array<Float> {
		
		//subroutine if format ranges are not null
		
		var measurements = [];
		var textLayout = handle;
		
		for (range in textEngine.__ranges) {
			
			var font = CairoTextField.getFontInstance (range.format);
			var width = 0.0;
			
			if (font != null && range.format.size != null) {
				
				textLayout.text = null;
				textLayout.font = font;
				textLayout.size = Std.int (range.format.size);
				textLayout.text = textEngine.text.substring (range.start, range.end);
				
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
	
	
	private function measureTextSubRangesNull (textEngine:TextEngine, condense:Bool):Array<Float> {
		
		//subroutine if format ranges are null
		
		var font = CairoTextField.getFontInstance (textEngine.__textFormat);
		var width = 0.0;
		var widths = [];
		var textLayout = handle;
		
		if (font != null && textEngine.__textFormat.size != null) {
			
			textLayout.text = null;
			textLayout.font = font;
			textLayout.size = Std.int (textEngine.__textFormat.size);
			textLayout.text = textEngine.text;
			
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