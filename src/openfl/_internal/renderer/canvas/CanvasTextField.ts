import * as internal from "../../../_internal/utils/InternalAccess";
import BitmapData from "../../../display/BitmapData";
import Matrix from "../../../geom/Matrix";
import Rectangle from "../../../geom/Rectangle";
import AntiAliasType from "../../../text/AntiAliasType";
import TextField from "../../../text/TextField";
import TextFieldAutoSize from "../../../text/TextFieldAutoSize";
import TextFieldType from "../../../text/TextFieldType";
import TextFormatAlign from "../../../text/TextFormatAlign";
import TextEngine from "../../text/TextEngine";
import CanvasRenderer from "./CanvasRenderer";

export default class CanvasTextField
{
	private static context: CanvasRenderingContext2D;
	private static clearRect: null | boolean;

	public static render(textField: TextField, renderer: CanvasRenderer, transform: Matrix): void
	{
		var textEngine = (<internal.TextField><any>textField).__textEngine;
		var bounds = (textEngine.background || textEngine.border) ? textEngine.bounds : textEngine.textBounds;
		var graphics = (<internal.DisplayObject><any>textField).__graphics;

		if ((<internal.TextField><any>textField).__dirty)
		{
			(<internal.TextField><any>textField).__updateLayout();

			if ((<internal.Graphics><any>graphics).__bounds == null)
			{
				(<internal.Graphics><any>graphics).__bounds = new Rectangle();
			}

			(<internal.Graphics><any>graphics).__bounds.copyFrom(bounds);
		}

		(<internal.Graphics><any>graphics).__update((<internal.DisplayObjectRenderer><any>renderer).__worldTransform);

		if ((<internal.TextField><any>textField).__dirty || (<internal.Graphics><any>graphics).__softwareDirty)
		{
			var width = (<internal.Graphics><any>graphics).__width;
			var height = (<internal.Graphics><any>graphics).__height;

			if (((textEngine.text == null || textEngine.text == "")
				&& !textEngine.background
				&& !textEngine.border
				&& !textEngine.__hasFocus
				&& (textEngine.type != TextFieldType.INPUT || !textEngine.selectable))
				|| ((textEngine.width <= 0 || textEngine.height <= 0) && textEngine.autoSize != TextFieldAutoSize.NONE))
			{
				(<internal.Graphics><any>(<internal.DisplayObject><any>textField).__graphics).__renderData.canvas = null;
				(<internal.Graphics><any>(<internal.DisplayObject><any>textField).__graphics).__renderData.context = null;
				(<internal.Graphics><any>(<internal.DisplayObject><any>textField).__graphics).__bitmap = null;
				(<internal.Graphics><any>(<internal.DisplayObject><any>textField).__graphics).__softwareDirty = false;
				(<internal.Graphics><any>(<internal.DisplayObject><any>textField).__graphics).__dirty = false;
				(<internal.TextField><any>textField).__dirty = false;
			}
			else
			{
				if ((<internal.Graphics><any>(<internal.DisplayObject><any>textField).__graphics).__renderData.canvas == null)
				{
					(<internal.Graphics><any>(<internal.DisplayObject><any>textField).__graphics).__renderData.canvas = document.createElement("canvas");
					(<internal.Graphics><any>(<internal.DisplayObject><any>textField).__graphics).__renderData.context = (<internal.Graphics><any>(<internal.DisplayObject><any>textField).__graphics).__renderData.canvas.getContext("2d");
				}

				this.context = (<internal.Graphics><any>graphics).__renderData.context;

				var transform = (<internal.Graphics><any>graphics).__renderTransform;

				if (renderer.__domRenderer != null)
				{
					var scale = renderer.pixelRatio;

					(<internal.Graphics><any>graphics).__renderData.canvas.width = Math.round(width * scale);
					(<internal.Graphics><any>graphics).__renderData.canvas.height = Math.round(height * scale);
					(<internal.Graphics><any>graphics).__renderData.canvas.style.width = width + "px";
					(<internal.Graphics><any>graphics).__renderData.canvas.style.height = height + "px";

					var matrix = (<internal.Matrix><any>Matrix).__pool.get();
					matrix.copyFrom(transform);
					matrix.scale(scale, scale);

					renderer.setTransform(matrix, this.context);

					(<internal.Matrix><any>Matrix).__pool.release(matrix);
				}
				else
				{
					(<internal.Graphics><any>graphics).__renderData.canvas.width = width;
					(<internal.Graphics><any>graphics).__renderData.canvas.height = height;

					this.context.setTransform(transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
				}

				if (this.clearRect == null)
				{
					this.clearRect = (typeof navigator !== 'undefined' && typeof navigator['isCocoonJS'] !== 'undefined');
				}

				if (this.clearRect)
				{
					this.context.clearRect(0, 0, (<internal.Graphics><any>graphics).__renderData.canvas.width, (<internal.Graphics><any>graphics).__renderData.canvas.height);
				}

				if ((textEngine.text != null && textEngine.text != "") || textEngine.__hasFocus)
				{
					var text = textEngine.text;

					if (!(<internal.DisplayObjectRenderer><any>renderer).__allowSmoothing || (textEngine.antiAliasType == AntiAliasType.ADVANCED && textEngine.sharpness == 400))
					{
						(<internal.Graphics><any>graphics).__renderData.context.imageSmoothingEnabled = false;
					}
					else
					{
						(<internal.Graphics><any>graphics).__renderData.context.imageSmoothingEnabled = true;
					}

					if (textEngine.border || textEngine.background)
					{
						this.context.rect(0.5, 0.5, bounds.width - 1, bounds.height - 1);

						if (textEngine.background)
						{
							this.context.fillStyle = "#" + (textEngine.backgroundColor & 0xFFFFFF).toString(16);
							this.context.fill();
						}

						if (textEngine.border)
						{
							this.context.lineWidth = 1;
							this.context.strokeStyle = "#" + (textEngine.borderColor & 0xFFFFFF).toString(16);
							this.context.stroke();
						}
					}

					this.context.textBaseline = "alphabetic";
					this.context.textAlign = "start";

					var scrollX = -textField.scrollH;
					var scrollY = 0.0;

					for (let i = 0; i < textField.scrollV - 1; i++)
					{
						scrollY -= textEngine.lineHeights[i];
					}

					var advance;

					for (let group of textEngine.layoutGroups)
					{
						if (group.lineIndex < textField.scrollV - 1) continue;
						if (group.lineIndex > textEngine.bottomScrollV - 1) break;

						var color = "#" + (group.format.color & 0xFFFFFF).toString(16);

						this.context.font = TextEngine.getFont(group.format);
						this.context.fillStyle = color;

						this.context.fillText(text.substring(group.startIndex, group.endIndex), group.offsetX
							+ scrollX
							- bounds.x,
							group.offsetY
							+ group.ascent
							+ scrollY
							- bounds.y);

						if ((<internal.TextField><any>textField).__caretIndex > -1 && textEngine.selectable)
						{
							if ((<internal.TextField><any>textField).__selectionIndex == (<internal.TextField><any>textField).__caretIndex)
							{
								if ((<internal.TextField><any>textField).__showCursor
									&& group.startIndex <= (<internal.TextField><any>textField).__caretIndex
									&& group.endIndex >= (<internal.TextField><any>textField).__caretIndex)
								{
									advance = 0.0;

									for (let i = 0; i < ((<internal.TextField><any>textField).__caretIndex - group.startIndex); i++)
									{
										if (group.positions.length <= i) break;
										advance += group.getAdvance(i);
									}

									var scrollY = 0.0;

									for (let i = textField.scrollV; i < (group.lineIndex + 1); i++)
									{
										scrollY += textEngine.lineHeights[i - 1];
									}

									this.context.beginPath();
									this.context.strokeStyle = "#" + (group.format.color & 0xFFFFFF).toString(16);
									this.context.moveTo(group.offsetX + advance - textField.scrollH - bounds.x, scrollY + 2 - bounds.y);
									this.context.lineWidth = 1;
									this.context.lineTo(group.offsetX
										+ advance
										- textField.scrollH
										- bounds.x,
										scrollY
										+ TextEngine.getFormatHeight(textField.defaultTextFormat)
										- 1
										- bounds.y);
									this.context.stroke();
									this.context.closePath();

									// context.fillRect (group.offsetX + advance - textField.scrollH, scrollY + 2, 1, TextEngine.getFormatHeight (textField.defaultTextFormat) - 1);
								}
							}
							else if ((group.startIndex <= (<internal.TextField><any>textField).__caretIndex && group.endIndex >= (<internal.TextField><any>textField).__caretIndex)
								|| (group.startIndex <= (<internal.TextField><any>textField).__selectionIndex && group.endIndex >= (<internal.TextField><any>textField).__selectionIndex)
								|| (group.startIndex > (<internal.TextField><any>textField).__caretIndex && group.endIndex < (<internal.TextField><any>textField).__selectionIndex)
								|| (group.startIndex > (<internal.TextField><any>textField).__selectionIndex && group.endIndex < (<internal.TextField><any>textField).__caretIndex))
							{
								var selectionStart = Math.floor(Math.min((<internal.TextField><any>textField).__selectionIndex, (<internal.TextField><any>textField).__caretIndex));
								var selectionEnd = Math.floor(Math.max((<internal.TextField><any>textField).__selectionIndex, (<internal.TextField><any>textField).__caretIndex));

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
									this.context.fillStyle = "#000000";
									this.context.fillRect(start.x + scrollX, start.y + scrollY, end.x - start.x, group.height);
									this.context.fillStyle = "#FFFFFF";

									// TODO: fill only once

									this.context.fillText(text.substring(selectionStart, selectionEnd), scrollX + start.x, group.offsetY + group.ascent + scrollY);
								}
							}
						}

						if (group.format.underline)
						{
							this.context.beginPath();
							this.context.strokeStyle = color;
							this.context.lineWidth = 1;
							var x = group.offsetX + scrollX - bounds.x;
							var y = Math.floor(group.offsetY + scrollY + group.ascent - bounds.y) + 0.5;
							this.context.moveTo(x, y);
							this.context.lineTo(x + group.width, y);
							this.context.stroke();
							this.context.closePath();
						}
					}
				}
				else
				{
					if (textEngine.border || textEngine.background)
					{
						if (textEngine.border)
						{
							this.context.rect(0.5, 0.5, bounds.width - 1, bounds.height - 1);
						}
						else
						{
							this.context.rect(0, 0, bounds.width, bounds.height);
						}

						if (textEngine.background)
						{
							this.context.fillStyle = "#" + (textEngine.backgroundColor & 0xFFFFFF).toString(16);
							this.context.fill();
						}

						if (textEngine.border)
						{
							this.context.lineWidth = 1;
							this.context.lineCap = "square";
							this.context.strokeStyle = "#" + (textEngine.borderColor & 0xFFFFFF).toString(16);
							this.context.stroke();
						}
					}

					if ((<internal.TextField><any>textField).__caretIndex > -1 && textEngine.selectable && (<internal.TextField><any>textField).__showCursor)
					{
						var scrollX = -textField.scrollH;
						var scrollY = 0.0;

						for (let i = 0; i < textField.scrollV - 1; i++)
						{
							scrollY += textEngine.lineHeights[i];
						}

						var offsetX = 0;

						switch (textField.defaultTextFormat.align)
						{
							case TextFormatAlign.CENTER:
								offsetX = (textField.width - 4) / 2;
								break;
							case TextFormatAlign.RIGHT:
								offsetX = (textField.width - 4);
								break;
							default:
						}

						this.context.beginPath();
						this.context.strokeStyle = "#" + (textField.defaultTextFormat.color & 0xFFFFFF).toString(16);
						this.context.moveTo(scrollX + offsetX + 2.5, scrollY + 2.5);
						this.context.lineWidth = 1;
						this.context.lineTo(scrollX + offsetX + 2.5, scrollY + TextEngine.getFormatHeight(textField.defaultTextFormat) - 1);
						this.context.stroke();
						this.context.closePath();
					}
				}

				(<internal.Graphics><any>graphics).__bitmap = BitmapData.fromCanvas((<internal.Graphics><any>(<internal.DisplayObject><any>textField).__graphics).__renderData.canvas);
				(<internal.Graphics><any>graphics).__visible = true;
				(<internal.TextField><any>textField).__dirty = false;
				(<internal.Graphics><any>graphics).__softwareDirty = false;
				(<internal.Graphics><any>graphics).__dirty = false;
			}
		}
	}
}
