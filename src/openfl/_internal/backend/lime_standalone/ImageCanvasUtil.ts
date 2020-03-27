namespace openfl._internal.backend.lime_standalone; #if openfl_html5

import haxe.io.Bytes;
import js.Browser;
import openfl._internal.bindings.typedarray.UInt8Array;
import openfl.display.BitmapDataChannel;
import Point from "../geom/Point";
import Rectangle from "../geom/Rectangle";
import openfl.utils.Endian;

@: access(openfl._internal.backend.lime_standalone.ImageBuffer)
class ImageCanvasUtil
{
	public static colorTransform(image: Image, rect: Rectangle, colorMatrix: ColorMatrix): void
	{
		convertToData(image);

		ImageDataUtil.colorTransform(image, rect, colorMatrix);
	}

	public static convertToCanvas(image: Image, clear: boolean = false): void
	{
		var buffer = image.buffer;

		if (buffer.__srcImage != null)
		{
			if (buffer.__srcCanvas == null)
			{
				createCanvas(image, buffer.__srcImage.width, buffer.__srcImage.height);
				buffer.__srcContext.drawImage(buffer.__srcImage, 0, 0);
			}

			buffer.__srcImage = null;
		}
		else if (buffer.__srcCanvas == null && buffer.data != null)
		{
			image.transparent = true;
			createCanvas(image, buffer.width, buffer.height);
			createImageData(image);

			buffer.__srcContext.putImageData(buffer.__srcImageData, 0, 0);
		}
		else
		{
			if (image.type == DATA && buffer.__srcImageData != null && image.dirty)
			{
				buffer.__srcContext.putImageData(buffer.__srcImageData, 0, 0);
				image.dirty = false;
			}
		}

		if (clear)
		{
			buffer.data = null;
			buffer.__srcImageData = null;
		}
		else
		{
			if (buffer.data == null && buffer.__srcImageData != null)
			{
				buffer.data = cast buffer.__srcImageData.data;
			}
		}

		image.type = CANVAS;
	}

	public static convertToData(image: Image, clear: boolean = false): void
	{
		var buffer = image.buffer;

		if (buffer.__srcImage != null)
		{
			convertToCanvas(image);
		}

		if (buffer.__srcCanvas != null && buffer.data == null)
		{
			createImageData(image);
			if (image.type == CANVAS) image.dirty = false;
		}
		else if (image.type == CANVAS && buffer.__srcCanvas != null && image.dirty)
		{
			if (buffer.__srcImageData == null)
			{
				createImageData(image);
			}
			else
			{
				buffer.__srcImageData = buffer.__srcContext.getImageData(0, 0, buffer.width, buffer.height);
				buffer.data = new UInt8Array(cast buffer.__srcImageData.data.buffer);
			}

			image.dirty = false;
		}

		if (clear)
		{
			image.buffer.__srcCanvas = null;
			image.buffer.__srcContext = null;
		}

		image.type = DATA;
	}

	public static copyChannel(image: Image, sourceImage: Image, sourceRect: Rectangle, destPoint: Point, sourceChannel: BitmapDataChannel,
		destChannel: BitmapDataChannel): void
	{
		convertToData(sourceImage);
		convertToData(image);

		ImageDataUtil.copyChannel(image, sourceImage, sourceRect, destPoint, sourceChannel, destChannel);
	}

