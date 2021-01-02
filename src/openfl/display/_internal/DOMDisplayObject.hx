package openfl.display._internal;

import openfl.display.DisplayObject;
import openfl.display.DOMRenderer;

@:access(openfl.display.DisplayObject)
@:access(openfl.geom.Matrix)
@SuppressWarnings("checkstyle:FieldDocComment")
class DOMDisplayObject
{
	public static function clear(displayObject:DisplayObject, renderer:DOMRenderer):Void
	{
		#if (js && html5)
		if (displayObject.__cacheBitmap != null)
		{
			DOMBitmap.clear(displayObject.__cacheBitmap, renderer);
		}
		DOMShape.clear(displayObject, renderer);
		#end
	}

	public static inline function render(displayObject:DisplayObject, renderer:DOMRenderer):Void
	{
		#if (js && html5)
		// if (displayObject.opaqueBackground == null && displayObject.__graphics == null) return;
		// if (!displayObject.__renderable || displayObject.__worldAlpha <= 0) return;

		if (displayObject.opaqueBackground != null
			&& !displayObject.__isCacheBitmapRender
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

	public static function renderDrawable(displayObject:DisplayObject, renderer:DOMRenderer):Void
	{
		renderer.__updateCacheBitmap(displayObject, /*!__worldColorTransform.__isDefault ()*/ false);

		if (displayObject.__cacheBitmap != null && !displayObject.__isCacheBitmapRender)
		{
			renderer.__renderDrawableClear(displayObject);
			displayObject.__cacheBitmap.stage = displayObject.stage;

			DOMBitmap.render(displayObject.__cacheBitmap, renderer);
		}
		else
		{
			DOMDisplayObject.render(displayObject, renderer);
		}

		renderer.__renderEvent(displayObject);
	}

	public static function renderDrawableClear(displayObject:DisplayObject, renderer:DOMRenderer):Void
	{
		DOMDisplayObject.clear(displayObject, renderer);
	}
}
