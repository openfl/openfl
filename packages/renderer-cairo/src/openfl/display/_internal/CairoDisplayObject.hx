package openfl.display._internal;

#if openfl_cairo
import lime.math.ARGB;
import openfl.display.DisplayObject;

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
		if (displayObject.opaqueBackground == null && (displayObject._ : _DisplayObject).__graphics == null) return;
		if (!(displayObject._ : _DisplayObject).__renderable) return;

		var alpha = (renderer._ : _CairoRenderer).__getAlpha((displayObject._ : _DisplayObject).__worldAlpha);
		if (alpha <= 0) return;

		if (displayObject.opaqueBackground != null
			&& !(displayObject._ : _DisplayObject).__renderData.isCacheBitmapRender && displayObject.width > 0 && displayObject.height > 0)
		{
			var cairo = renderer.cairo;

			(renderer._ : _CairoRenderer).__setBlendMode((displayObject._ : _DisplayObject).__worldBlendMode);
			(renderer._ : _CairoRenderer).__pushMaskObject(displayObject);

			renderer.applyMatrix((displayObject._ : _DisplayObject).__renderTransform, cairo);

			var color:ARGB = (displayObject.opaqueBackground : ARGB);
			cairo.setSourceRGB(color.r / 0xFF, color.g / 0xFF, color.b / 0xFF);
			cairo.rectangle(0, 0, displayObject.width, displayObject.height);
			cairo.fill();

			(renderer._ : _CairoRenderer).__popMaskObject(displayObject);
		}

		if ((displayObject._ : _DisplayObject).__graphics != null)
		{
			CairoShape.render(displayObject, renderer);
		}
	}
}
#end
