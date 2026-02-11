package openfl.display._internal;

#if !flash
import openfl.display.DisplayObject;
import openfl.display.DOMRenderer;
import openfl.geom.Rectangle;
import openfl.geom.Matrix;
#if (js && html5)
import js.Browser;
#end

@:access(openfl.display.DisplayObject)
@:access(openfl.geom.Rectangle)
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
			if (displayObject.__opaqueBackgroundElement == null)
			{
				displayObject.__opaqueBackgroundElement = js.Browser.document.createElement("div");
				renderer.element.appendChild(displayObject.__opaqueBackgroundElement);
				var style = displayObject.__opaqueBackgroundElement.style;
				style.left = "0";
				style.top = "0";
				style.position = "absolute";
				style.setProperty(renderer.__transformOriginProperty, "0 0 0", null);
			}

			var rect = Rectangle.__pool.get();
			var matrix = Matrix.__pool.get();

			displayObject.__getBounds(rect, Matrix.__identity);

			matrix.translate(rect.x, rect.y);
			matrix.concat(displayObject.__getRenderTransform());

			var style = displayObject.__opaqueBackgroundElement.style;
			style.width = rect.width + "px";
			style.height = rect.height + "px";
			style.setProperty(renderer.__transformProperty, matrix.to3DString(renderer.__roundPixels), null);

			Rectangle.__pool.release(rect);
			Matrix.__pool.release(matrix);

			style.zIndex = Std.string(renderer.__z);

			var bg = displayObject.opaqueBackground;
			if (bg != null)
			{
				var r:UInt = (bg & 0xFF0000) >>> 16;
				var g:UInt = (bg & 0x00FF00) >>> 8;
				var b:UInt = (bg & 0x0000FF);
				style.backgroundColor = "rgb(" + r + ", " + g + ", " + b + ")";
			}
			else if (style.backgroundColor != "")
			{
				style.removeProperty("background-color");
			}

			// if (displayObject.__worldClip != null)
			// {
			// 	var clip = displayObject.__worldClip;
			// 	style.setProperty("clip", "rect(" + clip.y + "px, " + clip.right + "px, " + clip.bottom + "px, " + clip.x + "px)", null);
			// }
			// else if (style.clip != "")
			// {
			// 	style.removeProperty("clip");
			// }
		}
		else
		{
			if (displayObject.__opaqueBackgroundElement != null)
			{
				renderer.element.removeChild(displayObject.__opaqueBackgroundElement);
				displayObject.__opaqueBackgroundElement = null;
			}
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
#end
