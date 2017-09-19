package openfl._internal.renderer.canvas;


import haxe.Utf8;
import openfl._internal.renderer.RenderSession;
import openfl._internal.text.TextEngine;
import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.display.Graphics;
import openfl.events.Event;
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
		if (textField.__dirty || textField.__graphics == null || textField.__graphics.__bitmap == null) {

			var textEngine = textField.__textEngine;

			textField.__updateLayout ();

			if (!textField.__showCursor && ((textEngine.text == null || textEngine.text == "") && !textEngine.background && !textEngine.border && !textEngine.__hasFocus) || ((textEngine.width <= 0 || textEngine.height <= 0) && textEngine.autoSize != TextFieldAutoSize.NONE)) {

				textField.__graphics.__canvas = null;
				textField.__graphics.__context = null;
				textField.__graphics.dirty = false;
				if( textField.__graphics.__bitmap != null ) {
					textField.__graphics.__bitmap.dispose();
				}
				textField.__dirty = false;

			} else {

				var renderBounds = Rectangle.pool.get();
				var bounds = Rectangle.pool.get();

				var renderTransform = textField.__renderTransform;
				textField.__getBounds (bounds);
				bounds.transform (renderBounds, renderTransform);

				if (textField.__graphics == null || textField.__graphics.__canvas == null) {

					if (textField.__graphics == null) {

						textField.__graphics = new Graphics (false);

					}

					textField.__graphics.__canvas = cast Browser.document.createElement ("canvas");
					textField.__graphics.__context = textField.__graphics.__canvas.getContext ("2d");
					textField.__graphics.__bounds = new Rectangle (0, 0, bounds.width, bounds.height);

				}

				var graphics = textField.__graphics;
				var context = graphics.__context;
				graphics.__canvas.width = Math.ceil (renderBounds.width);
				graphics.__canvas.height = Math.ceil (renderBounds.height);

				var transform = Matrix.pool.get ();
				transform.copyFrom (renderTransform);
				transform.translate (- Math.ffloor(renderBounds.x), - Math.ffloor(renderBounds.y));
				context.setTransform (transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);

				if ((textEngine.text != null && textEngine.text != "") || textEngine.__hasFocus) {

					var text = textEngine.text;

					if (textEngine.displayAsPassword) {

						var length = text.length;

						text = format.swf.utils.StringUtils.repeat(length, "*");

					}

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

						context.rect (0.5, 0.5, renderBounds.width - 1, renderBounds.height - 1);

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

					context.textBaseline = "alphabetic";
					context.textAlign = "start";

					var scrollX = -textField.scrollH;
					var scrollY = 0.0;

					for (i in 0...textField.scrollV - 1) {

						scrollY -= textEngine.lineHeights[i];

					}

					var advance;

					var offsetY = 0.0;

					if (textField.__showCursor && textEngine.layoutGroups.length == 0) {
						var format = textField.__textFormat;
						var fontData = TextEngine.getFont (format);
						context.font = fontData.name;
						context.fillStyle = "#" + StringTools.hex (format.color, 6);
						var data = textEngine.calculateFontDimensions(textField.__textFormat, fontData);
						context.fillRect (2, 2, 1, data.height);
					}

					for (group in textEngine.layoutGroups) {

						if (group.lineIndex < textField.scrollV - 1) continue;
						if (group.lineIndex > textField.scrollV + textEngine.bottomScrollV - 2) break;
						var fontData = TextEngine.getFont (group.format);
						offsetY = fontData.ascent * group.format.size;
						context.font = fontData.name;
						context.fillStyle = "#" + StringTools.hex (group.format.color, 6);
						var trimmed_text = text.substring (group.startIndex, group.endIndex);
						trimmed_text = new EReg ("\n", "g").replace (trimmed_text, "");
						context.fillText (trimmed_text, group.offsetX + scrollX, group.offsetY + offsetY + scrollY);

						if (textField.__caretIndex > -1 && textEngine.selectable) {

							// No selection box, just a cursor
							if (textField.__selectionIndex == textField.__caretIndex) {

								if (textField.__showCursor && group.startIndex <= textField.__caretIndex && ( group.endIndex > textField.__caretIndex || ( group.endIndex == textEngine.text.length && textEngine.text.length == textField.__caretIndex))) {

									advance = 0.0;

									for (i in 0...(textField.__caretIndex - group.startIndex)) {

										if (group.advances.length <= i) break;
										advance += group.advances[i];

									}

									context.fillRect (group.offsetX + advance, group.offsetY, 1, group.height);

								}

							// selection box
							} else if (!((group.endIndex < Math.min(textField.__caretIndex, textField.__selectionIndex))
									|| (group.startIndex > Math.max(textField.__caretIndex, textField.__selectionIndex)))) {

								var selectionStart = Std.int (Math.min (textField.__selectionIndex, textField.__caretIndex));
								var selectionEnd = Std.int (Math.max (textField.__selectionIndex, textField.__caretIndex));

								if (group.startIndex > selectionStart) {

									selectionStart = group.startIndex;

								}

								if (group.endIndex < selectionEnd) {

									selectionEnd = group.endIndex;

								}

								var start, end;

								start = textField.getCharBoundariesInGroup (selectionStart, group);

								if (selectionEnd >= textEngine.text.length) {

									end = textField.getCharBoundariesInGroup (textEngine.text.length - 1, group);
									end.x += end.width + 2;

								} else {

									end = textField.getCharBoundariesInGroup (selectionEnd, group);

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

					if (textEngine.border || textEngine.background) {

						if (textEngine.border) {

							context.rect (0.5, 0.5, renderBounds.width - 1, renderBounds.height - 1);

						} else {

							context.rect (0, 0, renderBounds.width, renderBounds.height);

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

				var renderToLocalMatrix = Matrix.pool.get ();
				renderToLocalMatrix.copyFrom (transform);
				renderToLocalMatrix.invert ();
				graphics.__bitmap = BitmapData.fromGraphics (graphics, renderToLocalMatrix);
				textField.__dirty = false;
				graphics.dirty = false;

				Matrix.pool.put (transform);
				Matrix.pool.put (renderToLocalMatrix);
				Rectangle.pool.put(renderBounds);
				Rectangle.pool.put(bounds);

			}

		}

		#end

	}


}
