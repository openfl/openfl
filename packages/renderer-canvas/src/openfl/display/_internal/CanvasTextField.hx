package openfl.display._internal;

#if openfl_html5
import js.html.CanvasRenderingContext2D;
import js.Browser;
import openfl.text._internal.TextEngine;
import openfl.display.BitmapData;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;

@:access(openfl.text._internal.TextEngine)
@:access(openfl.display._internal)
@:access(openfl.display.Graphics)
@:access(openfl.geom.Matrix)
@:access(openfl.text.TextField)
@:access(openfl.text.TextFormat)
@SuppressWarnings("checkstyle:FieldDocComment")
class CanvasTextField
{
	#if openfl_html5
	public static var context:CanvasRenderingContext2D;
	public static var clearRect:Null<Bool>;
	#end

	public static inline function render(textField:TextField, renderer:CanvasRenderer, transform:Matrix):Void
	{
		#if openfl_html5
		var textEngine = textField._.__textEngine;
		var bounds = (textEngine.background || textEngine.border) ? textEngine.bounds : textEngine.textBounds;
		var graphics = textField._.__graphics;

		if (textField._.__dirty)
		{
			textField._.__updateLayout();

			if (graphics._.__bounds == null)
			{
				graphics._.__bounds = new Rectangle();
			}

			graphics._.__bounds.copyFrom(bounds);
		}

		graphics._.__update(renderer._.__worldTransform);

		if (textField._.__dirty || graphics._.__softwareDirty)
		{
			var width = graphics._.__width;
			var height = graphics._.__height;

			if (((textEngine.text == null || textEngine.text == "")
				&& !textEngine.background
				&& !textEngine.border
				&& !textEngine._.__hasFocus
				&& (textEngine.type != INPUT || !textEngine.selectable))
				|| ((textEngine.width <= 0 || textEngine.height <= 0) && textEngine.autoSize != TextFieldAutoSize.NONE))
			{
				textField._.__graphics._.__renderData.canvas = null;
				textField._.__graphics._.__renderData.context = null;
				textField._.__graphics._.__bitmap = null;
				textField._.__graphics._.__softwareDirty = false;
				textField._.__graphics._.__dirty = false;
				textField._.__dirty = false;
			}
			else
			{
				if (textField._.__graphics._.__renderData.canvas == null)
				{
					textField._.__graphics._.__renderData.canvas = cast Browser.document.createElement("canvas");
					textField._.__graphics._.__renderData.context = textField._.__graphics._.__renderData.canvas.getContext("2d");
				}

				context = graphics._.__renderData.context;

				var transform = graphics._.__renderTransform;

				if (renderer._.__domRenderer != null)
				{
					var scale = renderer.pixelRatio;

					graphics._.__renderData.canvas.width = Std.int(width * scale);
					graphics._.__renderData.canvas.height = Std.int(height * scale);
					graphics._.__renderData.canvas.style.width = width + "px";
					graphics._.__renderData.canvas.style.height = height + "px";

					var matrix = _Matrix.__pool.get();
					matrix.copyFrom(transform);
					matrix.scale(scale, scale);

					renderer.setTransform(matrix, context);

					_Matrix.__pool.release(matrix);
				}
				else
				{
					graphics._.__renderData.canvas.width = width;
					graphics._.__renderData.canvas.height = height;

					context.setTransform(transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
				}

				if (clearRect == null)
				{
					clearRect = untyped __js__("(typeof navigator !== 'undefined' && typeof navigator['isCocoonJS'] !== 'undefined')");
				}

				if (clearRect)
				{
					context.clearRect(0, 0, graphics._.__renderData.canvas.width, graphics._.__renderData.canvas.height);
				}

				if ((textEngine.text != null && textEngine.text != "") || textEngine._.__hasFocus)
				{
					var text = textEngine.text;

					if (!renderer._.__allowSmoothing || (textEngine.antiAliasType == ADVANCED && textEngine.sharpness == 400))
					{
						graphics._.__renderData.context.imageSmoothingEnabled = false;
					}
					else
					{
						graphics._.__renderData.context.imageSmoothingEnabled = true;
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

						if (textField._.__caretIndex > -1 && textEngine.selectable)
						{
							if (textField._.__selectionIndex == textField._.__caretIndex)
							{
								if (textField._.__showCursor
									&& group.startIndex <= textField._.__caretIndex
									&& group.endIndex >= textField._.__caretIndex)
								{
									advance = 0.0;

									for (i in 0...(textField._.__caretIndex - group.startIndex))
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
							else if ((group.startIndex <= textField._.__caretIndex && group.endIndex >= textField._.__caretIndex)
								|| (group.startIndex <= textField._.__selectionIndex && group.endIndex >= textField._.__selectionIndex)
								|| (group.startIndex > textField._.__caretIndex && group.endIndex < textField._.__selectionIndex)
								|| (group.startIndex > textField._.__selectionIndex && group.endIndex < textField._.__caretIndex))
							{
								var selectionStart = Std.int(Math.min(textField._.__selectionIndex, textField._.__caretIndex));
								var selectionEnd = Std.int(Math.max(textField._.__selectionIndex, textField._.__caretIndex));

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
									context.fillRect(start.x + scrollX, start.y + scrollY, end.x - start.x, group.height);
									context.fillStyle = "#FFFFFF";

									// TODO: fill only once

									context.fillText(text.substring(selectionStart, selectionEnd), scrollX + start.x, group.offsetY + group.ascent + scrollY);
								}
							}
						}

						if (group.format.underline)
						{
							context.beginPath();
							context.strokeStyle = color;
							context.lineWidth = 1;
							var x = group.offsetX + scrollX - bounds.x;
							var y = Math.floor(group.offsetY + scrollY + group.ascent - bounds.y) + 0.5;
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

					if (textField._.__caretIndex > -1 && textEngine.selectable && textField._.__showCursor)
					{
						var scrollX = -textField.scrollH;
						var scrollY = 0.0;

						for (i in 0...textField.scrollV - 1)
						{
							scrollY += textEngine.lineHeights[i];
						}

						var offsetX = switch (textField.defaultTextFormat.align)
						{
							case CENTER: (textField.width - 4) / 2;
							case RIGHT: (textField.width - 4);
							default: 0;
						}

						context.beginPath();
						context.strokeStyle = "#" + StringTools.hex(textField.defaultTextFormat.color & 0xFFFFFF, 6);
						context.moveTo(scrollX + offsetX + 2.5, scrollY + 2.5);
						context.lineWidth = 1;
						context.lineTo(scrollX + offsetX + 2.5, scrollY + TextEngine.getFormatHeight(textField.defaultTextFormat) - 1);
						context.stroke();
						context.closePath();
					}
				}

				graphics._.__bitmap = BitmapData.fromCanvas(textField._.__graphics._.__renderData.canvas);
				graphics._.__visible = true;
				textField._.__dirty = false;
				graphics._.__softwareDirty = false;
				graphics._.__dirty = false;
			}
		}
		#end
	}
}
#end
