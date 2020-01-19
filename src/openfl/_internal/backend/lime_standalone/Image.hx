package openfl._internal.backend.lime_standalone; #if openfl_html5

import haxe.io.Bytes;
import haxe.io.BytesData;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import js.html.CanvasElement;
import js.html.ImageElement;
import js.html.Image as JSImage;
import js.Browser;
import openfl._internal.backend.lime_standalone.HTTPRequest;
import openfl._internal.bindings.typedarray.UInt8Array;
import openfl.display.BitmapDataChannel;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.utils.Endian;
import openfl.utils.Future;
import openfl.utils.Promise;

// @:autoBuild(lime._internal.macros.AssetsMacro.embedImage())
@:allow(openfl._internal.backend.lime_standalone.ImageCanvasUtil)
@:allow(openfl._internal.backend.lime_standalone.ImageDataUtil)
@:access(openfl._internal.backend.lime_standalone.ColorMatrix)
@:access(openfl._internal.backend.lime_standalone.Rectangle)
@:access(openfl._internal.backend.lime_standalone.Vector2)
@:access(openfl._internal.backend.lime_standalone.HTML5HTTPRequest)
class Image
{
	public var buffer:ImageBuffer;
	public var data(get, set):UInt8Array;
	public var dirty:Bool;
	public var format(get, set):PixelFormat;
	public var height:Int;
	public var offsetX:Int;
	public var offsetY:Int;
	public var powerOfTwo(get, set):Bool;
	public var premultiplied(get, set):Bool;
	public var rect(get, null):Rectangle;
	public var src(get, set):Dynamic;
	public var transparent(get, set):Bool;
	public var type:ImageType;
	public var version:Int;
	public var width:Int;
	public var x:Float;
	public var y:Float;

	public function new(buffer:ImageBuffer = null, offsetX:Int = 0, offsetY:Int = 0, width:Int = -1, height:Int = -1, color:Null<Int> = null,
			type:ImageType = null)
	{
		this.offsetX = offsetX;
		this.offsetY = offsetY;
		this.width = width;
		this.height = height;

		version = 0;

		if (type == null)
		{
			type = CANVAS;
		}

		this.type = type;

		if (buffer == null)
		{
			if (width > 0 && height > 0)
			{
				switch (this.type)
				{
					case CANVAS:
						this.buffer = new ImageBuffer(null, width, height);
						ImageCanvasUtil.createCanvas(this, width, height);

						if (color != null && color != 0)
						{
							fillRect(new Rectangle(0, 0, width, height), color);
						}

					case DATA:
						this.buffer = new ImageBuffer(new UInt8Array(width * height * 4), width, height);

						if (color != null && color != 0)
						{
							fillRect(new Rectangle(0, 0, width, height), color);
						}

					default:
				}
			}
		}
		else
		{
			__fromImageBuffer(buffer);
		}
	}

	public function clone():Image
	{
		if (buffer != null)
		{
			if (type == CANVAS)
			{
				ImageCanvasUtil.convertToCanvas(this);
			}
			else
			{
				ImageCanvasUtil.convertToData(this);
			}

			var image = new Image(buffer.clone(), offsetX, offsetY, width, height, null, type);
			image.version = version;
			return image;
		}
		else
		{
			return new Image(null, offsetX, offsetY, width, height, null, type);
		}
	}

	public function colorTransform(rect:Rectangle, colorMatrix:ColorMatrix):Void
	{
		rect = __clipRect(rect);
		if (buffer == null || rect == null) return;

		switch (type)
		{
			case CANVAS:
				ImageCanvasUtil.colorTransform(this, rect, colorMatrix);

			case DATA:
				ImageCanvasUtil.convertToData(this);
				ImageDataUtil.colorTransform(this, rect, colorMatrix);

			default:
		}
	}

