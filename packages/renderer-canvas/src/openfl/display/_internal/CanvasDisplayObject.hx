package openfl.display._internal;

#if openfl_html5
import openfl.display.DisplayObject;
#if !lime
import openfl._internal.backend.lime_standalone.ARGB;
#else
import lime.math.ARGB;
#end

@:access(openfl.display.DisplayObject)
@:access(openfl.geom.Matrix)
@SuppressWarnings("checkstyle:FieldDocComment")
class CanvasDisplayObject
{
	public static inline function render(displayObject:DisplayObject, renderer:CanvasRenderer):Void
	{
		#if openfl_html5
		if (displayObject.opaqueBackground == null && displayObject._.__graphics == null) return;
		if (!displayObject._.__renderable) return;

		var alpha = renderer._.__getAlpha(displayObject._.__worldAlpha);
		if (alpha <= 0) return;

		if (displayObject.opaqueBackground != null
			&& !displayObject._.__renderData.isCacheBitmapRender
			&& displayObject.width > 0
			&& displayObject.height > 0)
		{
			renderer._.__setBlendMode(displayObject._.__worldBlendMode);
			renderer._.__pushMaskObject(displayObject);

			var context = renderer.context;

			renderer.setTransform(displayObject._.__renderTransform, context);

			var color:ARGB = (displayObject.opaqueBackground : ARGB);
			context.fillStyle = 'rgb(${color.r},${color.g},${color.b})';
			context.fillRect(0, 0, displayObject.width, displayObject.height);

			renderer._.__popMaskObject(displayObject);
		}

		if (displayObject._.__graphics != null)
		{
			CanvasShape.render(displayObject, renderer);
		}
		#end
	}
}
#end
