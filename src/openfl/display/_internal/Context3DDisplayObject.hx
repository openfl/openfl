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
	@:noCompletion static private var __opaqueBackgroundShapes = new ObjectPool<Shape>(function() return new Shape());

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

			displayObject.__getRenderBounds(rect, Matrix.__identity);

			var rotated = displayObject.__renderTransform.b != 0 || displayObject.__renderTransform.c != 0;
			if (rotated)
			{
				var shape = __opaqueBackgroundShapes.get();
				shape.graphics.clear();
				shape.graphics.beginFill(displayObject.opaqueBackground);
				shape.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
				shape.__renderTransform.copyFrom(displayObject.__renderTransform);
				shape.__renderable = true;
				Context3DDisplayObject.render(shape, renderer);
				__opaqueBackgroundShapes.release(shape);
			}
			else
			{
				renderer.__pushMaskRect(rect, displayObject.__renderTransform);
				#if lime
				var color:ARGB = (displayObject.opaqueBackground : ARGB);
				context.__clear(true, color.r / 0xFF, color.g / 0xFF, color.b / 0xFF, 1, 0, 0, Context3DClearMask.COLOR);
				#end
				renderer.__popMaskRect();
			}

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
			// Context3DGraphics.renderMask (displayObject.__graphics, renderer);
			Context3DShape.renderMask(displayObject, renderer);
		}
	}

	public static inline function renderMask(displayObject:DisplayObject, renderer:OpenGLRenderer):Void
	{
		if (displayObject.opaqueBackground == null && displayObject.__graphics == null) return;

		if (displayObject.opaqueBackground != null
			&& !displayObject.__isCacheBitmapRender
			&& displayObject.width > 0
			&& displayObject.height > 0)
		{
			// var gl = renderer.__context.webgl;

			// TODO

			// var rect = Rectangle.__pool.get ();
			// rect.setTo (0, 0, displayObject.width, displayObject.height);
			// renderer.__pushMaskRect (rect, displayObject.__renderTransform);

			// var color:ARGB = (displayObject.opaqueBackground:ARGB);
			// gl.clearColor (color.r / 0xFF, color.g / 0xFF, color.b / 0xFF, 1);
			// gl.clear (gl.COLOR_BUFFER_BIT);

			// renderer.__popMaskRect ();
			// renderer.__popMaskObject (displayObject);

			// Rectangle.__pool.release (rect);
		}

		if (displayObject.__graphics != null)
		{
			Context3DShape.renderMask(displayObject, renderer);
		}
	}
}
#end
