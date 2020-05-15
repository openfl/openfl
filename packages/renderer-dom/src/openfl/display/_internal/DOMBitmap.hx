package openfl.display._internal;

#if openfl_html5
import js.Browser;
import openfl.display.Bitmap;

@:access(lime.graphics.ImageBuffer)
@:access(openfl._internal.backend.lime_standalone.ImageBuffer)
@:access(openfl.display._internal)
@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)
@SuppressWarnings("checkstyle:FieldDocComment")
class DOMBitmap
{
	public static function clear(bitmap:Bitmap, renderer:DOMRenderer):Void
	{
		#if openfl_html5
		if ((bitmap._ : _Bitmap).__image != null)
		{
			renderer.element.removeChild((bitmap._ : _Bitmap).__image);
			(bitmap._ : _Bitmap).__image = null;
			(bitmap._ : _Bitmap).__renderData.style = null;
		}

		if ((bitmap._ : _Bitmap).__renderData.canvas != null)
		{
			renderer.element.removeChild((bitmap._ : _Bitmap).__renderData.canvas);
			(bitmap._ : _Bitmap).__renderData.canvas = null;
			(bitmap._ : _Bitmap).__renderData.style = null;
		}
		#end
	}

	public static inline function render(bitmap:Bitmap, renderer:DOMRenderer):Void
	{
		#if openfl_html5
		if (bitmap.stage != null
			&& (bitmap._ : _Bitmap).__worldVisible
				&& (bitmap._ : _Bitmap).__renderable
					&& (bitmap._ : _Bitmap).__bitmapData != null
						&& ((bitmap._ : _Bitmap).__bitmapData._ : _BitmapData).__isValid && (bitmap._ : _Bitmap).__bitmapData.readable)
		{
			(renderer._ : _DOMRenderer).__pushMaskObject(bitmap);

			if (((bitmap._ : _Bitmap).__bitmapData._ : _BitmapData).__getJSImage() != null)
			{
				renderImage(bitmap, renderer);
			}
			else
			{
				renderCanvas(bitmap, renderer);
			}

				(renderer._ : _DOMRenderer).__popMaskObject(bitmap);
		}
		else
		{
			clear(bitmap, renderer);
		}
		#end
	}

	public static function renderCanvas(bitmap:Bitmap, renderer:DOMRenderer):Void
	{
		#if (lime && openfl_html5)
		if ((bitmap._ : _Bitmap).__image != null)
		{
			renderer.element.removeChild((bitmap._ : _Bitmap).__image);
			(bitmap._ : _Bitmap).__image = null;
		}

		if ((bitmap._ : _Bitmap).__renderData.canvas == null)
		{
			(bitmap._ : _Bitmap).__renderData.canvas = cast Browser.document.createElement("canvas");
			(bitmap._ : _Bitmap).__renderData.context = (bitmap._ : _Bitmap).__renderData.canvas.getContext("2d");
			(bitmap._ : _Bitmap).__imageVersion = -1;

			if (!(renderer._ : _DOMRenderer).__allowSmoothing || !bitmap.smoothing)
			{
				(bitmap._ : _Bitmap).__renderData.context.imageSmoothingEnabled = false;
			}

				(renderer._ : _DOMRenderer).__initializeElement(bitmap, (bitmap._ : _Bitmap).__renderData.canvas);
		}

		if ((bitmap._ : _Bitmap).__imageVersion != ((bitmap._ : _Bitmap).__bitmapData._ : _BitmapData).__getVersion())
		{
			// Next line is workaround, to fix rendering bug in Chrome 59 (https://vimeo.com/222938554)
			(bitmap._ : _Bitmap).__renderData.canvas.width = (bitmap._ : _Bitmap).__bitmapData.width + 1;

			(bitmap._ : _Bitmap).__renderData.canvas.width = (bitmap._ : _Bitmap).__bitmapData.width;
			(bitmap._ : _Bitmap).__renderData.canvas.height = (bitmap._ : _Bitmap).__bitmapData.height;

			(bitmap._ : _Bitmap).__renderData.context.drawImage(((bitmap._ : _Bitmap).__bitmapData._ : _BitmapData).__getCanvas(), 0, 0);
			(bitmap._ : _Bitmap).__imageVersion = ((bitmap._ : _Bitmap).__bitmapData._ : _BitmapData).__getVersion();
		}

			(renderer._ : _DOMRenderer).__updateClip(bitmap);
		(renderer._ : _DOMRenderer).__applyStyle(bitmap, true, true, true);
		#end
	}

	public static function renderImage(bitmap:Bitmap, renderer:DOMRenderer):Void
	{
		#if openfl_html5
		if ((bitmap._ : _Bitmap).__renderData.canvas != null)
		{
			renderer.element.removeChild((bitmap._ : _Bitmap).__renderData.canvas);
			(bitmap._ : _Bitmap).__renderData.canvas = null;
		}

		if ((bitmap._ : _Bitmap).__image == null)
		{
			(bitmap._ : _Bitmap).__image = cast Browser.document.createElement("img");
			(bitmap._ : _Bitmap).__image.crossOrigin = "Anonymous";
			(bitmap._ : _Bitmap).__image.src = ((bitmap._ : _Bitmap).__bitmapData._ : _BitmapData).__getJSImage().src;
			(renderer._ : _DOMRenderer).__initializeElement(bitmap, (bitmap._ : _Bitmap).__image);
		}

			(renderer._ : _DOMRenderer).__updateClip(bitmap);
		(renderer._ : _DOMRenderer).__applyStyle(bitmap, true, true, true);
		#end
	}
}
#end
