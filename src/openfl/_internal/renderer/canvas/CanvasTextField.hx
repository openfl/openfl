package openfl._internal.renderer.canvas;


import haxe.Utf8;
import openfl._internal.renderer.dom.DOMTextField;
import openfl._internal.renderer.RenderSession;
import openfl._internal.text.TextEngine;
import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.display.Graphics;
import openfl.events.Event;
import openfl.filters.GlowFilter;
import openfl.geom.Matrix;
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
	private static var clearRect:Null<Bool>;
	#end
	
	
	public static inline function render (textField:TextField, renderSession:RenderSession, transform:Matrix):Void {
		
		#if (js && html5)
		
		var textEngine = textField.__textEngine;
		var bounds = textEngine.bounds;
		var graphics = textField.__graphics;
		
		if (textField.__dirty) {
			
			textField.__updateLayout ();
			
			if (graphics.__bounds == null) {
				
				graphics.__bounds = new Rectangle ();
				
			}
			
			graphics.__bounds.copyFrom (bounds);
			
		}
		
		graphics.__update ();
		
		if (textField.__dirty || graphics.__dirty) {
			
			var width = graphics.__width;
			var height = graphics.__height;
			
			if (((textEngine.text == null || textEngine.text == "") && !textEngine.background && !textEngine.border && !textEngine.__hasFocus && (textEngine.type != INPUT || !textEngine.selectable)) || ((textEngine.width <= 0 || textEngine.height <= 0) && textEngine.autoSize != TextFieldAutoSize.NONE)) {
				
				textField.__graphics.__canvas = null;
				textField.__graphics.__context = null;
				textField.__graphics.__bitmap = null;
				textField.__graphics.__dirty = false;
				textField.__dirty = false;
				
			} else {
				
				if (textField.__graphics.__canvas == null) {
					
					textField.__graphics.__canvas = cast Browser.document.createElement ("canvas");
					textField.__graphics.__context = textField.__graphics.__canvas.getContext ("2d");
					
				}
				
				context = graphics.__context;
				
				var transform = graphics.__renderTransform;
				
				if (renderSession.renderType == DOM) {
					
					var scale = CanvasRenderer.scale;
					
					graphics.__canvas.width = Std.int (width * scale);
					graphics.__canvas.height = Std.int (height * scale);
					graphics.__canvas.style.width = width + "px";
					graphics.__canvas.style.height = height + "px";
					
					context.setTransform (transform.a * scale, transform.b * scale, transform.c * scale, transform.d * scale, transform.tx * scale, transform.ty * scale);
					
				} else {
					
					graphics.__canvas.width = width;
					graphics.__canvas.height = height;
					
					context.setTransform (transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
					
				}
				
				if (clearRect == null) {
					
					clearRect = untyped __js__ ("(typeof navigator !== 'undefined' && typeof navigator['isCocoonJS'] !== 'undefined')");
					
				}
				
				if (clearRect) {
					
					context.clearRect (0, 0, graphics.__canvas.width, graphics.__canvas.height);
					
				}
				
				if ((textEngine.text != null && textEngine.text != "") || textEngine.__hasFocus) {
					
					var text = textEngine.text;
					
					if (!renderSession.allowSmoothing || (textEngine.antiAliasType == ADVANCED && textEngine.sharpness == 400)) {
						
						untyped (graphics.__context).mozImageSmoothingEnabled = false;
						//untyped (graphics.__context).webkitImageSmoothingEnabled = false;
						untyped (graphics.__context).msImageSmoothingEnabled = false;
						untyped (graphics.__context).imageSmoothingEnabled = false;
						
					} else {
						
						untyped (graphics.__context).mozImageSmoothingEnabled = true;
						//untyped (graphics.__context).webkitImageSmoothingEnabled = true;
						untyped (graphics.__context).msImageSmoothingEnabled = true;
						untyped (graphics.__context).imageSmoothingEnabled = true;
						
					}
					
					if (textEngine.border || textEngine.background) {
						
						context.rect (0.5, 0.5, bounds.width - 1, bounds.height - 1);
						
						if (textEngine.background) {
							
							context.fillStyle = "#" + StringTools.hex (textEngine.backgroundColor & 0xFFFFFF, 6);
							context.fill ();
							
						}
						
						if (textEngine.border) {
							
							context.lineWidth = 1;
							context.strokeStyle = "#" + StringTools.hex (textEngine.borderColor & 0xFFFFFF, 6);
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
						
						if (group.format.underline) {
							
							context.beginPath ();
							context.strokeStyle = "#000000";
							context.lineWidth = .5;
							var x = group.offsetX + scrollX;
							var y = group.offsetY + offsetY + scrollY + group.ascent;
							context.moveTo (x, y);
							context.lineTo (x + group.width, y);
							context.stroke ();
							
						}
						
						context.font = TextEngine.getFont (group.format);
						context.fillStyle = "#" + StringTools.hex (group.format.color & 0xFFFFFF, 6);
						
						if (applyHack) {
							
							offsetY = group.format.size * 0.185;
							
						}
						
						if (textField.__filters != null && textField.__filters.length > 0) {
							
							// Hack, force outline
							
							if (Std.is (textField.__filters[0], GlowFilter)) {
								
								var glowFilter:GlowFilter = cast textField.__filters[0];
								
								var cacheAlpha = context.globalAlpha;
								context.globalAlpha = cacheAlpha * glowFilter.alpha;
								
								context.strokeStyle = "#" + StringTools.hex (glowFilter.color & 0xFFFFFF, 6);
								context.lineWidth = Math.max (glowFilter.blurX, glowFilter.blurY);
								context.strokeText (text.substring (group.startIndex, group.endIndex), group.offsetX + scrollX, group.offsetY + offsetY + scrollY);
								
								context.strokeStyle = null;
								context.globalAlpha = cacheAlpha;
								
							}
							
						}
						
						context.fillText (text.substring (group.startIndex, group.endIndex), group.offsetX + scrollX, group.offsetY + offsetY + scrollY);
						
						if (textField.__caretIndex > -1 && textEngine.selectable) {
							
							if (textField.__selectionIndex == textField.__caretIndex) {
								
								if (textField.__showCursor && group.startIndex <= textField.__caretIndex && group.endIndex >= textField.__caretIndex) {
									
									advance = 0.0;
									
									for (i in 0...(textField.__caretIndex - group.startIndex)) {
										
										if (group.positions.length <= i) break;
										advance += group.getAdvance (i);
										
									}
									
									var scrollY = 0.0;
									
									for (i in textField.scrollV...(group.lineIndex + 1)) {
										
										scrollY += textEngine.lineHeights[i - 1];
										
									}
									
									context.beginPath ();
									context.strokeStyle = "#" + StringTools.hex (group.format.color & 0xFFFFFF, 6);
									context.moveTo (group.offsetX + advance - textField.scrollH, scrollY + 2);
									context.lineWidth = 1;
									context.lineTo (group.offsetX + advance - textField.scrollH, scrollY + TextEngine.getFormatHeight (textField.defaultTextFormat) - 1);
									context.stroke ();
									context.closePath ();
									
									// context.fillRect (group.offsetX + advance - textField.scrollH, scrollY + 2, 1, TextEngine.getFormatHeight (textField.defaultTextFormat) - 1);
									
								}
								
							} else if ((group.startIndex <= textField.__caretIndex && group.endIndex >= textField.__caretIndex) || (group.startIndex <= textField.__selectionIndex && group.endIndex >= textField.__selectionIndex) || (group.startIndex > textField.__caretIndex && group.endIndex < textField.__selectionIndex) || (group.startIndex > textField.__selectionIndex && group.endIndex < textField.__caretIndex)) {
								
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
									context.fillRect (start.x + scrollX, start.y + scrollY, end.x - start.x, group.height);
									context.fillStyle = "#FFFFFF";
									
									// TODO: fill only once
									
									context.fillText (text.substring (selectionStart, selectionEnd), scrollX + start.x, group.offsetY + offsetY + scrollY);
									
								}
								
							}
							
						}
						
					}
					
				} else {
					
					if (textEngine.border || textEngine.background) {
						
						if (textEngine.border) {
							
							context.rect (0.5, 0.5, bounds.width - 1, bounds.height - 1);
							
						} else {
							
							context.rect (0, 0, bounds.width, bounds.height);
							
						}
						
						if (textEngine.background) {
							
							context.fillStyle = "#" + StringTools.hex (textEngine.backgroundColor & 0xFFFFFF, 6);
							context.fill ();
							
						}
						
						if (textEngine.border) {
							
							context.lineWidth = 1;
							context.lineCap = "square";
							context.strokeStyle = "#" + StringTools.hex (textEngine.borderColor & 0xFFFFFF, 6);
							context.stroke ();
							
						}
						
					}
					
					if (textField.__caretIndex > -1 && textEngine.selectable && textField.__showCursor) {
						
						var scrollX = -textField.scrollH;
						var scrollY = 0.0;
						
						for (i in 0...textField.scrollV - 1) {
							
							scrollY += textEngine.lineHeights[i];
							
						}
						
						context.beginPath ();
						context.strokeStyle = "#" + StringTools.hex (textField.defaultTextFormat.color & 0xFFFFFF, 6);
						context.moveTo (scrollX + 2.5, scrollY + 2.5);
						context.lineWidth = 1;
						context.lineTo (scrollX + 2.5, scrollY + TextEngine.getFormatHeight (textField.defaultTextFormat) - 1);
						context.stroke ();
						context.closePath ();
						
					}
					
				}
				
				graphics.__bitmap = BitmapData.fromCanvas (textField.__graphics.__canvas);
				graphics.__visible = true;
				textField.__dirty = false;
				graphics.__dirty = false;
				
			}
			
		}
		
		#end
		
	}
	
	
}