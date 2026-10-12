package openfl.display._internal;

#if !flash
import openfl.display._internal.CairoTextField;
import openfl.display._internal.CanvasTextField;
import openfl.display.OpenGLRenderer;
import openfl.text.TextField;

#if !openfl_debug
@:fileXml(' tags="haxe,release" ')
@:noDebug
#end
@:access(openfl.display.Graphics)
@:access(openfl.text.TextField)
@SuppressWarnings("checkstyle:FieldDocComment")
class Context3DTextField
{
	public static function render(textField:TextField, renderer:OpenGLRenderer):Void
	{
		renderer.__softwareRenderer.__pixelRatio = __computePixelRatio(renderer);

		#if (js && html5)
		CanvasTextField.render(textField, cast renderer.__softwareRenderer, textField.__worldTransform);
		#elseif lime_cairo
		CairoTextField.render(textField, cast renderer.__softwareRenderer, textField.__worldTransform);
		#end
		textField.__graphics.__hardwareDirty = false;
	}

	/**
		Effective pixel ratio for rasterizing the text bitmap.

		`renderer.__pixelRatio` is `window.scale` only — it ignores any scale
		applied higher up in the display tree (e.g. a parent container scaled
		by 2x) and any draw-time matrix scaling (e.g. `BitmapData.draw(text,
		batchMatrix)` where batchMatrix is a 2x video-export transform). When
		the text is later composited at that effective scale, a 1x bitmap is
		upscaled and looks blurry.

		Reading the scale magnitude from `renderer.__worldTransform` (which is
		the full effective transform for the current draw) lets us rasterize
		at the resolution the text will actually be displayed. We take the
		max of window.scale and the world transform scale so a downscaling
		transform doesn't reduce text rasterization below the device DPI.
	**/
	@:noCompletion private static inline function __computePixelRatio(renderer:OpenGLRenderer):Float
	{
		var wt = renderer.__worldTransform;
		if (wt == null) return renderer.__pixelRatio;
		var sx = Math.sqrt(wt.a * wt.a + wt.b * wt.b);
		var sy = Math.sqrt(wt.c * wt.c + wt.d * wt.d);
		var wtScale = sx > sy ? sx : sy;
		return wtScale > renderer.__pixelRatio ? wtScale : renderer.__pixelRatio;
	}

	public static function renderDrawable(textField:TextField, renderer:OpenGLRenderer):Void
	{
		renderer.__updateCacheBitmap(textField, false);

		if (textField.__cacheBitmap != null && !textField.__isCacheBitmapRender)
		{
			Context3DBitmap.render(textField.__cacheBitmap, renderer);
		}
		else
		{
			Context3DTextField.render(textField, renderer);
			Context3DDisplayObject.render(textField, renderer);
		}

		renderer.__renderEvent(textField);
	}

	public static function renderDrawableMask(textField:TextField, renderer:OpenGLRenderer):Void
	{
		Context3DTextField.renderMask(textField, renderer);
		Context3DDisplayObject.renderDrawableMask(textField, renderer);
	}

	public static function renderMask(textField:TextField, renderer:OpenGLRenderer):Void
	{
		#if (js && html5)
		CanvasTextField.render(textField, cast renderer.__softwareRenderer, textField.__worldTransform);
		#elseif lime_cairo
		CairoTextField.render(textField, cast renderer.__softwareRenderer, textField.__worldTransform);
		#end
		textField.__graphics.__hardwareDirty = false;
	}
}
#end