	public function copyChannel(sourceImage:Image, sourceRect:Rectangle, destPoint:Point, sourceChannel:BitmapDataChannel, destChannel:BitmapDataChannel):Void
	{
		sourceRect = __clipRect(sourceRect);
		if (buffer == null || sourceRect == null) return;
		if (destChannel == ALPHA && !transparent) return;
		if (sourceRect.width <= 0 || sourceRect.height <= 0) return;
		if (sourceRect.x + sourceRect.width > sourceImage.width) sourceRect.width = sourceImage.width - sourceRect.x;
		if (sourceRect.y + sourceRect.height > sourceImage.height) sourceRect.height = sourceImage.height - sourceRect.y;

		switch (type)
		{
			case CANVAS:
				ImageCanvasUtil.copyChannel(this, sourceImage, sourceRect, destPoint, sourceChannel, destChannel);

			case DATA:
				ImageCanvasUtil.convertToData(this);
				ImageCanvasUtil.convertToData(sourceImage);

				ImageDataUtil.copyChannel(this, sourceImage, sourceRect, destPoint, sourceChannel, destChannel);

			default:
		}
	}

	public function copyPixels(sourceImage:Image, sourceRect:Rectangle, destPoint:Point, alphaImage:Image = null, alphaPoint:Point = null,
			mergeAlpha:Bool = false):Void
	{
		if (buffer == null || sourceImage == null) return;
		if (sourceRect.width <= 0 || sourceRect.height <= 0) return;
		if (width <= 0 || height <= 0) return;

		if (sourceRect.x + sourceRect.width > sourceImage.width) sourceRect.width = sourceImage.width - sourceRect.x;
		if (sourceRect.y + sourceRect.height > sourceImage.height) sourceRect.height = sourceImage.height - sourceRect.y;

		if (sourceRect.x < 0)
		{
			sourceRect.width += sourceRect.x;
			sourceRect.x = 0;
		}

		if (sourceRect.y < 0)
		{
			sourceRect.height += sourceRect.y;
			sourceRect.y = 0;
		}

		if (destPoint.x + sourceRect.width > width) sourceRect.width = width - destPoint.x;
		if (destPoint.y + sourceRect.height > height) sourceRect.height = height - destPoint.y;

		if (destPoint.x < 0)
		{
			sourceRect.width += destPoint.x;
			sourceRect.x -= destPoint.x;
			destPoint.x = 0;
		}

		if (destPoint.y < 0)
		{
			sourceRect.height += destPoint.y;
			sourceRect.y -= destPoint.y;
			destPoint.y = 0;
		}

		if (sourceImage == this && destPoint.x < sourceRect.right && destPoint.y < sourceRect.bottom)
		{
			// TODO: Optimize further?
			sourceImage = clone();
		}

		if (alphaImage == sourceImage && (alphaPoint == null || (alphaPoint.x == 0 && alphaPoint.y == 0)))
		{
			alphaImage = null;
			alphaPoint = null;
		}

		switch (type)
		{
			case CANVAS:
				if (alphaImage != null)
				{
					ImageCanvasUtil.convertToData(this);
					ImageCanvasUtil.convertToData(sourceImage);
					if (alphaImage != null) ImageCanvasUtil.convertToData(alphaImage);

					ImageDataUtil.copyPixels(this, sourceImage, sourceRect, destPoint, alphaImage, alphaPoint, mergeAlpha);
				}
				else
				{
					ImageCanvasUtil.convertToCanvas(this);
					ImageCanvasUtil.convertToCanvas(sourceImage);
					ImageCanvasUtil.copyPixels(this, sourceImage, sourceRect, destPoint, alphaImage, alphaPoint, mergeAlpha);
				}

			case DATA:
				ImageCanvasUtil.convertToData(this);
				ImageCanvasUtil.convertToData(sourceImage);
				if (alphaImage != null) ImageCanvasUtil.convertToData(alphaImage);

				ImageDataUtil.copyPixels(this, sourceImage, sourceRect, destPoint, alphaImage, alphaPoint, mergeAlpha);

			default:
		}
	}

	public function encode(format:ImageFileFormat = null, quality:Int = 90):Bytes
	{
		switch (format)
		{
			case null, ImageFileFormat.PNG:
				return PNG.encode(this);

			case ImageFileFormat.JPEG:
				return JPEG.encode(this, quality);

			case ImageFileFormat.BMP:
				return BMP.encode(this);

			default:
		}

		return null;
	}

