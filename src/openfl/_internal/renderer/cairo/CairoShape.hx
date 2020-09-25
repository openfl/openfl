package openfl._internal.renderer.cairo;

import lime.graphics.cairo.CairoExtend;
import lime.graphics.cairo.CairoFilter;
import lime.graphics.cairo.CairoPattern;
import lime.math.Matrix3;
import openfl.display.CairoRenderer;
import openfl.display.DisplayObject;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl._internal.renderer.cairo.CairoGraphics)
@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
@SuppressWarnings("checkstyle:FieldDocComment")
class CairoShape
{
	private static var sourceTransform:Matrix3 = new Matrix3();

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

			var cairo = renderer.cairo;

			if (cairo != null && graphics.__visible && graphics.__width >= 1 && graphics.__height >= 1)
			{
				var localTransform = shape.__transform;
				var scale9Grid = shape.__scale9Grid;

				renderer.__setBlendMode(shape.__worldBlendMode);
				renderer.__pushMaskObject(shape);

				if (scale9Grid != null && localTransform.b == 0 && localTransform.c == 0)
				{
					var sourceTransform = graphics.__renderTransform;
					var transform = graphics.__worldTransform;

					var tempMatrix3 = CairoGraphics.tempMatrix3;
					tempMatrix3.identity();

					var tileRect = Rectangle.__pool.get();
					var tileTransform = Matrix.__pool.get();

					var fillPattern = CairoPattern.createForSurface(graphics.__cairo.target);
					fillPattern.filter = (CairoGraphics.allowSmoothing) ? CairoFilter.GOOD : CairoFilter.NEAREST;
					fillPattern.extend = CairoExtend.NONE;

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

						// cairo.matrix = tileTransform.__toMatrix3();
						renderer.applyMatrix(tileTransform, cairo);

						tempMatrix3.tx = tileRect.x;
						tempMatrix3.ty = tileRect.y;
						fillPattern.matrix = tempMatrix3;
						cairo.source = fillPattern;

						cairo.save();

						cairo.newPath();
						cairo.rectangle(0, 0, tileRect.width, tileRect.height);
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

					Rectangle.__pool.release(tileRect);
					Matrix.__pool.release(tileTransform);
				}

				renderer.__popMaskObject(shape);
			}
		}
		#end
	}
}
