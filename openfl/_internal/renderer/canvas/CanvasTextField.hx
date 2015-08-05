package openfl._internal.renderer.canvas;


import haxe.Utf8;
import openfl._internal.renderer.dom.DOMTextField;
import openfl._internal.renderer.RenderSession;
import openfl._internal.text.TextEngine;
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

@:access(openfl._internal.text.TextEngine)
@:access(openfl.display.Graphics)
@:access(openfl.text.TextField)


class CanvasTextField {
	
	
	#if (js && html5)
	private static var context:CanvasRenderingContext2D;
	#end
	
	
	public static function disableInputMode (textEngine:TextEngine):Void {
		
		//#if (js && html5)
		//textEngine.this_onRemovedFromStage (null);
		//#end
		
	}
	
	
	public static function enableInputMode (textEngine:TextEngine):Void {
		
		#if (js && html5)
		
		textEngine.__cursorPosition = -1;
		
		if (textEngine.__hiddenInput == null) {
			
			textEngine.__hiddenInput = cast Browser.document.createElement ('input');
			var hiddenInput = textEngine.__hiddenInput;
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
			
			if (textEngine.maxChars > 0) {
				
				hiddenInput.maxLength = textEngine.maxChars;
				
			}
			
			Browser.document.body.appendChild (hiddenInput);
			hiddenInput.value = textEngine.text;
			
		}
		
		//if (textField.stage != null) {
			//
			//textEngine.this_onAddedToStage (null);
			//
		//} else {
			//
			//textField.addEventListener (Event.ADDED_TO_STAGE, textEngine.this_onAddedToStage);
			//textField.addEventListener (Event.REMOVED_FROM_STAGE, textEngine.this_onRemovedFromStage);
			//
		//}
		
		#end
		
	}
	
	
	public static inline function render (textField:TextField, renderSession:RenderSession):Void {
		
		#if (js && html5)
		
		var textEngine = textField.__layout;
		var bounds = textField.getBounds (null);
		
		if (textField.__dirty) {
			
			var textEngine = textField.__layout;
			textField.__updateLayout ();
			
			if (((textEngine.text == null || textEngine.text == "") && !textEngine.background && !textEngine.border && !textEngine.__hasFocus) || ((textEngine.width <= 0 || textEngine.height <= 0) && textEngine.autoSize != TextFieldAutoSize.NONE)) {
				
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
					textField.__graphics.__bounds = new Rectangle (0, 0, bounds.width, bounds.height);
					
				}
				
				var graphics = textField.__graphics;
				context = graphics.__context;
				
				if ((textEngine.text != null && textEngine.text != "") || textEngine.__hasFocus) {
					
					var text = textEngine.text;
					
					if (textEngine.displayAsPassword) {
						
						var length = text.length;
						var mask = "";
						
						for (i in 0...length) {
							
							mask += "*";
							
						}
						
						text = mask;
						
					}
					
					var bounds = textEngine.bounds;
					
					graphics.__canvas.width = Math.ceil (bounds.width);
					graphics.__canvas.height = Math.ceil (bounds.height);
					
					if (textEngine.border || textEngine.background) {
						
						context.rect (0.5, 0.5, bounds.width, bounds.height);
						
						if (textEngine.background) {
							
							context.fillStyle = "#" + StringTools.hex (textEngine.backgroundColor, 6);
							context.fill ();
							
						}
						
						if (textEngine.border) {
							
							context.lineWidth = 1;
							context.strokeStyle = "#" + StringTools.hex (textEngine.borderColor, 6);
							context.stroke ();
							
						}
						
					}
					
					// TODO: keep character positions?
					
					//if (textEngine.__hasFocus && (textEngine.__selectionStart == textEngine.__cursorPosition) && textEngine.__showCursor) {
						//
						//var cursorOffset = textEngine.__textLayout.getTextWidth (textEngine, text.substring (0, textEngine.__cursorPosition)) + 3;
						//context.fillStyle = "#" + StringTools.hex (textEngine.__textFormat.color, 6);
						//context.fillRect (cursorOffset, 5, 1, (textEngine.__textFormat.size * 1.185) - 4);
						//
					//} else if (textEngine.__hasFocus && (Math.abs (textEngine.__selectionStart - textEngine.__cursorPosition)) > 0) {
						//
						//var lowPos = Std.int (Math.min (textEngine.__selectionStart, textEngine.__cursorPosition));
						//var highPos = Std.int (Math.max (textEngine.__selectionStart, textEngine.__cursorPosition));
						//var xPos = textEngine.__textLayout.getTextWidth (textEngine, text.substring (0, lowPos)) + 2;
						//var widthPos = textEngine.__textLayout.getTextWidth (textEngine, text.substring (lowPos, highPos));
						//
						//// TODO: White text
						//
						//context.fillStyle = "#000000";
						//context.fillRect (xPos, 5, widthPos, (textEngine.__textFormat.size * 1.185) - 4);
						//
					//}
					
					//context.textBaseline = "top";
					context.textBaseline = "alphabetic";
					context.textAlign = "start";
					
					for (group in textEngine.renderGroups) {
						
						renderText (textField, text.substring (group.start, group.end), group.format, group.x, group.y, bounds);
						
					}
					
				} else {
					
					graphics.__canvas.width = Math.ceil (textEngine.width);
					graphics.__canvas.height = Math.ceil (textEngine.height);
					
					if (textEngine.border || textEngine.background) {
						
						if (textEngine.border) {
							
							context.rect (0.5, 0.5, textEngine.width, textEngine.height);
							
						} else {
							
							context.rect (0, 0, textEngine.width, textEngine.height);
							
						}
						
						if (textEngine.background) {
							
							context.fillStyle = "#" + StringTools.hex (textEngine.backgroundColor, 6);
							context.fill ();
							
						}
						
						if (textEngine.border) {
							
							context.lineWidth = 1;
							context.lineCap = "square";
							context.strokeStyle = "#" + StringTools.hex (textEngine.borderColor, 6);
							context.stroke ();
							
						}
						
					}
					
				}
				
				graphics.__bitmap = BitmapData.fromCanvas (textField.__canvas);
				textField.__dirty = false;
				graphics.__dirty = false;
				
			}
			
		}
		
