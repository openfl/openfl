package openfl._internal.backend.lime;

#if lime
import openfl._internal.bindings.cairo.CairoImageSurface;
import openfl._internal.bindings.cairo.Cairo;
import openfl._internal.bindings.typedarray.Float32Array;
import openfl._internal.utils.PerlinNoise;
import openfl._internal.bindings.typedarray.UInt16Array;
import openfl._internal.bindings.typedarray.UInt8Array;
import openfl.display3D.textures.TextureBase;
import openfl.display3D.Context3D;
import openfl.display3D.IndexBuffer3D;
import openfl.display3D.VertexBuffer3D;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.display.BlendMode;
import openfl.display.DisplayObject;
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
#if openfl_gl
import openfl._internal.renderer.context3D.batcher.BatchRenderer;
#end
#if openfl_html5
import js.html.CanvasElement;
import lime.graphics.Canvas2DRenderContext;
import openfl._internal.renderer.canvas.CanvasRenderer;
#else
import openfl._internal.renderer.cairo.CairoRenderer;
#end

@:access(lime.graphics.opengl.GL)
@:access(lime.graphics.Image)
@:access(lime.graphics.ImageBuffer)
@:access(lime.math.Rectangle)
@:access(openfl._internal.backend.lime.cairo.CairoRenderer)
@:access(openfl._internal.renderer.canvas.CanvasRenderer)
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

		parent.__textureWidth = width;
		parent.__textureHeight = height;

		#if openfl_power_of_two
		parent.__textureWidth = __powerOfTwo(width);
		parent.__textureHeight = __powerOfTwo(height);
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
			bitmapData.__textureWidth = parent.__textureWidth;
			bitmapData.__textureHeight = parent.__textureHeight;
			bitmapData.rect.copyFrom(parent.rect);

			bitmapData.__framebuffer = parent.__framebuffer;
			bitmapData.__framebufferContext = parent.__framebufferContext;
			bitmapData.__texture = parent.__texture;
			bitmapData.__textureContext = parent.__textureContext;
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

		parent.__surface = null;

		parent.__vertexBuffer = null;
		parent.__framebuffer = null;
		parent.__framebufferContext = null;
		parent.__texture = null;
		parent.__textureContext = null;
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

		if (!parent.readable && parent.__texture != null && BitmapData.__hardwareRenderer != null)
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
		bitmapData.__texture = texture;
		bitmapData.__textureContext = texture.__textureContext;
		bitmapData.limeImage = null;
		return bitmapData;
	}

	public function generateFilterRect(sourceRect:Rectangle, filter:BitmapFilter):Rectangle
	{
		return sourceRect.clone();
	}

	public function getIndexBuffer(context:Context3D, scale9Grid:Rectangle = null):IndexBuffer3D
	{
		var gl = context.gl;

		if (parent.__indexBuffer == null
			|| parent.__indexBufferContext != context.__context
			|| (scale9Grid != null && parent.__indexBufferGrid == null)
			|| (parent.__indexBufferGrid != null && !parent.__indexBufferGrid.equals(scale9Grid)))
		{
			// TODO: Use shared buffer on context
			// TODO: Support for UVs other than scale-9 grid?

			parent.__indexBufferContext = context.__context;
			parent.__indexBuffer = null;

			if (scale9Grid != null)
			{
				if (parent.__indexBufferGrid == null) parent.__indexBufferGrid = new Rectangle();
				parent.__indexBufferGrid.copyFrom(scale9Grid);

				var centerX = scale9Grid.width;
				var centerY = scale9Grid.height;
				if (centerX != 0 && centerY != 0)
				{
					parent.__indexBufferData = new UInt16Array(54);

					//  0 ——— 1    4 ——— 5    8 ——— 9
					//  |  /  |    |  /  |    |  /  |
					//  2 ——— 3    6 ——— 7   10 ——— 11
					//
					// 12 ——— 13  16 ——— 18  20 ——— 21
					//  |  /  |    |  /  |    |  /  |
					// 14 ——— 15  17 ——— 19  22 ——— 23
					//
					// 24 ——— 25  28 ——— 29  32 ——— 33
					//  |  /  |    |  /  |    |  /  |
					// 26 ——— 27  30 ——— 31  34 ——— 35

					// top left
					parent.__indexBufferData[0] = 0;
					parent.__indexBufferData[1] = 1;
					parent.__indexBufferData[2] = 2;
					parent.__indexBufferData[3] = 2;
					parent.__indexBufferData[4] = 1;
					parent.__indexBufferData[5] = 3;

					// top center
					parent.__indexBufferData[6] = 4;
					parent.__indexBufferData[7] = 5;
					parent.__indexBufferData[8] = 6;
					parent.__indexBufferData[9] = 6;
					parent.__indexBufferData[10] = 5;
					parent.__indexBufferData[11] = 7;

					// top right
					parent.__indexBufferData[12] = 8;
					parent.__indexBufferData[13] = 9;
					parent.__indexBufferData[14] = 10;
					parent.__indexBufferData[15] = 10;
					parent.__indexBufferData[16] = 9;
					parent.__indexBufferData[17] = 11;

					// middle left
					parent.__indexBufferData[18] = 12;
					parent.__indexBufferData[19] = 13;
					parent.__indexBufferData[20] = 14;
					parent.__indexBufferData[21] = 14;
					parent.__indexBufferData[22] = 13;
					parent.__indexBufferData[23] = 15;

					// middle center
					parent.__indexBufferData[24] = 16;
					parent.__indexBufferData[25] = 18;
					parent.__indexBufferData[26] = 17;
					parent.__indexBufferData[27] = 17;
					parent.__indexBufferData[28] = 18;
					parent.__indexBufferData[29] = 19;

					// middle right
					parent.__indexBufferData[30] = 20;
					parent.__indexBufferData[31] = 21;
					parent.__indexBufferData[32] = 22;
					parent.__indexBufferData[33] = 22;
					parent.__indexBufferData[34] = 21;
					parent.__indexBufferData[35] = 23;

					// bottom left
					parent.__indexBufferData[36] = 24;
					parent.__indexBufferData[37] = 25;
					parent.__indexBufferData[38] = 26;
					parent.__indexBufferData[39] = 26;
					parent.__indexBufferData[40] = 25;
					parent.__indexBufferData[41] = 27;

					// bottom center
					parent.__indexBufferData[42] = 28;
					parent.__indexBufferData[43] = 29;
					parent.__indexBufferData[44] = 30;
					parent.__indexBufferData[45] = 30;
					parent.__indexBufferData[46] = 29;
					parent.__indexBufferData[47] = 31;

					// bottom right
					parent.__indexBufferData[48] = 32;
					parent.__indexBufferData[49] = 33;
					parent.__indexBufferData[50] = 34;
					parent.__indexBufferData[51] = 34;
					parent.__indexBufferData[52] = 33;
					parent.__indexBufferData[53] = 35;

					parent.__indexBuffer = context.createIndexBuffer(54);
				}
				else if (centerX == 0 && centerY != 0)
				{
					parent.__indexBufferData = new UInt16Array(18);

					// 3 ——— 2
					// |  /  |
					// 1 ——— 0
					// |  /  |
					// 5 ——— 4
					// |  /  |
					// 7 ——— 6

					// top
					parent.__indexBufferData[0] = 0;
					parent.__indexBufferData[1] = 1;
					parent.__indexBufferData[2] = 2;
					parent.__indexBufferData[3] = 2;
					parent.__indexBufferData[4] = 1;
					parent.__indexBufferData[5] = 3;

					// middle
					parent.__indexBufferData[6] = 4;
					parent.__indexBufferData[7] = 5;
					parent.__indexBufferData[8] = 0;
					parent.__indexBufferData[9] = 0;
					parent.__indexBufferData[10] = 5;
					parent.__indexBufferData[11] = 1;

					// bottom
					parent.__indexBufferData[12] = 6;
					parent.__indexBufferData[13] = 7;
					parent.__indexBufferData[14] = 4;
					parent.__indexBufferData[15] = 4;
					parent.__indexBufferData[16] = 7;
					parent.__indexBufferData[17] = 5;

					parent.__indexBuffer = context.createIndexBuffer(18);
				}
				else if (centerX != 0 && centerY == 0)
				{
					parent.__indexBufferData = new UInt16Array(18);

					// 3 ——— 2 ——— 5 ——— 7
					// |  /  |  /  |  /  |
					// 1 ——— 0 ——— 4 ——— 6

					// left
					parent.__indexBufferData[0] = 0;
					parent.__indexBufferData[1] = 1;
					parent.__indexBufferData[2] = 2;
					parent.__indexBufferData[3] = 2;
					parent.__indexBufferData[4] = 1;
					parent.__indexBufferData[5] = 3;

					// center
					parent.__indexBufferData[6] = 4;
					parent.__indexBufferData[7] = 0;
					parent.__indexBufferData[8] = 5;
					parent.__indexBufferData[9] = 5;
					parent.__indexBufferData[10] = 0;
					parent.__indexBufferData[11] = 2;

					// right
					parent.__indexBufferData[12] = 6;
					parent.__indexBufferData[13] = 4;
					parent.__indexBufferData[14] = 7;
					parent.__indexBufferData[15] = 7;
					parent.__indexBufferData[16] = 4;
					parent.__indexBufferData[17] = 5;

					parent.__indexBuffer = context.createIndexBuffer(18);
				}
			}
			else
			{
				parent.__indexBufferGrid = null;
			}

			if (parent.__indexBuffer == null)
			{
				parent.__indexBufferData = new UInt16Array(6);
				parent.__indexBufferData[0] = 0;
				parent.__indexBufferData[1] = 1;
				parent.__indexBufferData[2] = 2;
				parent.__indexBufferData[3] = 2;
				parent.__indexBufferData[4] = 1;
				parent.__indexBufferData[5] = 3;
				parent.__indexBuffer = context.createIndexBuffer(6);
			}

			parent.__indexBuffer.uploadFromTypedArray(parent.__indexBufferData);
		}

		return parent.__indexBuffer;
	}

	#if (openfl_gl && !disable_batcher)
	public function pushQuadsToBatcher(batcher:BatchRenderer, transform:Matrix, alpha:Float, object:DisplayObject):Void
	{
		var blendMode = object.__worldBlendMode;
		var colorTransform = object.__worldColorTransform;
		var scale9Grid = object.__worldScale9Grid;

		#if openfl_power_of_two
		var uvWidth = width / __textureWidth;
		var uvHeight = height / __textureHeight;
		#else
		var uvWidth = 1;
		var uvHeight = 1;
		#end

		if (object != null && scale9Grid != null)
		{
			var vertexBufferWidth = object.width;
			var vertexBufferHeight = object.height;
			var vertexBufferScaleX = object.scaleX;
			var vertexBufferScaleY = object.scaleY;

			var centerX = scale9Grid.width;
			var centerY = scale9Grid.height;
			if (centerX != 0 && centerY != 0)
			{
				var left = scale9Grid.x;
				var top = scale9Grid.y;
				var right = vertexBufferWidth - centerX - left;
				var bottom = vertexBufferHeight - centerY - top;

				var uvLeft = left / vertexBufferWidth;
				var uvTop = top / vertexBufferHeight;
				var uvCenterX = scale9Grid.width / vertexBufferWidth;
				var uvCenterY = scale9Grid.height / vertexBufferHeight;
				var uvRight = right / parent.width;
				var uvBottom = bottom / parent.height;
				var uvOffsetU = 0.5 / vertexBufferWidth;
				var uvOffsetV = 0.5 / vertexBufferHeight;

				var renderedLeft = left / vertexBufferScaleX;
				var renderedTop = top / vertexBufferScaleY;
				var renderedRight = right / vertexBufferScaleX;
				var renderedBottom = bottom / vertexBufferScaleY;
				var renderedCenterX = (parent.width - renderedLeft - renderedRight);
				var renderedCenterY = (parent.height - renderedTop - renderedBottom);

				//  a         b          c         d
				// p  0 ——— 1    4 ——— 5    8 ——— 9
				//    |  /  |    |  /  |    |  /  |
				//    2 ——— 3    6 ——— 7   10 ——— 11
				// q
				//   12 ——— 13  16 ——— 18  20 ——— 21
				//    |  /  |    |  /  |    |  /  |
				//   14 ——— 15  17 ——— 19  22 ——— 23
				// r
				//   24 ——— 25  28 ——— 29  32 ——— 33
				//    |  /  |    |  /  |    |  /  |
				//   26 ——— 27  30 ——— 31  34 ——— 35
				// s

				var a = 0;
				var b = renderedLeft;
				var c = renderedLeft + renderedCenterX;
				var bc = renderedCenterX;
				var d = parent.width;
				var cd = d - c;

				var p = 0;
				var q = renderedTop;
				var r = renderedTop + renderedCenterY;
				var qr = renderedCenterY;
				var s = parent.height;
				var rs = s - r;

				batcher.setVs(0, (uvHeight * uvTop) - uvOffsetV);
				batcher.setVertices(transform, a, p, b, q);
				batcher.setUs(0, (uvWidth * uvLeft) - uvOffsetU);
				batcher.pushQuad(parent, blendMode, alpha, colorTransform);

				batcher.setVertices(transform, b, p, bc, q);
				batcher.setUs((uvWidth * uvLeft) + uvOffsetU, (uvWidth * (uvLeft + uvCenterX)) - uvOffsetU);
				batcher.pushQuad(parent, blendMode, alpha, colorTransform);

				batcher.setVertices(transform, c, p, cd, q);
				batcher.setUs((uvWidth * (uvLeft + uvCenterX)) + uvOffsetU, uvWidth);
				batcher.pushQuad(parent, blendMode, alpha, colorTransform);

				batcher.setVs((uvHeight * uvTop) + uvOffsetV, (uvHeight * (uvTop + uvCenterY)) - uvOffsetV);
				batcher.setVertices(transform, a, q, b, qr);
				batcher.setUs(0, (uvWidth * uvLeft) - uvOffsetU);
				batcher.pushQuad(parent, blendMode, alpha, colorTransform);

				batcher.setVertices(transform, b, q, bc, qr);
				batcher.setUs((uvWidth * uvLeft) + uvOffsetU, (uvWidth * (uvLeft + uvCenterX)) - uvOffsetU);
				batcher.pushQuad(parent, blendMode, alpha, colorTransform);

				batcher.setVertices(transform, c, q, cd, qr);
				batcher.setUs((uvWidth * (uvLeft + uvCenterX)) + uvOffsetU, uvWidth);
				batcher.pushQuad(parent, blendMode, alpha, colorTransform);

				batcher.setVs((uvHeight * (uvTop + uvCenterY)) + uvOffsetV, uvHeight);
				batcher.setVertices(transform, a, r, b, rs);
				batcher.setUs(0, (uvWidth * uvLeft) - uvOffsetU);
				batcher.pushQuad(parent, blendMode, alpha, colorTransform);

				batcher.setVertices(transform, b, r, bc, rs);
				batcher.setUs((uvWidth * uvLeft) + uvOffsetU, (uvWidth * (uvLeft + uvCenterX)) - uvOffsetU);
				batcher.pushQuad(parent, blendMode, alpha, colorTransform);

				batcher.setVertices(transform, c, r, cd, rs);
				batcher.setUs((uvWidth * (uvLeft + uvCenterX)) + uvOffsetU, uvWidth);
				batcher.pushQuad(parent, blendMode, alpha, colorTransform);
			}
			else if (centerX == 0 && centerY != 0)
			{
				// TODO
				// 3 ——— 2
				// |  /  |
				// 1 ——— 0
				// |  /  |
				// 5 ——— 4
				// |  /  |
				// 7 ——— 6
			}
			else if (centerY == 0 && centerX != 0)
			{
				// TODO
				// 3 ——— 2 ——— 5 ——— 7
				// |  /  |  /  |  /  |
				// 1 ——— 0 ——— 4 ——— 6
			}
		}
		else
		{
			batcher.setVertices(transform, 0, 0, parent.width, parent.height);
			batcher.setUs(0, uvWidth);
			batcher.setVs(0, uvHeight);
			batcher.pushQuad(parent, blendMode, alpha, colorTransform);
		}
	}
	#end

	public function getVersion():Int
	{
		return parent.limeImage.version;
	}

	public function getVertexBuffer(context:Context3D, scale9Grid:Rectangle = null, targetObject:DisplayObject = null):VertexBuffer3D
	{
		var gl = context.gl;

		// TODO: Support for UVs other than scale-9 grid?
		// TODO: Better way of handling object transform?

		if (parent.__vertexBuffer == null
			|| parent.__vertexBufferContext != context.__context
			|| (scale9Grid != null && parent.__vertexBufferGrid == null)
			|| (parent.__vertexBufferGrid != null && !parent.__vertexBufferGrid.equals(scale9Grid))
			|| (targetObject != null
				&& (parent.__vertexBufferWidth != targetObject.width
					|| parent.__vertexBufferHeight != targetObject.height
					|| parent.__vertexBufferScaleX != targetObject.scaleX
					|| parent.__vertexBufferScaleY != targetObject.scaleY)))
		{
			parent.__uvRect = new Rectangle(0, 0, parent.__textureWidth, parent.__textureHeight);

			var uvWidth = parent.width / parent.__textureWidth;
			var uvHeight = parent.height / parent.__textureHeight;

			// __vertexBufferData = new Float32Array ([
			//
			// width, height, 0, uvWidth, uvHeight, alpha, (color transform, color offset...)
			// 0, height, 0, 0, uvHeight, alpha, (color transform, color offset...)
			// width, 0, 0, uvWidth, 0, alpha, (color transform, color offset...)
			// 0, 0, 0, 0, 0, alpha, (color transform, color offset...)
			//
			//
			// ]);

			// [ colorTransform.redMultiplier, 0, 0, 0, 0, colorTransform.greenMultiplier, 0, 0, 0, 0, colorTransform.blueMultiplier, 0, 0, 0, 0, colorTransform.alphaMultiplier ];
			// [ colorTransform.redOffset / 255, colorTransform.greenOffset / 255, colorTransform.blueOffset / 255, colorTransform.alphaOffset / 255 ]

			parent.__vertexBufferContext = context.__context;
			parent.__vertexBuffer = null;

			if (targetObject != null)
			{
				parent.__vertexBufferWidth = targetObject.width;
				parent.__vertexBufferHeight = targetObject.height;
				parent.__vertexBufferScaleX = targetObject.scaleX;
				parent.__vertexBufferScaleY = targetObject.scaleY;
			}

			if (scale9Grid != null && targetObject != null)
			{
				if (parent.__vertexBufferGrid == null) parent.__vertexBufferGrid = new Rectangle();
				parent.__vertexBufferGrid.copyFrom(scale9Grid);

				parent.__vertexBufferWidth = targetObject.width;
				parent.__vertexBufferHeight = targetObject.height;
				parent.__vertexBufferScaleX = targetObject.scaleX;
				parent.__vertexBufferScaleY = targetObject.scaleY;

				var centerX = scale9Grid.width;
				var centerY = scale9Grid.height;
				if (centerX != 0 && centerY != 0)
				{
					parent.__vertexBufferData = new Float32Array(BitmapData.VERTEX_BUFFER_STRIDE * 36);

					var left = scale9Grid.x;
					var top = scale9Grid.y;
					var right = parent.__vertexBufferWidth - centerX - left;
					var bottom = parent.__vertexBufferHeight - centerY - top;

					var uvLeft = left / parent.__vertexBufferWidth;
					var uvTop = top / parent.__vertexBufferHeight;
					var uvCenterX = scale9Grid.width / parent.__vertexBufferWidth;
					var uvCenterY = scale9Grid.height / parent.__vertexBufferHeight;
					var uvRight = right / parent.width;
					var uvBottom = bottom / parent.height;
					var uvOffsetU = 0.5 / parent.__vertexBufferWidth;
					var uvOffsetV = 0.5 / parent.__vertexBufferHeight;

					var renderedLeft = left / targetObject.scaleX;
					var renderedTop = top / targetObject.scaleY;
					var renderedRight = right / targetObject.scaleX;
					var renderedBottom = bottom / targetObject.scaleY;
					var renderedCenterX = (parent.width - renderedLeft - renderedRight);
					var renderedCenterY = (parent.height - renderedTop - renderedBottom);

					//  0 ——— 1    4 ——— 5    8 ——— 9
					//  |  /  |    |  /  |    |  /  |
					//  2 ——— 3    6 ——— 7   10 ——— 11
					//
					// 12 ——— 13  16 ——— 18  20 ——— 21
					//  |  /  |    |  /  |    |  /  |
					// 14 ——— 15  17 ——— 19  22 ——— 23
					//
					// 24 ——— 25  28 ——— 29  32 ——— 33
					//  |  /  |    |  /  |    |  /  |
					// 26 ——— 27  30 ——— 31  34 ——— 35

					__setVertex(0, 0, 0, 0, 0);
					__setVertices([3, 6, 13, 16], renderedLeft, renderedTop, uvWidth * uvLeft, uvHeight * uvTop);
					__setVertices([2, 12], 0, renderedTop, 0, uvHeight * uvTop);
					__setVertices([1, 4], renderedLeft, 0, uvWidth * uvLeft, 0);
					__setVertices([7, 10, 18, 20], renderedLeft + renderedCenterX, renderedTop, uvWidth * (uvLeft + uvCenterX), uvHeight * uvTop);
					__setVertices([5, 8], renderedLeft + renderedCenterX, 0, uvWidth * (uvLeft + uvCenterX), 0);
					__setVertices([11, 21], parent.width, renderedTop, uvWidth, uvHeight * uvTop);
					__setVertex(9, parent.width, 0, uvWidth, 0);
					__setVertices([15, 17, 25, 28], renderedLeft, renderedTop + renderedCenterY, uvWidth * uvLeft, uvHeight * (uvTop + uvCenterY));
					__setVertices([14, 24], 0, renderedTop + renderedCenterY, 0, uvHeight * (uvTop + uvCenterY));
					__setVertices([19, 22, 29, 32], renderedLeft + renderedCenterX, renderedTop + renderedCenterY, uvWidth * (uvLeft + uvCenterX),
						uvHeight * (uvTop + uvCenterY));
					__setVertices([23, 33], parent.width, renderedTop + renderedCenterY, uvWidth, uvHeight * (uvTop + uvCenterY));
					__setVertices([27, 30], renderedLeft, parent.height, uvWidth * uvLeft, uvHeight);
					__setVertex(26, 0, parent.height, 0, uvHeight);
					__setVertices([31, 34], renderedLeft + renderedCenterX, parent.height, uvWidth * (uvLeft + uvCenterX), uvHeight);
					__setVertex(35, parent.width, parent.height, uvWidth, uvHeight);

					__setUOffsets([1, 3, 5, 7, 13, 15, 18, 19, 25, 27, 29, 31], -uvOffsetU);
					__setUOffsets([4, 6, 8, 10, 16, 17, 20, 22, 28, 30, 32, 34], uvOffsetU);
					__setVOffsets([2, 3, 6, 7, 10, 11, 14, 15, 17, 19, 22, 23], -uvOffsetV);
					__setVOffsets([12, 13, 16, 18, 20, 21, 24, 25, 28, 29, 32, 33], uvOffsetV);

					parent.__vertexBuffer = context.createVertexBuffer(16, BitmapData.VERTEX_BUFFER_STRIDE);
				}
				else if (centerX == 0 && centerY != 0)
				{
					parent.__vertexBufferData = new Float32Array(BitmapData.VERTEX_BUFFER_STRIDE * 8);

					var top = scale9Grid.y;
					var bottom = parent.height - centerY - top;

					var uvTop = top / parent.height;
					var uvCenterY = centerY / parent.height;
					var uvBottom = bottom / parent.height;

					var renderedTop = top / targetObject.scaleY;
					var renderedBottom = bottom / targetObject.scaleY;
					var renderedCenterY = (targetObject.height / targetObject.scaleY) - renderedTop - renderedBottom;

					var renderedWidth = targetObject.width / targetObject.scaleX;

					// 3 ——— 2
					// |  /  |
					// 1 ——— 0
					// |  /  |
					// 5 ——— 4
					// |  /  |
					// 7 ——— 6

					// top <0-1-2> <2-1-3>
					parent.__vertexBufferData[0] = renderedWidth;
					parent.__vertexBufferData[1] = renderedTop;
					parent.__vertexBufferData[3] = uvWidth;
					parent.__vertexBufferData[4] = uvHeight * uvTop;

					parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE + 1] = renderedTop;
					parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE + 4] = uvHeight * uvTop;

					parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 2] = renderedWidth;
					parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 2 + 3] = uvWidth;

					// middle <4-5-0> <0-5-1>
					parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 4] = renderedWidth;
					parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 4 + 1] = renderedTop + renderedCenterY;
					parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 4 + 3] = uvWidth;
					parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 4 + 4] = uvHeight * (uvTop + uvCenterY);

					parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 5 + 1] = renderedTop + renderedCenterY;
					parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 5 + 4] = uvHeight * (uvTop + uvCenterY);

					// bottom <6-7-4> <4-7-5>
					parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 6] = renderedWidth;
					parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 6 + 1] = parent.height;
					parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 6 + 3] = uvWidth;
					parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 6 + 4] = uvHeight;

					parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 7 + 1] = parent.height;
					parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 7 + 4] = uvHeight;

					parent.__vertexBuffer = context.createVertexBuffer(8, BitmapData.VERTEX_BUFFER_STRIDE);
				}
				else if (centerY == 0 && centerX != 0)
				{
					parent.__vertexBufferData = new Float32Array(BitmapData.VERTEX_BUFFER_STRIDE * 8);

					var left = scale9Grid.x;
					var right = parent.width - centerX - left;

					var uvLeft = left / parent.width;
					var uvCenterX = centerX / parent.width;
					var uvRight = right / parent.width;

					var renderedLeft = left / targetObject.scaleX;
					var renderedRight = right / targetObject.scaleX;
					var renderedCenterX = (targetObject.width / targetObject.scaleX) - renderedLeft - renderedRight;

					var renderedHeight = targetObject.height / targetObject.scaleY;

					// 3 ——— 2 ——— 5 ——— 7
					// |  /  |  /  |  /  |
					// 1 ——— 0 ——— 4 ——— 6

					// top left <0-1-2> <2-1-3>
					parent.__vertexBufferData[0] = renderedLeft;
					parent.__vertexBufferData[1] = renderedHeight;
					parent.__vertexBufferData[3] = uvWidth * uvLeft;
					parent.__vertexBufferData[4] = uvHeight;

					parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE + 1] = renderedHeight;
					parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE + 4] = uvHeight;

					parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 2] = renderedLeft;
					parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 2 + 3] = uvWidth * uvLeft;

					// top center <4-0-5> <5-0-2>
					parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 4] = renderedLeft + renderedCenterX;
					parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 4 + 1] = renderedHeight;
					parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 4 + 3] = uvWidth * (uvLeft + uvCenterX);
					parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 4 + 4] = uvHeight;

					parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 5] = renderedLeft + renderedCenterX;
					parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 5 + 3] = uvWidth * (uvLeft + uvCenterX);

					// top right <6-4-7> <7-4-5>
					parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 6] = parent.width;
					parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 6 + 1] = renderedHeight;
					parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 6 + 3] = uvWidth;
					parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 6 + 4] = uvHeight;

					parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 7] = parent.width;
					parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 7 + 3] = uvWidth;

					parent.__vertexBuffer = context.createVertexBuffer(8, BitmapData.VERTEX_BUFFER_STRIDE);
				}
			}
			else
			{
				parent.__vertexBufferGrid = null;
			}

			if (parent.__vertexBuffer == null)
			{
				parent.__vertexBufferData = new Float32Array(BitmapData.VERTEX_BUFFER_STRIDE * 4);

				parent.__vertexBufferData[0] = parent.width;
				parent.__vertexBufferData[1] = parent.height;
				parent.__vertexBufferData[3] = uvWidth;
				parent.__vertexBufferData[4] = uvHeight;
				parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE + 1] = parent.height;
				parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE + 4] = uvHeight;
				parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 2] = parent.width;
				parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 2 + 3] = uvWidth;

				parent.__vertexBuffer = context.createVertexBuffer(3, BitmapData.VERTEX_BUFFER_STRIDE);
			}

			// for (i in 0...4) {

			// 	__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * i + 5] = alpha;

			// 	if (colorTransform != null) {

			// 		__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * i + 6] = colorTransform.redMultiplier;
			// 		__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * i + 7] = colorTransform.greenMultiplier;
			// 		__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * i + 8] = colorTransform.blueMultiplier;
			// 		__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * i + 9] = colorTransform.alphaMultiplier;
			// 		__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * i + 10] = colorTransform.redOffset / 255;
			// 		__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * i + 11] = colorTransform.greenOffset / 255;
			// 		__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * i + 12] = colorTransform.blueOffset / 255;
			// 		__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * i + 13] = colorTransform.alphaOffset / 255;

			// 	}

			// }

			// __vertexBufferAlpha = alpha;
			// __vertexBufferColorTransform = colorTransform != null ? colorTransform.__clone () : null;

			parent.__vertexBuffer.uploadFromTypedArray(parent.__vertexBufferData);
		}
		else
		{
			// var dirty = false;

			// if (__vertexBufferAlpha != alpha) {

			// 	dirty = true;

			// 	for (i in 0...4) {

			// 		__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * i + 5] = alpha;

			// 	}

			// 	__vertexBufferAlpha = alpha;

			// }

			// if ((__vertexBufferColorTransform == null && colorTransform != null) || (__vertexBufferColorTransform != null && !__vertexBufferColorTransform.__equals (colorTransform))) {

			// 	dirty = true;

			// 	if (colorTransform != null) {

			// 		if (__vertexBufferColorTransform == null) {
			// 			__vertexBufferColorTransform = colorTransform.__clone ();
			// 		} else {
			// 			__vertexBufferColorTransform.__copyFrom (colorTransform);
			// 		}

			// 		for (i in 0...4) {

			// 			__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * i + 6] = colorTransform.redMultiplier;
			// 			__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * i + 11] = colorTransform.greenMultiplier;
			// 			__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * i + 16] = colorTransform.blueMultiplier;
			// 			__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * i + 21] = colorTransform.alphaMultiplier;
			// 			__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * i + 22] = colorTransform.redOffset / 255;
			// 			__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * i + 23] = colorTransform.greenOffset / 255;
			// 			__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * i + 24] = colorTransform.blueOffset / 255;
			// 			__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * i + 25] = colorTransform.alphaOffset / 255;

			// 		}

			// 	} else {

			// 		for (i in 0...4) {

			// 			__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * i + 6] = 1;
			// 			__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * i + 11] = 1;
			// 			__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * i + 16] = 1;
			// 			__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * i + 21] = 1;
			// 			__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * i + 22] = 0;
			// 			__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * i + 23] = 0;
			// 			__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * i + 24] = 0;
			// 			__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * i + 25] = 0;

			// 		}

			// 	}

			// }

			// context.__bindGLArrayBuffer (__vertexBuffer);

			// if (dirty) {

			// 	gl.bufferData (gl.ARRAY_BUFFER, __vertexBufferData.byteLength, __vertexBufferData, gl.STATIC_DRAW);

			// }
		}

		return parent.__vertexBuffer;
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

	public function getSurface():CairoImageSurface
	{
		if (parent.__surface == null)
		{
			parent.__surface = CairoImageSurface.fromImage(parent.limeImage);
		}

		return parent.__surface;
	}

	public function getTexture(context:Context3D):TextureBase
	{
		if (!parent.readable && parent.limeImage == null && (parent.__texture == null || parent.__textureContext != context.__context))
		{
			parent.__textureContext = null;
			parent.__texture = null;
			return null;
		}

		if (parent.__texture == null || parent.__textureContext != context.__context)
		{
			parent.__textureContext = context.__context;
			parent.__texture = context.createRectangleTexture(parent.__textureWidth, parent.__textureHeight, BGRA, false);

			// context.__bindGLTexture2D (__texture);
			// gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
			// gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
			// gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
			// gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
			parent.__textureVersion = -1;
		}

		#if openfl_html5
		ImageCanvasUtil.sync(parent.limeImage, false);
		#end

		if (parent.limeImage != null && parent.limeImage.version > parent.__textureVersion)
		{
			if (parent.__surface != null)
			{
				parent.__surface.flush();
			}

			var textureImage = parent.limeImage;

			#if openfl_html5
			if (#if openfl_power_of_two true || #end (!TextureBase.__supportsBGRA && textureImage.format != RGBA32))
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

			parent.__texture.__uploadFromImage(textureImage);

			parent.__textureVersion = parent.limeImage.version;

			parent.__textureWidth = textureImage.buffer.width;
			parent.__textureHeight = textureImage.buffer.height;
		}

		if (!parent.readable && parent.limeImage != null)
		{
			parent.__surface = null;
			parent.limeImage = null;
		}

		return parent.__texture;
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

			parent.__textureWidth = parent.width;
			parent.__textureHeight = parent.height;

			#if openfl_power_of_two
			parent.__textureWidth = __powerOfTwo(parent.width);
			parent.__textureHeight = __powerOfTwo(parent.height);
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

	private function __resize(width:Int, height:Int):Void
	{
		parent.width = width;
		parent.height = height;
		parent.rect.width = width;
		parent.rect.height = height;

		parent.__textureWidth = width;
		parent.__textureHeight = height;

		#if openfl_power_of_two
		parent.__textureWidth = __powerOfTwo(width);
		parent.__textureHeight = __powerOfTwo(height);
		#end
	}

	private function __setUVRect(context:Context3D, x:Float, y:Float, width:Float, height:Float):Void
	{
		var buffer = getVertexBuffer(context);

		if (buffer != null
			&& (width != parent.__uvRect.width || height != parent.__uvRect.height || x != parent.__uvRect.x || y != parent.__uvRect.y))
		{
			var gl = context.gl;

			if (parent.__uvRect == null) parent.__uvRect = new Rectangle();
			parent.__uvRect.setTo(x, y, width, height);

			var uvX = parent.__textureWidth > 0 ? x / parent.__textureWidth : 0;
			var uvY = parent.__textureHeight > 0 ? y / parent.__textureHeight : 0;
			var uvWidth = parent.__textureWidth > 0 ? width / parent.__textureWidth : 0;
			var uvHeight = parent.__textureHeight > 0 ? height / parent.__textureHeight : 0;

			parent.__vertexBufferData[0] = width;
			parent.__vertexBufferData[1] = height;
			parent.__vertexBufferData[3] = uvX + uvWidth;
			parent.__vertexBufferData[4] = uvY + uvHeight;
			parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE + 1] = height;
			parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE + 3] = uvX;
			parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE + 4] = uvY + uvHeight;
			parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 2] = width;
			parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 2 + 3] = uvX + uvWidth;
			parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 2 + 4] = uvY;
			parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 3 + 3] = uvX;
			parent.__vertexBufferData[BitmapData.VERTEX_BUFFER_STRIDE * 3 + 4] = uvY;

			parent.__vertexBuffer.uploadFromTypedArray(parent.__vertexBufferData);
		}
	}

	private function __setVertex(index:Int, x:Float, y:Float, u:Float, v:Float):Void
	{
		var i = index * BitmapData.VERTEX_BUFFER_STRIDE;
		parent.__vertexBufferData[i + 0] = x;
		parent.__vertexBufferData[i + 1] = y;
		parent.__vertexBufferData[i + 3] = u;
		parent.__vertexBufferData[i + 4] = v;
	}

	private function __setVertices(indices:Array<Int>, x:Float, y:Float, u:Float, v:Float):Void
	{
		for (index in indices)
		{
			__setVertex(index, x, y, u, v);
		}
	}

	private function __setUOffsets(indices:Array<Int>, offset:Float):Void
	{
		for (index in indices)
		{
			parent.__vertexBufferData[index * BitmapData.VERTEX_BUFFER_STRIDE + 3] += offset;
		}
	}

	private function __setVOffsets(indices:Array<Int>, offset:Float):Void
	{
		for (index in indices)
		{
			parent.__vertexBufferData[index * BitmapData.VERTEX_BUFFER_STRIDE + 4] += offset;
		}
	}

	private function __sync():Void
	{
		#if openfl_html5
		ImageCanvasUtil.sync(parent.limeImage, false);
		#end
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
}
#end
