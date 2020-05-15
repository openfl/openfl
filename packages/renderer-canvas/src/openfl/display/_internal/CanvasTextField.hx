package openfl.display._internal;

#if openfl_html5
import js.html.CanvasRenderingContext2D;
import js.Browser;
import openfl.text._internal.TextEngine;
import openfl.display._CanvasRenderer;
import openfl.display.BitmapData;
import openfl.display._Graphics;
import openfl.geom.Matrix;
import openfl.geom._Matrix;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.text._TextField;
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
		var textEngine = (textField._ : _TextField).__textEngine;
		var bounds = (textEngine.background || textEngine.border) ? textEngine.bounds : textEngine.textBounds;
		var graphics = (textField._ : _TextField).__graphics;

		if ((textField._ : _TextField).__dirty)
		{
			(textField._ : _TextField).__updateLayout();

			if ((graphics._ : _Graphics).__bounds == null)
			{
				(graphics._ : _Graphics).__bounds = new Rectangle();
			}

				(graphics._ : _Graphics).__bounds.copyFrom(bounds);
		}

			(graphics._ : _Graphics).__update((renderer._ : _CanvasRenderer).__worldTransform);

		if ((textField._ : _TextField).__dirty || (graphics._ : _Graphics).__softwareDirty)
		{
			var width = (graphics._ : _Graphics).__width;
			var height = (graphics._ : _Graphics).__height;

			if (((textEngine.text == null || textEngine.text == "")
				&& !textEngine.background
				&& !textEngine.border
				&& !textEngine.__hasFocus
				&& (textEngine.type != INPUT || !textEngine.selectable))
				|| ((textEngine.width <= 0 || textEngine.height <= 0) && textEngine.autoSize != TextFieldAutoSize.NONE))
			{
				((textField._ : _TextField).__graphics._ : _Graphics).__renderData.canvas = null;
				((textField._ : _TextField).__graphics._ : _Graphics).__renderData.context = null;
				((textField._ : _TextField).__graphics._ : _Graphics).__bitmap = null;
				((textField._ : _TextField).__graphics._ : _Graphics).__softwareDirty = false;
				((textField._ : _TextField).__graphics._ : _Graphics).__dirty = false;
				(textField._ : _TextField).__dirty = false;
			}
			else
			{
				if (((textField._ : _TextField).__graphics._ : _Graphics).__renderData.canvas == null)
				{
					((textField._ : _TextField).__graphics._ : _Graphics).__renderData.canvas = cast Browser.document.createElement("canvas");
					((textField._ : _TextField).__graphics._ : _Graphics).__renderData.context = ((textField._ : _TextField).__graphics._ : _Graphics)
						.__renderData.canvas.getContext("2d");
				}

				context = (graphics._ : _Graphics).__renderData.context;

				var transform = (graphics._ : _Graphics).__renderTransform;

				if ((renderer._ : _CanvasRenderer).__domRenderer != null)
				{
					var scale = renderer.pixelRatio;

					(graphics._ : _Graphics).__renderData.canvas.width = Std.int(width * scale);
					(graphics._ : _Graphics).__renderData.canvas.height = Std.int(height * scale);
					(graphics._ : _Graphics).__renderData.canvas.style.width = width + "px";
					(graphics._ : _Graphics).__renderData.canvas.style.height = height + "px";

					var matrix = _Matrix.__pool.get();
					matrix.copyFrom(transform);
					matrix.scale(scale, scale);

					renderer.setTransform(matrix, context);

					_Matrix.__pool.release(matrix);
				}
				else
				{
					(graphics._ : _Graphics).__renderData.canvas.width = width;
					(graphics._ : _Graphics).__renderData.canvas.height = height;

					context.setTransform(transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
				}

				if (clearRect == null)
				{
					clearRect = untyped __js__("(typeof navigator !== 'undefined' && typeof navigator['isCocoonJS'] !== 'undefined')");
				}

				if (clearRect)
				{
					context.clearRect(0, 0, (graphics._ : _Graphics).__renderData.canvas.width, (graphics._ : _Graphics).__renderData.canvas.height);
				}

				if ((textEngine.text != null && textEngine.text != "") || textEngine.__hasFocus)
				{
					var text = textEngine.text;

					if (!(renderer._ : _CanvasRenderer).__allowSmoothing
						|| (textEngine.antiAliasType == ADVANCED && textEngine.sharpness == 400))
					{
						(graphics._ : _Graphics).__renderData.context.imageSmoothingEnabled = false;
					}
					else
					{
						(graphics._ : _Graphics).__renderData.context.imageSmoothingEnabled = true;
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

						if ((textField._ : _TextField).__caretIndex > -1 && textEngine.selectable)
						{
							if ((textField._ : _TextField).__selectionIndex == (textField._ : _TextField).__caretIndex)
							{
								if ((textField._ : _TextField).__showCursor
									&& group.startIndex <= (textField._ : _TextField).__caretIndex
										&& group.endIndex >= (textField._ : _TextField).__caretIndex)
								{
									advance = 0.0;

									for (i in 0...((textField._ : _TextField).__caretIndex - group.startIndex))
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
							else if ((group.startIndex <= (textField._ : _TextField).__caretIndex
								&& group.endIndex >= (textField._ : _TextField).__caretIndex)
								|| (group.startIndex <= (textField._ : _TextField).__selectionIndex
									&& group.endIndex >= (textField._ : _TextField).__selectionIndex)
								|| (group.startIndex > (textField._ : _TextField).__caretIndex
									&& group.endIndex < (textField._:_TextField).__selectionIndex)
								|| (group.startIndex > (textField._ : _TextField).__selectionIndex
									&& group.endIndex < (textField._:_TextField).__caretIndex))
							{
								var selectionStart = Std.int(Math.min((textField._ : _TextField).__selectionIndex, (textField._ : _TextField).__caretIndex));
								var selectionEnd = Std.int(Math.max((textField._ : _TextField).__selectionIndex, (textField._ : _TextField).__caretIndex));

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

					if ((textField._ : _TextField).__caretIndex > -1 && textEngine.selectable && (textField._ : _TextField).__showCursor)
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

					(graphics._ : _Graphics).__bitmap = BitmapData.fromCanvas(((textField._ : _TextField).__graphics._ : _Graphics).__renderData.canvas);
				(graphics._ : _Graphics).__visible = true;
				(textField._ : _TextField).__dirty = false;
				(graphics._ : _Graphics).__softwareDirty = false;
				(graphics._ : _Graphics).__dirty = false;
			}
		}
		#end
	}
}
#end
