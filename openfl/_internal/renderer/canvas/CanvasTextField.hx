package openfl._internal.renderer.canvas;


import haxe.Utf8;
import openfl._internal.renderer.dom.DOMTextField;
import openfl._internal.renderer.RenderSession;
import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.display.Graphics;
import openfl.events.Event;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.utils.ByteArray;

#if (js && html5)
import js.html.CanvasRenderingContext2D;
import js.Browser;
import js.html.ImageData;
#end

@:access(openfl.text.TextField)
@:access(openfl.display.Graphics)


class CanvasTextField {
	
	
	#if (js && html5)
	private static var context:CanvasRenderingContext2D;
	#end
	
	private static var __utf8_endline_code:Int = 10;
	
	
	private static function clipText (textField:TextField, value:String):String {
		
		var textWidth = getTextWidth (textField, value);
		var fillPer = textWidth / textField.__width;
		textField.text = fillPer > 1 ? textField.text.substr (-1 * Math.floor (textField.text.length / fillPer)) : textField.text;
		return textField.text + '';
		
	}
	
	
	public static function disableInputMode (textField:TextField):Void {
		
		#if (js && html5)
		textField.this_onRemovedFromStage (null);
		#end
		
	}
	
	
	public static function enableInputMode (textField:TextField):Void {
		
		#if (js && html5)
		
		textField.__cursorPosition = -1;
		
		if (textField.__hiddenInput == null) {
			
			textField.__hiddenInput = cast Browser.document.createElement ('input');
			var hiddenInput = textField.__hiddenInput;
			hiddenInput.type = 'text';
			hiddenInput.style.position = 'absolute';
			hiddenInput.style.opacity = "0";
			hiddenInput.style.color = "transparent";
			
			// TODO: Position for mobile browsers better
			
			hiddenInput.style.left = "0px";
			hiddenInput.style.top = "50%";
			
			if (~/(iPad|iPhone|iPod).*OS 8_/gi.match (Browser.window.navigator.userAgent)) {
				
				hiddenInput.style.fontSize = "0px";
				hiddenInput.style.width = '0px';
				hiddenInput.style.height = '0px';
				
			} else {
				
				hiddenInput.style.width = '1px';
				hiddenInput.style.height = '1px';
				
			}
			
			untyped (hiddenInput.style).pointerEvents = 'none';
			hiddenInput.style.zIndex = "-10000000";
			
			if (textField.maxChars > 0) {
				
				hiddenInput.maxLength = textField.maxChars;
				
			}
			
			Browser.document.body.appendChild (hiddenInput);
			hiddenInput.value = textField.__text;
			
		}
		
		if (textField.stage != null) {
			
			textField.this_onAddedToStage (null);
			
		} else {
			
			textField.addEventListener (Event.ADDED_TO_STAGE, textField.this_onAddedToStage);
			textField.addEventListener (Event.REMOVED_FROM_STAGE, textField.this_onRemovedFromStage);
			
		}
		
		#end
		
	}
	
	
	private static function getLineBreakIndices (textField:TextField):Array<Int> {
		
		//returns the exact character indeces where the line breaks occur
		
		var breaks = [];
		
		for (i in 0...Utf8.length (textField.text)) {
			
			try {
				
				var char = Utf8.charCodeAt (textField.text, i);
				
				if (char == __utf8_endline_code) {
					
					breaks.push (i);
					
				}
				
			}
			
		}
		
		return breaks;
		
	}
	
	
	public static function getLineWidth (textField:TextField, line:Int):Float {
		
		#if (js && html5)
		
		if (textField.__context == null) {
			
			textField.__canvas = cast Browser.document.createElement ("canvas");
			textField.__context = textField.__canvas.getContext ("2d");
			
		}
		
		var linebreaks = getLineBreakIndices (textField);
		
		var context = textField.__context;
		context.font = DOMTextField.getFont (textField.__textFormat);
		
		if (line == -1) {
			
			var longest = 0.0;
			
			for (i in 0...linebreaks.length) {
				
				longest = Math.max (longest, context.measureText (textField.__text.substring (i == 0 ? 0 : (linebreaks[i - 1] + 1), linebreaks[i])).width);
				
			}
			
			longest = Math.max (longest, context.measureText (textField.__text.substring (linebreaks.length == 0 ? 0 : (linebreaks[linebreaks.length - 1] + 1))).width);
			
			return longest;
			
		} else {
			
			return context.measureText (textField.__text.substring (line == 0 ? 0 : (linebreaks[line - 1] + 1))).width;
			
		}
		
		#else
		
		return 0;
		
		#end
		
	}
	
	
	public static function getTextWidth (textField:TextField, text:String):Float {
		
		#if (js && html5) 
		
		if (textField.__context == null) {
			
			textField.__canvas = cast Browser.document.createElement ("canvas");
			textField.__context = textField.__canvas.getContext ("2d");
			
		}
		
		textField.__context.font = DOMTextField.getFont (textField.__textFormat);
		textField.__context.textAlign = 'left';
		
		return textField.__context.measureText (text).width;
		
		#else
		
		return 0;
		
		#end
		
	}
	
	
	public static function measureText (textField:TextField, condense:Bool = true):Array<Float> {
		
		#if (js && html5)
		
		if (textField.__context == null) {
			
			textField.__canvas = cast Browser.document.createElement ("canvas");
			textField.__context = textField.__canvas.getContext ("2d");
			
		}
		
		if (textField.__ranges == null) {
			
			textField.__context.font = DOMTextField.getFont (textField.__textFormat);
			return [ textField.__context.measureText (textField.__text).width ];
			
		} else {
			
			var measurements = [];
			
			for (range in textField.__ranges) {
				
				textField.__context.font = DOMTextField.getFont (range.format);
				measurements.push (textField.__context.measureText (textField.text.substring (range.start, range.end)).width);
				
			}
			
			return measurements;
			
		}
		
		#else
		
		return null;
		
		#end
		
	}
	
	
	public static inline function render (textField:TextField, renderSession:RenderSession):Void {
		
		#if (js && html5)
		
		var bounds = textField.getBounds (null);
		
		if (textField.__dirty) {
			
			if (((textField.__text == null || textField.__text == "") && !textField.background && !textField.border && !textField.__hasFocus) || ((textField.width <= 0 || textField.height <= 0) && textField.autoSize != TextFieldAutoSize.NONE)) {
				
				textField.__graphics.__canvas = null;
				textField.__graphics.__context = null;
				textField.__graphics.__dirty = false;
				textField.__dirty = false;
				
			} else {
				
				if (textField.__graphics == null || textField.__graphics.__canvas == null) {
					
					if (textField.__graphics == null) {
						
						textField.__graphics = new Graphics ();
						
					}
					
					textField.__graphics.__canvas = cast Browser.document.createElement ("canvas");
					textField.__graphics.__context = textField.__graphics.__canvas.getContext ("2d");
					textField.__graphics.__bounds = new Rectangle( 0, 0, bounds.width, bounds.height );
					
				}
				
				var graphics = textField.__graphics;
				context = graphics.__context;
				
				if ((textField.__text != null && textField.__text != "") || textField.__hasFocus) {
					
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
					var bounds = textField.bounds;
					
					graphics.__canvas.width = Math.ceil (bounds.width);
					graphics.__canvas.height = Math.ceil (bounds.height);
					
					if (textField.border || textField.background) {
						
						context.rect (0.5, 0.5, bounds.width, bounds.height);
						
						if (textField.background) {
							
							context.fillStyle = "#" + StringTools.hex (textField.backgroundColor, 6);
							context.fill ();
							
						}
						
						if (textField.border) {
							
							context.lineWidth = 1;
							context.strokeStyle = "#" + StringTools.hex (textField.borderColor, 6);
							context.stroke ();
							
						}
						
					}
					
					if (textField.__hasFocus && (textField.__selectionStart == textField.__cursorPosition) && textField.__showCursor) {
						
						var cursorOffset = getTextWidth (textField, text.substring (0, textField.__cursorPosition)) + 3;
						context.fillStyle = "#" + StringTools.hex (textField.__textFormat.color, 6);
						context.fillRect (cursorOffset, 5, 1, (textField.__textFormat.size * 1.185) - 4);
						
					} else if (textField.__hasFocus && (Math.abs (textField.__selectionStart - textField.__cursorPosition)) > 0) {
						
						var lowPos = Std.int (Math.min (textField.__selectionStart, textField.__cursorPosition));
						var highPos = Std.int (Math.max (textField.__selectionStart, textField.__cursorPosition));
						var xPos = getTextWidth (textField, text.substring (0, lowPos)) + 2;
						var widthPos = getTextWidth (textField, text.substring (lowPos, highPos));
						
						// TODO: White text
						
						context.fillStyle = "#000000";
						context.fillRect (xPos, 5, widthPos, (textField.__textFormat.size * 1.185) - 4);
						
					}
					
					if (textField.__ranges == null) {
						
						renderText (textField, text, textField.__textFormat, 0, bounds );
						
					} else {
						
						var currentIndex = 0;
						var range;
						var offsetX = 0.0;
						
						for (i in 0...textField.__ranges.length) {
							
							range = textField.__ranges[i];
							
							renderText (textField, text.substring (range.start, range.end), range.format, offsetX, bounds );
							offsetX += measurements[i];
							
						}
						
					}
					
				} else {
					
					graphics.__canvas.width = Math.ceil (textField.__width);
					graphics.__canvas.height = Math.ceil (textField.__height);
					
					if (textField.border || textField.background) {
						
						if (textField.border) {
							
							context.rect (0.5, 0.5, textField.width, textField.height);
							
						} else {
							
							context.rect (0, 0, textField.width, textField.height);
							
						}
						
						if (textField.background) {
							
							context.fillStyle = "#" + StringTools.hex (textField.backgroundColor, 6);
							context.fill ();
							
						}
						
						if (textField.border) {
							
							context.lineWidth = 1;
							context.lineCap = "square";
							context.strokeStyle = "#" + StringTools.hex (textField.borderColor, 6);
							context.stroke ();
							
						}
						
					}
					
				}
				
				graphics.__bitmap = BitmapData.fromCanvas (graphics.__canvas);
				textField.__dirty = false;
				graphics.__dirty = false;
				
			}
			
		}
		
		#end
		
	}
	
	
	private static inline function renderText (textField:TextField, text:String, format:TextFormat, offsetX:Float, bounds:Rectangle ):Void {
		
		#if (js && html5)
		
		context.font = DOMTextField.getFont (format);
		context.fillStyle = "#" + StringTools.hex (format.color, 6);
		context.textBaseline = "top";
		
		var yOffset = 0.0;
		
		// Hack, baseline "top" is not consistent across browsers
		
		if (~/(iPad|iPhone|iPod|Firefox)/g.match (Browser.window.navigator.userAgent)) {
			
			yOffset = format.size * 0.185;
			
		}
		
		var lines = [];
		
		if (textField.wordWrap) {
			
			var words = text.split (" ");
			var line = "";
			
			var word, newLineIndex, test;
			
			for (i in 0...words.length) {
				
				word = words[i];
				newLineIndex = word.indexOf ("\n");
				
				if (newLineIndex > -1) {
					
					while (newLineIndex > -1) {
						
						test = line + word.substring (0, newLineIndex) + " ";
						
						if (context.measureText (test).width > textField.__width - 4 && i > 0) {
							
							lines.push (line);
							lines.push (word.substring (0, newLineIndex));
							
						} else {
							
							lines.push (line + word.substring (0, newLineIndex));
							
						}
						
						word = word.substr (newLineIndex + 1);
						newLineIndex = word.indexOf ("\n");
						line = "";
						
					}
					
					if (word != "") {
						
						line = word + " ";
						
					}
					
				} else {
					
					test = line + words[i] + " ";
					
					if (context.measureText (test).width > textField.__width - 4 && i > 0) {
						
						lines.push (line);
						line = words[i] + " ";
						
					} else {
						
						line = test;
						
					}
					
				}
				
			}
			
			if (line != "") {
				
				lines.push (line);
				
			}
			
		} else {
			
			lines = text.split ("\n");
			
		}
		
		for (line in lines) {
			
			switch (format.align) {
				
				case TextFormatAlign.CENTER:
					
					context.textAlign = "center";
					context.fillText (line, offsetX + textField.width / 2, 2 + yOffset, textField.textWidth);
					
				case TextFormatAlign.RIGHT:
					
					context.textAlign = "end";
					context.fillText (line, offsetX + textField.width - 2, 2 + yOffset, textField.textWidth);
					
				default:
					
					context.textAlign = "start";
					context.fillText (line, 2 + offsetX, 2 + yOffset, textField.textWidth);
					
			}
			
			yOffset += format.size + format.leading + 6;
			offsetX = 0;
			
		}
		
		#end
		
	}
	
	
}