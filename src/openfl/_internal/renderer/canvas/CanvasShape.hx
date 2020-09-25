package openfl._internal.renderer.canvas;

import openfl.display.CanvasRenderer;
import openfl.display.DisplayObject;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
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

			var canvas = graphics.__canvas;
			var context = renderer.context;

			if (canvas != null && graphics.__visible && graphics.__width >= 1 && graphics.__height >= 1)
			{
				var localTransform = shape.__transform;
				var scale9Grid = shape.__scale9Grid;

				renderer.__setBlendMode(shape.__worldBlendMode);
				renderer.__pushMaskObject(shape);

				if (scale9Grid != null && localTransform.b == 0 && localTransform.c == 0)
				{
					var sourceTransform = graphics.__renderTransform;
					var transform = graphics.__worldTransform;

					var tileRect = Rectangle.__pool.get();
					var tileTransform = Matrix.__pool.get();

					context.globalAlpha = alpha;

					var bounds = graphics.__bounds;

					var scaleX = sourceTransform.a;
					var scaleY = sourceTransform.d;
					var renderScaleX = scaleX / localTransform.a;
					var renderScaleY = scaleY / localTransform.d;

					var width = bounds.width * localTransform.a;
					var height = bounds.height * localTransform.d;

					var left = Math.round(scale9Grid.x * scaleX);
					var top = Math.round(scale9Grid.y * scaleY);
					var right = Math.round((bounds.right - scale9Grid.right) * scaleX);
					var bottom = Math.round((bounds.bottom - scale9Grid.bottom) * scaleY);
					var centerWidth = Math.round(scale9Grid.width * scaleX);
					var centerHeight = Math.round(scale9Grid.height * scaleY);

					var renderLeft = Math.round(scale9Grid.x * renderScaleX);
					var renderTop = Math.round(scale9Grid.y * renderScaleY);
					var renderRight = Math.round((bounds.right - scale9Grid.right) * renderScaleX);
					var renderBottom = Math.round((bounds.bottom - scale9Grid.bottom) * renderScaleY);
					var renderCenterWidth = Math.round(width * renderScaleX) - renderLeft - renderRight;
					var renderCenterHeight = Math.round(height * renderScaleY) - renderTop - renderBottom;

					function drawImage(sx:Float, sy:Float, sWidth:Float, sHeight:Float, dx:Float, dy:Float, dWidth:Float, dHeight:Float):Void
					{
						tileRect.setTo(sx, sy, sWidth, sHeight);

						tileTransform.setTo(dWidth / sWidth, 0, 0, dHeight / sHeight, dx, dy);
						tileTransform.concat(transform);

						// if (roundPixels) {

						// 	tileTransform.tx = Math.round (tileTransform.tx);
						// 	tileTransform.ty = Math.round (tileTransform.ty);

						// }

						context.setTransform(tileTransform.a, tileTransform.b, tileTransform.c, tileTransform.d, tileTransform.tx, tileTransform.ty);

						context.drawImage(canvas, tileRect.x, tileRect.y, tileRect.width, tileRect.height, 0, 0, tileRect.width, tileRect.height);
					}

					context.save(); // TODO: Restore transform without save/restore

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

					Rectangle.__pool.release(tileRect);
					Matrix.__pool.release(tileTransform);

					context.restore();
				}

				renderer.__popMaskObject(shape);
			}
		}
		#end
	}
}
