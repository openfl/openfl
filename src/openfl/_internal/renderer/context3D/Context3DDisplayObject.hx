package openfl._internal.renderer.context3D;

#if openfl_gl
import openfl._internal.backend.math.ARGB;
import openfl.display3D.Context3DClearMask;
import openfl.display.DisplayObject;
import openfl.geom.Rectangle;

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
	public static inline function render(displayObject:DisplayObject, renderer:Context3DRenderer):Void
	{
		if (displayObject.opaqueBackground == null && displayObject.__graphics == null) return;
		if (!displayObject.__renderable || displayObject.__worldAlpha <= 0) return;

		if (displayObject.opaqueBackground != null
			&& !displayObject.__isCacheBitmapRender
			&& displayObject.width > 0
			&& displayObject.height > 0)
		{
			#if !disable_batcher
			renderer.batcher.flush();
			#end

			renderer.__setBlendMode(displayObject.__worldBlendMode);
			renderer.__pushMaskObject(displayObject);

			var context = renderer.context3D;

			var rect = Rectangle.__pool.get();
			rect.setTo(0, 0, displayObject.width, displayObject.height);
			renderer.__pushMaskRect(rect, displayObject.__renderTransform);

			var color:ARGB = (displayObject.opaqueBackground : ARGB);
			context.clear(color.r / 0xFF, color.g / 0xFF, color.b / 0xFF, 1, 0, 0, Context3DClearMask.COLOR);

			renderer.__popMaskRect();
			renderer.__popMaskObject(displayObject);

			Rectangle.__pool.release(rect);
		}

		if (displayObject.__graphics != null)
		{
			Context3DShape.render(displayObject, renderer);
		}
	}

	public static inline function renderMask(displayObject:DisplayObject, renderer:Context3DRenderer):Void
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
