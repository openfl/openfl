package openfl.display._internal;

#if openfl_gl
import openfl.display3D.Context3DClearMask;
import openfl.display.DisplayObject;
import openfl.geom.Rectangle;
#if !lime
import openfl._internal.backend.lime_standalone.ARGB;
#else
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
	public static inline function render(displayObject:DisplayObject, renderer:Context3DRenderer):Void
	{
		if (displayObject.opaqueBackground == null && displayObject._.__graphics == null) return;
		if (!displayObject._.__renderable || displayObject._.__worldAlpha <= 0) return;

		if (displayObject.opaqueBackground != null
			&& !displayObject._.__renderData.isCacheBitmapRender
			&& displayObject.width > 0
			&& displayObject.height > 0)
		{
			#if !disable_batcher
			renderer.batcher.flush();
			#end

			renderer._.__setBlendMode(displayObject._.__worldBlendMode);
			renderer._.__pushMaskObject(displayObject);

			var context = renderer.context3D;

			var rect = _Rectangle.__pool.get();
			rect.setTo(0, 0, displayObject.width, displayObject.height);
			renderer._.__pushMaskRect(rect, displayObject._.__renderTransform);

			var color:ARGB = (displayObject.opaqueBackground : ARGB);
			context.clear(color.r / 0xFF, color.g / 0xFF, color.b / 0xFF, 1, 0, 0, Context3DClearMask.COLOR);

			renderer._.__popMaskRect();
			renderer._.__popMaskObject(displayObject);

			_Rectangle.__pool.release(rect);
		}

		if (displayObject._.__graphics != null)
		{
			Context3DShape.render(displayObject, renderer);
		}
	}

	public static inline function renderMask(displayObject:DisplayObject, renderer:Context3DRenderer):Void
	{
		if (displayObject.opaqueBackground == null && displayObject._.__graphics == null) return;

		if (displayObject.opaqueBackground != null
			&& !displayObject._.__renderData.isCacheBitmapRender
			&& displayObject.width > 0
			&& displayObject.height > 0)
		{
			// TODO

			// var rect = _Rectangle.__pool.get ();
			// rect.setTo (0, 0, displayObject.width, displayObject.height);
			// renderer._.__pushMaskRect (rect, displayObject._.__renderTransform);

			// var color:ARGB = (displayObject.opaqueBackground:ARGB);
			// gl.clearColor (color.r / 0xFF, color.g / 0xFF, color.b / 0xFF, 1);
			// gl.clear (gl.COLOR_BUFFER_BIT);

			// renderer._.__popMaskRect ();
			// renderer._.__popMaskObject (displayObject);

			// _Rectangle.__pool.release (rect);
		}

		if (displayObject._.__graphics != null)
		{
			Context3DShape.renderMask(displayObject, renderer);
		}
	}
}
#end
