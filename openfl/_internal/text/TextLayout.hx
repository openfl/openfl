package openfl._internal.text;


import lime.text.TextLayout in NativeLayout;
import openfl._internal.renderer.cairo.CairoTextField;
import openfl._internal.renderer.dom.DOMTextField;
import haxe.Utf8;

#if (js && html5)
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.Browser;
#end

@:access(openfl._internal.text.TextEngine)
@:access(openfl.text.TextField)


class TextLayout {
	
	
	#if (js && html5)
	private static var canvas:CanvasElement;
	private static var context:CanvasRenderingContext2D;
	#end
	
	public var height (get, set):Float;
	public var lineAscent:Array<Int>;
	public var lineBreaks:Array<Int>;
	public var lineDescent:Array<Int>;
	public var lineLeading:Array<Int>;
	public var lineWidth:Array<Float>;
	public var multiline (get, set):Bool;
	public var numLines (get, null):Int;
	public var text (get, set):String;
	public var textFormat (get, set):Array<TextFormatRange>;
	public var width (get, set):Float;
	public var wordWrap (get, set):Bool;
	
	private var handle:NativeLayout;
	private var spaces:Array<Int>;
	
	private var __dirty:Bool;
	private var __height:Float;
	private var __multiline:Bool;
	private var __text:String;
	private var __textFormat:Array<TextFormatRange>;
	private var __width:Float;
	private var __wordWrap:Bool;
	
	
	public function new (text:String, width:Float, height:Float) {
		
		this.text = text;
		this.width = width;
		this.height = height;
		
		lineAscent = new Array ();
		lineBreaks = new Array ();
		lineDescent = new Array ();
		lineLeading = new Array ();
		lineWidth = new Array ();
		
	}
	
	
	public function getLine (index:Int):String {
		
		if (index < 0 || index > numLines) {
			
			return null;
			
		}
		
		if (lineBreaks.length == 0) {
			
			return __text;
			
		} else {
			
			return __text.substring (index > 0 ? lineBreaks[index - 1] : 0, lineBreaks[index]);
			
		}
		
	}
	
	
	private function getLineBreaks ():Void {
		
		lineBreaks.splice (0, lineBreaks.length);
		
		var i = 0;
		
		Utf8.iter (__text, function (char:Int) {
			
			if (char == 10) {
				
				lineBreaks.push (i);
				i++;
				
			}
			
		});
		
	}
	
	
	private function getLineMeasurements ():Void {
		
		lineAscent.splice (0, lineAscent.length);
		lineDescent.splice (0, lineDescent.length);
		lineLeading.splice (0, lineLeading.length);
		lineWidth.splice (0, lineWidth.length);
		
		var currentLineAscent = 0;
		var currentLineDescent = 0;
		var currentLineLeading = 0;
		var currentLineWidth = 0.0;
		
		var nextLineBreak = -1;
		var lineBreakIndex = 0;
		
		if (lineBreaks.length > 0) {
			
			nextLineBreak = lineBreaks[0];
			
		}
		
		#if (js && html5)
		
		if (context == null) {
			
			canvas = cast Browser.document.createElement ("canvas");
			context = canvas.getContext ("2d");
			
		}
		
		#elseif (cpp || neko || nodejs)
		
		if (handle == null) {
			
			handle = new NativeLayout ();
			
		}
		
		var font;
		#end
		
		var done = false;
		var startIndex;
		var endIndex;
		
		// TODO: wordWrap
		
		for (range in __textFormat) {
			
			if (range.end <= range.start) continue;
			
			#if (js && html5)
			context.font = DOMTextField.getFont (range.format);
			#elseif (cpp || neko || nodejs)
			font = CairoTextField.getFontInstance (range.format);
			#end
			
			startIndex = range.start;
			
			while (!done) {
				
				endIndex = (nextLineBreak == -1 || range.end < nextLineBreak) ? range.end : nextLineBreak;
				
				#if (js && html5)
				
				currentLineWidth += context.measureText (__text.substring (startIndex, endIndex)).width;
				
				currentLineAscent = Std.int (Math.max (currentLineAscent, range.format.size * 0.8));
				currentLineDescent = Std.int (Math.max (currentLineDescent, range.format.size * 0.2));
				currentLineLeading = Std.int (Math.max (currentLineLeading, range.format.leading + 4));
				
				#elseif (cpp || neko || nodejs)
				
				handle.text = null;
				handle.font = font;
				handle.size = Std.int (range.format.size);
				handle.text = __text.substring (startIndex, endIndex);
				
				for (position in handle.positions) {
					
					currentLineWidth += position.advance.x;
					
				}
				
				currentLineAscent = Std.int (Math.max (currentLineAscent, (font.ascender / font.unitsPerEM) * range.format.size));
				currentLineDescent = Std.int (Math.max (currentLineDescent, (font.descender / font.unitsPerEM) * range.format.size));
				currentLineLeading = Std.int (Math.max (currentLineLeading, range.format.leading + 4));
				
				#end
				
				if (range.end >= nextLineBreak) {
					
					lineAscent.push (currentLineAscent);
					lineDescent.push (currentLineDescent);
					lineLeading.push (currentLineLeading);
					lineWidth.push (currentLineWidth);
					
					currentLineAscent = 0;
					currentLineDescent = 0;
					currentLineLeading = 0;
					currentLineWidth = 0;
					
					startIndex = nextLineBreak + 1;
					
					if (lineBreakIndex < lineBreaks.length - 1) {
						
						lineBreakIndex++;
						nextLineBreak = lineBreaks[lineBreakIndex];
						
					} else {
						
						nextLineBreak = -1;
						done = true;
						
					}
					
				} else {
					
					done = true;
					
				}
				
			}
			
			done = false;
			
		}
		
		if (lineWidth.length < numLines) {
			
			lineAscent.push (currentLineAscent);
			lineDescent.push (currentLineDescent);
			lineLeading.push (currentLineLeading);
			lineWidth.push (currentLineWidth);
			
		}
		
	}
	
	
	public function update ():Void {
		
		if (__dirty) {
			
			if (__text == null || StringTools.trim (__text) == "" && __textFormat != null && __textFormat.length > 0) {
				
				lineAscent.splice (0, lineAscent.length);
				lineBreaks.splice (0, lineBreaks.length);
				lineDescent.splice (0, lineDescent.length);
				lineLeading.splice (0, lineLeading.length);
				lineWidth.splice (0, lineWidth.length);
				
			} else {
				
				// TODO: wordWrap
				
				getLineBreaks ();
				getLineMeasurements ();
				
			}
			
		}
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_height ():Float {
		
		return __height;
		
	}
	
	
	private function set_height (value:Float):Float {
		
		if (value != __height) {
			
			__dirty = true;
			
		}
		
		return __height = value;
		
	}
	
	
	private function get_multiline ():Bool {
		
		return __multiline;
		
	}
	
	
	private function set_multiline (value:Bool):Bool {
		
		if (value != __multiline) {
			
			__dirty = true;
			
		}
		
		return __multiline = value;
		
	}
	
	
	private function get_numLines ():Int {
		
		return lineBreaks.length + 1;
		
	}
	
	
	private function get_text ():String {
		
		return __text;
		
	}
	
	
	private function set_text (value:String):String {
		
		if (value != __text) {
			
			__dirty = true;
			
		}
		
		return __text = value;
		
	}
	
	
	private function get_textFormat ():Array<TextFormatRange> {
		
		return __textFormat;
		
	}
	
	
	private function set_textFormat (value:Array<TextFormatRange>):Array<TextFormatRange> {
		
		if (value != __textFormat) {
			
			__dirty = true;
			
		}
		
		return __textFormat = value;
		
	}
	
	
	private function get_width ():Float {
		
		return __width;
		
	}
	
	
	private function set_width (value:Float):Float {
		
		if (value != __width) {
			
			__dirty = true;
			
		}
		
		return __width = value;
		
	}
	
	
	private function get_wordWrap ():Bool {
		
		return __wordWrap;
		
	}
	
	
	private function set_wordWrap (value:Bool):Bool {
		
		if (value != __wordWrap) {
			
			__dirty = true;
			
		}
		
		return __wordWrap = value;
		
	}
	
	
}