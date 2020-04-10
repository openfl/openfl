import * as internal from "../../../_internal/utils/InternalAccess";
import Bitmap from "../../../display/Bitmap";
import DOMRenderer from "./DOMRenderer";

export default class DOMBitmap
{
	public static clear(bitmap: Bitmap, renderer: DOMRenderer): void
	{
		if ((<internal.Bitmap><any>bitmap).__image != null)
		{
			renderer.element.removeChild((<internal.Bitmap><any>bitmap).__image);
			(<internal.Bitmap><any>bitmap).__image = null;
			(<internal.DisplayObject><any>bitmap).__renderData.style = null;
		}

		if ((<internal.DisplayObject><any>bitmap).__renderData.canvas != null)
		{
			renderer.element.removeChild((<internal.DisplayObject><any>bitmap).__renderData.canvas);
			(<internal.DisplayObject><any>bitmap).__renderData.canvas = null;
			(<internal.DisplayObject><any>bitmap).__renderData.style = null;
		}
	}

	public static render(bitmap: Bitmap, renderer: DOMRenderer): void
	{
		if (bitmap.stage != null && (<internal.DisplayObject><any>bitmap).__worldVisible && (<internal.DisplayObject><any>bitmap).__renderable && (<internal.Bitmap><any>bitmap).__bitmapData != null && (<internal.BitmapData><any>(<internal.Bitmap><any>bitmap).__bitmapData).__isValid
			&& (<internal.Bitmap><any>bitmap).__bitmapData.readable)
		{
			renderer.__pushMaskObject(bitmap);

			if ((<internal.BitmapData><any>(<internal.Bitmap><any>bitmap).__bitmapData).__getJSImage() != null)
			{
				this.renderImage(bitmap, renderer);
			}
			else
			{
				this.renderCanvas(bitmap, renderer);
			}

			renderer.__popMaskObject(bitmap);
		}
		else
		{
			this.clear(bitmap, renderer);
		}
	}

	private static renderCanvas(bitmap: Bitmap, renderer: DOMRenderer): void
	{
		if ((<internal.Bitmap><any>bitmap).__image != null)
		{
			renderer.element.removeChild((<internal.Bitmap><any>bitmap).__image);
			(<internal.Bitmap><any>bitmap).__image = null;
		}

		if ((<internal.DisplayObject><any>bitmap).__renderData.canvas == null)
		{
			(<internal.DisplayObject><any>bitmap).__renderData.canvas = document.createElement("canvas");
			(<internal.DisplayObject><any>bitmap).__renderData.context = (<internal.DisplayObject><any>bitmap).__renderData.canvas.getContext("2d");
			(<internal.Bitmap><any>bitmap).__imageVersion = -1;

			if (!(<internal.DisplayObjectRenderer><any>renderer).__allowSmoothing || !bitmap.smoothing)
			{
				(<internal.DisplayObject><any>bitmap).__renderData.context.imageSmoothingEnabled = false;
			}

			renderer.__initializeElement(bitmap, (<internal.DisplayObject><any>bitmap).__renderData.canvas);
		}

		if ((<internal.Bitmap><any>bitmap).__imageVersion != (<internal.BitmapData><any>(<internal.Bitmap><any>bitmap).__bitmapData).__getVersion())
		{
			// Next line is workaround, to fix rendering bug in Chrome 59 (https://vimeo.com/222938554)
			(<internal.DisplayObject><any>bitmap).__renderData.canvas.width = (<internal.Bitmap><any>bitmap).__bitmapData.width + 1;

			(<internal.DisplayObject><any>bitmap).__renderData.canvas.width = (<internal.Bitmap><any>bitmap).__bitmapData.width;
			(<internal.DisplayObject><any>bitmap).__renderData.canvas.height = (<internal.Bitmap><any>bitmap).__bitmapData.height;

			(<internal.DisplayObject><any>bitmap).__renderData.context.drawImage((<internal.BitmapData><any>(<internal.Bitmap><any>bitmap).__bitmapData).__getCanvas(), 0, 0);
			(<internal.Bitmap><any>bitmap).__imageVersion = (<internal.BitmapData><any>(<internal.Bitmap><any>bitmap).__bitmapData).__getVersion();
		}

		renderer.__updateClip(bitmap);
		renderer.__applyStyle(bitmap, true, true, true);
	}

	private static renderImage(bitmap: Bitmap, renderer: DOMRenderer): void
	{
		if ((<internal.DisplayObject><any>bitmap).__renderData.canvas != null)
		{
			renderer.element.removeChild((<internal.DisplayObject><any>bitmap).__renderData.canvas);
			(<internal.DisplayObject><any>bitmap).__renderData.canvas = null;
		}

		if ((<internal.Bitmap><any>bitmap).__image == null)
		{
			(<internal.Bitmap><any>bitmap).__image = document.createElement("img");
			(<internal.Bitmap><any>bitmap).__image.crossOrigin = "Anonymous";
			(<internal.Bitmap><any>bitmap).__image.src = (<internal.BitmapData><any>(<internal.Bitmap><any>bitmap).__bitmapData).__getJSImage().src;
			renderer.__initializeElement(bitmap, (<internal.Bitmap><any>bitmap).__image);
		}

		renderer.__updateClip(bitmap);
		renderer.__applyStyle(bitmap, true, true, true);
	}
}
