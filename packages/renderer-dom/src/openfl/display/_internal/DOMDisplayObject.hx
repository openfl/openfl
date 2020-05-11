package openfl.display._internal;

#if openfl_html5
import openfl.display.DisplayObject;

@:access(openfl.display.DisplayObject)
@:access(openfl.geom.Matrix)
@SuppressWarnings("checkstyle:FieldDocComment")
class DOMDisplayObject
{
	public static function clear(displayObject:DisplayObject, renderer:DOMRenderer):Void
	{
		#if openfl_html5
		if (displayObject._.__renderData.cacheBitmap != null)
		{
			DOMBitmap.clear(displayObject._.__renderData.cacheBitmap, renderer);
		}
		DOMShape.clear(displayObject, renderer);
		#end
	}

	public static inline function render(displayObject:DisplayObject, renderer:DOMRenderer):Void
	{
		#if openfl_html5
		// if (displayObject.opaqueBackground == null && displayObject._.__graphics == null) return;
		// if (!displayObject._.__renderable || displayObject._.__worldAlpha <= 0) return;

		if (displayObject.opaqueBackground != null
			&& !displayObject._.__renderData.isCacheBitmapRender
			&& displayObject.width > 0
			&& displayObject.height > 0)
		{
			// renderer._.__pushMaskObject (displayObject);

			// TODO: opaqueBackground using DIV element

			// renderer._.__popMaskObject (displayObject);
		}

		DOMShape.render(displayObject, renderer);
		#end
	}
}
#end
