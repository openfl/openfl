package openfl.display._internal;

import openfl.display.CairoRenderer;
import openfl.display.DisplayObject;
import openfl.geom.Matrix;
#if lime
import lime.graphics.cairo.CairoFilter;
import lime.graphics.cairo.CairoPattern;
import lime.math.Matrix3;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.geom.Matrix)
@SuppressWarnings("checkstyle:FieldDocComment")
class CairoShape
{
	#if lime_cairo
	private static var sourceTransform:Matrix3 = new Matrix3();
	#end

	public static function render(shape:DisplayObject, renderer:CairoRenderer):Void
	{
		#if lime_cairo
		if (!shape.__renderable) return;

		var alpha = renderer.__getAlpha(shape.__worldAlpha);
		if (alpha <= 0) return;

		var graphics = shape.__graphics;

		if (graphics != null)
		{
			CairoGraphics.render(graphics, renderer);

			var width = graphics.__width;
			var height = graphics.__height;
			var cairo = renderer.cairo;

			if (cairo != null && graphics.__visible && width >= 1 && height >= 1)
			{
				var transform = graphics.__worldTransform;
				var scale9Grid = shape.__worldScale9Grid;

				renderer.__setBlendMode(shape.__worldBlendMode);
				renderer.__pushMaskObject(shape);

				if (scale9Grid != null && transform.b == 0 && transform.c == 0)
				{
					#if (openfl_disable_hdpi || openfl_disable_hdpi_graphics)
					var pixelRatio = 1;
					#else
					var pixelRatio = renderer.__pixelRatio;
					#end

					var matrix = Matrix.__pool.get();
					matrix.translate(transform.tx, transform.ty);

					renderer.applyMatrix(matrix, cairo);

					Matrix.__pool.release(matrix);

					var bounds = graphics.__bounds;

					var renderTransform = Matrix.__pool.get();

					var scaleX = graphics.__renderTransform.a / graphics.__bitmapScale;
					var scaleY = graphics.__renderTransform.d / graphics.__bitmapScale;
					var renderScaleX = (scaleX * transform.a);
					var renderScaleY = (scaleY * transform.d);

					var left = Math.max(1, Math.round(scale9Grid.x * scaleX));
					var top = Math.round(scale9Grid.y * scaleY);
					var right = Math.max(1, Math.round((bounds.right - scale9Grid.right) * scaleX));
					var bottom = Math.round((bounds.bottom - scale9Grid.bottom) * scaleY);
					var centerWidth = Math.round(scale9Grid.width * scaleX);
					var centerHeight = Math.round(scale9Grid.height * scaleY);

					var renderLeft = Math.round(left / pixelRatio);
					var renderTop = Math.round(top / pixelRatio);
					var renderRight = Math.round(right / pixelRatio);
					var renderBottom = Math.round(bottom / pixelRatio);
					var renderCenterWidth = (bounds.width * renderScaleX) - renderLeft - renderRight;
					var renderCenterHeight = (bounds.height * renderScaleY) - renderTop - renderBottom;

					var pattern = CairoPattern.createForSurface(graphics.__cairo.target);
					// TODO: Allow smoothing, even though it shows seams?
					pattern.filter = CairoFilter.NEAREST;
					// pattern.filter = renderer.__allowSmoothing ? CairoFilter.GOOD : CairoFilter.NEAREST;

					function drawImage(sx:Float, sy:Float, sWidth:Float, sHeight:Float, dx:Float, dy:Float, dWidth:Float, dHeight:Float):Void
					{
						renderTransform.a = (dWidth / sWidth);
						renderTransform.d = (dHeight / sHeight);
						renderTransform.tx = transform.tx + dx;
						renderTransform.ty = transform.ty + dy;

						renderer.applyMatrix(renderTransform, cairo);

						sourceTransform.tx = sx;
						sourceTransform.ty = sy;
						pattern.matrix = sourceTransform;
						cairo.source = pattern;

						cairo.save();

						cairo.newPath();
						cairo.rectangle(0, 0, sWidth, sHeight);
						cairo.clip();

						if (alpha == 1)
						{
							cairo.paint();
						}
						else
						{
							cairo.paintWithAlpha(alpha);
						}

						cairo.restore();
					}

					if (centerWidth != 0 && centerHeight != 0)
					{
						drawImage(0, 0, left, top, 0, 0, renderLeft, renderTop);
						drawImage(left, 0, centerWidth, top, renderLeft, 0, renderCenterWidth, renderTop);
						drawImage(left + centerWidth, 0, right, top, renderLeft + renderCenterWidth, 0, renderRight, renderTop);

						drawImage(0, top, left, centerHeight, 0, renderTop, renderLeft, renderCenterHeight);
						drawImage(left, top, centerWidth, centerHeight, renderLeft, renderTop, renderCenterWidth, renderCenterHeight);
						drawImage(left + centerWidth, top, right, centerHeight, renderLeft + renderCenterWidth, renderTop, renderRight, renderCenterHeight);

						drawImage(0, top + centerHeight, left, bottom, 0, renderTop + renderCenterHeight, renderLeft, renderBottom);
						drawImage(left, top + centerHeight, centerWidth, bottom, renderLeft, renderTop + renderCenterHeight, renderCenterWidth, renderBottom);
						drawImage(left + centerWidth, top + centerHeight, right, bottom, renderLeft + renderCenterWidth, renderTop + renderCenterHeight,
							renderRight, renderBottom);
					}
					else if (centerWidth == 0 && centerHeight != 0)
					{
						var renderWidth = renderLeft + renderCenterWidth + renderRight;

						drawImage(0, 0, width, top, 0, 0, renderWidth, renderTop);
						drawImage(0, top, width, centerHeight, 0, renderTop, renderWidth, renderCenterHeight);
						drawImage(0, top + centerHeight, width, bottom, 0, renderTop + renderCenterHeight, renderWidth, renderBottom);
					}
					else if (centerHeight == 0 && centerWidth != 0)
					{
						var renderHeight = renderTop + renderCenterHeight + renderBottom;

						drawImage(0, 0, left, height, 0, 0, renderLeft, renderHeight);
						drawImage(left, 0, centerWidth, height, renderLeft, 0, renderCenterWidth, renderHeight);
						drawImage(left + centerWidth, 0, right, height, renderLeft + renderCenterWidth, 0, renderRight, renderHeight);
					}

					Matrix.__pool.release(renderTransform);
				}
				else
				{
					var renderTransform = Matrix.__pool.get();
					renderTransform.scale(1 / graphics.__bitmapScale, 1 / graphics.__bitmapScale);
					renderTransform.concat(transform);

					renderer.applyMatrix(renderTransform, cairo);

					cairo.setSourceSurface(graphics.__cairo.target, 0, 0);

					if (alpha >= 1)
					{
						cairo.paint();
					}
					else
					{
						cairo.paintWithAlpha(alpha);
					}

					Matrix.__pool.release(renderTransform);
				}

				renderer.__popMaskObject(shape);
			}
		}
		#end
	}

	public static inline function renderDrawable(shape:Shape, renderer:CairoRenderer):Void
	{
		CairoDisplayObject.renderDrawable(shape, renderer);
	}

	public static inline function renderDrawableMask(shape:Shape, renderer:CairoRenderer):Void
	{
		CairoDisplayObject.renderDrawableMask(shape, renderer);
	}
}
