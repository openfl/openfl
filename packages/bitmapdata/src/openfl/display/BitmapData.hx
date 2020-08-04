package openfl.display;

#if !flash
import openfl._internal.backend.gl.GLFramebuffer;
import openfl._internal.backend.gl.GLRenderbuffer;
import openfl._internal.utils.Float32Array;
import openfl.display._internal.PerlinNoise;
import openfl._internal.utils.UInt16Array;
import openfl._internal.utils.UInt8Array;
import openfl.display3D.textures.TextureBase;
import openfl.display3D.Context3DClearMask;
import openfl.display3D.Context3D;
import openfl.display3D.IndexBuffer3D;
import openfl.display3D.VertexBuffer3D;
import openfl.errors.Error;
import openfl.filters.BitmapFilter;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import openfl.utils.Endian;
import openfl.utils.Future;
import openfl.utils.Object;
import openfl.Lib;
import openfl.Vector;
#if lime
import lime._internal.graphics.ImageCanvasUtil; // TODO
import lime.app.Application;
import lime.graphics.cairo.CairoFilter;
import lime.graphics.cairo.CairoImageSurface;
import lime.graphics.cairo.CairoPattern;
import lime.graphics.cairo.CairoSurface;
import lime.graphics.cairo.Cairo;
import lime.graphics.Image;
import lime.graphics.ImageChannel;
import lime.graphics.ImageBuffer;
import lime.graphics.RenderContext;
import lime.math.ARGB;
import lime.math.Vector2;
#end
#if (js && html5)
import js.html.CanvasElement;
#end
#if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
#end

@:access(lime.graphics.opengl.GL)
@:access(lime.graphics.Image)
@:access(lime.graphics.ImageBuffer)
@:access(lime.math.Rectangle)
@:access(openfl.display3D.textures.TextureBase)
@:access(openfl.display3D.Context3D)
@:access(openfl.display.DisplayObject)
@:access(openfl.display.DisplayObjectShader)
@:access(openfl.display.Graphics)
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
@:autoBuild(openfl._internal.macros.AssetsMacro.embedBitmap())
class BitmapData implements IBitmapDrawable
{
	@:noCompletion private static inline var VERTEX_BUFFER_STRIDE:Int = 14;
	@:noCompletion private static var __supportsBGRA:Null<Bool> = null;
	@:noCompletion private static var __textureFormat:Int;
	@:noCompletion private static var __textureInternalFormat:Int;
	#if lime
	@:noCompletion private static var __tempVector:Vector2 = new Vector2();
	#end

	public var height(default, null):Int;
	@SuppressWarnings("checkstyle:Dynamic")
	public var image(default, null):#if lime Image #else Dynamic #end;
	@:beta public var readable(default, null):Bool;
	public var rect(default, null):Rectangle;
	public var transparent(default, null):Bool;
	public var width(default, null):Int;

	@:noCompletion private var __blendMode:BlendMode;
	// @:noCompletion private var __vertexBufferColorTransform:ColorTransform;
	// @:noCompletion private var __vertexBufferAlpha:Float;
	@:noCompletion private var __framebuffer:GLFramebuffer;
	@SuppressWarnings("checkstyle:Dynamic") @:noCompletion private var __framebufferContext:#if lime RenderContext #else Dynamic #end;
	@:noCompletion private var __indexBuffer:IndexBuffer3D;
	@SuppressWarnings("checkstyle:Dynamic") @:noCompletion private var __indexBufferContext:#if lime RenderContext #else Dynamic #end;
	@:noCompletion private var __indexBufferData:UInt16Array;
	@:noCompletion private var __indexBufferGrid:Rectangle;
	@:noCompletion private var __isMask:Bool;
	@:noCompletion private var __isValid:Bool;
	@:noCompletion private var __mask:DisplayObject;
	@:noCompletion private var __renderable:Bool;
	@:noCompletion private var __renderTransform:Matrix;
	@:noCompletion private var __scrollRect:Rectangle;
	@:noCompletion private var __stencilBuffer:GLRenderbuffer;
	@SuppressWarnings("checkstyle:Dynamic") @:noCompletion private var __surface:#if lime CairoSurface #else Dynamic #end;
	@:noCompletion private var __texture:TextureBase;
	@SuppressWarnings("checkstyle:Dynamic") @:noCompletion private var __textureContext:#if lime RenderContext #else Dynamic #end;
	@:noCompletion private var __textureHeight:Int;
	@:noCompletion private var __textureVersion:Int;
	@:noCompletion private var __textureWidth:Int;
	@:noCompletion private var __transform:Matrix;
	@:noCompletion private var __uvRect:Rectangle;
	@:noCompletion private var __vertexBuffer:VertexBuffer3D;
	@SuppressWarnings("checkstyle:Dynamic") @:noCompletion private var __vertexBufferContext:#if lime RenderContext #else Dynamic #end;
	@:noCompletion private var __vertexBufferData:Float32Array;
	@:noCompletion private var __vertexBufferGrid:Rectangle;
	@:noCompletion private var __vertexBufferHeight:Float;
	@:noCompletion private var __vertexBufferScaleX:Float;
	@:noCompletion private var __vertexBufferScaleY:Float;
	@:noCompletion private var __vertexBufferWidth:Float;
	@:noCompletion private var __worldAlpha:Float;
	@:noCompletion private var __worldColorTransform:ColorTransform;
	@:noCompletion private var __worldTransform:Matrix;

	public function new(width:Int, height:Int, transparent:Bool = true, fillColor:UInt = 0xFFFFFFFF)
	{
		this.transparent = transparent;

		#if (neko || (js && html5))
		width = width == null ? 0 : width;
		height = height == null ? 0 : height;
		#end

		width = width < 0 ? 0 : width;
		height = height < 0 ? 0 : height;

		this.width = width;
		this.height = height;
		rect = new Rectangle(0, 0, width, height);

		__textureWidth = width;
		__textureHeight = height;

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

			#if lime
			#if sys
			var buffer = new ImageBuffer(new UInt8Array(width * height * 4), width, height);
			buffer.format = BGRA32;
			buffer.premultiplied = true;

			image = new Image(buffer, 0, 0, width, height);

			if (fillColor != 0)
			{
				image.fillRect(image.rect, fillColor);
			}
			// #elseif (js && html5)
			// var buffer = new ImageBuffer (null, width, height);
			// var canvas:CanvasElement = cast Browser.document.createElement ("canvas");
			// buffer.__srcCanvas = canvas;
			// buffer.__srcContext = canvas.getContext ("2d");
			//
			// image = new Image (buffer, 0, 0, width, height);
			// image.type = CANVAS;
			//
			// if (fillColor != 0) {
			//
			// image.fillRect (image.rect, fillColor);
			//
			// }
			#else
			image = new Image(null, 0, 0, width, height, fillColor);
			#end

			image.transparent = transparent;
			#end

			__isValid = true;
			readable = true;
		}