	public function fillRect(rect:Rectangle, color:Int, format:PixelFormat = null):Void
	{
		rect = __clipRect(rect);
		if (buffer == null || rect == null) return;

		switch (type)
		{
			case CANVAS:
				ImageCanvasUtil.fillRect(this, rect, color, format);

			case DATA:
				ImageCanvasUtil.convertToData(this);

				if (buffer.data.length == 0) return;

				ImageDataUtil.fillRect(this, rect, color, format);

			default:
		}
	}

	public function floodFill(x:Int, y:Int, color:Int, format:PixelFormat = null):Void
	{
		if (buffer == null) return;

		switch (type)
		{
			case CANVAS:
				ImageCanvasUtil.floodFill(this, x, y, color, format);

			case DATA:
				ImageCanvasUtil.convertToData(this);

				ImageDataUtil.floodFill(this, x, y, color, format);

			default:
		}
	}

	public static function fromBase64(base64:String, type:String):Image
	{
		if (base64 == null) return null;
		var image = new Image();
		image.__fromBase64(base64, type);
		return image;
	}

	public static function fromBitmapData(bitmapData:#if flash BitmapData #else Dynamic #end):Image
	{
		if (bitmapData == null) return null;
		return bitmapData.image;
	}

	public static function fromBytes(bytes:Bytes):Image
	{
		if (bytes == null) return null;
		var image = new Image();
		if (image.__fromBytes(bytes))
		{
			return image;
		}
		else
		{
			return null;
		}
	}

	public static function fromCanvas(canvas:CanvasElement):Image
	{
		if (canvas == null) return null;
		var buffer = new ImageBuffer(null, canvas.width, canvas.height);
		buffer.src = canvas;
		var image = new Image(buffer);

		image.type = CANVAS;
		return image;
	}

	public static function fromFile(path:String):Image
	{
		if (path == null) return null;
		var image = new Image();
		if (image.__fromFile(path))
		{
			return image;
		}
		else
		{
			return null;
		}
	}

	public static function fromImageElement(image:ImageElement):Image
	{
		if (image == null) return null;
		var buffer = new ImageBuffer(null, image.width, image.height);
		buffer.src = image;
		var _image = new Image(buffer);

		_image.type = CANVAS;
		return _image;
	}

	public function getColorBoundsRect(mask:Int, color:Int, findColor:Bool = true, format:PixelFormat = null):Rectangle
	{
		if (buffer == null) return null;

		switch (type)
		{
			case CANVAS:
				ImageCanvasUtil.convertToData(this);

				return ImageDataUtil.getColorBoundsRect(this, mask, color, findColor, format);

			case DATA:
				return ImageDataUtil.getColorBoundsRect(this, mask, color, findColor, format);

			default:
				return null;
		}
	}

	public function getPixel(x:Int, y:Int, format:PixelFormat = null):Int
	{
		if (buffer == null || x < 0 || y < 0 || x >= width || y >= height) return 0;

		switch (type)
		{
			case CANVAS:
				return ImageCanvasUtil.getPixel(this, x, y, format);

			case DATA:
				ImageCanvasUtil.convertToData(this);

				return ImageDataUtil.getPixel(this, x, y, format);

			default:
				return 0;
		}
	}

	public function getPixel32(x:Int, y:Int, format:PixelFormat = null):Int
	{
		if (buffer == null || x < 0 || y < 0 || x >= width || y >= height) return 0;

		switch (type)
		{
			case CANVAS:
				return ImageCanvasUtil.getPixel32(this, x, y, format);

			case DATA:
				ImageCanvasUtil.convertToData(this);

				return ImageDataUtil.getPixel32(this, x, y, format);

			default:
				return 0;
		}
	}

	public function getPixels(rect:Rectangle, format:PixelFormat = null):Bytes
	{
		if (buffer == null) return null;

		switch (type)
		{
			case CANVAS:
				return ImageCanvasUtil.getPixels(this, rect, format);

			case DATA:
				ImageCanvasUtil.convertToData(this);

				return ImageDataUtil.getPixels(this, rect, format);

			default:
				return null;
		}
	}

	public static function loadFromBase64(base64:String, type:String):Future<Image>
	{
		if (base64 == null || type == null) return Future.withValue(null);

		return HTML5HTTPRequest.loadImage("data:" + type + ";base64," + base64);
	}

	public static function loadFromBytes(bytes:Bytes):Future<Image>
	{
		if (bytes == null) return Future.withValue(null);

		var type = "";

		if (__isPNG(bytes))
		{
			type = "image/png";
		}
		else if (__isJPG(bytes))
		{
			type = "image/jpeg";
		}
		else if (__isGIF(bytes))
		{
			type = "image/gif";
		}
		else if (__isWebP(bytes))
		{
			type = "image/webp";
		}
		else
		{
			// throw "Image tried to read PNG/JPG Bytes, but found an invalid header.";
			return Future.withValue(null);
		}

		return HTML5HTTPRequest.loadImageFromBytes(bytes, type);
	}

	public static function loadFromFile(path:String):Future<Image>
	{
		if (path == null) return Future.withValue(null);
		return HTML5HTTPRequest.loadImage(path);
	}

	public function merge(sourceImage:Image, sourceRect:Rectangle, destPoint:Point, redMultiplier:Int, greenMultiplier:Int, blueMultiplier:Int,
			alphaMultiplier:Int):Void
	{
		if (buffer == null || sourceImage == null) return;

		switch (type)
		{
			case CANVAS:
				ImageCanvasUtil.convertToCanvas(this);
				ImageCanvasUtil.merge(this, sourceImage, sourceRect, destPoint, redMultiplier, greenMultiplier, blueMultiplier, alphaMultiplier);

			case DATA:
				#if (js && html5)
				ImageCanvasUtil.convertToData(this);
				ImageCanvasUtil.convertToData(sourceImage);
				#end

				ImageDataUtil.merge(this, sourceImage, sourceRect, destPoint, redMultiplier, greenMultiplier, blueMultiplier, alphaMultiplier);

			default:
				return;
		}
	}

	public function resize(newWidth:Int, newHeight:Int):Void
	{
		switch (type)
		{
			case CANVAS:
				ImageCanvasUtil.resize(this, newWidth, newHeight);

			case DATA:
				ImageDataUtil.resize(this, newWidth, newHeight);

			default:
		}

		buffer.width = newWidth;
		buffer.height = newHeight;

		offsetX = 0;
		offsetY = 0;
		width = newWidth;
		height = newHeight;
	}

	public function scroll(x:Int, y:Int):Void
	{
		if (buffer == null) return;

		switch (type)
		{
			case CANVAS:
				ImageCanvasUtil.scroll(this, x, y);

			case DATA:
				copyPixels(this, rect, new Point(x, y));

			default:
		}
	}

	public function setPixel(x:Int, y:Int, color:Int, format:PixelFormat = null):Void
	{
		if (buffer == null || x < 0 || y < 0 || x >= width || y >= height) return;

		switch (type)
		{
			case CANVAS:
				ImageCanvasUtil.setPixel(this, x, y, color, format);

			case DATA:
				ImageCanvasUtil.convertToData(this);
				ImageDataUtil.setPixel(this, x, y, color, format);

			default:
		}
	}

	public function setPixel32(x:Int, y:Int, color:Int, format:PixelFormat = null):Void
	{
		if (buffer == null || x < 0 || y < 0 || x >= width || y >= height) return;

		switch (type)
		{
			case CANVAS:
				ImageCanvasUtil.setPixel32(this, x, y, color, format);

			case DATA:
				ImageCanvasUtil.convertToData(this);
				ImageDataUtil.setPixel32(this, x, y, color, format);

			default:
		}
	}

	public function setPixels(rect:Rectangle, bytePointer:BytePointer, format:PixelFormat = null, endian:Endian = null):Void
	{
		rect = __clipRect(rect);
		if (buffer == null || rect == null) return;
		if (endian == null) endian = BIG_ENDIAN;

		switch (type)
		{
			case CANVAS:
				ImageCanvasUtil.setPixels(this, rect, bytePointer, format, endian);

			case DATA:
				ImageCanvasUtil.convertToData(this);
				ImageDataUtil.setPixels(this, rect, bytePointer, format, endian);

			default:
		}
	}

	public function threshold(sourceImage:Image, sourceRect:Rectangle, destPoint:Point, operation:String, threshold:Int, color:Int = 0x00000000,
			mask:Int = 0xFFFFFFFF, copySource:Bool = false, format:PixelFormat = null):Int
	{
		if (buffer == null || sourceImage == null || sourceRect == null) return 0;

		switch (type)
		{
			case CANVAS, DATA:
				ImageCanvasUtil.convertToData(this);
				ImageCanvasUtil.convertToData(sourceImage);
				return ImageDataUtil.threshold(this, sourceImage, sourceRect, destPoint, operation, threshold, color, mask, copySource, format);

			default:
		}

		return 0;
	}

	@:noCompletion private function __clipRect(r:Rectangle):Rectangle
	{
		if (r == null) return null;

		if (r.x < 0)
		{
			r.width -= -r.x;
			r.x = 0;

			if (r.x + r.width <= 0) return null;
		}

		if (r.y < 0)
		{
			r.height -= -r.y;
			r.y = 0;

			if (r.y + r.height <= 0) return null;
		}

		if (r.x + r.width >= width)
		{
			r.width -= r.x + r.width - width;

			if (r.width <= 0) return null;
		}

		if (r.y + r.height >= height)
		{
			r.height -= r.y + r.height - height;

			if (r.height <= 0) return null;
		}

		return r;
	}

	@:noCompletion private function __fromBase64(base64:String, type:String, onload:Image->Void = null):Void
	{
		#if openfljs
		var image:JSImage = untyped __js__('new window.Image ()');
		#else
		var image = new JSImage();
		#end

		var image_onLoaded = function(event)
		{
			buffer = new ImageBuffer(null, image.width, image.height);
			buffer.__srcImage = cast image;

			offsetX = 0;
			offsetY = 0;
			width = buffer.width;
			height = buffer.height;

			if (onload != null)
			{
				onload(this);
			}
		}

		image.addEventListener("load", image_onLoaded, false);
		image.src = "data:" + type + ";base64," + base64;
	}

	@:noCompletion private function __fromBytes(bytes:Bytes, onload:Image->Void = null):Bool
	{
		var type = "";

		if (__isPNG(bytes))
		{
			type = "image/png";
		}
		else if (__isJPG(bytes))
		{
			type = "image/jpeg";
		}
		else if (__isGIF(bytes))
		{
			type = "image/gif";
		}
		else
		{
			// throw "Image tried to read PNG/JPG Bytes, but found an invalid header.";
			return false;
		}

		__fromBase64(Base64.encode(bytes), type, onload);
		return true;
	}

	@:noCompletion private function __fromFile(path:String, onload:Image->Void = null, onerror:Void->Void = null):Bool
	{
		#if openfljs
		var image:JSImage = untyped __js__('new window.Image ()');
		#else
		var image = new JSImage();
		#end

		if (!HTML5HTTPRequest.__isSameOrigin(path))
		{
			image.crossOrigin = "Anonymous";
		}

		image.onload = function(_)
		{
			buffer = new ImageBuffer(null, image.width, image.height);
			buffer.__srcImage = cast image;

			width = image.width;
			height = image.height;

			if (onload != null)
			{
				onload(this);
			}
		}

		image.onerror = function(_)
		{
			if (onerror != null)
			{
				onerror();
			}
		}

		image.src = path;

		// Another IE9 bug: loading 20+ images fails unless this line is added.
		// (issue #1019768)
		if (image.complete) {}

		return true;
	}

	@:noCompletion private function __fromImageBuffer(buffer:ImageBuffer):Void
	{
		this.buffer = buffer;

		if (buffer != null)
		{
			if (width == -1)
			{
				this.width = buffer.width;
			}

			if (height == -1)
			{
				this.height = buffer.height;
			}
		}
	}

	private static function __isGIF(bytes:Bytes):Bool
	{
		if (bytes == null || bytes.length < 6) return false;

		var header = bytes.getString(0, 6);
		return (header == "GIF87a" || header == "GIF89a");
	}

	private static function __isJPG(bytes:Bytes):Bool
	{
		if (bytes == null || bytes.length < 4) return false;

		return bytes.get(0) == 0xFF
			&& bytes.get(1) == 0xD8
			&& bytes.get(bytes.length - 2) == 0xFF
			&& bytes.get(bytes.length - 1) == 0xD9;
	}

	private static function __isPNG(bytes:Bytes):Bool
	{
		if (bytes == null || bytes.length < 8) return false;

		return (bytes.get(0) == 0x89 && bytes.get(1) == "P".code && bytes.get(2) == "N".code && bytes.get(3) == "G".code && bytes.get(4) == "\r".code
			&& bytes.get(5) == "\n".code && bytes.get(6) == 0x1A && bytes.get(7) == "\n".code);
	}

	private static function __isWebP(bytes:Bytes):Bool
	{
		if (bytes == null || bytes.length < 16) return false;

		return (bytes.getString(0, 4) == "RIFF" && bytes.getString(8, 4) == "WEBP");
	}

	// Get & Set Methods
	@:noCompletion private function get_data():UInt8Array
	{
		if (buffer.data == null && buffer.width > 0 && buffer.height > 0)
		{
			ImageCanvasUtil.convertToData(this);
		}

		return buffer.data;
	}

	@:noCompletion private function set_data(value:UInt8Array):UInt8Array
	{
		return buffer.data = value;
	}

	@:noCompletion private function get_format():PixelFormat
	{
		return buffer.format;
	}

	@:noCompletion private function set_format(value:PixelFormat):PixelFormat
	{
		if (buffer.format != value)
		{
			switch (type)
			{
				case DATA:
					ImageDataUtil.setFormat(this, value);

				default:
			}
		}

		return buffer.format = value;
	}

	@:noCompletion private function get_powerOfTwo():Bool
	{
		return ((buffer.width != 0)
			&& ((buffer.width & (~buffer.width + 1)) == buffer.width))
			&& ((buffer.height != 0) && ((buffer.height & (~buffer.height + 1)) == buffer.height));
	}

	@:noCompletion private function set_powerOfTwo(value:Bool):Bool
	{
		if (value != powerOfTwo)
		{
			var newWidth = 1;
			var newHeight = 1;

			while (newWidth < buffer.width)
			{
				newWidth <<= 1;
			}

			while (newHeight < buffer.height)
			{
				newHeight <<= 1;
			}

			if (newWidth == buffer.width && newHeight == buffer.height)
			{
				return value;
			}

			switch (type)
			{
				case CANVAS:
					ImageCanvasUtil.convertToData(this);
					ImageDataUtil.resizeBuffer(this, newWidth, newHeight);

				case DATA:
					ImageDataUtil.resizeBuffer(this, newWidth, newHeight);

				default:
			}
		}

		return value;
	}

	@:noCompletion private function get_premultiplied():Bool
	{
		return buffer.premultiplied;
	}

	@:noCompletion private function set_premultiplied(value:Bool):Bool
	{
		if (value && !buffer.premultiplied)
		{
			switch (type)
			{
				case CANVAS, DATA:
					ImageCanvasUtil.convertToData(this);
					ImageDataUtil.multiplyAlpha(this);

				default:
					// TODO
			}
		}
		else if (!value && buffer.premultiplied)
		{
			switch (type)
			{
				case DATA:
					ImageCanvasUtil.convertToData(this);
					ImageDataUtil.unmultiplyAlpha(this);

				default:
					// TODO
			}
		}

		return value;
	}

	@:noCompletion private function get_rect():Rectangle
	{
		return new Rectangle(0, 0, width, height);
	}

	@:noCompletion private function get_src():Dynamic
	{
		if (buffer.__srcCanvas == null && (buffer.data != null || type == DATA))
		{
			ImageCanvasUtil.convertToCanvas(this);
		}
		return buffer.src;
	}

	@:noCompletion private function set_src(value:Dynamic):Dynamic
	{
		return buffer.src = value;
	}

	@:noCompletion private function get_transparent():Bool
	{
		if (buffer == null) return false;
		return buffer.transparent;
	}

	@:noCompletion private function set_transparent(value:Bool):Bool
	{
		// TODO, modify data to set transparency
		if (buffer == null) return false;
		return buffer.transparent = value;
	}
}
#end
