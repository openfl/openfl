package openfl._internal.renderer.dom;

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
		if (displayObject.__renderData.cacheBitmap != null)
		{
			DOMBitmap.clear(displayObject.__renderData.cacheBitmap, renderer);
		}
		DOMShape.clear(displayObject, renderer);
		#end
	}

	public static inline function render(displayObject:DisplayObject, renderer:DOMRenderer):Void
	{
		#if openfl_html5
		// if (displayObject.opaqueBackground == null && displayObject.__graphics == null) return;
		// if (!displayObject.__renderable || displayObject.__worldAlpha <= 0) return;

		if (displayObject.opaqueBackground != null
			&& !displayObject.__renderData.isCacheBitmapRender
			&& displayObject.width > 0
			&& displayObject.height > 0)
		{
			// renderer.__pushMaskObject (displayObject);

			// TODO: opaqueBackground using DIV element

			// renderer.__popMaskObject (displayObject);
		}

		DOMShape.render(displayObject, renderer);
		#end
	}
}
#end
