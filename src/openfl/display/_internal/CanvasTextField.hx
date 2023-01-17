package openfl.display._internal;

import openfl.text._internal.HTMLParser;
import openfl.text._internal.TextEngine;
import openfl.display.BitmapData;
import openfl.display.CanvasRenderer;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
#if (js && html5)
import js.html.CanvasRenderingContext2D;
import js.Browser;
#end

@:access(openfl.text._internal.TextEngine)
@:access(openfl.display.Graphics)
@:access(openfl.geom.Matrix)
@:access(openfl.text.TextField)
@:access(openfl.text.TextFormat)
@SuppressWarnings("checkstyle:FieldDocComment")
class CanvasTextField
{
	#if (js && html5)
	private static var context:CanvasRenderingContext2D;
	private static var clearRect:Null<Bool>;
	#end

	public static inline function render(textField:TextField, renderer:CanvasRenderer, transform:Matrix):Void
	{
		#if (js && html5)
		var textEngine = textField.__textEngine;
		// textBounds maximizes rendering efficiency by clipping the rectangle to a minimal size containing only the text. Measurements
		// will always be smaller than bounds.
		var useTextBounds = !(textEngine.background || textEngine.border);
		var bounds = useTextBounds ? textEngine.textBounds : textEngine.bounds;
		var graphics = textField.__graphics;
		var cursorOffsetX = 0.0;

		if (textField.__dirty)
		{
			textField.__updateLayout();

			if (graphics.__bounds == null)
			{
				graphics.__bounds = new Rectangle();
			}

			// There might be a better way of handling this!
			if (textField.text.length == 0)
			{
				var boundsWidth = textEngine.bounds.width - 4;
				var align = textField.defaultTextFormat.align;

				cursorOffsetX = (align == LEFT) ? 0 : (align == RIGHT) ? boundsWidth : boundsWidth / 2;

				switch (align)
				{
					case LEFT:
						cursorOffsetX += textField.defaultTextFormat.leftMargin;
						cursorOffsetX += textField.defaultTextFormat.indent;
						cursorOffsetX += textField.defaultTextFormat.blockIndent;
					case RIGHT:
						cursorOffsetX -= textField.defaultTextFormat.rightMargin;
					case CENTER:
						cursorOffsetX += (textField.defaultTextFormat.leftMargin / 2);
						cursorOffsetX -= (textField.defaultTextFormat.rightMargin / 2);
						cursorOffsetX += textField.defaultTextFormat.indent / 2;
						cursorOffsetX += textField.defaultTextFormat.blockIndent / 2;
					case START:
					// not supported?
					case JUSTIFY:
						cursorOffsetX += textField.defaultTextFormat.leftMargin;
						cursorOffsetX += textField.defaultTextFormat.indent;
						cursorOffsetX += textField.defaultTextFormat.blockIndent;
					case END:
						// not supported in Textfield yet?
				}

				if (useTextBounds)
				{
					bounds.y = textEngine.bounds.y;
					bounds.x = cursorOffsetX;
				}
			}

			graphics.__bounds.copyFrom(bounds);
		}

		#if (openfl_disable_hdpi || openfl_disable_hdpi_textfield)
		var pixelRatio = 1;
		#else
		var pixelRatio = renderer.__pixelRatio;
		#end

		graphics.__update(renderer.__worldTransform, pixelRatio);

		if (textField.__dirty || graphics.__softwareDirty)
		{
			var width = Math.round(graphics.__width * pixelRatio);
			var height = Math.round(graphics.__height * pixelRatio);

			if (((textEngine.text == null || textEngine.text == "")
				&& !textEngine.background
				&& !textEngine.border
				&& !textEngine.__hasFocus
				&& (textEngine.type != INPUT || !textEngine.selectable))
				|| ((textEngine.width <= 0 || textEngine.height <= 0) && textEngine.autoSize != TextFieldAutoSize.NONE))
			{
				textField.__graphics.__canvas = null;
				textField.__graphics.__context = null;
				textField.__graphics.__bitmap = null;
				textField.__graphics.__softwareDirty = false;
				textField.__graphics.__dirty = false;
				textField.__dirty = false;
			}
			else
			{
				if (textField.__graphics.__canvas == null)
				{
					textField.__graphics.__canvas = cast Browser.document.createElement("canvas");
					textField.__graphics.__context = textField.__graphics.__canvas.getContext("2d");
				}

				context = graphics.__context;

				graphics.__canvas.width = width;
				graphics.__canvas.height = height;

				if (renderer.__isDOM)
				{
					graphics.__canvas.style.width = Math.round(width / pixelRatio) + "px";
					graphics.__canvas.style.height = Math.round(height / pixelRatio) + "px";
				}

				var matrix = Matrix.__pool.get();
				matrix.scale(pixelRatio, pixelRatio);
				matrix.concat(graphics.__renderTransform);

				context.setTransform(matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx, matrix.ty);

				Matrix.__pool.release(matrix);

				if (clearRect == null)
				{
					clearRect = untyped #if haxe4 js.Syntax.code #else __js__ #end ("(typeof navigator !== 'undefined' && typeof navigator['isCocoonJS'] !== 'undefined')");
				}

				if (clearRect)
				{
					context.clearRect(0, 0, graphics.__canvas.width, graphics.__canvas.height);
				}

				if ((textEngine.text != null && textEngine.text != "") || textEngine.__hasFocus)
				{
					var text = textEngine.text;

					if (!renderer.__allowSmoothing || (textEngine.antiAliasType == ADVANCED && textEngine.sharpness == 400))
					{
						graphics.__context.imageSmoothingEnabled = false;
					}
					else
					{
						graphics.__context.imageSmoothingEnabled = true;
					}

					if (textEngine.border || textEngine.background)
					{
						context.rect(0.5, 0.5, bounds.width - 1, bounds.height - 1);

						if (textEngine.background)
						{
							context.fillStyle = "#" + StringTools.hex(textEngine.backgroundColor & 0xFFFFFF, 6);
							context.fill();
						}

						if (textEngine.border)
						{
							context.lineWidth = 1;
							context.strokeStyle = "#" + StringTools.hex(textEngine.borderColor & 0xFFFFFF, 6);
							context.stroke();
						}
					}

					context.textBaseline = "alphabetic";
					context.textAlign = "start";

					var scrollX = -textField.scrollH;
					var scrollY = 0.0;

					for (i in 0...textField.scrollV - 1)
					{
						scrollY -= textEngine.lineHeights[i];
					}

					var advance;

					for (group in textEngine.layoutGroups)
					{
						if (group.lineIndex < textField.scrollV - 1) continue;
						if (group.lineIndex > textEngine.bottomScrollV - 1) break;

						var color = "#" + StringTools.hex(group.format.color & 0xFFFFFF, 6);

						context.font = TextEngine.getFont(group.format);
						context.fillStyle = color;

						context.fillText(text.substring(group.startIndex, group.endIndex), group.offsetX
							+ scrollX
							- bounds.x,
							group.offsetY
							+ group.ascent
							+ scrollY
							- bounds.y);

						if (textField.__caretIndex > -1 && textEngine.selectable)
						{
							if (textField.__selectionIndex == textField.__caretIndex)
							{
								if (textField.__showCursor
									&& group.startIndex <= textField.__caretIndex
									&& group.endIndex >= textField.__caretIndex)
								{
									advance = 0.0;

									for (i in 0...(textField.__caretIndex - group.startIndex))
									{
										if (group.positions.length <= i) break;
										advance += group.getAdvance(i);
									}

									var scrollY = 0.0;

									for (i in textField.scrollV...(group.lineIndex + 1))
									{
										scrollY += textEngine.lineHeights[i - 1];
									}

									context.beginPath();
									context.strokeStyle = "#" + StringTools.hex(group.format.color & 0xFFFFFF, 6);
									context.moveTo(group.offsetX + advance - textField.scrollH - bounds.x, scrollY + 2 - bounds.y);
									context.lineWidth = 1;
									context.lineTo(group.offsetX
										+ advance
										- textField.scrollH
										- bounds.x,
										scrollY
										+ TextEngine.getFormatHeight(textField.defaultTextFormat)
										- 1
										- bounds.y);
									context.stroke();
									context.closePath();

									// context.fillRect (group.offsetX + advance - textField.scrollH, scrollY + 2, 1, TextEngine.getFormatHeight (textField.defaultTextFormat) - 1);
								}
							}
							else if ((group.startIndex <= textField.__caretIndex && group.endIndex >= textField.__caretIndex)
								|| (group.startIndex <= textField.__selectionIndex && group.endIndex >= textField.__selectionIndex)
								|| (group.startIndex > textField.__caretIndex && group.endIndex < textField.__selectionIndex)
								|| (group.startIndex > textField.__selectionIndex && group.endIndex < textField.__caretIndex))
							{
								var selectionStart = Std.int(Math.min(textField.__selectionIndex, textField.__caretIndex));
								var selectionEnd = Std.int(Math.max(textField.__selectionIndex, textField.__caretIndex));

								if (group.startIndex > selectionStart)
								{
									selectionStart = group.startIndex;
								}

								if (group.endIndex < selectionEnd)
								{
									selectionEnd = group.endIndex;
								}

								var start, end;

								start = textField.getCharBoundaries(selectionStart);

								if (selectionEnd >= group.endIndex)
								{
									end = textField.getCharBoundaries(group.endIndex - 1);

									if (end != null)
									{
										end.x += end.width + 2;
									}
								}
								else
								{
									end = textField.getCharBoundaries(selectionEnd);
								}

								if (start != null && end != null)
								{
									context.fillStyle = "#000000";
									context.fillRect(start.x + scrollX - bounds.x, start.y + scrollY, end.x - start.x, group.height);
									context.fillStyle = "#FFFFFF";

									// TODO: fill only once

									context.fillText(text.substring(selectionStart, selectionEnd), scrollX + start.x - bounds.x,
										group.offsetY + group.ascent + scrollY);
								}
							}
						}

						if (group.format.underline)
						{
							context.beginPath();
							context.strokeStyle = color;
							context.lineWidth = 1;
							var descent = Math.floor(group.ascent * 0.185);
							var x = group.offsetX + scrollX - bounds.x;
							var y = Math.ceil(group.offsetY + scrollY + group.ascent - bounds.y) + descent + 0.5;
							context.moveTo(x, y);
							context.lineTo(x + group.width, y);
							context.stroke();
							context.closePath();
						}
					}
				}
				else
				{
					if (textEngine.border || textEngine.background)
					{
						if (textEngine.border)
						{
							context.rect(0.5, 0.5, bounds.width - 1, bounds.height - 1);
						}
						else
						{
							context.rect(0, 0, bounds.width, bounds.height);
						}

						if (textEngine.background)
						{
							context.fillStyle = "#" + StringTools.hex(textEngine.backgroundColor & 0xFFFFFF, 6);
							context.fill();
						}

						if (textEngine.border)
						{
							context.lineWidth = 1;
							context.lineCap = "square";
							context.strokeStyle = "#" + StringTools.hex(textEngine.borderColor & 0xFFFFFF, 6);
							context.stroke();
						}
					}

					if (textField.__caretIndex > -1 && textEngine.selectable && textField.__showCursor)
					{
						var scrollX = -textField.scrollH + (useTextBounds ? 0 : cursorOffsetX);
						var scrollY = 0.0;

						for (i in 0...textField.scrollV - 1)
						{
							scrollY += textEngine.lineHeights[i];
						}

						context.beginPath();
						context.strokeStyle = "#" + StringTools.hex(textField.defaultTextFormat.color & 0xFFFFFF, 6);
						context.moveTo(scrollX + 2.5, scrollY + 2.5);
						context.lineWidth = 1;
						context.lineTo(scrollX + 2.5, scrollY + TextEngine.getFormatHeight(textField.defaultTextFormat) - 1);
						context.stroke();
						context.closePath();
					}
				}

				graphics.__bitmap = BitmapData.fromCanvas(textField.__graphics.__canvas);
				graphics.__bitmapScale = pixelRatio;
				graphics.__visible = true;
				textField.__dirty = false;
				graphics.__softwareDirty = false;
				graphics.__dirty = false;
			}
		}
		#end
	}