		#end
		
	}
	
	
	private static inline function renderText (textField:TextField, text:String, format:TextFormat, offsetX:Float, offsetY:Float, bounds:Rectangle):Void {
		
		#if (js && html5)
		
		var textEngine = textField.__layout;
		
		context.font = TextEngine.getFont (format);
		context.fillStyle = "#" + StringTools.hex (format.color, 6);
		//context.textBaseline = "top";
		
		//var yOffset = 0.0;
		
		// Hack, baseline "top" is not consistent across browsers
		
		if (~/(iPad|iPhone|iPod|Firefox)/g.match (Browser.window.navigator.userAgent)) {
			
			offsetY += format.size * 0.185;
			
		}
		
		//var lines = [];
		//
		//if (textEngine.wordWrap) {
			//
			//var words = text.split (" ");
			//var line = "";
			//
			//var word, newLineIndex, test;
			//
			//for (i in 0...words.length) {
				//
				//word = words[i];
				//newLineIndex = word.indexOf ("\n");
				//
				//if (newLineIndex > -1) {
					//
					//while (newLineIndex > -1) {
						//
						//test = line + word.substring (0, newLineIndex) + " ";
						//
						//if (context.measureText (test).width > textEngine.width - 4 && i > 0) {
							//
							//lines.push (line);
							//lines.push (word.substring (0, newLineIndex));
							//
						//} else {
							//
							//lines.push (line + word.substring (0, newLineIndex));
							//
						//}
						//
						//word = word.substr (newLineIndex + 1);
						//newLineIndex = word.indexOf ("\n");
						//line = "";
						//
					//}
					//
					//if (word != "") {
						//
						//line = word + " ";
						//
					//}
					//
				//} else {
					//
					//test = line + words[i] + " ";
					//
					//if (context.measureText (test).width > textEngine.width - 4 && i > 0) {
						//
						//lines.push (line);
						//line = words[i] + " ";
						//
					//} else {
						//
						//line = test;
						//
					//}
					//
				//}
				//
			//}
			//
			//if (line != "") {
				//
				//lines.push (line);
				//
			//}
			//
		//} else {
			//
			//lines = text.split ("\n");
			//
		//}
		//
		//for (line in lines) {
			//
			//switch (format.align) {
				//
				//case TextFormatAlign.CENTER:
					//
					//context.textAlign = "center";
					//context.fillText (line, offsetX + textEngine.width / 2, 2 + yOffset, textEngine.getTextWidth ());
					//
				//case TextFormatAlign.RIGHT:
					//
					//context.textAlign = "end";
					//context.fillText (line, offsetX + textEngine.width - 2, 2 + yOffset, textEngine.getTextWidth ());
					//
				//default:
					//
					//context.textAlign = "start";
					//context.fillText (line, 2 + offsetX, 2 + yOffset, textEngine.getTextWidth ());
					//
			//}
			//
			//yOffset += format.size + format.leading + 4;
			//offsetX = 0;
			//
		//}
		
		context.fillText (text, offsetX, offsetY);
		
		#end
		
	}
	
	
}