	public static copyPixels(image: Image, sourceImage: Image, sourceRect: Rectangle, destPoint: Point, alphaImage: Image = null,
		alphaPoint: Point = null, mergeAlpha: boolean = false): void
	{
		if (destPoint == null || destPoint.x >= image.width || destPoint.y >= image.height || sourceRect == null || sourceRect.width < 1
			|| sourceRect.height < 1)
		{
			return;
		}

		if (alphaImage != null && alphaImage.transparent)
		{
			if (alphaPoint == null) alphaPoint = new Point();

			// TODO: use faster method

			var tempData = sourceImage.clone();
			tempData.copyChannel(alphaImage, new Rectangle(sourceRect.x + alphaPoint.x, sourceRect.y + alphaPoint.y, sourceRect.width, sourceRect.height),
				new Point(sourceRect.x, sourceRect.y), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
			sourceImage = tempData;
		}

		convertToCanvas(image, true);

		if (!mergeAlpha)
		{
			if (image.transparent && sourceImage.transparent)
			{
				image.buffer.__srcContext.clearRect(destPoint.x
					+ image.offsetX, destPoint.y
				+ image.offsetY, sourceRect.width
				+ image.offsetX,
					sourceRect.height
					+ image.offsetY);
			}
		}

		convertToCanvas(sourceImage);

		if (sourceImage.buffer.src != null)
		{
			// Set default composition (just in case it is different)
			image.buffer.__srcContext.globalCompositeOperation = "source-over";

			image.buffer.__srcContext.drawImage(sourceImage.buffer.src, Std.int(sourceRect.x + sourceImage.offsetX),
				Std.int(sourceRect.y + sourceImage.offsetY), Std.int(sourceRect.width), Std.int(sourceRect.height), Std.int(destPoint.x + image.offsetX),
				Std.int(destPoint.y + image.offsetY), Std.int(sourceRect.width), Std.int(sourceRect.height));
		}

		image.dirty = true;
		image.version++;
	}

	public static createCanvas(image: Image, width: number, height: number): void
	{
		var buffer = image.buffer;

		if (buffer.__srcCanvas == null)
		{
			buffer.__srcCanvas = cast Browser.document.createElement("canvas");
			buffer.__srcCanvas.width = width;
			buffer.__srcCanvas.height = height;

			if (!image.transparent)
			{
				if (!image.transparent) buffer.__srcCanvas.setAttribute("moz-opaque", "true");
				buffer.__srcContext = untyped __js__('buffer.__srcCanvas.getContext ("2d", { alpha: false })');
			}
			else
			{
				buffer.__srcContext = buffer.__srcCanvas.getContext("2d");
			}
		}
	}

	public static createImageData(image: Image): void
	{
		var buffer = image.buffer;

		if (buffer.__srcImageData == null)
		{
			if (buffer.data == null)
			{
				buffer.__srcImageData = buffer.__srcContext.getImageData(0, 0, buffer.width, buffer.height);
			}
			else
			{
				buffer.__srcImageData = buffer.__srcContext.createImageData(buffer.width, buffer.height);
				buffer.__srcImageData.data.set(cast buffer.data);
			}

			buffer.data = new UInt8Array(cast buffer.__srcImageData.data.buffer);
		}
	}

	public static fillRect(image: Image, rect: Rectangle, color: number, format: PixelFormat): void
	{
		convertToCanvas(image);

		var r, g, b, a;

		if (format == ARGB32)
		{
			r = (color >> 16) & 0xFF;
			g = (color >> 8) & 0xFF;
			b = color & 0xFF;
			a = (image.transparent) ? (color >> 24) & 0xFF : 0xFF;
		}
		else
		{
			r = (color >> 24) & 0xFF;
			g = (color >> 16) & 0xFF;
			b = (color >> 8) & 0xFF;
			a = (image.transparent) ? color & 0xFF : 0xFF;
		}

		if (rect.x == 0 && rect.y == 0 && rect.width == image.width && rect.height == image.height)
		{
			if (image.transparent && a == 0)
			{
				image.buffer.__srcCanvas.width = image.buffer.width;
				return;
			}
		}

		if (a < 255)
		{
			image.buffer.__srcContext.clearRect(rect.x + image.offsetX, rect.y + image.offsetY, rect.width + image.offsetX, rect.height + image.offsetY);
		}

		if (a > 0)
		{
			image.buffer.__srcContext.fillStyle = 'rgba(' + r + ', ' + g + ', ' + b + ', ' + (a / 255) + ')';
			image.buffer.__srcContext.fillRect(rect.x + image.offsetX, rect.y + image.offsetY, rect.width + image.offsetX, rect.height + image.offsetY);
		}

		image.dirty = true;
		image.version++;
	}

	public static floodFill(image: Image, x: number, y: number, color: number, format: PixelFormat): void
	{
		convertToData(image);

		ImageDataUtil.floodFill(image, x, y, color, format);
	}

	public static getPixel(image: Image, x: number, y: number, format: PixelFormat): number
	{
		convertToData(image);

		return ImageDataUtil.getPixel(image, x, y, format);
	}

	public static getPixel32(image: Image, x: number, y: number, format: PixelFormat): number
	{
		convertToData(image);

		return ImageDataUtil.getPixel32(image, x, y, format);
	}

	public static getPixels(image: Image, rect: Rectangle, format: PixelFormat): Bytes
	{
		convertToData(image);

		return ImageDataUtil.getPixels(image, rect, format);
	}

	public static merge(image: Image, sourceImage: Image, sourceRect: Rectangle, destPoint: Point, redMultiplier: number, greenMultiplier: number,
		blueMultiplier: number, alphaMultiplier: number): void
	{
		convertToData(sourceImage);
		convertToData(image);

		ImageDataUtil.merge(image, sourceImage, sourceRect, destPoint, redMultiplier, greenMultiplier, blueMultiplier, alphaMultiplier);
	}

	public static resize(image: Image, newWidth: number, newHeight: number): void
	{
		var buffer = image.buffer;

		if (buffer.__srcCanvas == null)
		{
			createCanvas(image, newWidth, newHeight);
			buffer.__srcContext.drawImage(buffer.src, 0, 0, newWidth, newHeight);
		}
		else
		{
			convertToCanvas(image, true);
			var sourceCanvas = buffer.__srcCanvas;
			buffer.__srcCanvas = null;
			createCanvas(image, newWidth, newHeight);
			buffer.__srcContext.drawImage(sourceCanvas, 0, 0, newWidth, newHeight);
		}

		buffer.__srcImageData = null;
		buffer.data = null;

		image.dirty = true;
		image.version++;
	}

	public static scroll(image: Image, x: number, y: number): void
	{
		if ((x % image.width == 0) && (y % image.height == 0)) return;

		var copy = image.clone();

		convertToCanvas(image, true);

		image.buffer.__srcContext.clearRect(x, y, image.width, image.height);
		image.buffer.__srcContext.drawImage(copy.src, x, y);

		image.dirty = true;
		image.version++;
	}

	public static setPixel(image: Image, x: number, y: number, color: number, format: PixelFormat): void
	{
		convertToData(image);

		ImageDataUtil.setPixel(image, x, y, color, format);
	}

	public static setPixel32(image: Image, x: number, y: number, color: number, format: PixelFormat): void
	{
		convertToData(image);

		ImageDataUtil.setPixel32(image, x, y, color, format);
	}

	public static setPixels(image: Image, rect: Rectangle, bytePointer: BytePointer, format: PixelFormat, endian: Endian): void
	{
		convertToData(image);

		ImageDataUtil.setPixels(image, rect, bytePointer, format, endian);
	}

	public static sync(image: Image, clear: boolean): void
	{
		if (image == null) return;

		if (image.type == CANVAS && (image.buffer.__srcCanvas != null || image.buffer.data != null))
		{
			convertToCanvas(image, clear);
		}
		else if (image.type == DATA)
		{
			convertToData(image, clear);
		}
	}
}
#end
