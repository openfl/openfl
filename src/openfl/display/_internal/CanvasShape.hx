package openfl.display._internal;

import openfl.display.CanvasRenderer;
import openfl.display.DisplayObject;
import openfl.geom.Matrix;

@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.geom.Matrix)
@SuppressWarnings("checkstyle:FieldDocComment")
class CanvasShape
{
	public static inline function render(shape:DisplayObject, renderer:CanvasRenderer):Void
	{
		#if (js && html5)
		if (!shape.__renderable) return;

		var alpha = renderer.__getAlpha(shape.__worldAlpha);
		if (alpha <= 0) return;

		var graphics = shape.__graphics;

		if (graphics != null)
		{
			CanvasGraphics.render(graphics, renderer);

			var width = graphics.__width;
			var height = graphics.__height;
			var canvas = graphics.__canvas;

			if (canvas != null && graphics.__visible && width >= 1 && height >= 1)
			{
				var transform = graphics.__worldTransform;
				var context = renderer.context;
				var scrollRect = shape.__scrollRect;
				var scale9Grid = shape.__worldScale9Grid;

				// TODO: Render for scroll rect?

				if (scrollRect == null || (scrollRect.width > 0 && scrollRect.height > 0))
				{
					renderer.__setBlendMode(shape.__worldBlendMode);
					renderer.__pushMaskObject(shape);

					context.globalAlpha = alpha;

					if (scale9Grid != null && transform.b == 0 && transform.c == 0)
					{
						#if (openfl_disable_hdpi || openfl_disable_hdpi_graphics)
						var pixelRatio = 1;
						#else
						var pixelRatio = renderer.__pixelRatio;
						#end

						var matrix = Matrix.__pool.get();
						matrix.translate(transform.tx, transform.ty);

						renderer.setTransform(matrix, context);

						Matrix.__pool.release(matrix);

						var bounds = graphics.__bounds;

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

						// TODO: Allow smoothing, even though it shows seams?
						renderer.applySmoothing(context, false);

						if (centerWidth != 0 && centerHeight != 0)
						{
							context.drawImage(canvas, 0, 0, left, top, 0, 0, renderLeft, renderTop);
							context.drawImage(canvas, left, 0, centerWidth, top, renderLeft, 0, renderCenterWidth, renderTop);
							context.drawImage(canvas, left + centerWidth, 0, right, top, renderLeft + renderCenterWidth, 0, renderRight, renderTop);

							context.drawImage(canvas, 0, top, left, centerHeight, 0, renderTop, renderLeft, renderCenterHeight);
							context.drawImage(canvas, left, top, centerWidth, centerHeight, renderLeft, renderTop, renderCenterWidth, renderCenterHeight);
							context.drawImage(canvas, left + centerWidth, top, right, centerHeight, renderLeft + renderCenterWidth, renderTop, renderRight,
								renderCenterHeight);

							context.drawImage(canvas, 0, top + centerHeight, left, bottom, 0, renderTop + renderCenterHeight, renderLeft, renderBottom);
							context.drawImage(canvas, left, top + centerHeight, centerWidth, bottom, renderLeft, renderTop + renderCenterHeight,
								renderCenterWidth, renderBottom);
							context.drawImage(canvas, left
								+ centerWidth, top
								+ centerHeight, right, bottom, renderLeft
								+ renderCenterWidth,
								renderTop
								+ renderCenterHeight, renderRight, renderBottom);
						}
						else if (centerWidth == 0 && centerHeight != 0)
						{
							var renderWidth = renderLeft + renderCenterWidth + renderRight;

							context.drawImage(canvas, 0, 0, width, top, 0, 0, renderWidth, renderTop);
							context.drawImage(canvas, 0, top, width, centerHeight, 0, renderTop, renderWidth, renderCenterHeight);
							context.drawImage(canvas, 0, top + centerHeight, width, bottom, 0, renderTop + renderCenterHeight, renderWidth, renderBottom);
						}
						else if (centerHeight == 0 && centerWidth != 0)
						{
							var renderHeight = renderTop + renderCenterHeight + renderBottom;

							context.drawImage(canvas, 0, 0, left, height, 0, 0, renderLeft, renderHeight);
							context.drawImage(canvas, left, 0, centerWidth, height, renderLeft, 0, renderCenterWidth, renderHeight);
							context.drawImage(canvas, left + centerWidth, 0, right, height, renderLeft + renderCenterWidth, 0, renderRight, renderHeight);
						}
					}
					else
					{
						// var matrix = Matrix.__pool.get();
						// matrix.scale(1 / graphics.__bitmapScale, 1 / graphics.__bitmapScale);
						// matrix.concat(transform);

						renderer.setTransform(transform, context);

						// Matrix.__pool.release(matrix);

						context.drawImage(canvas, 0, 0, width, height);
					}

					renderer.__popMaskObject(shape);
				}
			}
		}
		#end
	}
}
