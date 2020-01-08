package openfl._internal.backend.lime;

#if lime
import openfl._internal.bindings.cairo.CairoImageSurface;
import openfl._internal.bindings.cairo.Cairo;
import openfl._internal.utils.PerlinNoise;
import openfl._internal.bindings.typedarray.UInt8Array;
import openfl.display3D.textures.TextureBase;
import openfl.display3D.Context3D;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.display.BlendMode;
import openfl.display.IBitmapDrawable;
import openfl.display.JPEGEncoderOptions;
import openfl.display.PNGEncoderOptions;
import openfl.display.StageQuality;
import openfl.filters.BitmapFilter;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import openfl.utils.Endian;
import openfl.utils.Future;
import openfl.utils.Object;
import openfl.Vector;
import lime._internal.graphics.ImageCanvasUtil;
import lime.graphics.Image;
import lime.graphics.ImageChannel;
import lime.graphics.ImageBuffer;
import lime.math.ARGB;
#if openfl_html5
import js.html.CanvasElement;
import js.html.Image in JSImage;
import lime.graphics.Canvas2DRenderContext;
import openfl._internal.renderer.canvas.CanvasRenderer;
#elseif openfl_cairo
import openfl._internal.renderer.cairo.CairoRenderer;
#end

@:access(lime.graphics.opengl.GL)
@:access(lime.graphics.Image)
@:access(lime.graphics.ImageBuffer)
@:access(lime.math.Rectangle)
@:access(openfl._internal.backend.lime.cairo.CairoRenderer)
@:access(openfl._internal.renderer.canvas.CanvasRenderer)
@:access(openfl._internal.renderer.cairo.CairoRenderer)
@:access(openfl.display3D.textures.TextureBase)
@:access(openfl.display3D.Context3D)
@:access(openfl.display.BitmapData)
@:access(openfl.display.DisplayObject)
@:access(openfl.display.DisplayObjectRenderer)
@:access(openfl.display.DisplayObjectShader)
@:access(openfl.display.Graphics)
@:access(openfl.display.IBitmapDrawable)
@:access(openfl.display.Shader)
@:access(openfl.filters.BitmapFilter)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Point)
@:access(openfl.geom.Rectangle)
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class LimeBitmapDataBackend
{
	private var parent:BitmapData;

	public function new(parent:BitmapData, width:Int, height:Int, transparent:Bool = true, fillColor:UInt = 0xFFFFFFFF)
	{
		this.parent = parent;

		parent.__renderData.textureWidth = width;
		parent.__renderData.textureHeight = height;

		#if openfl_power_of_two
		parent.__renderData.textureWidth = __powerOfTwo(width);
		parent.__renderData.textureHeight = __powerOfTwo(height);
		#end

		if (width > 0 && height > 0)
		{
			if (transparent)
			{
				if ((fillColor & 0xFF000000) == 0)
				{
					fillColor = 0;
				}
			}
			else
			{
				fillColor = (0xFF << 24) | (fillColor & 0xFFFFFF);
			}

			fillColor = (fillColor << 8) | ((fillColor >> 24) & 0xFF);

			#if sys
			var buffer = new ImageBuffer(new UInt8Array(width * height * 4), width, height);
			buffer.format = BGRA32;
			buffer.premultiplied = true;

			parent.limeImage = new Image(buffer, 0, 0, width, height);

			if (fillColor != 0)
			{
				parent.limeImage.fillRect(parent.limeImage.rect, fillColor);
			}
			// #elseif openfl_html5
			// var buffer = new ImageBuffer (null, width, height);
			// var canvas:CanvasElement = cast Browser.document.createElement ("canvas");
			// buffer.__srcCanvas = canvas;
			// buffer.__srcContext = canvas.getContext ("2d");
			//
			// image = new Image (buffer, 0, 0, width, height);
			// parent.limeImage.type = CANVAS;
			//
			// if (fillColor != 0) {
			//
			// parent.limeImage.fillRect (parent.limeImage.rect, fillColor);
			//
			// }
			#else
			parent.limeImage = new Image(null, 0, 0, width, height, fillColor);
			#end

			parent.limeImage.transparent = transparent;

			parent.__isValid = true;
			parent.readable = true;
		}
	}

	public function applyFilter(sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, filter:BitmapFilter):Void
	{
		// TODO: Ways to optimize this?

		var needSecondBitmapData = filter.__needSecondBitmapData;
		var needCopyOfOriginal = filter.__preserveObject;

		var bitmapData2 = null;
		var bitmapData3 = null;

		if (needSecondBitmapData)
		{
			bitmapData2 = new BitmapData(parent.width, parent.height, true, 0);
		}
		else
		{
			bitmapData2 = parent;
		}

		if (needCopyOfOriginal)
		{
			bitmapData3 = new BitmapData(parent.width, parent.height, true, 0);
		}

		if (filter.__preserveObject)
		{
			bitmapData3.copyPixels(parent, parent.rect, destPoint);
		}

		var lastBitmap = filter.__applyFilter(bitmapData2, parent, sourceRect, destPoint);

		if (filter.__preserveObject)
		{
			lastBitmap.draw(bitmapData3, null, null);
		}

		if (needSecondBitmapData && lastBitmap == bitmapData2)
		{
			bitmapData2.limeImage.version = parent.limeImage.version;
			parent.limeImage = bitmapData2.limeImage;
		}

		parent.limeImage.dirty = true;
		parent.limeImage.version++;
	}

	public function clone():BitmapData
	{
		var bitmapData;

		if (!parent.__isValid)
		{
			bitmapData = new BitmapData(parent.width, parent.height, parent.transparent, 0);
		}
		else if (!parent.readable && parent.limeImage == null)
		{
			bitmapData = new BitmapData(0, 0, parent.transparent, 0);

			bitmapData.width = parent.width;
			bitmapData.height = parent.height;
			bitmapData.__renderData.textureWidth = parent.__renderData.textureWidth;
			bitmapData.__renderData.textureHeight = parent.__renderData.textureHeight;
			bitmapData.rect.copyFrom(parent.rect);

			bitmapData.__renderData.framebuffer = parent.__renderData.framebuffer;
			bitmapData.__renderData.framebufferContext = parent.__renderData.framebufferContext;
			bitmapData.__renderData.texture = parent.__renderData.texture;
			bitmapData.__renderData.textureContext = parent.__renderData.textureContext;
			bitmapData.__isValid = true;
		}
		else
		{
			bitmapData = BitmapData.fromImage(parent.limeImage.clone(), parent.transparent);
		}

		bitmapData.__worldTransform.copyFrom(parent.__worldTransform);
		bitmapData.__renderTransform.copyFrom(parent.__renderTransform);

		return bitmapData;
	}

	public function colorTransform(rect:Rectangle, colorTransform:ColorTransform):Void
	{
		parent.limeImage.colorTransform(rect.__toLimeRectangle(), colorTransform.__toLimeColorMatrix());
	}

	public function compare(otherBitmapData:BitmapData):Dynamic
	{
		if (parent.limeImage != null && otherBitmapData.limeImage != null && parent.limeImage.format == otherBitmapData.limeImage.format)
		{
			var bytes = parent.limeImage.data;
			var otherBytes = otherBitmapData.limeImage.data;
			var equal = true;

			for (i in 0...bytes.length)
			{
				if (bytes[i] != otherBytes[i])
				{
					equal = false;
					break;
				}
			}

			if (equal)
			{
				return 0;
			}
		}

		var bitmapData = null;
		var foundDifference,
			pixel:ARGB,
			otherPixel:ARGB,
			comparePixel:ARGB,
			r,
			g,
			b,
			a;

		for (y in 0...parent.height)
		{
			for (x in 0...parent.width)
			{
				foundDifference = false;

				pixel = getPixel32(x, y);
				otherPixel = otherBitmapData.getPixel32(x, y);
				comparePixel = 0;

				if (pixel != otherPixel)
				{
					r = pixel.r - otherPixel.r;
					g = pixel.g - otherPixel.g;
					b = pixel.b - otherPixel.b;

					if (r < 0) r *= -1;
					if (g < 0) g *= -1;
					if (b < 0) b *= -1;

					if (r == 0 && g == 0 && b == 0)
					{
						a = pixel.a - otherPixel.a;

						if (a != 0)
						{
							comparePixel.r = 0xFF;
							comparePixel.g = 0xFF;
							comparePixel.b = 0xFF;
							comparePixel.a = a;

							foundDifference = true;
						}
					}
					else
					{
						comparePixel.r = r;
						comparePixel.g = g;
						comparePixel.b = b;
						comparePixel.a = 0xFF;

						foundDifference = true;
					}
				}

				if (foundDifference)
				{
					if (bitmapData == null)
					{
						bitmapData = new BitmapData(parent.width, parent.height, parent.transparent || otherBitmapData.transparent, 0x00000000);
					}

					bitmapData.setPixel32(x, y, comparePixel);
				}
			}
		}

		if (bitmapData == null)
		{
			return 0;
		}

		return bitmapData;
	}

	public function copyChannel(sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, sourceChannel:BitmapDataChannel,
			destChannel:BitmapDataChannel):Void
	{
		var sourceChannel = switch (sourceChannel)
		{
			case 1: ImageChannel.RED;
			case 2: ImageChannel.GREEN;
			case 4: ImageChannel.BLUE;
			case 8: ImageChannel.ALPHA;
			default: return;
		}

		var destChannel = switch (destChannel)
		{
			case 1: ImageChannel.RED;
			case 2: ImageChannel.GREEN;
			case 4: ImageChannel.BLUE;
			case 8: ImageChannel.ALPHA;
			default: return;
		}

		parent.limeImage.copyChannel(sourceBitmapData.limeImage, sourceRect.__toLimeRectangle(), destPoint.__toLimeVector2(), sourceChannel, destChannel);
	}

	public function copyPixels(sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, alphaBitmapData:BitmapData = null, alphaPoint:Point = null,
			mergeAlpha:Bool = false):Void
	{
		if (alphaBitmapData != null
			&& alphaBitmapData.transparent
			&& (alphaBitmapData != sourceBitmapData || (alphaPoint != null && (alphaPoint.x != 0 || alphaPoint.y != 0))))
		{
			var point = Point.__pool.get();
			var rect = Rectangle.__pool.get();
			rect.copyFrom(sourceBitmapData.rect);
			rect.__contract(sourceRect.x, sourceRect.y, sourceRect.width, sourceRect.height);

			var copy = BitmapData.__pool.get(Std.int(rect.width), Std.int(rect.height));

			ImageCanvasUtil.convertToCanvas(copy.limeImage);
			ImageCanvasUtil.convertToCanvas(sourceBitmapData.limeImage);
			ImageCanvasUtil.convertToCanvas(alphaBitmapData.limeImage);

			if (alphaPoint != null)
			{
				rect.x += alphaPoint.x;
				rect.y += alphaPoint.y;
			}

			copy.limeImage.buffer.__srcContext.globalCompositeOperation = "source-over";
			copy.limeImage.buffer.__srcContext.drawImage(alphaBitmapData.limeImage.buffer.src, Std.int(rect.x + sourceBitmapData.limeImage.offsetX),
				Std.int(rect.y + sourceBitmapData.limeImage.offsetY), Std.int(rect.width), Std.int(rect.height), Std.int(point.x + parent.limeImage.offsetX),
				Std.int(point.y + parent.limeImage.offsetY), Std.int(rect.width), Std.int(rect.height));

			if (alphaPoint != null)
			{
				rect.x -= alphaPoint.x;
				rect.y -= alphaPoint.y;
			}

			copy.limeImage.buffer.__srcContext.globalCompositeOperation = "source-in";
			copy.limeImage.buffer.__srcContext.drawImage(sourceBitmapData.limeImage.buffer.src, Std.int(rect.x + sourceBitmapData.limeImage.offsetX),
				Std.int(rect.y + sourceBitmapData.limeImage.offsetY), Std.int(rect.width), Std.int(rect.height), Std.int(point.x + parent.limeImage.offsetX),
				Std.int(point.y + parent.limeImage.offsetY), Std.int(rect.width), Std.int(rect.height));

			// TODO: Render directly for mergeAlpha=false?
			parent.limeImage.copyPixels(copy.limeImage, copy.rect.__toLimeRectangle(), destPoint.__toLimeVector2(), null, null, mergeAlpha);

			BitmapData.__pool.release(copy);
			Rectangle.__pool.release(rect);
			Point.__pool.release(point);
			return;
		}

		if (alphaPoint != null)
		{
			BitmapData.__tempVector.x = alphaPoint.x;
			BitmapData.__tempVector.y = alphaPoint.y;
		}

		parent.limeImage.copyPixels(sourceBitmapData.limeImage, sourceRect.__toLimeRectangle(), destPoint.__toLimeVector2(),
			alphaBitmapData != null ? alphaBitmapData.limeImage : null, alphaPoint != null ? BitmapData.__tempVector : null, mergeAlpha);
	}

	public function dispose():Void
	{
		parent.limeImage = null;
		parent.__isValid = false;
		parent.__renderData.dispose();
	}

	@:beta public function disposeImage():Void
	{
		parent.readable = false;
	}

	public function draw(source:IBitmapDrawable, matrix:Matrix = null, colorTransform:ColorTransform = null, blendMode:BlendMode = null,
			clipRect:Rectangle = null, smoothing:Bool = false):Void
	{
		var _colorTransform = new ColorTransform();
		_colorTransform.__copyFrom(source.__worldColorTransform);
		_colorTransform.__invert();

		if (!parent.readable && BitmapData.__hardwareRenderer != null && getTexture(BitmapData.__hardwareRenderer.context3D) != null)
		{
			if (colorTransform != null)
			{
				_colorTransform.__combine(colorTransform);
			}

			BitmapData.__hardwareRenderer.__allowSmoothing = smoothing;
			BitmapData.__hardwareRenderer.__overrideBlendMode = blendMode;

			BitmapData.__hardwareRenderer.__worldTransform = matrix;
			BitmapData.__hardwareRenderer.__worldAlpha = 1 / source.__worldAlpha;
			BitmapData.__hardwareRenderer.__worldColorTransform = _colorTransform;

			BitmapData.__hardwareRenderer.__drawBitmapData(parent, source, clipRect);
		}
		else
		{
			#if (openfl_html5 || openfl_cairo)
			if (colorTransform != null)
			{
				var bounds = Rectangle.__pool.get();
				var boundsMatrix = Matrix.__pool.get();

				source.__getBounds(bounds, boundsMatrix);

				var width:Int = Math.ceil(bounds.width);
				var height:Int = Math.ceil(bounds.height);

				boundsMatrix.tx = -bounds.x;
				boundsMatrix.ty = -bounds.y;

				var copy = new BitmapData(width, height, true, 0);
				copy.draw(source, boundsMatrix);

				copy.colorTransform(copy.rect, colorTransform);
				copy.__renderTransform.identity();
				copy.__renderTransform.tx = bounds.x;
				copy.__renderTransform.ty = bounds.y;
				copy.__renderTransform.concat(source.__renderTransform);
				copy.__worldAlpha = source.__worldAlpha;
				copy.__worldColorTransform.__copyFrom(source.__worldColorTransform);
				source = copy;

				Rectangle.__pool.release(bounds);
				Matrix.__pool.release(boundsMatrix);
			}

			#if openfl_html5
			if (BitmapData.__softwareRenderer == null) BitmapData.__softwareRenderer = new CanvasRenderer(null);
			ImageCanvasUtil.convertToCanvas(parent.limeImage);
			var renderer:CanvasRenderer = cast BitmapData.__softwareRenderer;
			renderer.context = parent.limeImage.buffer.__srcContext;
			#elseif openfl_cairo
			if (BitmapData.__softwareRenderer == null) BitmapData.__softwareRenderer = new CairoRenderer(null);
			var renderer:CairoRenderer = cast BitmapData.__softwareRenderer;
			renderer.cairo = new Cairo(getSurface());
			#end

			renderer.__allowSmoothing = smoothing;
			renderer.__overrideBlendMode = blendMode;

			renderer.__worldTransform = matrix;
			renderer.__worldAlpha = 1 / source.__worldAlpha;
			renderer.__worldColorTransform = _colorTransform;

			renderer.__drawBitmapData(parent, source, clipRect);
			#end
		}
	}

	public function drawWithQuality(source:IBitmapDrawable, matrix:Matrix = null, colorTransform:ColorTransform = null, blendMode:BlendMode = null,
			clipRect:Rectangle = null, smoothing:Bool = false, quality:StageQuality = null):Void
	{
		draw(source, matrix, colorTransform, blendMode, clipRect, quality != LOW ? smoothing : false);
	}

	public function encode(rect:Rectangle, compressor:Object, byteArray:ByteArray = null):ByteArray
	{
		if (byteArray == null) byteArray = new ByteArray();

		var image = parent.limeImage;

		if (!rect.equals(parent.rect))
		{
			var matrix = Matrix.__pool.get();
			matrix.tx = Math.round(-rect.x);
			matrix.ty = Math.round(-rect.y);

			var bitmapData = new BitmapData(Math.ceil(rect.width), Math.ceil(rect.height), true, 0);
			bitmapData.draw(parent, matrix);

			image = bitmapData.limeImage;

			Matrix.__pool.release(matrix);
		}

		if (Std.is(compressor, PNGEncoderOptions))
		{
			byteArray.writeBytes(ByteArray.fromBytes(parent.limeImage.encode(PNG)));
			return byteArray;
		}
		else if (Std.is(compressor, JPEGEncoderOptions))
		{
			byteArray.writeBytes(ByteArray.fromBytes(parent.limeImage.encode(JPEG, cast(compressor, JPEGEncoderOptions).quality)));
			return byteArray;
		}

		return byteArray = null;
	}

	public function fillRect(rect:Rectangle, color:Int):Void
	{
		if (parent.transparent && (color & 0xFF000000) == 0)
		{
			color = 0;
		}

		if (!parent.readable && parent.__renderData.texture != null && BitmapData.__hardwareRenderer != null)
		{
			BitmapData.__hardwareRenderer.__fillRect(parent, rect, color);
		}
		else if (parent.readable)
		{
			parent.limeImage.fillRect(rect.__toLimeRectangle(), color, ARGB32);
		}
	}

	public function floodFill(x:Int, y:Int, color:Int):Void
	{
		parent.limeImage.floodFill(x, y, color, ARGB32);
	}

	public static function fromBase64(base64:String, type:String):BitmapData
	{
		#if openfl_html5
		return null;
		#else
		var bitmapData = new BitmapData(0, 0, true, 0);
		bitmapData.__backend.__fromBase64(base64, type);
		return bitmapData;
		#end
	}

	public static function fromBytes(bytes:ByteArray, rawAlpha:ByteArray = null):BitmapData
	{
		#if openfl_html5
		return null;
		#else
		var bitmapData = new BitmapData(0, 0, true, 0);
		bitmapData.__backend.__fromBytes(bytes, rawAlpha);
		return bitmapData;
		#end
	}

	#if openfl_html5
	public static function fromCanvas(canvas:CanvasElement, transparent:Bool = true):BitmapData
	{
		if (canvas == null) return null;

		var bitmapData = new BitmapData(0, 0, transparent, 0);
		bitmapData.__backend.__fromImage(Image.fromCanvas(canvas));
		bitmapData.limeImage.transparent = transparent;
		return bitmapData;
	}
	#end

	public static function fromFile(path:String):BitmapData
	{
		#if openfl_html5
		return null;
		#else
		var bitmapData = new BitmapData(0, 0, true, 0);
		bitmapData.__backend.__fromFile(path);
		return bitmapData.limeImage != null ? bitmapData : null;
		#end
	}

	public static function fromImage(image:Image, transparent:Bool = true):BitmapData
	{
		if (image == null || image.buffer == null) return null;

		var bitmapData = new BitmapData(0, 0, transparent, 0);
		bitmapData.__backend.__fromImage(image);
		bitmapData.limeImage.transparent = transparent;
		return bitmapData.limeImage != null ? bitmapData : null;
	}

	public static function fromTexture(texture:TextureBase):BitmapData
	{
		var bitmapData = new BitmapData(texture.__width, texture.__height, true, 0);
		bitmapData.readable = false;
		bitmapData.__renderData.texture = texture;
		bitmapData.__renderData.textureContext = texture.__context;
		bitmapData.limeImage = null;
		return bitmapData;
	}

	public function generateFilterRect(sourceRect:Rectangle, filter:BitmapFilter):Rectangle
	{
		return sourceRect.clone();
	}

	public function getVersion():Int
	{
		return parent.limeImage.version;
	}

	#if openfl_html5
	public function getCanvas(clearData:Bool):CanvasElement
	{
		if (parent.limeImage == null) return null;
		ImageCanvasUtil.convertToCanvas(parent.limeImage, clearData);
		return parent.limeImage.buffer.__srcCanvas;
	}

	public function getCanvasContext(clearData:Bool):Canvas2DRenderContext
	{
		if (parent.limeImage == null) return null;
		ImageCanvasUtil.convertToCanvas(parent.limeImage, clearData);
		return parent.limeImage.buffer.__srcContext;
	}
	#end

	public function getColorBoundsRect(mask:Int, color:Int, findColor:Bool = true):Rectangle
	{
		if (!parent.transparent || ((mask >> 24) & 0xFF) > 0)
		{
			var color = (color : ARGB);
			if (color.a == 0) color = 0;
		}

		var rect = parent.limeImage.getColorBoundsRect(mask, color, findColor, ARGB32);
		return new Rectangle(rect.x, rect.y, rect.width, rect.height);
	}

	#if openfl_html5
	public function getJSImage():JSImage
	{
		if (parent.limeImage == null) return null;
		return parent.limeImage.buffer.__srcImage;
	}
	#end

	#if openfl_html5
	public function getElement(clearData:Bool):Dynamic
	{
		if (parent.limeImage == null) return null;
		if (parent.limeImage.type == DATA)
		{
			ImageCanvasUtil.convertToCanvas(parent.limeImage, clearData);
		}
		return parent.limeImage.src;
	}
	#end

	public function getPixel(x:Int, y:Int):Int
	{
		return parent.limeImage.getPixel(x, y, ARGB32);
	}

	public function getPixel32(x:Int, y:Int):Int
	{
		return parent.limeImage.getPixel32(x, y, ARGB32);
	}

	public function getPixels(rect:Rectangle):ByteArray
	{
		if (rect == null) rect = parent.rect;
		var byteArray = ByteArray.fromBytes(parent.limeImage.getPixels(rect.__toLimeRectangle(), ARGB32));
		// TODO: System endian order
		byteArray.endian = Endian.BIG_ENDIAN;
		return byteArray;
	}

	#if openfl_cairo
	public function getSurface():CairoImageSurface
	{
		if (parent.__renderData.surface == null)
		{
			parent.__renderData.surface = CairoImageSurface.fromImage(parent.limeImage);
		}

		return parent.__renderData.surface;
	}
	#end

	public function getTexture(context:Context3D):TextureBase
	{
		// TODO: Refactor further
		if (!parent.readable
			&& parent.limeImage == null
			&& (parent.__renderData.texture == null || parent.__renderData.textureContext != context))
		{
			parent.__renderData.textureContext = null;
			parent.__renderData.texture = null;
			return null;
		}

		if (parent.__renderData.texture == null || parent.__renderData.textureContext != context)
		{
			parent.__renderData.textureContext = context;
			parent.__renderData.texture = context.createRectangleTexture(parent.__renderData.textureWidth, parent.__renderData.textureHeight, BGRA, false);

			// context.__bindGLTexture2D (__texture);
			// gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
			// gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
			// gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
			// gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
			parent.__renderData.textureVersion = -1;
		}

		#if openfl_html5
		ImageCanvasUtil.sync(parent.limeImage, false);
		#end

		if (parent.limeImage != null && parent.limeImage.version > parent.__renderData.textureVersion)
		{
			#if openfl_cairo
			if (parent.__renderData.surface != null)
			{
				parent.__renderData.surface.flush();
			}
			#end

			var textureImage = parent.limeImage;

			#if openfl_html5
			if (#if openfl_power_of_two true || #end (!Context3D.__supportsBGRA && textureImage.format != RGBA32))
			{
				textureImage = textureImage.clone();
				textureImage.format = RGBA32;
				// textureImage.buffer.premultiplied = true;
				#if openfl_power_of_two
				textureImage.powerOfTwo = true;
				#end
			}
			#else
			if (#if openfl_power_of_two !textureImage.powerOfTwo || #end (!textureImage.premultiplied && textureImage.transparent))
			{
				textureImage = textureImage.clone();
				textureImage.premultiplied = true;
				#if openfl_power_of_two
				textureImage.powerOfTwo = true;
				#end
			}
			#end

			@:privateAccess parent.__renderData.texture.__baseBackend.uploadFromImage(textureImage);

			parent.__renderData.textureVersion = parent.limeImage.version;

			parent.__renderData.textureWidth = textureImage.buffer.width;
			parent.__renderData.textureHeight = textureImage.buffer.height;
		}

		if (!parent.readable && parent.limeImage != null)
		{
			#if openfl_cairo
			parent.__renderData.surface = null;
			#end
			parent.limeImage = null;
		}

		return parent.__renderData.texture;
	}

	public function getVector(rect:Rectangle):Vector<UInt>
	{
		var pixels = parent.getPixels(rect);
		var length = Std.int(pixels.length / 4);
		var result = new Vector<UInt>(length, true);

		for (i in 0...length)
		{
			result[i] = pixels.readUnsignedInt();
		}

		return result;
	}

	public function histogram(hRect:Rectangle = null):Array<Array<Int>>
	{
		var rect = hRect != null ? hRect : new Rectangle(0, 0, parent.width, parent.height);
		var pixels = parent.getPixels(rect);
		var result = [for (i in 0...4) [for (j in 0...256) 0]];

		for (i in 0...pixels.length)
		{
			++result[i % 4][pixels.readUnsignedByte()];
		}

		return result;
	}

	public function hitTest(firstPoint:Point, firstAlphaThreshold:Int, secondObject:Object, secondBitmapDataPoint:Point = null,
			secondAlphaThreshold:Int = 1):Bool
	{
		if (Std.is(secondObject, Bitmap))
		{
			secondObject = cast(secondObject, Bitmap).__bitmapData;
		}

		if (Std.is(secondObject, Point))
		{
			var secondPoint:Point = cast secondObject;

			var x = Std.int(secondPoint.x - firstPoint.x);
			var y = Std.int(secondPoint.y - firstPoint.y);

			if (parent.rect.contains(x, y))
			{
				var pixel = getPixel32(x, y);

				if ((pixel >> 24) & 0xFF > firstAlphaThreshold)
				{
					return true;
				}
			}
		}
		else if (Std.is(secondObject, BitmapData))
		{
			var secondBitmapData:BitmapData = cast secondObject;
			var x, y;

			if (secondBitmapDataPoint == null)
			{
				x = 0;
				y = 0;
			}
			else
			{
				x = Math.round(secondBitmapDataPoint.x - firstPoint.x);
				y = Math.round(secondBitmapDataPoint.y - firstPoint.y);
			}

			var hitRect = Rectangle.__pool.get();
			hitRect.setTo(x, y, secondBitmapData.width, secondBitmapData.height);

			if (parent.rect.intersects(hitRect))
			{
				if (x < 0)
				{
					hitRect.x = 0;
					hitRect.width = Math.min(secondBitmapData.width + x, parent.width);
				}
				else
				{
					hitRect.width = Math.min(secondBitmapData.width, parent.width - x);
				}

				if (y < 0)
				{
					hitRect.y = 0;
					hitRect.height = Math.min(secondBitmapData.height + y, parent.height);
				}
				else
				{
					hitRect.height = Math.min(secondBitmapData.height, parent.height - y);
				}

				var pixels = getPixels(hitRect);

				hitRect.x = (x < 0) ? -x : 0;
				hitRect.y = (y < 0) ? -y : 0;

				var testPixels = secondBitmapData.getPixels(hitRect);

				var length = Std.int(hitRect.width * hitRect.height);
				var pixel, testPixel;

				for (i in 0...length)
				{
					pixel = pixels.readUnsignedInt();
					testPixel = testPixels.readUnsignedInt();

					if ((pixel >> 24) & 0xFF > firstAlphaThreshold && (testPixel >> 24) & 0xFF > secondAlphaThreshold)
					{
						Rectangle.__pool.release(hitRect);
						return true;
					}
				}
			}

			Rectangle.__pool.release(hitRect);
		}
		else if (Std.is(secondObject, Rectangle))
		{
			var secondRectangle = Rectangle.__pool.get();
			secondRectangle.copyFrom(cast secondObject);
			secondRectangle.offset(-firstPoint.x, -firstPoint.y);
			secondRectangle.__contract(0, 0, parent.width, parent.height);

			if (secondRectangle.width > 0 && secondRectangle.height > 0)
			{
				var pixels = getPixels(secondRectangle);
				var length = Std.int(pixels.length / 4);
				var pixel;

				for (i in 0...length)
				{
					pixel = pixels.readUnsignedInt();

					if ((pixel >> 24) & 0xFF > firstAlphaThreshold)
					{
						Rectangle.__pool.release(secondRectangle);
						return true;
					}
				}
			}

			Rectangle.__pool.release(secondRectangle);
		}

		return false;
	}

	public static function loadFromBase64(base64:String, type:String):Future<BitmapData>
	{
		return Image.loadFromBase64(base64, type).then(function(image)
		{
			return Future.withValue(BitmapData.fromImage(image));
		});
	}

	public static function loadFromBytes(bytes:ByteArray, rawAlpha:ByteArray = null):Future<BitmapData>
	{
		return Image.loadFromBytes(bytes).then(function(image)
		{
			var bitmapData = BitmapData.fromImage(image);

			if (rawAlpha != null)
			{
				bitmapData.__backend.__applyAlpha(rawAlpha);
			}

			return Future.withValue(bitmapData);
		});
	}

	public static function loadFromFile(path:String):Future<BitmapData>
	{
		return Image.loadFromFile(path).then(function(image)
		{
			return Future.withValue(BitmapData.fromImage(image));
		});
	}

	public function lock():Void {}

	public function merge(sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, redMultiplier:UInt, greenMultiplier:UInt, blueMultiplier:UInt,
			alphaMultiplier:UInt):Void
	{
		parent.limeImage.merge(sourceBitmapData.limeImage, sourceRect.__toLimeRectangle(), destPoint.__toLimeVector2(), redMultiplier, greenMultiplier,
			blueMultiplier, alphaMultiplier);
	}

	public function noise(randomSeed:Int, low:Int = 0, high:Int = 255, channelOptions:Int = 7, grayScale:Bool = false):Void
	{
		// Seeded Random Number Generator
		var rand:Void->Int =
			{
				function func():Int
				{
					randomSeed = randomSeed * 1103515245 + 12345;
					return Std.int(Math.abs(randomSeed / 65536)) % 32768;
				}
			};
		rand();

		// Range of values to value to.
		var range:Int = high - low;

		var redChannel:Bool = ((channelOptions & (1 << 0)) >> 0) == 1;
		var greenChannel:Bool = ((channelOptions & (1 << 1)) >> 1) == 1;
		var blueChannel:Bool = ((channelOptions & (1 << 2)) >> 2) == 1;
		var alphaChannel:Bool = ((channelOptions & (1 << 3)) >> 3) == 1;

		for (y in 0...parent.height)
		{
			for (x in 0...parent.width)
			{
				// Default channel colours if all channel options are false.
				var red:Int = 0;
				var blue:Int = 0;
				var green:Int = 0;
				var alpha:Int = 255;

				if (grayScale)
				{
					red = green = blue = low + (rand() % range);
					alpha = 255;
				}
				else
				{
					if (redChannel) red = low + (rand() % range);
					if (greenChannel) green = low + (rand() % range);
					if (blueChannel) blue = low + (rand() % range);
					if (alphaChannel) alpha = low + (rand() % range);
				}

				var rgb:Int = alpha;
				rgb = (rgb << 8) + red;
				rgb = (rgb << 8) + green;
				rgb = (rgb << 8) + blue;

				setPixel32(x, y, rgb);
			}
		}
	}

	public function paletteMap(sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, redArray:Array<Int> = null, greenArray:Array<Int> = null,
			blueArray:Array<Int> = null, alphaArray:Array<Int> = null):Void
	{
		var sw:Int = Std.int(sourceRect.width);
		var sh:Int = Std.int(sourceRect.height);

		var pixels = sourceBitmapData.getPixels(sourceRect);

		var pixelValue:Int, r:Int, g:Int, b:Int, a:Int, color:Int;

		for (i in 0...(sh * sw))
		{
			pixelValue = pixels.readUnsignedInt();

			a = (alphaArray == null) ? pixelValue & 0xFF000000 : alphaArray[(pixelValue >> 24) & 0xFF];
			r = (redArray == null) ? pixelValue & 0x00FF0000 : redArray[(pixelValue >> 16) & 0xFF];
			g = (greenArray == null) ? pixelValue & 0x0000FF00 : greenArray[(pixelValue >> 8) & 0xFF];
			b = (blueArray == null) ? pixelValue & 0x000000FF : blueArray[(pixelValue) & 0xFF];

			color = a + r + g + b;

			pixels.position = i * 4;
			pixels.writeUnsignedInt(color);
		}

		pixels.position = 0;
		var destRect = Rectangle.__pool.get();
		destRect.setTo(destPoint.x, destPoint.y, sw, sh);
		setPixels(destRect, pixels);
		Rectangle.__pool.release(destRect);
	}

	public function perlinNoise(baseX:Float, baseY:Float, numOctaves:UInt, randomSeed:Int, stitch:Bool, fractalNoise:Bool, channelOptions:UInt = 7,
			grayScale:Bool = false, offsets:Array<Point> = null):Void
	{
		var noise = new PerlinNoise(randomSeed, numOctaves, channelOptions, grayScale, 0.5, stitch, 0.15);
		noise.fill(parent, baseX, baseY, 0);
	}

	public function scroll(x:Int, y:Int):Void
	{
		parent.limeImage.scroll(x, y);
	}

	public function setDirty():Void
	{
		parent.limeImage.dirty = true;
		parent.limeImage.version++;
	}

	public function setPixel(x:Int, y:Int, color:Int):Void
	{
		parent.limeImage.setPixel(x, y, color, ARGB32);
	}

	public function setPixel32(x:Int, y:Int, color:Int):Void
	{
		parent.limeImage.setPixel32(x, y, color, ARGB32);
	}

	public function setPixels(rect:Rectangle, byteArray:ByteArray):Void
	{
		parent.limeImage.setPixels(rect.__toLimeRectangle(), byteArray, ARGB32, byteArray.endian);
	}

	public function setVector(rect:Rectangle, inputVector:Vector<UInt>):Void
	{
		var byteArray = new ByteArray();
		byteArray.length = inputVector.length * 4;

		for (color in inputVector)
		{
			byteArray.writeUnsignedInt(color);
		}

		byteArray.position = 0;
		setPixels(rect, byteArray);
	}

	public function threshold(sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, operation:String, threshold:Int, color:Int = 0x00000000,
			mask:Int = 0xFFFFFFFF, copySource:Bool = false):Int
	{
		return parent.limeImage.threshold(sourceBitmapData.limeImage, sourceRect.__toLimeRectangle(), destPoint.__toLimeVector2(), operation, threshold,
			color, mask, copySource, ARGB32);
	}

	public function unlock(changeRect:Rectangle = null):Void {}

	private function __applyAlpha(alpha:ByteArray):Void
	{
		#if openfl_html5
		ImageCanvasUtil.convertToCanvas(parent.limeImage);
		ImageCanvasUtil.createImageData(parent.limeImage);
		#end

		var data = parent.limeImage.buffer.data;

		for (i in 0...alpha.length)
		{
			data[i * 4 + 3] = alpha.readUnsignedByte();
		}

		parent.limeImage.version++;
	}

	private inline function __fromBase64(base64:String, type:String):Void
	{
		var image = Image.fromBase64(base64, type);
		__fromImage(image);
	}

	private inline function __fromBytes(bytes:ByteArray, rawAlpha:ByteArray = null):Void
	{
		var image = Image.fromBytes(bytes);
		__fromImage(image);

		if (rawAlpha != null)
		{
			__applyAlpha(rawAlpha);
		}
	}

	private function __fromFile(path:String):Void
	{
		var image = Image.fromFile(path);
		__fromImage(image);
	}

	private function __fromImage(image:Image):Void
	{
		if (image != null && image.buffer != null)
		{
			parent.limeImage = image;

			parent.width = image.width;
			parent.height = image.height;
			parent.rect = new Rectangle(0, 0, image.width, image.height);

			parent.__renderData.textureWidth = parent.width;
			parent.__renderData.textureHeight = parent.height;

			#if openfl_power_of_two
			parent.__renderData.textureWidth = __powerOfTwo(parent.width);
			parent.__renderData.textureHeight = __powerOfTwo(parent.height);
			#end

			#if sys
			image.format = BGRA32;
			image.premultiplied = true;
			#end

			parent.readable = true;
			parent.__isValid = true;
		}
	}

	private inline function __loadFromBase64(base64:String, type:String):Future<BitmapData>
	{
		return Image.loadFromBase64(base64, type).then(function(image)
		{
			__fromImage(image);
			return Future.withValue(parent);
		});
	}

	private inline function __loadFromBytes(bytes:ByteArray, rawAlpha:ByteArray = null):Future<BitmapData>
	{
		return Image.loadFromBytes(bytes).then(function(image)
		{
			__fromImage(image);

			if (rawAlpha != null)
			{
				__applyAlpha(rawAlpha);
			}

			return Future.withValue(parent);
		});
	}

	private function __loadFromFile(path:String):Future<BitmapData>
	{
		return Image.loadFromFile(path).then(function(image)
		{
			__fromImage(image);
			return Future.withValue(parent);
		});
	}

	private inline function __powerOfTwo(value:Int):Int
	{
		var newValue = 1;
		while (newValue < value)
		{
			newValue <<= 1;
		}
		return newValue;
	}

	private function __resize(width:Int, height:Int):Void
	{
		parent.width = width;
		parent.height = height;
		parent.rect.width = width;
		parent.rect.height = height;

		parent.__renderData.textureWidth = width;
		parent.__renderData.textureHeight = height;

		#if openfl_power_of_two
		parent.__renderData.textureWidth = __powerOfTwo(width);
		parent.__renderData.textureHeight = __powerOfTwo(height);
		#end
	}

	private function __sync():Void
	{
		#if openfl_html5
		ImageCanvasUtil.sync(parent.limeImage, false);
		#end
	}
}
#end
