package openfl._internal.renderer.canvas;

import openfl.display.Bitmap;
import openfl.display.CanvasRenderer;
#if lime
import lime._internal.graphics.ImageCanvasUtil; // TODO

#end
@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)
@SuppressWarnings("checkstyle:FieldDocComment")
class CanvasBitmap
{
	public static inline function render(bitmap:Bitmap, renderer:CanvasRenderer):Void
	{
		#if (js && html5)
		if (!bitmap.__renderable) return;

		var alpha = renderer.__getAlpha(bitmap.__worldAlpha);

		if (alpha > 0 && bitmap.__bitmapData != null && bitmap.__bitmapData.__isValid && bitmap.__bitmapData.readable)
		{
			var context = renderer.context;

			renderer.__setBlendMode(bitmap.__worldBlendMode);
			renderer.__pushMaskObject(bitmap, false);

			ImageCanvasUtil.convertToCanvas(bitmap.__bitmapData.image);

			context.globalAlpha = alpha;
			var scrollRect = bitmap.__scrollRect;

			renderer.setTransform(bitmap.__renderTransform, context);

			if (!renderer.__allowSmoothing || !bitmap.smoothing)
			{
				context.imageSmoothingEnabled = false;
			}

			if (scrollRect == null)
			{
				if (bitmap.scale9Grid == null)
				{
					context.drawImage(bitmap.__bitmapData.image.src, 0, 0, bitmap.__bitmapData.image.width, bitmap.__bitmapData.image.height);
				}
				else
				{
					var image = bitmap.__bitmapData.image;
					var imageSrc = image.src;
					var centerX = bitmap.scale9Grid.width;
					var centerY = bitmap.scale9Grid.height;
					if (centerX != 0 && centerY != 0)
					{
						var left = bitmap.scale9Grid.x;
						var top = bitmap.scale9Grid.y;
						var right = image.width - centerX - left;
						var bottom = image.height - centerY - top;
						var renderedLeft = left / bitmap.scaleX;
						var renderedTop = top / bitmap.scaleY;
						var renderedRight = right / bitmap.scaleX;
						var renderedBottom = bottom / bitmap.scaleY;
						var renderedCenterX = (bitmap.width / bitmap.scaleX) - renderedLeft - renderedRight;
						var renderedCenterY = (bitmap.height / bitmap.scaleY) - renderedTop - renderedBottom;

						context.drawImage(imageSrc, 0, 0, left, top, 0, 0, renderedLeft, renderedTop);
						context.drawImage(imageSrc, left, 0, centerX, top, renderedLeft, 0, renderedCenterX, renderedTop);
						context.drawImage(imageSrc, left + centerX, 0, right, top, renderedLeft + renderedCenterX, 0, renderedRight, renderedTop);

						context.drawImage(imageSrc, 0, top, left, centerY, 0, renderedTop, renderedLeft, renderedCenterY);
						context.drawImage(imageSrc, left, top, centerX, centerY, renderedLeft, renderedTop, renderedCenterX, renderedCenterY);
						context.drawImage(imageSrc, left + centerX, top, right, centerY, renderedLeft + renderedCenterX, renderedTop, renderedRight,
							renderedCenterY);

						context.drawImage(imageSrc, 0, top + centerY, left, bottom, 0, renderedTop + renderedCenterY, renderedLeft, renderedBottom);
						context.drawImage(imageSrc, left, top + centerY, centerX, bottom, renderedLeft, renderedTop + renderedCenterY, renderedCenterX,
							renderedBottom);
						context
							.drawImage(imageSrc, left + centerX, top + centerY, right, bottom, renderedLeft + renderedCenterX, renderedTop + renderedCenterY, renderedRight, renderedBottom);
					}
					else if (centerX == 0 && centerY != 0)
					{
						var top = bitmap.scale9Grid.y;
						var bottom = image.height - top - centerY;
						var renderedTop = top / bitmap.scaleY;
						var renderedBottom = bottom / bitmap.scaleY;
						var renderedCenterY = (bitmap.height / bitmap.scaleY) - renderedTop - renderedBottom;
						var renderedWidth = bitmap.width / bitmap.scaleX;

						context.drawImage(imageSrc, 0, 0, image.width, top, 0, 0, renderedWidth, renderedTop);
						context.drawImage(imageSrc, 0, top, image.width, centerY, 0, renderedTop, renderedWidth, renderedCenterY);
						context.drawImage(imageSrc, 0, top + centerY, image.width, bottom, 0, renderedTop + renderedCenterY, renderedWidth, renderedBottom);
					}
					else if (centerY == 0 && centerX != 0)
					{
						var left = bitmap.scale9Grid.x;
						var right = image.width - left - centerX;
						var renderedLeft = left / bitmap.scaleX;
						var renderedRight = right / bitmap.scaleX;
						var renderedCenterX = (bitmap.width / bitmap.scaleX) - renderedLeft - renderedRight;
						var renderedHeight = bitmap.height / bitmap.scaleY;

						context.drawImage(imageSrc, 0, 0, left, image.height, 0, 0, renderedLeft, renderedHeight);
						context.drawImage(imageSrc, left, 0, centerX, image.height, renderedLeft, 0, renderedCenterX, renderedHeight);
						context.drawImage(imageSrc, left + centerX, 0, right, image.height, renderedLeft + renderedCenterX, 0, renderedRight, renderedHeight);
					}
				}
			}
			else
			{
				context.drawImage(bitmap.__bitmapData.image.src, scrollRect.x, scrollRect.y, scrollRect.width, scrollRect.height);
			}

			if (!renderer.__allowSmoothing || !bitmap.smoothing)
			{
				context.imageSmoothingEnabled = true;
			}

			renderer.__popMaskObject(bitmap, false);
		}
		#end
	}
}
