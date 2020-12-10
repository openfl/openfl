package openfl.display._internal;

import openfl.display.CairoRenderer;
import openfl.display.DisplayObject;
#if lime
import lime.math.ARGB;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.DisplayObject)
@:access(openfl.geom.Matrix)
@SuppressWarnings("checkstyle:FieldDocComment")
class CairoDisplayObject
{
	public static function render(displayObject:DisplayObject, renderer:CairoRenderer):Void
	{
		#if lime_cairo
		if (displayObject.opaqueBackground == null && displayObject.__graphics == null) return;
		if (!displayObject.__renderable) return;

		var alpha = renderer.__getAlpha(displayObject.__worldAlpha);
		if (alpha <= 0) return;

		if (displayObject.opaqueBackground != null
			&& !displayObject.__isCacheBitmapRender
			&& displayObject.width > 0
			&& displayObject.height > 0)
		{
			var cairo = renderer.cairo;

			renderer.__setBlendMode(displayObject.__worldBlendMode);
			renderer.__pushMaskObject(displayObject);

			renderer.applyMatrix(displayObject.__renderTransform, cairo);

			var color:ARGB = (displayObject.opaqueBackground : ARGB);
			cairo.setSourceRGB(color.r / 0xFF, color.g / 0xFF, color.b / 0xFF);
			cairo.rectangle(0, 0, displayObject.width, displayObject.height);
			cairo.fill();

			renderer.__popMaskObject(displayObject);
		}

		if (displayObject.__graphics != null)
		{
			CairoShape.render(displayObject, renderer);
		}
		#end
	}

	public static inline function renderDrawable(displayObject:DisplayObject, renderer:CairoRenderer):Void
	{
		#if lime_cairo
		renderer.__updateCacheBitmap(displayObject, /*!__worldColorTransform.__isDefault ()*/ false);

		if (displayObject.__cacheBitmap != null && !displayObject.__isCacheBitmapRender)
		{
			CairoBitmap.render(displayObject.__cacheBitmap, renderer);
		}
		else
		{
			CairoDisplayObject.render(displayObject, renderer);
		}

		renderer.__renderEvent(displayObject);
		#end
	}

	public static inline function renderDrawableMask(displayObject:DisplayObject, renderer:CairoRenderer):Void
	{
		#if lime_cairo
		if (displayObject.__graphics != null)
		{
			CairoGraphics.renderMask(displayObject.__graphics, renderer);
		}
		#end
	}
}
