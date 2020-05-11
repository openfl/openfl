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
		if (bitmap._.__image != null)
		{
			renderer.element.removeChild(bitmap._.__image);
			bitmap._.__image = null;
			bitmap._.__renderData.style = null;
		}

		if (bitmap._.__renderData.canvas != null)
		{
			renderer.element.removeChild(bitmap._.__renderData.canvas);
			bitmap._.__renderData.canvas = null;
			bitmap._.__renderData.style = null;
		}
		#end
	}

	public static inline function render(bitmap:Bitmap, renderer:DOMRenderer):Void
	{
		#if openfl_html5
		if (bitmap.stage != null && bitmap._.__worldVisible && bitmap._.__renderable && bitmap._.__bitmapData != null && bitmap._.__bitmapData._.__isValid
			&& bitmap._.__bitmapData.readable)
		{
			renderer._.__pushMaskObject(bitmap);

			if (bitmap._.__bitmapData._.__getJSImage() != null)
			{
				renderImage(bitmap, renderer);
			}
			else
			{
				renderCanvas(bitmap, renderer);
			}

			renderer._.__popMaskObject(bitmap);
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
		if (bitmap._.__image != null)
		{
			renderer.element.removeChild(bitmap._.__image);
			bitmap._.__image = null;
		}

		if (bitmap._.__renderData.canvas == null)
		{
			bitmap._.__renderData.canvas = cast Browser.document.createElement("canvas");
			bitmap._.__renderData.context = bitmap._.__renderData.canvas.getContext("2d");
			bitmap._.__imageVersion = -1;

			if (!renderer._.__allowSmoothing || !bitmap.smoothing)
			{
				bitmap._.__renderData.context.imageSmoothingEnabled = false;
			}

			renderer._.__initializeElement(bitmap, bitmap._.__renderData.canvas);
		}

		if (bitmap._.__imageVersion != bitmap._.__bitmapData._.__getVersion())
		{
			// Next line is workaround, to fix rendering bug in Chrome 59 (https://vimeo.com/222938554)
			bitmap._.__renderData.canvas.width = bitmap._.__bitmapData.width + 1;

			bitmap._.__renderData.canvas.width = bitmap._.__bitmapData.width;
			bitmap._.__renderData.canvas.height = bitmap._.__bitmapData.height;

			bitmap._.__renderData.context.drawImage(bitmap._.__bitmapData._.__getCanvas(), 0, 0);
			bitmap._.__imageVersion = bitmap._.__bitmapData._.__getVersion();
		}

		renderer._.__updateClip(bitmap);
		renderer._.__applyStyle(bitmap, true, true, true);
		#end
	}

	public static function renderImage(bitmap:Bitmap, renderer:DOMRenderer):Void
	{
		#if openfl_html5
		if (bitmap._.__renderData.canvas != null)
		{
			renderer.element.removeChild(bitmap._.__renderData.canvas);
			bitmap._.__renderData.canvas = null;
		}

		if (bitmap._.__image == null)
		{
			bitmap._.__image = cast Browser.document.createElement("img");
			bitmap._.__image.crossOrigin = "Anonymous";
			bitmap._.__image.src = bitmap._.__bitmapData._.__getJSImage().src;
			renderer._.__initializeElement(bitmap, bitmap._.__image);
		}

		renderer._.__updateClip(bitmap);
		renderer._.__applyStyle(bitmap, true, true, true);
		#end
	}
}
#end