		__renderTransform = new Matrix();
		__worldAlpha = 1;
		__worldTransform = new Matrix();
		__worldColorTransform = new ColorTransform();
		__renderable = true;
	}

	public function applyFilter(sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, filter:BitmapFilter):Void
	{
		if (!readable || sourceBitmapData == null || !sourceBitmapData.readable) return;

		// TODO: Ways to optimize this?

		var needSecondBitmapData = filter.__needSecondBitmapData;
		var needCopyOfOriginal = filter.__preserveObject;

		var bitmapData2 = null;
		var bitmapData3 = null;

		if (needSecondBitmapData)
		{
			bitmapData2 = new BitmapData(width, height, true, 0);
		}
		else
		{
			bitmapData2 = this;
		}

		if (needCopyOfOriginal)
		{
			bitmapData3 = new BitmapData(width, height, true, 0);
		}

		if (filter.__preserveObject)
		{
			bitmapData3.copyPixels(this, rect, destPoint);
		}

		var lastBitmap = filter.__applyFilter(bitmapData2, this, sourceRect, destPoint);

		if (filter.__preserveObject)
		{
			lastBitmap.draw(bitmapData3, null, null);
		}

		if (needSecondBitmapData && lastBitmap == bitmapData2)
		{
			bitmapData2.image.version = image.version;
			image = bitmapData2.image;
		}

		image.dirty = true;
		image.version++;
	}

	public function clone():BitmapData
	{
		#if lime
		var bitmapData;

		if (!__isValid)
		{
			bitmapData = new BitmapData(width, height, transparent, 0);
		}
		else if (!readable && image == null)
		{
			bitmapData = new BitmapData(0, 0, transparent, 0);

			bitmapData.width = width;
			bitmapData.height = height;
			bitmapData.__textureWidth = __textureWidth;
			bitmapData.__textureHeight = __textureHeight;
			bitmapData.rect.copyFrom(rect);

			bitmapData.__framebuffer = __framebuffer;
			bitmapData.__framebufferContext = __framebufferContext;
			bitmapData.__texture = __texture;
			bitmapData.__textureContext = __textureContext;
			bitmapData.__isValid = true;
		}
		else
		{
			bitmapData = BitmapData.fromImage(image.clone(), transparent);
		}

		bitmapData.__worldTransform.copyFrom(__worldTransform);
		bitmapData.__renderTransform.copyFrom(__renderTransform);

		return bitmapData;
		#else
		return null;
		#end
	}

	public function colorTransform(rect:Rectangle, colorTransform:ColorTransform):Void
	{
		if (!readable) return;

		#if lime
		image.colorTransform(rect.__toLimeRectangle(), colorTransform.__toLimeColorMatrix());
		#end
	}

	@SuppressWarnings("checkstyle:Dynamic")
	public function compare(otherBitmapData:BitmapData):Dynamic
	{
		#if lime
		if (otherBitmapData == this)
		{
			return 0;
		}
		else if (otherBitmapData == null)
		{
			return -1;
		}
		else if (readable == false || otherBitmapData.readable == false)
		{
			return -2;
		}
		else if (width != otherBitmapData.width)
		{
			return -3;
		}
		else if (height != otherBitmapData.height)
		{
			return -4;
		}

		if (image != null && otherBitmapData.image != null && image.format == otherBitmapData.image.format)
		{
			var bytes = image.data;
			var otherBytes = otherBitmapData.image.data;
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

		for (y in 0...height)
		{
			for (x in 0...width)
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
						bitmapData = new BitmapData(width, height, transparent || otherBitmapData.transparent, 0x00000000);
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
		#else
		return 0;
		#end
	}

	public function copyChannel(sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, sourceChannel:BitmapDataChannel,
			destChannel:BitmapDataChannel):Void
	{
		if (!readable) return;

		#if lime
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

		image.copyChannel(sourceBitmapData.image, sourceRect.__toLimeRectangle(), destPoint.__toLimeVector2(), sourceChannel, destChannel);
		#end
	}

	public function copyPixels(sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, alphaBitmapData:BitmapData = null, alphaPoint:Point = null,
			mergeAlpha:Bool = false):Void
	{
		if (!readable || sourceBitmapData == null) return;

		#if lime
		if (alphaPoint != null)
		{
			__tempVector.x = alphaPoint.x;
			__tempVector.y = alphaPoint.y;
		}

		image.copyPixels(sourceBitmapData.image, sourceRect.__toLimeRectangle(), destPoint.__toLimeVector2(),
			alphaBitmapData != null ? alphaBitmapData.image : null, alphaPoint != null ? __tempVector : null, mergeAlpha);
		#end
	}

	// @:noCompletion @:dox(hide) @:require(flash11_4) public function copyPixelsToByteArray (rect:Rectangle, data:ByteArray):Void;

	public function dispose():Void
	{
		image = null;

		width = 0;
		height = 0;
		rect = null;

		__isValid = false;
		readable = false;

		__surface = null;

		__vertexBuffer = null;
		__framebuffer = null;
		__framebufferContext = null;
		__texture = null;
		__textureContext = null;

		// if (__texture != null) {
		//
		// var renderer = @:privateAccess Lib.current.stage.__renderer;
		//
		// if(renderer != null) {
		//
		// var renderer = @:privateAccess renderer.renderer;
		// var gl = renderer.__gl;
		//
		// if (gl != null) {
		//
		// gl.deleteTexture (__texture);
		// __texture = null;
		//
		// }
		//
		// }
		//
		// }
	}

	@:beta public function disposeImage():Void
	{
		readable = false;
	}

	public function draw(source:IBitmapDrawable, matrix:Matrix = null, colorTransform:ColorTransform = null, blendMode:BlendMode = null,
			clipRect:Rectangle = null, smoothing:Bool = false):Void
	{
		if (source == null) return;

		source.__update(false, true);

		var transform = Matrix.__pool.get();

		transform.copyFrom(source.__renderTransform);
		transform.invert();

		if (matrix != null)
		{
			transform.concat(matrix);
		}

		var clipMatrix = null;

		if (clipRect != null)
		{
			clipMatrix = Matrix.__pool.get();
			clipMatrix.copyFrom(transform);
			clipMatrix.invert();
		}

		var _colorTransform = new ColorTransform();
		_colorTransform.__copyFrom(source.__worldColorTransform);
		_colorTransform.__invert();

		if (!readable && Lib.current.stage.context3D != null)
		{
			if (__textureContext == null)
			{
				// TODO: Some way to select current GL context for renderer?
				__textureContext = Application.current.window.context;
			}

			if (colorTransform != null)
			{
				_colorTransform.__combine(colorTransform);
			}

			var renderer = new OpenGLRenderer(Lib.current.stage.context3D, this);
			renderer.__allowSmoothing = smoothing;
			renderer.__overrideBlendMode = blendMode;

			renderer.__worldTransform = transform;
			renderer.__worldAlpha = 1 / source.__worldAlpha;
			renderer.__worldColorTransform = _colorTransform;

			renderer.__resize(width, height);

			if (clipRect != null)
			{
				renderer.__pushMaskRect(clipRect, clipMatrix);
			}

			__drawGL(source, renderer);

			if (clipRect != null)
			{
				renderer.__popMaskRect();
				Matrix.__pool.release(clipMatrix);
			}
		}
		else
		{
			#if ((js && html5) || lime_cairo)
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

			#if (js && html5)
			ImageCanvasUtil.convertToCanvas(image);
			var renderer = new CanvasRenderer(image.buffer.__srcContext);
			#else
			var renderer = new CairoRenderer(new Cairo(getSurface()));
			#end

			renderer.__allowSmoothing = smoothing;
			renderer.__overrideBlendMode = blendMode;

			renderer.__worldTransform = transform;
			renderer.__worldAlpha = 1 / source.__worldAlpha;
			renderer.__worldColorTransform = _colorTransform;

			if (clipRect != null)
			{
				renderer.__pushMaskRect(clipRect, clipMatrix);
			}

			#if (js && html5)
			__drawCanvas(source, renderer);
			#else
			__drawCairo(source, renderer);
			#end

			if (clipRect != null)
			{
				renderer.__popMaskRect();
				Matrix.__pool.release(clipMatrix);
			}
			#end
		}

		Matrix.__pool.release(transform);
	}

	public function drawWithQuality(source:IBitmapDrawable, matrix:Matrix = null, colorTransform:ColorTransform = null, blendMode:BlendMode = null,
			clipRect:Rectangle = null, smoothing:Bool = false, quality:StageQuality = null):Void
	{
		draw(source, matrix, colorTransform, blendMode, clipRect, quality != LOW ? smoothing : false);
	}

	public function encode(rect:Rectangle, compressor:Object, byteArray:ByteArray = null):ByteArray
	{
		#if lime
		if (!readable || rect == null) return byteArray = null;
		if (byteArray == null) byteArray = new ByteArray();

		var image = this.image;

		if (!rect.equals(this.rect))
		{
			var matrix = Matrix.__pool.get();
			matrix.tx = Math.round(-rect.x);
			matrix.ty = Math.round(-rect.y);

			var bitmapData = new BitmapData(Math.ceil(rect.width), Math.ceil(rect.height), true, 0);
			bitmapData.draw(this, matrix);

			image = bitmapData.image;

			Matrix.__pool.release(matrix);
		}

		if ((compressor is PNGEncoderOptions))
		{
			byteArray.writeBytes(ByteArray.fromBytes(image.encode(PNG)));
			return byteArray;
		}
		else if ((compressor is JPEGEncoderOptions))
		{
			byteArray.writeBytes(ByteArray.fromBytes(image.encode(JPEG, cast(compressor, JPEGEncoderOptions).quality)));
			return byteArray;
		}
		#end

		return byteArray = null;
	}

	public function fillRect(rect:Rectangle, color:Int):Void
	{
		__fillRect(rect, color, true);
	}

	public function floodFill(x:Int, y:Int, color:Int):Void
	{
		#if lime
		if (!readable) return;
		image.floodFill(x, y, color, ARGB32);
		#end
	}

	#if (!openfl_doc_gen || (!js && !html5 && !flash_doc_gen))
	public static function fromBase64(base64:String, type:String):BitmapData
	{
		#if (js && html5)
		return null;
		#else
		var bitmapData = new BitmapData(0, 0, true, 0);
		bitmapData.__fromBase64(base64, type);
		return bitmapData;
		#end
	}
	#end

	#if (!openfl_doc_gen || (!js && !html5 && !flash_doc_gen))
	public static function fromBytes(bytes:ByteArray, rawAlpha:ByteArray = null):BitmapData
	{
		#if (js && html5)
		return null;
		#else
		var bitmapData = new BitmapData(0, 0, true, 0);
		bitmapData.__fromBytes(bytes, rawAlpha);
		return bitmapData;
		#end
	}
	#end

	#if (js && html5)
	public static function fromCanvas(canvas:CanvasElement, transparent:Bool = true):BitmapData
	{
		if (canvas == null) return null;

		var bitmapData = new BitmapData(0, 0, transparent, 0);
		bitmapData.__fromImage(Image.fromCanvas(canvas));
		bitmapData.image.transparent = transparent;
		return bitmapData;
	}
	#end

	#if (!openfl_doc_gen || (!js && !html5 && !flash_doc_gen))
	public static function fromFile(path:String):BitmapData
	{
		#if (js && html5)
		return null;
		#else
		var bitmapData = new BitmapData(0, 0, true, 0);
		bitmapData.__fromFile(path);
		return bitmapData.image != null ? bitmapData : null;
		#end
	}
	#end

	#if lime
	public static function fromImage(image:Image, transparent:Bool = true):BitmapData
	{
		if (image == null || image.buffer == null) return null;

		var bitmapData = new BitmapData(0, 0, transparent, 0);
		bitmapData.__fromImage(image);
		bitmapData.image.transparent = transparent;
		return bitmapData.image != null ? bitmapData : null;
	}
	#end

	public static function fromTexture(texture:TextureBase):BitmapData
	{
		if (texture == null) return null;

		var bitmapData = new BitmapData(texture.__width, texture.__height, true, 0);
		bitmapData.readable = false;
		bitmapData.__texture = texture;
		bitmapData.__textureContext = texture.__textureContext;
		bitmapData.image = null;
		return bitmapData;
	}

	public function generateFilterRect(sourceRect:Rectangle, filter:BitmapFilter):Rectangle
	{
		return sourceRect.clone();
	}

	@:dox(hide) public function getIndexBuffer(context:Context3D, scale9Grid:Rectangle = null):IndexBuffer3D
	{
		var gl = context.gl;

		if (__indexBuffer == null
			|| __indexBufferContext != context.__context
			|| (scale9Grid != null && __indexBufferGrid == null)
			|| (__indexBufferGrid != null && !__indexBufferGrid.equals(scale9Grid)))
		{
			// TODO: Use shared buffer on context
			// TODO: Support for UVs other than scale-9 grid?

			#if lime
			__indexBufferContext = context.__context;
			__indexBuffer = null;

			if (scale9Grid != null)
			{
				if (__indexBufferGrid == null) __indexBufferGrid = new Rectangle();
				__indexBufferGrid.copyFrom(scale9Grid);

				var centerX = scale9Grid.width;
				var centerY = scale9Grid.height;
				if (centerX != 0 && centerY != 0)
				{
					__indexBufferData = new UInt16Array(54);

					// 3 ——— 2 ——— 5 ——— 7
					// |  /  |  /  |  /  |
					// 1 ——— 0 ——— 4 ——— 6
					// |  /  |  /  |  /  |
					// 9 ——— 8 —— 10 —— 11
					// |  /  |  /  |  /  |
					// 13 — 12 —— 14 —— 15

					// top left
					__indexBufferData[0] = 0;
					__indexBufferData[1] = 1;
					__indexBufferData[2] = 2;
					__indexBufferData[3] = 2;
					__indexBufferData[4] = 1;
					__indexBufferData[5] = 3;

					// top center
					__indexBufferData[6] = 4;
					__indexBufferData[7] = 0;
					__indexBufferData[8] = 5;
					__indexBufferData[9] = 5;
					__indexBufferData[10] = 0;
					__indexBufferData[11] = 2;

					// top right
					__indexBufferData[12] = 6;
					__indexBufferData[13] = 4;
					__indexBufferData[14] = 7;
					__indexBufferData[15] = 7;
					__indexBufferData[16] = 4;
					__indexBufferData[17] = 5;

					// middle left
					__indexBufferData[18] = 8;
					__indexBufferData[19] = 9;
					__indexBufferData[20] = 0;
					__indexBufferData[21] = 0;
					__indexBufferData[22] = 9;
					__indexBufferData[23] = 1;

					// middle center
					__indexBufferData[24] = 10;
					__indexBufferData[25] = 8;
					__indexBufferData[26] = 4;
					__indexBufferData[27] = 4;
					__indexBufferData[28] = 8;
					__indexBufferData[29] = 0;

					// middle right
					__indexBufferData[30] = 11;
					__indexBufferData[31] = 10;
					__indexBufferData[32] = 6;
					__indexBufferData[33] = 6;
					__indexBufferData[34] = 10;
					__indexBufferData[35] = 4;

					// bottom left
					__indexBufferData[36] = 12;
					__indexBufferData[37] = 13;
					__indexBufferData[38] = 8;
					__indexBufferData[39] = 8;
					__indexBufferData[40] = 13;
					__indexBufferData[41] = 9;

					// bottom center
					__indexBufferData[42] = 14;
					__indexBufferData[43] = 12;
					__indexBufferData[44] = 10;
					__indexBufferData[45] = 10;
					__indexBufferData[46] = 12;
					__indexBufferData[47] = 8;

					// bottom center
					__indexBufferData[48] = 15;
					__indexBufferData[49] = 14;
					__indexBufferData[50] = 11;
					__indexBufferData[51] = 11;
					__indexBufferData[52] = 14;
					__indexBufferData[53] = 10;

					__indexBuffer = context.createIndexBuffer(54);
				}
				else if (centerX == 0 && centerY != 0)
				{
					__indexBufferData = new UInt16Array(18);

					// 3 ——— 2
					// |  /  |
					// 1 ——— 0
					// |  /  |
					// 5 ——— 4
					// |  /  |
					// 7 ——— 6

					// top
					__indexBufferData[0] = 0;
					__indexBufferData[1] = 1;
					__indexBufferData[2] = 2;
					__indexBufferData[3] = 2;
					__indexBufferData[4] = 1;
					__indexBufferData[5] = 3;

					// middle
					__indexBufferData[6] = 4;
					__indexBufferData[7] = 5;
					__indexBufferData[8] = 0;
					__indexBufferData[9] = 0;
					__indexBufferData[10] = 5;
					__indexBufferData[11] = 1;

					// bottom
					__indexBufferData[12] = 6;
					__indexBufferData[13] = 7;
					__indexBufferData[14] = 4;
					__indexBufferData[15] = 4;
					__indexBufferData[16] = 7;
					__indexBufferData[17] = 5;

					__indexBuffer = context.createIndexBuffer(18);
				}
				else if (centerX != 0 && centerY == 0)
				{
					__indexBufferData = new UInt16Array(18);

					// 3 ——— 2 ——— 5 ——— 7
					// |  /  |  /  |  /  |
					// 1 ——— 0 ——— 4 ——— 6

					// left
					__indexBufferData[0] = 0;
					__indexBufferData[1] = 1;
					__indexBufferData[2] = 2;
					__indexBufferData[3] = 2;
					__indexBufferData[4] = 1;
					__indexBufferData[5] = 3;

					// center
					__indexBufferData[6] = 4;
					__indexBufferData[7] = 0;
					__indexBufferData[8] = 5;
					__indexBufferData[9] = 5;
					__indexBufferData[10] = 0;
					__indexBufferData[11] = 2;

					// right
					__indexBufferData[12] = 6;
					__indexBufferData[13] = 4;
					__indexBufferData[14] = 7;
					__indexBufferData[15] = 7;
					__indexBufferData[16] = 4;
					__indexBufferData[17] = 5;

					__indexBuffer = context.createIndexBuffer(18);
				}
			}
			else
			{
				__indexBufferGrid = null;
			}

			if (__indexBuffer == null)
			{
				__indexBufferData = new UInt16Array(6);
				__indexBufferData[0] = 0;
				__indexBufferData[1] = 1;
				__indexBufferData[2] = 2;
				__indexBufferData[3] = 2;
				__indexBufferData[4] = 1;
				__indexBufferData[5] = 3;
				__indexBuffer = context.createIndexBuffer(6);
			}

			__indexBuffer.uploadFromTypedArray(__indexBufferData);
			#end
		}

		return __indexBuffer;
	}

	@:dox(hide) public function getVertexBuffer(context:Context3D, scale9Grid:Rectangle = null, targetObject:DisplayObject = null):VertexBuffer3D
	{
		var gl = context.gl;

		// TODO: Support for UVs other than scale-9 grid?
		// TODO: Better way of handling object transform?

		if (__vertexBuffer == null
			|| __vertexBufferContext != context.__context
			|| (scale9Grid != null && __vertexBufferGrid == null)
			|| (__vertexBufferGrid != null && !__vertexBufferGrid.equals(scale9Grid))
			|| (targetObject != null
				&& (__vertexBufferWidth != targetObject.width
					|| __vertexBufferHeight != targetObject.height
					|| __vertexBufferScaleX != targetObject.scaleX
					|| __vertexBufferScaleY != targetObject.scaleY)))
		{
			#if openfl_power_of_two
			var newWidth = 1;
			var newHeight = 1;

			while (newWidth < width)
			{
				newWidth <<= 1;
			}

			while (newHeight < height)
			{
				newHeight <<= 1;
			}

			__uvRect = new Rectangle(0, 0, newWidth, newHeight);

			var uvWidth = width / newWidth;
			var uvHeight = height / newHeight;

			__textureWidth = newWidth;
			__textureHeight = newHeight;
			#else
			__uvRect = new Rectangle(0, 0, width, height);

			var uvWidth = 1;
			var uvHeight = 1;
			#end

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

			#if lime
			__vertexBufferContext = context.__context;
			__vertexBuffer = null;

			if (targetObject != null)
			{
				__vertexBufferWidth = targetObject.width;
				__vertexBufferHeight = targetObject.height;
				__vertexBufferScaleX = targetObject.scaleX;
				__vertexBufferScaleY = targetObject.scaleY;
			}

			if (scale9Grid != null && targetObject != null)
			{
				if (__vertexBufferGrid == null) __vertexBufferGrid = new Rectangle();
				__vertexBufferGrid.copyFrom(scale9Grid);

				__vertexBufferWidth = targetObject.width;
				__vertexBufferHeight = targetObject.height;
				__vertexBufferScaleX = targetObject.scaleX;
				__vertexBufferScaleY = targetObject.scaleY;

				var centerX = scale9Grid.width;
				var centerY = scale9Grid.height;
				if (centerX != 0 && centerY != 0)
				{
					__vertexBufferData = new Float32Array(VERTEX_BUFFER_STRIDE * 16);

					var left = scale9Grid.x;
					var top = scale9Grid.y;
					var right = width - centerX - left;
					var bottom = height - centerY - top;

					var uvLeft = left / width;
					var uvTop = top / height;
					var uvCenterX = centerX / width;
					var uvCenterY = centerY / height;
					var uvRight = right / width;
					var uvBottom = bottom / height;

					var renderedLeft = left / targetObject.scaleX;
					var renderedTop = top / targetObject.scaleY;
					var renderedRight = right / targetObject.scaleX;
					var renderedBottom = bottom / targetObject.scaleY;
					var renderedCenterX = (targetObject.width / targetObject.scaleX) - renderedLeft - renderedRight;
					var renderedCenterY = (targetObject.height / targetObject.scaleY) - renderedTop - renderedBottom;

					// 3 ——— 2 ——— 5 ——— 7
					// |  /  |  /  |  /  |
					// 1 ——— 0 ——— 4 ——— 6
					// |  /  |  /  |  /  |
					// 9 ——— 8 —— 10 —— 11
					// |  /  |  /  |  /  |
					// 13 — 12 —— 14 —— 15

					// top left <0-1-2> <2-1-3>
					__vertexBufferData[0] = renderedLeft;
					__vertexBufferData[1] = renderedTop;
					__vertexBufferData[3] = uvWidth * uvLeft;
					__vertexBufferData[4] = uvHeight * uvTop;

					__vertexBufferData[VERTEX_BUFFER_STRIDE + 1] = renderedTop;
					__vertexBufferData[VERTEX_BUFFER_STRIDE + 4] = uvHeight * uvTop;

					__vertexBufferData[VERTEX_BUFFER_STRIDE * 2] = renderedLeft;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 2 + 3] = uvWidth * uvLeft;

					// top center <4-0-5> <5-0-2>
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 4] = renderedLeft + renderedCenterX;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 4 + 1] = renderedTop;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 4 + 3] = uvWidth * (uvLeft + uvCenterX);
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 4 + 4] = uvHeight * uvTop;

					__vertexBufferData[VERTEX_BUFFER_STRIDE * 5] = renderedLeft + renderedCenterX;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 5 + 3] = uvWidth * (uvLeft + uvCenterX);

					// top right <6-4-7> <7-4-5>
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 6] = width;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 6 + 1] = renderedTop;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 6 + 3] = uvWidth;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 6 + 4] = uvHeight * uvTop;

					__vertexBufferData[VERTEX_BUFFER_STRIDE * 7] = width;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 7 + 3] = uvWidth;

					// middle left <8-9-0> <0-9-1>
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 8] = renderedLeft;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 8 + 1] = renderedTop + renderedCenterY;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 8 + 3] = uvWidth * uvLeft;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 8 + 4] = uvHeight * (uvTop + uvCenterY);

					__vertexBufferData[VERTEX_BUFFER_STRIDE * 9 + 1] = renderedTop + renderedCenterY;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 9 + 4] = uvHeight * (uvTop + uvCenterY);

					// middle center <10-8-4> <4-8-0>
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 10] = renderedLeft + renderedCenterX;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 10 + 1] = renderedTop + renderedCenterY;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 10 + 3] = uvWidth * (uvLeft + uvCenterX);
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 10 + 4] = uvHeight * (uvTop + uvCenterY);

					// middle right <11-10-6> <6-10-4>
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 11] = width;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 11 + 1] = renderedTop + renderedCenterY;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 11 + 3] = uvWidth;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 11 + 4] = uvHeight * (uvTop + uvCenterY);

					// bottom left <12-13-8> <8-13-9>
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 12] = renderedLeft;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 12 + 1] = height;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 12 + 3] = uvWidth * uvLeft;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 12 + 4] = uvHeight;

					__vertexBufferData[VERTEX_BUFFER_STRIDE * 13 + 1] = height;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 13 + 4] = uvHeight;

					// bottom center <14-12-10> <10-12-8>
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 14] = renderedLeft + renderedCenterX;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 14 + 1] = height;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 14 + 3] = uvWidth * (uvLeft + uvCenterX);
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 14 + 4] = uvHeight;

					// bottom right <15-14-11> <11-14-10>
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 15] = width;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 15 + 1] = height;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 15 + 3] = uvWidth;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 15 + 4] = uvHeight;

					__vertexBuffer = context.createVertexBuffer(16, VERTEX_BUFFER_STRIDE);
				}
				else if (centerX == 0 && centerY != 0)
				{
					__vertexBufferData = new Float32Array(VERTEX_BUFFER_STRIDE * 8);

					var top = scale9Grid.y;
					var bottom = height - centerY - top;

					var uvTop = top / height;
					var uvCenterY = centerY / height;
					var uvBottom = bottom / height;

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
					__vertexBufferData[0] = renderedWidth;
					__vertexBufferData[1] = renderedTop;
					__vertexBufferData[3] = uvWidth;
					__vertexBufferData[4] = uvHeight * uvTop;

					__vertexBufferData[VERTEX_BUFFER_STRIDE + 1] = renderedTop;
					__vertexBufferData[VERTEX_BUFFER_STRIDE + 4] = uvHeight * uvTop;

					__vertexBufferData[VERTEX_BUFFER_STRIDE * 2] = renderedWidth;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 2 + 3] = uvWidth;

					// middle <4-5-0> <0-5-1>
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 4] = renderedWidth;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 4 + 1] = renderedTop + renderedCenterY;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 4 + 3] = uvWidth;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 4 + 4] = uvHeight * (uvTop + uvCenterY);

					__vertexBufferData[VERTEX_BUFFER_STRIDE * 5 + 1] = renderedTop + renderedCenterY;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 5 + 4] = uvHeight * (uvTop + uvCenterY);

					// bottom <6-7-4> <4-7-5>
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 6] = renderedWidth;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 6 + 1] = height;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 6 + 3] = uvWidth;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 6 + 4] = uvHeight;

					__vertexBufferData[VERTEX_BUFFER_STRIDE * 7 + 1] = height;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 7 + 4] = uvHeight;

					__vertexBuffer = context.createVertexBuffer(8, VERTEX_BUFFER_STRIDE);
				}
				else if (centerY == 0 && centerX != 0)
				{
					__vertexBufferData = new Float32Array(VERTEX_BUFFER_STRIDE * 8);

					var left = scale9Grid.x;
					var right = width - centerX - left;

					var uvLeft = left / width;
					var uvCenterX = centerX / width;
					var uvRight = right / width;

					var renderedLeft = left / targetObject.scaleX;
					var renderedRight = right / targetObject.scaleX;
					var renderedCenterX = (targetObject.width / targetObject.scaleX) - renderedLeft - renderedRight;

					var renderedHeight = targetObject.height / targetObject.scaleY;

					// 3 ——— 2 ——— 5 ——— 7
					// |  /  |  /  |  /  |
					// 1 ——— 0 ——— 4 ——— 6

					// top left <0-1-2> <2-1-3>
					__vertexBufferData[0] = renderedLeft;
					__vertexBufferData[1] = renderedHeight;
					__vertexBufferData[3] = uvWidth * uvLeft;
					__vertexBufferData[4] = uvHeight;

					__vertexBufferData[VERTEX_BUFFER_STRIDE + 1] = renderedHeight;
					__vertexBufferData[VERTEX_BUFFER_STRIDE + 4] = uvHeight;

					__vertexBufferData[VERTEX_BUFFER_STRIDE * 2] = renderedLeft;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 2 + 3] = uvWidth * uvLeft;

					// top center <4-0-5> <5-0-2>
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 4] = renderedLeft + renderedCenterX;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 4 + 1] = renderedHeight;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 4 + 3] = uvWidth * (uvLeft + uvCenterX);
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 4 + 4] = uvHeight;

					__vertexBufferData[VERTEX_BUFFER_STRIDE * 5] = renderedLeft + renderedCenterX;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 5 + 3] = uvWidth * (uvLeft + uvCenterX);

					// top right <6-4-7> <7-4-5>
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 6] = width;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 6 + 1] = renderedHeight;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 6 + 3] = uvWidth;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 6 + 4] = uvHeight;

					__vertexBufferData[VERTEX_BUFFER_STRIDE * 7] = width;
					__vertexBufferData[VERTEX_BUFFER_STRIDE * 7 + 3] = uvWidth;

					__vertexBuffer = context.createVertexBuffer(8, VERTEX_BUFFER_STRIDE);
				}
			}
			else
			{
				__vertexBufferGrid = null;
			}

			if (__vertexBuffer == null)
			{
				__vertexBufferData = new Float32Array(VERTEX_BUFFER_STRIDE * 4);

				__vertexBufferData[0] = width;
				__vertexBufferData[1] = height;
				__vertexBufferData[3] = uvWidth;
				__vertexBufferData[4] = uvHeight;
				__vertexBufferData[VERTEX_BUFFER_STRIDE + 1] = height;
				__vertexBufferData[VERTEX_BUFFER_STRIDE + 4] = uvHeight;
				__vertexBufferData[VERTEX_BUFFER_STRIDE * 2] = width;
				__vertexBufferData[VERTEX_BUFFER_STRIDE * 2 + 3] = uvWidth;

				__vertexBuffer = context.createVertexBuffer(3, VERTEX_BUFFER_STRIDE);
			}

			// for (i in 0...4) {

			// 	__vertexBufferData[VERTEX_BUFFER_STRIDE * i + 5] = alpha;

			// 	if (colorTransform != null) {

			// 		__vertexBufferData[VERTEX_BUFFER_STRIDE * i + 6] = colorTransform.redMultiplier;
			// 		__vertexBufferData[VERTEX_BUFFER_STRIDE * i + 7] = colorTransform.greenMultiplier;
			// 		__vertexBufferData[VERTEX_BUFFER_STRIDE * i + 8] = colorTransform.blueMultiplier;
			// 		__vertexBufferData[VERTEX_BUFFER_STRIDE * i + 9] = colorTransform.alphaMultiplier;
			// 		__vertexBufferData[VERTEX_BUFFER_STRIDE * i + 10] = colorTransform.redOffset / 255;
			// 		__vertexBufferData[VERTEX_BUFFER_STRIDE * i + 11] = colorTransform.greenOffset / 255;
			// 		__vertexBufferData[VERTEX_BUFFER_STRIDE * i + 12] = colorTransform.blueOffset / 255;
			// 		__vertexBufferData[VERTEX_BUFFER_STRIDE * i + 13] = colorTransform.alphaOffset / 255;

			// 	}

			// }

			// __vertexBufferAlpha = alpha;
			// __vertexBufferColorTransform = colorTransform != null ? colorTransform.__clone () : null;

			__vertexBuffer.uploadFromTypedArray(__vertexBufferData);
			#end
		}
		else
		{
			// var dirty = false;

			// if (__vertexBufferAlpha != alpha) {

			// 	dirty = true;

			// 	for (i in 0...4) {

			// 		__vertexBufferData[VERTEX_BUFFER_STRIDE * i + 5] = alpha;

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

			// 			__vertexBufferData[VERTEX_BUFFER_STRIDE * i + 6] = colorTransform.redMultiplier;
			// 			__vertexBufferData[VERTEX_BUFFER_STRIDE * i + 11] = colorTransform.greenMultiplier;
			// 			__vertexBufferData[VERTEX_BUFFER_STRIDE * i + 16] = colorTransform.blueMultiplier;
			// 			__vertexBufferData[VERTEX_BUFFER_STRIDE * i + 21] = colorTransform.alphaMultiplier;
			// 			__vertexBufferData[VERTEX_BUFFER_STRIDE * i + 22] = colorTransform.redOffset / 255;
			// 			__vertexBufferData[VERTEX_BUFFER_STRIDE * i + 23] = colorTransform.greenOffset / 255;
			// 			__vertexBufferData[VERTEX_BUFFER_STRIDE * i + 24] = colorTransform.blueOffset / 255;
			// 			__vertexBufferData[VERTEX_BUFFER_STRIDE * i + 25] = colorTransform.alphaOffset / 255;

			// 		}

			// 	} else {

			// 		for (i in 0...4) {

			// 			__vertexBufferData[VERTEX_BUFFER_STRIDE * i + 6] = 1;
			// 			__vertexBufferData[VERTEX_BUFFER_STRIDE * i + 11] = 1;
			// 			__vertexBufferData[VERTEX_BUFFER_STRIDE * i + 16] = 1;
			// 			__vertexBufferData[VERTEX_BUFFER_STRIDE * i + 21] = 1;
			// 			__vertexBufferData[VERTEX_BUFFER_STRIDE * i + 22] = 0;
			// 			__vertexBufferData[VERTEX_BUFFER_STRIDE * i + 23] = 0;
			// 			__vertexBufferData[VERTEX_BUFFER_STRIDE * i + 24] = 0;
			// 			__vertexBufferData[VERTEX_BUFFER_STRIDE * i + 25] = 0;

			// 		}

			// 	}

			// }

			// context.__bindGLArrayBuffer (__vertexBuffer);

			// if (dirty) {

			// 	gl.bufferData (gl.ARRAY_BUFFER, __vertexBufferData.byteLength, __vertexBufferData, gl.STATIC_DRAW);

			// }
		}

		return __vertexBuffer;
	}

	public function getColorBoundsRect(mask:Int, color:Int, findColor:Bool = true):Rectangle
	{
		#if lime
		if (!readable) return new Rectangle(0, 0, width, height);

		if (!transparent || ((mask >> 24) & 0xFF) > 0)
		{
			var color = (color : ARGB);
			if (color.a == 0) color = 0;
		}

		var rect = image.getColorBoundsRect(mask, color, findColor, ARGB32);
		return new Rectangle(rect.x, rect.y, rect.width, rect.height);
		#else
		return new Rectangle(0, 0, width, height);
		#end
	}

	public function getPixel(x:Int, y:Int):Int
	{
		if (!readable) return 0;
		#if lime
		return image.getPixel(x, y, ARGB32);
		#else
		return 0;
		#end
	}

	public function getPixel32(x:Int, y:Int):Int
	{
		if (!readable) return 0;
		#if lime
		return image.getPixel32(x, y, ARGB32);
		#else
		return 0;
		#end
	}

	public function getPixels(rect:Rectangle):ByteArray
	{
		#if lime
		if (!readable) return null;
		if (rect == null) rect = this.rect;
		var byteArray = ByteArray.fromBytes(image.getPixels(rect.__toLimeRectangle(), ARGB32));
		// TODO: System endian order
		byteArray.endian = Endian.BIG_ENDIAN;
		return byteArray;
		#else
		return null;
		#end
	}

	@SuppressWarnings("checkstyle:Dynamic")
	@:dox(hide) public function getSurface():#if lime CairoImageSurface #else Dynamic #end
	{
		#if lime
		if (!readable) return null;

		if (__surface == null)
		{
			__surface = CairoImageSurface.fromImage(image);
		}

		return __surface;
		#else
		return null;
		#end
	}

	@:dox(hide) public function getTexture(context:Context3D):TextureBase
	{
		if (!__isValid) return null;

		if (__texture == null || __textureContext != context.__context)
		{
			__textureContext = context.__context;
			__texture = context.createRectangleTexture(width, height, BGRA, false);

			// context.__bindGLTexture2D (__texture);
			// gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
			// gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
			// gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
			// gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
			__textureVersion = -1;
		}

		#if lime
		#if (js && html5)
		ImageCanvasUtil.sync(image, false);
		#end

		if (image != null && image.version > __textureVersion)
		{
			if (__surface != null)
			{
				__surface.flush();
			}

			var textureImage = image;

			#if (js && html5)
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

			__texture.__uploadFromImage(textureImage);

			__textureVersion = image.version;

			__textureWidth = textureImage.buffer.width;
			__textureHeight = textureImage.buffer.height;
		}

		if (!readable && image != null)
		{
			__surface = null;
			image = null;
		}
		#end

		return __texture;
	}

	public function getVector(rect:Rectangle):Vector<UInt>
	{
		var pixels = getPixels(rect);
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
		var rect = hRect != null ? hRect : new Rectangle(0, 0, width, height);
		var pixels = getPixels(rect);
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
		if (!readable) return false;

		// #if !openfljs
		if ((secondObject is Bitmap))
		{
			secondObject = cast(secondObject, Bitmap).__bitmapData;
		}
		// #end

		if ((secondObject is Point))
		{
			var secondPoint:Point = cast secondObject;

			var x = Std.int(secondPoint.x - firstPoint.x);
			var y = Std.int(secondPoint.y - firstPoint.y);

			if (rect.contains(x, y))
			{
				var pixel = getPixel32(x, y);

				if ((pixel >> 24) & 0xFF > firstAlphaThreshold)
				{
					return true;
				}
			}
		}
		else if ((secondObject is BitmapData))
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

			if (rect.intersects(hitRect))
			{
				if (x < 0)
				{
					hitRect.x = 0;
					hitRect.width = Math.min(secondBitmapData.width + x, width);
				}
				else
				{
					hitRect.width = Math.min(secondBitmapData.width, width - x);
				}

				if (y < 0)
				{
					hitRect.y = 0;
					hitRect.height = Math.min(secondBitmapData.height + y, height);
				}
				else
				{
					hitRect.height = Math.min(secondBitmapData.height, height - y);
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
		else if ((secondObject is Rectangle))
		{
			var secondRectangle = Rectangle.__pool.get();
			secondRectangle.copyFrom(cast secondObject);
			secondRectangle.offset(-firstPoint.x, -firstPoint.y);
			secondRectangle.__contract(0, 0, width, height);

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
		#if lime
		return Image.loadFromBase64(base64, type).then(function(image)
		{
			return Future.withValue(BitmapData.fromImage(image));
		});
		#else
		return cast Future.withValue(null);
		#end
	}

	public static function loadFromBytes(bytes:ByteArray, rawAlpha:ByteArray = null):Future<BitmapData>
	{
		#if lime
		return Image.loadFromBytes(bytes).then(function(image)
		{
			var bitmapData = BitmapData.fromImage(image);

			if (rawAlpha != null)
			{
				bitmapData.__applyAlpha(rawAlpha);
			}

			return Future.withValue(bitmapData);
		});
		#else
		return cast Future.withValue(null);
		#end
	}

	public static function loadFromFile(path:String):Future<BitmapData>
	{
		#if lime
		return Image.loadFromFile(path).then(function(image)
		{
			return Future.withValue(BitmapData.fromImage(image));
		});
		#else
		return cast Future.withValue(null);
		#end
	}

	public function lock():Void {}

	public function merge(sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, redMultiplier:UInt, greenMultiplier:UInt, blueMultiplier:UInt,
			alphaMultiplier:UInt):Void
	{
		#if lime
		if (!readable || sourceBitmapData == null || !sourceBitmapData.readable || sourceRect == null || destPoint == null) return;
		image.merge(sourceBitmapData.image, sourceRect.__toLimeRectangle(), destPoint.__toLimeVector2(), redMultiplier, greenMultiplier, blueMultiplier,
			alphaMultiplier);
		#end
	}

	public function noise(randomSeed:Int, low:Int = 0, high:Int = 255, channelOptions:Int = 7, grayScale:Bool = false):Void
	{
		if (!readable) return;

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

		for (y in 0...height)
		{
			for (x in 0...width)
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
		if (!readable) return;
		var noise = new PerlinNoise(randomSeed, numOctaves, channelOptions, grayScale, 0.5, stitch, 0.15);
		noise.fill(this, baseX, baseY, 0);
	}

	// @:noCompletion @:dox(hide) public function pixelDissolve (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, randomSeed:Int = 0, numPixels:Int = 0, fillColor:UInt = 0):Int;

	public function scroll(x:Int, y:Int):Void
	{
		if (!readable) return;
		image.scroll(x, y);
	}

	public function setPixel(x:Int, y:Int, color:Int):Void
	{
		if (!readable) return;
		#if lime
		image.setPixel(x, y, color, ARGB32);
		#end
	}

	public function setPixel32(x:Int, y:Int, color:Int):Void
	{
		if (!readable) return;
		#if lime
		image.setPixel32(x, y, color, ARGB32);
		#end
	}

	public function setPixels(rect:Rectangle, byteArray:ByteArray):Void
	{
		if (!readable || rect == null) return;

		var length = (rect.width * rect.height * 4);
		if (byteArray.bytesAvailable < length) throw new Error("End of file was encountered.", 2030);

		#if lime
		image.setPixels(rect.__toLimeRectangle(), byteArray, ARGB32, byteArray.endian);
		#end
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
		if (sourceBitmapData == null
			|| sourceRect == null
			|| destPoint == null
			|| sourceRect.x > sourceBitmapData.width
			|| sourceRect.y > sourceBitmapData.height
			|| destPoint.x > width
			|| destPoint.y > height)
		{
			return 0;
		}

		#if lime
		return image.threshold(sourceBitmapData.image, sourceRect.__toLimeRectangle(), destPoint.__toLimeVector2(), operation, threshold, color, mask,
			copySource, ARGB32);
		#else
		return 0;
		#end
	}

	public function unlock(changeRect:Rectangle = null):Void {}

	@:noCompletion private function __applyAlpha(alpha:ByteArray):Void
	{
		#if (js && html5)
		ImageCanvasUtil.convertToCanvas(image);
		ImageCanvasUtil.createImageData(image);
		#end

		var data = image.buffer.data;

		for (i in 0...alpha.length)
		{
			data[i * 4 + 3] = alpha.readUnsignedByte();
		}

		image.version++;
	}

	@:noCompletion private function __drawCairo(source:IBitmapDrawable, renderer:CairoRenderer):Void
	{
		#if lime_cairo
		var cairo = renderer.cairo;

		if (source == this)
		{
			source = clone();
		}

		if (!renderer.__allowSmoothing) cairo.antialias = NONE;

		renderer.__render(source);

		if (!renderer.__allowSmoothing) cairo.antialias = GOOD;

		cairo.target.flush();

		image.dirty = true;
		image.version++;
		#end
	}

	@:noCompletion private function __drawCanvas(source:IBitmapDrawable, renderer:CanvasRenderer):Void
	{
		var buffer = image.buffer;

		if (!renderer.__allowSmoothing) renderer.applySmoothing(buffer.__srcContext, false);

		renderer.__render(source);

		if (!renderer.__allowSmoothing) renderer.applySmoothing(buffer.__srcContext, true);

		buffer.__srcContext.setTransform(1, 0, 0, 1, 0, 0);
		buffer.__srcImageData = null;
		buffer.data = null;

		image.dirty = true;
		image.version++;
	}

	@:noCompletion private function __drawGL(source:IBitmapDrawable, renderer:OpenGLRenderer):Void
	{
		var context = renderer.__context3D;

		var cacheRTT = context.__state.renderToTexture;
		var cacheRTTDepthStencil = context.__state.renderToTextureDepthStencil;
		var cacheRTTAntiAlias = context.__state.renderToTextureAntiAlias;
		var cacheRTTSurfaceSelector = context.__state.renderToTextureSurfaceSelector;

		context.setRenderToTexture(getTexture(context), true);

		renderer.__render(source);

		if (cacheRTT != null)
		{
			context.setRenderToTexture(cacheRTT, cacheRTTDepthStencil, cacheRTTAntiAlias, cacheRTTSurfaceSelector);
		}
		else
		{
			context.setRenderToBackBuffer();
		}
	}

	@:noCompletion private function __fillRect(rect:Rectangle, color:Int, allowFramebuffer:Bool):Void
	{
		#if lime
		if (rect == null) return;

		if (transparent && (color & 0xFF000000) == 0)
		{
			color = 0;
		}

		if (allowFramebuffer
			&& __texture != null
			&& __texture.__glFramebuffer != null
			&& Lib.current.stage.__renderer.__type == OPENGL)
		{
			var renderer:OpenGLRenderer = cast Lib.current.stage.__renderer;
			var context = renderer.__context3D;
			var color:ARGB = (color : ARGB);
			var useScissor = !this.rect.equals(rect);

			var cacheRTT = context.__state.renderToTexture;
			var cacheRTTDepthStencil = context.__state.renderToTextureDepthStencil;
			var cacheRTTAntiAlias = context.__state.renderToTextureAntiAlias;
			var cacheRTTSurfaceSelector = context.__state.renderToTextureSurfaceSelector;

			context.setRenderToTexture(__texture);

			if (useScissor)
			{
				context.setScissorRectangle(rect);
			}

			context.clear(color.r / 0xFF, color.g / 0xFF, color.b / 0xFF, transparent ? color.a / 0xFF : 1, 0, 0, Context3DClearMask.COLOR);

			if (useScissor)
			{
				context.setScissorRectangle(null);
			}

			if (cacheRTT != null)
			{
				context.setRenderToTexture(cacheRTT, cacheRTTDepthStencil, cacheRTTAntiAlias, cacheRTTSurfaceSelector);
			}
			else
			{
				context.setRenderToBackBuffer();
			}
		}
		else if (readable)
		{
			image.fillRect(rect.__toLimeRectangle(), color, ARGB32);
		}
		#end
	}

	@:noCompletion private inline function __fromBase64(base64:String, type:String):Void
	{
		#if lime
		var image = Image.fromBase64(base64, type);
		__fromImage(image);
		#end
	}

	@:noCompletion private inline function __fromBytes(bytes:ByteArray, rawAlpha:ByteArray = null):Void
	{
		#if lime
		var image = Image.fromBytes(bytes);
		__fromImage(image);

		if (rawAlpha != null)
		{
			__applyAlpha(rawAlpha);
		}
		#end
	}

	@:noCompletion private function __fromFile(path:String):Void
	{
		#if lime
		var image = Image.fromFile(path);
		__fromImage(image);
		#end
	}

	@SuppressWarnings("checkstyle:Dynamic")
	@:noCompletion private function __fromImage(image:#if lime Image #else Dynamic #end):Void
	{
		#if lime
		if (image != null && image.buffer != null)
		{
			this.image = image;

			width = image.width;
			height = image.height;
			rect = new Rectangle(0, 0, image.width, image.height);

			__textureWidth = width;
			__textureHeight = height;

			#if sys
			image.format = BGRA32;
			image.premultiplied = true;
			#end

			readable = true;
			__isValid = true;
		}
		#end
	}

	@:noCompletion private function __getBounds(rect:Rectangle, matrix:Matrix):Void
	{
		var bounds = Rectangle.__pool.get();
		this.rect.__transform(bounds, matrix);
		rect.__expand(bounds.x, bounds.y, bounds.width, bounds.height);
		Rectangle.__pool.release(bounds);
	}

	// @:noCompletion private function __getFramebuffer (context:Context3D, requireStencil:Bool):GLFramebuffer {
	// 	if (__framebuffer == null || __framebufferContext != context.__context) {
	// 		var gl = context.gl;
	// 		var texture = getTexture (context);
	// 		context.__bindGLTexture2D (texture.__textureID);
	// 		__framebufferContext = context.__context;
	// 		__framebuffer = gl.createFramebuffer ();
	// 		context.__bindGLFramebuffer (__framebuffer);
	// 		gl.framebufferTexture2D (gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_2D, texture.__textureID, 0);
	// 		if (gl.checkFramebufferStatus (gl.FRAMEBUFFER) != gl.FRAMEBUFFER_COMPLETE) {
	// 			trace (gl.getError ());
	// 		}
	// 	}
	// 	if (requireStencil && __stencilBuffer == null) {
	// 		var gl = context.gl;
	// 		__stencilBuffer = gl.createRenderbuffer ();
	// 		gl.bindRenderbuffer (gl.RENDERBUFFER, __stencilBuffer);
	// 		gl.renderbufferStorage (gl.RENDERBUFFER, gl.STENCIL_INDEX8, __textureWidth, __textureHeight);
	// 		context.__bindGLFramebuffer (__framebuffer);
	// 		gl.framebufferRenderbuffer (gl.FRAMEBUFFER, gl.STENCIL_ATTACHMENT, gl.RENDERBUFFER, __stencilBuffer);
	// 		if (gl.checkFramebufferStatus (gl.FRAMEBUFFER) != gl.FRAMEBUFFER_COMPLETE) {
	// 			trace (gl.getError ());
	// 		}
	// 		gl.bindRenderbuffer (gl.RENDERBUFFER, null);
	// 	}
	// 	return __framebuffer;
	// }
	@:noCompletion private inline function __loadFromBase64(base64:String, type:String):Future<BitmapData>
	{
		#if lime
		return Image.loadFromBase64(base64, type).then(function(image)
		{
			__fromImage(image);
			return Future.withValue(this);
		});
		#else
		return cast Future.withValue(null);
		#end
	}

	@:noCompletion private inline function __loadFromBytes(bytes:ByteArray, rawAlpha:ByteArray = null):Future<BitmapData>
	{
		#if lime
		return Image.loadFromBytes(bytes).then(function(image)
		{
			__fromImage(image);

			if (rawAlpha != null)
			{
				__applyAlpha(rawAlpha);
			}

			return Future.withValue(this);
		});
		#else
		return cast Future.withValue(null);
		#end
	}

	@:noCompletion private function __loadFromFile(path:String):Future<BitmapData>
	{
		#if lime
		return Image.loadFromFile(path).then(function(image)
		{
			__fromImage(image);
			return Future.withValue(this);
		});
		#else
		return cast Future.withValue(this);
		#end
	}

	@:noCompletion private function __renderCairo(renderer:CairoRenderer):Void
	{
		#if lime_cairo
		if (!readable) return;

		var cairo = renderer.cairo;

		renderer.applyMatrix(__renderTransform, cairo);

		var surface = getSurface();

		if (surface != null)
		{
			var pattern = CairoPattern.createForSurface(surface);

			if (!renderer.__allowSmoothing || cairo.antialias == NONE)
			{
				pattern.filter = CairoFilter.NEAREST;
			}
			else
			{
				pattern.filter = CairoFilter.GOOD;
			}

			cairo.source = pattern;
			cairo.paint();
		}
		#end
	}

	@:noCompletion private function __renderCairoMask(renderer:CairoRenderer):Void {}

	@:noCompletion private function __renderCanvas(renderer:CanvasRenderer):Void
	{
		#if (js && html5)
		if (!readable) return;

		if (image.type == DATA)
		{
			ImageCanvasUtil.convertToCanvas(image);
		}

		var context = renderer.context;
		context.globalAlpha = 1;

		renderer.setTransform(__renderTransform, context);

		context.drawImage(image.src, 0, 0, image.width, image.height);
		#end
	}

	@:noCompletion private function __renderCanvasMask(renderer:CanvasRenderer):Void {}

	@:noCompletion private function __renderDOM(renderer:DOMRenderer):Void {}

	@:noCompletion private function __renderGL(renderer:OpenGLRenderer):Void
	{
		var context = renderer.__context3D;
		var gl = context.gl;

		renderer.__setBlendMode(NORMAL);

		var shader = renderer.__defaultDisplayShader;
		renderer.setShader(shader);
		renderer.applyBitmapData(this, renderer.__upscaled);
		renderer.applyMatrix(renderer.__getMatrix(__worldTransform, AUTO));
		renderer.applyAlpha(__worldAlpha);
		renderer.applyColorTransform(__worldColorTransform);
		renderer.updateShader();

		// alpha == 1, __worldColorTransform

		var vertexBuffer = getVertexBuffer(context);
		if (shader.__position != null) context.setVertexBufferAt(shader.__position.index, vertexBuffer, 0, FLOAT_3);
		if (shader.__textureCoord != null) context.setVertexBufferAt(shader.__textureCoord.index, vertexBuffer, 3, FLOAT_2);
		var indexBuffer = getIndexBuffer(context);
		context.drawTriangles(indexBuffer);

		#if gl_stats
		Context3DStats.incrementDrawCall(DrawCallContext.STAGE);
		#end

		renderer.__clearShader();
	}

	@:noCompletion private function __renderGLMask(renderer:OpenGLRenderer):Void
	{
		var context = renderer.__context3D;
		var gl = context.gl;

		var shader = renderer.__maskShader;
		renderer.setShader(shader);
		renderer.applyBitmapData(this, renderer.__upscaled);
		renderer.applyMatrix(renderer.__getMatrix(__worldTransform, AUTO));
		renderer.updateShader();

		var vertexBuffer = getVertexBuffer(context);
		if (shader.__position != null) context.setVertexBufferAt(shader.__position.index, vertexBuffer, 0, FLOAT_3);
		if (shader.__textureCoord != null) context.setVertexBufferAt(shader.__textureCoord.index, vertexBuffer, 3, FLOAT_2);
		var indexBuffer = getIndexBuffer(context);
		context.drawTriangles(indexBuffer);

		#if gl_stats
		Context3DStats.incrementDrawCall(DrawCallContext.STAGE);
		#end

		renderer.__clearShader();
	}

	@:noCompletion private function __resize(width:Int, height:Int):Void
	{
		this.width = width;
		this.height = height;
		this.rect.width = width;
		this.rect.height = height;

		__textureWidth = width;
		__textureHeight = height;
	}

	@:noCompletion private function __setUVRect(context:Context3D, x:Float, y:Float, width:Float, height:Float):Void
	{
		var buffer = getVertexBuffer(context);

		if (buffer != null && (width != __uvRect.width || height != __uvRect.height || x != __uvRect.x || y != __uvRect.y))
		{
			var gl = context.gl;

			if (__uvRect == null) __uvRect = new Rectangle();
			__uvRect.setTo(x, y, width, height);

			var uvX = __textureWidth > 0 ? x / __textureWidth : 0;
			var uvY = __textureHeight > 0 ? y / __textureHeight : 0;
			var uvWidth = __textureWidth > 0 ? width / __textureWidth : 0;
			var uvHeight = __textureHeight > 0 ? height / __textureHeight : 0;

			__vertexBufferData[0] = width;
			__vertexBufferData[1] = height;
			__vertexBufferData[3] = uvX + uvWidth;
			__vertexBufferData[4] = uvY + uvHeight;
			__vertexBufferData[VERTEX_BUFFER_STRIDE + 1] = height;
			__vertexBufferData[VERTEX_BUFFER_STRIDE + 3] = uvX;
			__vertexBufferData[VERTEX_BUFFER_STRIDE + 4] = uvY + uvHeight;
			__vertexBufferData[VERTEX_BUFFER_STRIDE * 2] = width;
			__vertexBufferData[VERTEX_BUFFER_STRIDE * 2 + 3] = uvX + uvWidth;
			__vertexBufferData[VERTEX_BUFFER_STRIDE * 2 + 4] = uvY;
			__vertexBufferData[VERTEX_BUFFER_STRIDE * 3 + 3] = uvX;
			__vertexBufferData[VERTEX_BUFFER_STRIDE * 3 + 4] = uvY;

			__vertexBuffer.uploadFromTypedArray(__vertexBufferData);
		}
	}

	@:noCompletion private function __sync():Void
	{
		#if (js && html5)
		ImageCanvasUtil.sync(image, false);
		#end
	}

	@:noCompletion private function __update(transformOnly:Bool, updateChildren:Bool):Void
	{
		__updateTransforms();
	}

	@:noCompletion private function __updateTransforms(overrideTransform:Matrix = null):Void
	{
		if (overrideTransform == null)
		{
			__worldTransform.identity();
		}
		else
		{
			__worldTransform.copyFrom(overrideTransform);
		}

		__renderTransform.copyFrom(__worldTransform);
	}
}
#else
typedef BitmapData = flash.display.BitmapData;
#end
