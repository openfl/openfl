package openfl.display._internal;

#if !flash
import openfl.display.DisplayObject;
import openfl.display.OpenGLRenderer;
import openfl.display.Shape;
import openfl.display3D.Context3DClearMask;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.utils.ObjectPool;
#if lime
import lime.math.ARGB;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display3D.Context3D)
@:access(openfl.display.DisplayObject)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
@SuppressWarnings("checkstyle:FieldDocComment")
class Context3DDisplayObject
{
	@:noCompletion static private var __opaqueBackgroundShape:Shape;

	public static inline function render(displayObject:DisplayObject, renderer:OpenGLRenderer):Void
	{
		if (displayObject.__graphics == null || !displayObject.__renderable || displayObject.__worldAlpha <= 0) return;

		Context3DShape.render(displayObject, renderer);
	}

	public static function renderDrawable(displayObject:DisplayObject, renderer:OpenGLRenderer):Void
	{
		renderer.__updateCacheBitmap(displayObject, false);

		if (displayObject.opaqueBackground != null
			&& !displayObject.__isCacheBitmapRender
			&& displayObject.width > 0
			&& displayObject.height > 0)
		{
			if (!renderer.__cleared)
			{
				renderer.__clear();
			}

			renderer.__setBlendMode(displayObject.__worldBlendMode);
			renderer.__pushMaskObject(displayObject);

			var context = renderer.__context3D;

			var rect = Rectangle.__pool.get();
			var renderTransform = displayObject.__getRenderTransform();

			if (__opaqueBackgroundShape == null)
			{
				__opaqueBackgroundShape = new Shape();
				__opaqueBackgroundShape.__renderable = true;
			}

			var shape = __opaqueBackgroundShape;
			shape.graphics.clear();
			shape.graphics.beginFill(displayObject.opaqueBackground);

			// Pixel offset fix for axis-aligned transform when bounds.x is resting perfectly between 2 pixel centers
			// if ((renderTransform.a * renderTransform.b == 0) && (renderTransform.c * renderTransform.d == 0))
			// {
			// 	displayObject.__getRenderBounds(rect, renderTransform);
			// 	if (Math.abs(rect.x % 1) == 0.5) rect.x += 0.01;
			// 	shape.__renderTransform.copyFrom(Matrix.__identity);
			// }
			// else
			// {
			displayObject.__getRenderBounds(rect, Matrix.__identity);
			shape.__renderTransform.copyFrom(renderTransform);
			// }
			shape.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);

			Context3DDisplayObject.render(shape, renderer);

			renderer.__popMaskObject(displayObject);

			Rectangle.__pool.release(rect);
		}

		if (displayObject.__cacheBitmap != null && !displayObject.__isCacheBitmapRender)
		{
			Context3DBitmap.render(displayObject.__cacheBitmap, renderer);
		}
		else
		{
			Context3DDisplayObject.render(displayObject, renderer);
		}

		renderer.__renderEvent(displayObject);
	}

	public static function renderDrawableMask(displayObject:DisplayObject, renderer:OpenGLRenderer):Void
	{
		if (displayObject.__graphics != null)
		{
			Context3DShape.renderMask(displayObject, renderer);
		}
	}

	public static inline function renderMask(displayObject:DisplayObject, renderer:OpenGLRenderer):Void
	{
		if (displayObject.__graphics != null)
		{
			Context3DShape.renderMask(displayObject, renderer);
		}
	}
}
#end