	public static function renderDrawable(textField:TextField, renderer:CanvasRenderer):Void
	{
		#if (js && html5)
		// TODO: Better DOM workaround on cacheAsBitmap

		if (renderer.__isDOM && !textField.__renderedOnCanvasWhileOnDOM)
		{
			textField.__renderedOnCanvasWhileOnDOM = true;

			if (textField.type == TextFieldType.INPUT)
			{
				textField.replaceText(0, textField.__text.length, textField.__text);
			}

			if (textField.__isHTML)
			{
				textField.__updateText(HTMLParser.parse(textField.__text, textField.multiline, textField.__styleSheet, textField.__textFormat,
					textField.__textEngine.textFormatRanges));
			}

			textField.__dirty = true;
			textField.__layoutDirty = true;
			textField.__setRenderDirty();
		}

		if (textField.mask == null || (textField.mask.width > 0 && textField.mask.height > 0))
		{
			renderer.__updateCacheBitmap(textField, textField.__dirty);

			if (textField.__cacheBitmap != null && !textField.__isCacheBitmapRender)
			{
				CanvasBitmap.render(textField.__cacheBitmap, renderer);
			}
			else
			{
				CanvasTextField.render(textField, renderer, textField.__worldTransform);

				var smoothingEnabled = false;

				if (textField.__textEngine.antiAliasType == ADVANCED && textField.__textEngine.gridFitType == PIXEL)
				{
					smoothingEnabled = renderer.context.imageSmoothingEnabled;

					if (smoothingEnabled)
					{
						renderer.context.imageSmoothingEnabled = false;
					}
				}

				CanvasDisplayObject.render(textField, renderer);

				if (smoothingEnabled)
				{
					renderer.context.imageSmoothingEnabled = true;
				}
			}
		}
		#end
	}

	public static function renderDrawableMask(textField:TextField, renderer:CanvasRenderer):Void
	{
		CanvasDisplayObject.renderDrawableMask(textField, renderer);
	}
}
