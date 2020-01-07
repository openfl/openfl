package openfl._internal.renderer.dom;

#if openfl_html5
import js.Browser;
import openfl.display.Bitmap;

@:access(lime.graphics.ImageBuffer)
@:access(openfl._internal.backend.lime_standalone.ImageBuffer)
@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)
@SuppressWarnings("checkstyle:FieldDocComment")
class DOMBitmap
{
	public static function clear(bitmap:Bitmap, renderer:DOMRenderer):Void
	{
		#if openfl_html5
		if (bitmap.__image != null)
		{
			renderer.element.removeChild(bitmap.__image);
			bitmap.__image = null;
			bitmap.__renderData.style = null;
		}

		if (bitmap.__renderData.canvas != null)
		{
			renderer.element.removeChild(bitmap.__renderData.canvas);
			bitmap.__renderData.canvas = null;
			bitmap.__renderData.style = null;
		}
		#end
	}

	public static inline function render(bitmap:Bitmap, renderer:DOMRenderer):Void
	{
		#if openfl_html5
		if (bitmap.stage != null && bitmap.__worldVisible && bitmap.__renderable && bitmap.__bitmapData != null && bitmap.__bitmapData.__isValid
			&& bitmap.__bitmapData.readable)
		{
			renderer.__pushMaskObject(bitmap);

			if (bitmap.__bitmapData.__getJSImage() != null)
			{
				renderImage(bitmap, renderer);
			}
			else
			{
				renderCanvas(bitmap, renderer);
			}

			renderer.__popMaskObject(bitmap);
		}
		else
		{
			clear(bitmap, renderer);
		}
		#end
	}

	private static function renderCanvas(bitmap:Bitmap, renderer:DOMRenderer):Void
	{
		#if (lime && openfl_html5)
		if (bitmap.__image != null)
		{
			renderer.element.removeChild(bitmap.__image);
			bitmap.__image = null;
		}

		if (bitmap.__renderData.canvas == null)
		{
			bitmap.__renderData.canvas = cast Browser.document.createElement("canvas");
			bitmap.__renderData.context = bitmap.__renderData.canvas.getContext("2d");
			bitmap.__imageVersion = -1;

			if (!renderer.__allowSmoothing || !bitmap.smoothing)
			{
				bitmap.__renderData.context.imageSmoothingEnabled = false;
			}

			renderer.__initializeElement(bitmap, bitmap.__renderData.canvas);
		}

		if (bitmap.__imageVersion != bitmap.__bitmapData.__getVersion())
		{
			// Next line is workaround, to fix rendering bug in Chrome 59 (https://vimeo.com/222938554)
			bitmap.__renderData.canvas.width = bitmap.__bitmapData.width + 1;

			bitmap.__renderData.canvas.width = bitmap.__bitmapData.width;
			bitmap.__renderData.canvas.height = bitmap.__bitmapData.height;

			bitmap.__renderData.context.drawImage(bitmap.__bitmapData.__getCanvas(), 0, 0);
			bitmap.__imageVersion = bitmap.__bitmapData.__getVersion();
		}

		renderer.__updateClip(bitmap);
		renderer.__applyStyle(bitmap, true, true, true);
		#end
	}

	private static function renderImage(bitmap:Bitmap, renderer:DOMRenderer):Void
	{
		#if openfl_html5
		if (bitmap.__renderData.canvas != null)
		{
			renderer.element.removeChild(bitmap.__renderData.canvas);
			bitmap.__renderData.canvas = null;
		}

		if (bitmap.__image == null)
		{
			bitmap.__image = cast Browser.document.createElement("img");
			bitmap.__image.crossOrigin = "Anonymous";
			bitmap.__image.src = bitmap.__bitmapData.__getJSImage().src;
			renderer.__initializeElement(bitmap, bitmap.__image);
		}

		renderer.__updateClip(bitmap);
		renderer.__applyStyle(bitmap, true, true, true);
		#end
	}
}
#end
