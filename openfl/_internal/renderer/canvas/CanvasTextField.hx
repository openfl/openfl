package openfl._internal.renderer.canvas;


import openfl._internal.renderer.RenderSession;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

#if js
import js.html.CanvasRenderingContext2D;
import js.Browser;
#end

@:access(openfl.text.TextField)


class CanvasTextField {
	
	
	#if js
	private static var context:CanvasRenderingContext2D;
	#end
	
	
	public static inline function render (textField:TextField, renderSession:RenderSession):Void {
		
		#if js
		
		if (!textField.__renderable || textField.__worldAlpha <= 0) return;
		
		update (textField);
		
		if (textField.__canvas != null) {
			
			var context = renderSession.context;
			
			context.globalAlpha = textField.__worldAlpha;
			var transform = textField.__worldTransform;
			var scrollRect = textField.scrollRect;
			
			if (renderSession.roundPixels) {
				
				context.setTransform (transform.a, transform.b, transform.c, transform.d, Std.int (transform.tx), Std.int (transform.ty));
				
			} else {
				
				context.setTransform (transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
				
			}
			
			if (scrollRect == null) {
				
				context.drawImage (textField.__canvas, 0, 0);
				
			} else {
				
				context.drawImage (textField.__canvas, scrollRect.x, scrollRect.y, scrollRect.width, scrollRect.height, scrollRect.x, scrollRect.y, scrollRect.width, scrollRect.height);
				
			}
			
		}
		
		#end
		
	}
	
	
	private static inline function renderText (textField:TextField, text:String, format:TextFormat, offsetX:Float):Void {
		
		#if js
		
		context.font = textField.__getFont (format);
		context.textBaseline = "top";
		context.fillStyle = "#" + StringTools.hex (format.color, 6);
		
		var lines = text.split("\n");
		var yOffset:Float = 0;
		
		for (line in lines) {
			
			switch (format.align) {
				
				case TextFormatAlign.CENTER:
					
					context.textAlign = "center";
					context.fillText (line, textField.__width / 2, 2 + yOffset, textField.__width - 4);
					
				case TextFormatAlign.RIGHT:
					
					context.textAlign = "end";
					context.fillText (line, textField.__width - 2, 2 + yOffset, textField.__width - 4);
					
				default:
					
					context.textAlign = "start";
					context.fillText (line, 2 + offsetX, 2 + yOffset, textField.__width - 4);
					
			}
			
			yOffset += textField.textHeight;
		}
		
		#end
		
	}
	
	
	public static function update (textField:TextField):Bool {
		
		#if js
		
		if (textField.__dirty) {
			
			if (((textField.__text == null || textField.__text == "") && !textField.background && !textField.border) || ((textField.width <= 0 || textField.height <= 0) && textField.autoSize != TextFieldAutoSize.LEFT)) {
				
				textField.__canvas = null;
				textField.__context = null;
				textField.__dirty = false;
				
			} else {
				
				if (textField.__canvas == null) {
					
					textField.__canvas = cast Browser.document.createElement ("canvas");
					textField.__context = textField.__canvas.getContext ("2d");
					
				}
				
				context = textField.__context;
				
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
					
					var measurements = textField.__measureText ();
					var textWidth = 0.0;
					
					for (measurement in measurements) {
						
						textWidth += measurement;
						
					}
					
					if (textField.autoSize == TextFieldAutoSize.LEFT) {
						
						textField.__width = textWidth + 4;
						
					}
					
					textField.__canvas.width = Math.ceil (textField.__width);
					textField.__canvas.height = Math.ceil (textField.__height);
					
					if (textField.border || textField.background) {
						
						textField.__context.rect (0.5, 0.5, textField.__width - 1, textField.__height - 1);
						
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
						
						var cursorOffset = textField.__getTextWidth (text.substring (0, textField.__cursorPosition));
						context.fillStyle = "#" + StringTools.hex (textField.__textFormat.color, 6);
						context.fillRect (cursorOffset, 5, 1, textField.__textFormat.size - 5);
						
					} else if (textField.__hasFocus && (Math.abs (textField.__selectionStart - textField.__cursorPosition)) > 0 && !textField.__isKeyDown) {
						
						var lowPos = Std.int (Math.min (textField.__selectionStart, textField.__cursorPosition));
						var highPos = Std.int (Math.max (textField.__selectionStart, textField.__cursorPosition));
						var xPos = textField.__getTextWidth (text.substring (0, lowPos));
						var widthPos = textField.__getTextWidth (text.substring (lowPos, highPos));
						
						context.fillStyle = "#" + StringTools.hex (textField.__textFormat.color, 6);
						context.fillRect (xPos, 5, widthPos, textField.__textFormat.size - 5);
						
					}
					
					if (textField.__ranges == null) {
						
						renderText (textField, text, textField.__textFormat, 0);
						
					} else {
						
						var currentIndex = 0;
						var range;
						var offsetX = 0.0;
						
						for (i in 0...textField.__ranges.length) {
							
							range = textField.__ranges[i];
							
							renderText (textField, text.substring (range.start, range.end), range.format, offsetX);
							offsetX += measurements[i];
							
						}
						
					}
					
				} else {
					
					if (textField.autoSize == TextFieldAutoSize.LEFT) {
						
						textField.__width = 4;
						
					}
					
					textField.__canvas.width = Math.ceil (textField.__width);
					textField.__canvas.height = Math.ceil (textField.__height);
					
					if (textField.border || textField.background) {
						
						if (textField.border) {
							
							context.rect (0.5, 0.5, textField.__width - 1, textField.__height - 1);
							
						} else {
							
							textField.__context.rect (0, 0, textField.__width, textField.__height);
							
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
				
				textField.__dirty = false;
				return true;
				
			}
			
		}
		
		#end
		
		return false;
		
	}
	
	
}