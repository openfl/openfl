package openfl.display._internal;

#if openfl_cairo
import lime.graphics.cairo.Cairo;
import lime.graphics.cairo.CairoAntialias;
import lime.graphics.cairo.CairoFontOptions;
import lime.graphics.cairo.CairoFTFontFace;
import lime.graphics.cairo.CairoGlyph;
import lime.graphics.cairo.CairoHintMetrics;
import lime.graphics.cairo.CairoHintStyle;
import openfl.text._internal.TextEngine;
import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.text.TextField;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display._internal)
@:access(openfl.display.BitmapData)
@:access(openfl.display.Graphics)
@:access(openfl.geom.Matrix)
@:access(openfl.text.TextField)
@SuppressWarnings("checkstyle:FieldDocComment")
class CairoTextField
{
	public static function render(textField:TextField, renderer:CairoRenderer, transform:Matrix):Void
	{
		var textEngine = textField._.__textEngine;
		var bounds = (textEngine.background || textEngine.border) ? textEngine.bounds : textEngine.textBounds;
		var graphics = textField._.__graphics;
		var cairo = graphics._.__renderData.cairo;

		if (textField._.__dirty)
		{
			textField._.__updateLayout();

			if (graphics._.__bounds == null)
			{
				graphics._.__bounds = new Rectangle();
			}

			graphics._.__bounds.copyFrom(bounds);

			// graphics._.__bounds.x += textField._.__offsetX;
			// graphics._.__bounds.y += textField._.__offsetY;
		}

		graphics._.__update(renderer._.__worldTransform);

		var width = graphics._.__width;
		var height = graphics._.__height;

		var renderable = (textEngine.border || textEngine.background || textEngine.text != null);
		var needsUpscaling = false;

		if (cairo != null)
		{
			// var surface:CairoImageSurface = cast cairo.target;
			var surface = graphics._.__bitmap.getSurface();

			if (graphics._.__softwareDirty && (width > surface.width || height > surface.height))
			{
				needsUpscaling = true;
			}

			if (!renderable || needsUpscaling)
			{
				graphics._.__renderData.cairo = null;
				graphics._.__bitmap = null;
				graphics._.__visible = false;
				cairo = null;
			}
		}

		if (width <= 0
			|| height <= 0
			|| (!textField._.__dirty && !graphics._.__softwareDirty && (!graphics._.__visible || graphics._.__bitmap != null))
			|| !renderable)
		{
			textField._.__dirty = false;
			return;
		}

		if (cairo == null)
		{
			var bitmapWidth = needsUpscaling ? Std.int(width * 1.25) : width;
			var bitmapHeight = needsUpscaling ? Std.int(height * 1.25) : height;

			if (Graphics.maxTextureWidth != null && bitmapWidth > Graphics.maxTextureWidth)
			{
				bitmapWidth = Graphics.maxTextureWidth;
			}

			if (Graphics.maxTextureHeight != null && bitmapHeight > Graphics.maxTextureHeight)
			{
				bitmapHeight = Graphics.maxTextureHeight;
			}

			var bitmap = new BitmapData(bitmapWidth, bitmapHeight, true, 0);
			var surface = bitmap.getSurface();
			graphics._.__renderData.cairo = new Cairo(surface);
			graphics._.__visible = true;
			graphics._.__managed = true;

			graphics._.__bitmap = bitmap;

			cairo = graphics._.__renderData.cairo;

			var options = new CairoFontOptions();

			if (textEngine.antiAliasType == ADVANCED && textEngine.sharpness == 400)
			{
				options.hintStyle = CairoHintStyle.NONE;
				options.hintMetrics = CairoHintMetrics.OFF;
				options.antialias = CairoAntialias.NONE;
			}
			else
			{
				options.hintStyle = CairoHintStyle.SLIGHT;
				options.hintMetrics = CairoHintMetrics.OFF;
				options.antialias = CairoAntialias.GOOD;
			}

			cairo.fontOptions = options;
		}
		else
		{
			cairo.identityMatrix();
			cairo.resetClip();

			cairo.setOperator(CLEAR);
			cairo.paint();
			cairo.setOperator(OVER);
		}

		renderer.applyMatrix(graphics._.__renderTransform, cairo);

		if (textEngine.border)
		{
			cairo.rectangle(0.5, 0.5, Std.int(bounds.width - 1), Std.int(bounds.height - 1));
		}
		else
		{
			cairo.rectangle(0, 0, bounds.width, bounds.height);
		}

		if (textEngine.background)
		{
			var color = textEngine.backgroundColor;
			var r = ((color & 0xFF0000) >>> 16) / 0xFF;
			var g = ((color & 0x00FF00) >>> 8) / 0xFF;
			var b = (color & 0x0000FF) / 0xFF;

			cairo.setSourceRGB(r, g, b);
			cairo.fillPreserve();
		}

		if (textEngine.border)
		{
			var color = textEngine.borderColor;
			var r = ((color & 0xFF0000) >>> 16) / 0xFF;
			var g = ((color & 0x00FF00) >>> 8) / 0xFF;
			var b = (color & 0x0000FF) / 0xFF;

			cairo.setSourceRGB(r, g, b);
			cairo.lineWidth = 1;
			cairo.stroke();
		}

		if (textEngine.text != null && textEngine.text != "")
		{
			cairo.rectangle(0, 0, bounds.width - (textField.border ? 1 : 0), bounds.height - (textField.border ? 1 : 0));
			cairo.clip();

			var text = textEngine.text;

			var scrollX = -textField.scrollH;
			var scrollY = 0.0;

			for (i in 0...textField.scrollV - 1)
			{
				scrollY -= textEngine.lineHeights[i];
			}

			var color, r, g, b, font, size, advance;

			for (group in textEngine.layoutGroups)
			{
				if (group.lineIndex < textField.scrollV - 1) continue;
				if (group.lineIndex > textEngine.bottomScrollV - 1) break;

				color = group.format.color;
				r = ((color & 0xFF0000) >>> 16) / 0xFF;
				g = ((color & 0x00FF00) >>> 8) / 0xFF;
				b = (color & 0x0000FF) / 0xFF;

				cairo.setSourceRGB(r, g, b);

				font = TextEngine.getFontInstance(group.format);

				if (font != null && group.format.size != null)
				{
					if (textEngine._.__cairoFont != null)
					{
						if (textEngine._.__font != font)
						{
							textEngine._.__cairoFont = null;
						}
					}

					if (textEngine._.__cairoFont == null)
					{
						textEngine._.__font = font;
						textEngine._.__cairoFont = CairoFTFontFace.create(font, 0);
					}

					cairo.fontFace = textEngine._.__cairoFont;

					size = Std.int(group.format.size);
					cairo.setFontSize(size);

					cairo.moveTo(group.offsetX + scrollX - bounds.x, group.offsetY + group.ascent + scrollY - bounds.y);

					#if openfl_cairo_show_text
					cairo.showText(text.substring(group.startIndex, group.endIndex));
					#else
					// TODO: Improve performance

					cairo.translate(0, 0);

					var glyphs = [];
					var x:Float = group.offsetX + scrollX - bounds.x;
					var y:Float = group.offsetY + group.ascent + scrollY - bounds.y;

					for (position in group.positions)
					{
						if (position == null || position.glyph == 0) continue;
						glyphs.push(new CairoGlyph(position.glyph, x + position.offset.x + 0.5, y - position.offset.y + 0.5));
						x += position.advance.x;
						y -= position.advance.y;
					}

					cairo.showGlyphs(glyphs);
					#end

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

								cairo.moveTo(Math.floor(group.offsetX + advance) + 0.5 - textField.scrollH - bounds.x, scrollY + 2.5 - bounds.y);
								cairo.lineWidth = 1;
								cairo.lineTo(Math.floor(group.offsetX + advance)
									+ 0.5
									- textField.scrollH
									- bounds.x,
									scrollY
									+ TextEngine.getFormatHeight(textField.defaultTextFormat)
									- 1
									- bounds.y);
								cairo.stroke();
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
								cairo.setSourceRGB(0, 0, 0);
								cairo.rectangle(scrollX + start.x, start.y + scrollY, end.x - start.x, group.height);
								cairo.fill();
								cairo.setSourceRGB(1, 1, 1);

								// TODO: draw only once

								cairo.moveTo(scrollX + start.x, group.offsetY + group.ascent + scrollY);

								// TODO: Use `showGlyphs` not `showText`
								cairo.showText(text.substring(selectionStart, selectionEnd));
							}
						}
					}

					if (group.format.underline)
					{
						// TODO: Use font underlinePosition/underlineThickness

						cairo.newPath();
						cairo.lineWidth = 1;
						var x = group.offsetX + scrollX - bounds.x;
						var y = Math.floor(group.offsetY + scrollY + group.ascent - bounds.y) + 0.5;
						cairo.moveTo(x, y);
						cairo.lineTo(x + group.width, y);
						cairo.stroke();
						cairo.closePath();
					}
				}
			}
		}
		else if (textField._.__caretIndex > -1 && textEngine.selectable && textField._.__showCursor)
		{
			var scrollX = -textField.scrollH;
			var scrollY = 0.0;

			for (i in 0...textField.scrollV - 1)
			{
				scrollY += textEngine.lineHeights[i];
			}

			var color = textField.defaultTextFormat.color;
			var r = ((color & 0xFF0000) >>> 16) / 0xFF;
			var g = ((color & 0x00FF00) >>> 8) / 0xFF;
			var b = (color & 0x0000FF) / 0xFF;

			cairo.setSourceRGB(r, g, b);

			var offsetX = switch (textField.defaultTextFormat.align)
			{
				case CENTER: (textField.width - 4) / 2;
				case RIGHT: (textField.width - 4);
				default: 0;
			}

			cairo.newPath();
			cairo.moveTo(scrollX + offsetX + 2.5, scrollY + 2.5);
			cairo.lineWidth = 1;
			cairo.lineTo(scrollX + offsetX + 2.5, scrollY + TextEngine.getFormatHeight(textField.defaultTextFormat) - 1);
			cairo.stroke();
			cairo.closePath();
		}

		graphics._.__bitmap._.__setDirty();
		textField._.__dirty = false;
		graphics._.__softwareDirty = false;
		graphics._.__dirty = false;
	}
}
#end
