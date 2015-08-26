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
		
		if (textField.__dirty) {
			
			var textEngine = textField.__textEngine;
			
			textField.__updateLayout ();
			
			if (((textEngine.text == null || textEngine.text == "") && !textEngine.background && !textEngine.border && !textEngine.__hasFocus) || ((textEngine.width <= 0 || textEngine.height <= 0) && textEngine.autoSize != TextFieldAutoSize.NONE)) {
				
				textField.__graphics.__canvas = null;
				textField.__graphics.__context = null;
				textField.__graphics.__dirty = false;
				textField.__dirty = false;
				
			} else {
				
				var bounds = textEngine.bounds;
				
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
					
					graphics.__canvas.width = Math.ceil (bounds.width);
					graphics.__canvas.height = Math.ceil (bounds.height);
					
					if (textEngine.antiAliasType != ADVANCED || textEngine.gridFitType != PIXEL) {
						
						untyped (graphics.__context).mozImageSmoothingEnabled = true;
						//untyped (graphics.__context).webkitImageSmoothingEnabled = true;
						untyped (graphics.__context).msImageSmoothingEnabled = true;
						untyped (graphics.__context).imageSmoothingEnabled = true;
						
					} else {
						
						untyped (graphics.__context).mozImageSmoothingEnabled = false;
						//untyped (graphics.__context).webkitImageSmoothingEnabled = false;
						untyped (graphics.__context).msImageSmoothingEnabled = false;
						untyped (graphics.__context).imageSmoothingEnabled = false;
						
					}
					
					if (textEngine.border || textEngine.background) {
						
						context.rect (0.5, 0.5, bounds.width - 1, bounds.height - 1);
						
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
					
					context.textBaseline = "top";
					//context.textBaseline = "alphabetic";
					context.textAlign = "start";
					
					var scrollX = -textField.scrollH;
					var scrollY = 0.0;
					
					for (i in 0...textField.scrollV - 1) {
						
						scrollY -= textEngine.lineHeights[i];
						
					}
					
					var advance;
					
					// Hack, baseline "top" is not consistent across browsers
					
					var offsetY = 0.0;
					var applyHack = ~/(iPad|iPhone|iPod|Firefox)/g.match (Browser.window.navigator.userAgent);
					
					for (group in textEngine.layoutGroups) {
						
						if (group.lineIndex < textField.scrollV - 1) continue;
						if (group.lineIndex > textField.scrollV + textEngine.bottomScrollV - 2) break;
						
						context.font = TextEngine.getFont (group.format);
						context.fillStyle = "#" + StringTools.hex (group.format.color, 6);
						
						if (applyHack) {
							
							offsetY = group.format.size * 0.185;
							
						}
						
						context.fillText (text.substring (group.startIndex, group.endIndex), group.offsetX + scrollX, group.offsetY + offsetY + scrollY);
						
						if (textField.__caretIndex > -1 && textEngine.selectable) {
							
							if (textField.__selectionIndex == textField.__caretIndex) {
								
								if (textField.__showCursor && group.startIndex <= textField.__caretIndex && group.endIndex >= textField.__caretIndex) {
									
									advance = 0.0;
									
									for (i in 0...(textField.__caretIndex - group.startIndex)) {
										
										if (group.advances.length <= i) break;
										advance += group.advances[i];
										
									}
									
									context.fillRect (group.offsetX + advance, group.offsetY, 1, group.height);
									
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
									
									context.fillStyle = "#000000";
									context.fillRect (start.x, start.y, end.x - start.x, group.height);
									context.fillStyle = "#FFFFFF";
									
									// TODO: fill only once
									
									context.fillText (text.substring (selectionStart, selectionEnd), scrollX + start.x, group.offsetY + offsetY + scrollY);
									
								}
								
							}
							
						}
						
					}
					
				} else {
					
					graphics.__canvas.width = Math.ceil (bounds.width);
					graphics.__canvas.height = Math.ceil (bounds.height);
					
					if (textEngine.border || textEngine.background) {
						
						if (textEngine.border) {
							
							context.rect (0.5, 0.5, bounds.width - 1, bounds.height - 1);
							
						} else {
							
							context.rect (0, 0, bounds.width, bounds.height);
							
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
				
				graphics.__bitmap = BitmapData.fromCanvas (textField.__graphics.__canvas);
				textField.__dirty = false;
				graphics.__dirty = false;
				
			}
			
		}
		
		#end
		
	}
	
	
}