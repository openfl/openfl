package openfl.display._internal;

#if openfl_html5
import openfl.display._CanvasRenderer;
import openfl.display.DisplayObject;
import openfl.display._DisplayObject;
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
		if (displayObject.opaqueBackground == null && (displayObject._ : _DisplayObject).__graphics == null) return;
		if (!(displayObject._ : _DisplayObject).__renderable) return;

		var alpha = (renderer._ : _CanvasRenderer).__getAlpha((displayObject._ : _DisplayObject).__worldAlpha);
		if (alpha <= 0) return;

		if (displayObject.opaqueBackground != null
			&& !(displayObject._ : _DisplayObject).__renderData.isCacheBitmapRender && displayObject.width > 0 && displayObject.height > 0)
		{
			(renderer._ : _CanvasRenderer).__setBlendMode((displayObject._ : _DisplayObject).__worldBlendMode);
			(renderer._ : _CanvasRenderer).__pushMaskObject(displayObject);

			var context = renderer.context;

			renderer.setTransform((displayObject._ : _DisplayObject).__renderTransform, context);

			var color:ARGB = (displayObject.opaqueBackground : ARGB);
			context.fillStyle = 'rgb(${color.r},${color.g},${color.b})';
			context.fillRect(0, 0, displayObject.width, displayObject.height);

			(renderer._ : _CanvasRenderer).__popMaskObject(displayObject);
		}

		if ((displayObject._ : _DisplayObject).__graphics != null)
		{
			CanvasShape.render(displayObject, renderer);
		}
		#end
	}
}
#end
