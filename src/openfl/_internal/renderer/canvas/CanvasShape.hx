package openfl._internal.renderer.canvas;

import openfl.display.CanvasRenderer;
import openfl.display.DisplayObject;

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

			if (canvas != null)
			{
				var context = renderer.context;
				var scrollRect = shape.__scrollRect;
				var scale9Grid = shape.__worldScale9Grid;

				// TODO: Render for scroll rect?

				if (width > 0 && height > 0 && (scrollRect == null || (scrollRect.width > 0 && scrollRect.height > 0)))
				{
					renderer.__setBlendMode(shape.__worldBlendMode);
					renderer.__pushMaskObject(shape);

					context.globalAlpha = alpha;
					renderer.setTransform(graphics.__worldTransform, context);

					if (renderer.__isDOM)
					{
						var reverseScale = 1 / renderer.pixelRatio;
						context.scale(reverseScale, reverseScale);
					}

					// TODO: Use renderTransform instead of scaleX/scaleY?

					if (scale9Grid != null)
					{
						var centerX = scale9Grid.width;
						var centerY = scale9Grid.height;

						if (centerX != 0 && centerY != 0)
						{
							var left = scale9Grid.x;
							var top = scale9Grid.y;
							var right = width - centerX - left;
							var bottom = height - centerY - top;
							var renderedLeft = left / shape.scaleX;
							var renderedTop = top / shape.scaleY;
							var renderedRight = right / shape.scaleX;
							var renderedBottom = bottom / shape.scaleY;
							var renderedCenterX = width - renderedLeft - renderedRight;
							var renderedCenterY = height - renderedTop - renderedBottom;

							context.drawImage(canvas, 0, 0, left, top, 0, 0, renderedLeft, renderedTop);
							context.drawImage(canvas, left, 0, centerX, top, renderedLeft, 0, renderedCenterX, renderedTop);
							context.drawImage(canvas, left + centerX, 0, right, top, renderedLeft + renderedCenterX, 0, renderedRight, renderedTop);

							context.drawImage(canvas, 0, top, left, centerY, 0, renderedTop, renderedLeft, renderedCenterY);
							context.drawImage(canvas, left, top, centerX, centerY, renderedLeft, renderedTop, renderedCenterX, renderedCenterY);
							context.drawImage(canvas, left + centerX, top, right, centerY, renderedLeft + renderedCenterX, renderedTop, renderedRight,
								renderedCenterY);

							context.drawImage(canvas, 0, top + centerY, left, bottom, 0, renderedTop + renderedCenterY, renderedLeft, renderedBottom);
							context.drawImage(canvas, left, top + centerY, centerX, bottom, renderedLeft, renderedTop + renderedCenterY, renderedCenterX,
								renderedBottom);
							context
								.drawImage(canvas, left + centerX, top + centerY, right, bottom, renderedLeft + renderedCenterX, renderedTop + renderedCenterY, renderedRight, renderedBottom);
						}
						else if (centerX == 0 && centerY != 0)
						{
							var top = scale9Grid.y;
							var bottom = height - top - centerY;
							var renderedTop = top / shape.scaleY;
							var renderedBottom = bottom / shape.scaleY;
							var renderedCenterY = height - renderedTop - renderedBottom;
							var renderedWidth = width;

							context.drawImage(canvas, 0, 0, width, top, 0, 0, renderedWidth, renderedTop);
							context.drawImage(canvas, 0, top, width, centerY, 0, renderedTop, renderedWidth, renderedCenterY);
							context.drawImage(canvas, 0, top + centerY, width, bottom, 0, renderedTop + renderedCenterY, renderedWidth, renderedBottom);
						}
						else if (centerY == 0 && centerX != 0)
						{
							var left = scale9Grid.x;
							var right = width - left - centerX;
							var renderedLeft = left / shape.scaleX;
							var renderedRight = right / shape.scaleX;
							var renderedCenterX = width - renderedLeft - renderedRight;
							var renderedHeight = height;

							context.drawImage(canvas, 0, 0, left, height, 0, 0, renderedLeft, renderedHeight);
							context.drawImage(canvas, left, 0, centerX, height, renderedLeft, 0, renderedCenterX, renderedHeight);
							context.drawImage(canvas, left + centerX, 0, right, height, renderedLeft + renderedCenterX, 0, renderedRight, renderedHeight);
						}
					}
					else
					{
						context.drawImage(canvas, 0, 0, width, height);
					}

					renderer.__popMaskObject(shape);
				}
			}
		}
		#end
	}
}
