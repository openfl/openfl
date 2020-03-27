namespace openfl._internal.backend.html5;

#if openfl_html5
import js.html.CanvasElement;
import js.html.Image in JSImage;
import openfl._internal.backend.lime_standalone.ARGB;
import openfl._internal.backend.lime_standalone.Canvas2DRenderContext;
import openfl._internal.backend.lime_standalone.Image;
import openfl._internal.backend.lime_standalone.ImageCanvasUtil;
import openfl._internal.backend.lime_standalone.ImageBuffer;
import openfl._internal.utils.PerlinNoise;
import openfl._internal.bindings.typedarray.UInt8Array;
import openfl._internal.renderer.canvas.CanvasRenderer;
import openfl.display3D.textures.TextureBase;
import Context3D from "../display3D/Context3D";
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.display.BlendMode;
import openfl.display.IBitmapDrawable;
import openfl.display.JPEGEncoderOptions;
import openfl.display.PNGEncoderOptions;
import openfl.display.StageQuality;
import openfl.filters.BitmapFilter;
import ColorTransfrom from "../geom/ColorTransform";
import Matrix from "../geom/Matrix";
import Point from "../geom/Point";
import Rectangle from "../geom/Rectangle";
import ByteArray from "../utils/ByteArray";
import openfl.utils.Endian;
import openfl.utils.Future;
import openfl.utils.Object;
import Vector from "../Vector";

@: access(openfl._internal.backend.lime_standalone.Image)
@: access(openfl._internal.backend.lime_standalone.ImageBuffer)
@: access(openfl._internal.backend.opengl.OpenGLTextureBaseBackend) // TODO: Remove backend references
@: access(openfl._internal.renderer.canvas.CanvasRenderer)
@: access(openfl.display3D.textures.TextureBase)
@: access(openfl.display3D.Context3D)
@: access(openfl.display.BitmapData)
@: access(openfl.display.DisplayObject)
@: access(openfl.display.DisplayObjectRenderer)
@: access(openfl.display.DisplayObjectShader)
@: access(openfl.display.Graphics)
@: access(openfl.display.IBitmapDrawable)
@: access(openfl.display.Shader)
@: access(openfl.filters.BitmapFilter)
@: access(openfl.geom.ColorTransform)
@: access(openfl.geom.Matrix)
@: access(openfl.geom.Point)
@: access(openfl.geom.Rectangle)
class HTML5BitmapDataBackend
{
	private image: Image;
	private parent: BitmapData;

	public constructor(parent: BitmapData, width: number, height: number, transparent: boolean = true, fillColor: number = 0xFFFFFFFF)
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

			this.image = new Image(buffer, 0, 0, width, height);

			if (fillColor != 0)
			{
				this.image.fillRect(this.image.rect, fillColor);
			}
			// #elseif openfl_html5
			// buffer = new ImageBuffer (null, width, height);
			// canvas:CanvasElement = cast Browser.document.createElement ("canvas");
			// buffer.__srcCanvas = canvas;
			// buffer.__srcContext = canvas.getContext ("2d");
			//
			// image = new Image (buffer, 0, 0, width, height);
			// this.image.type = CANVAS;
			//
			// if (fillColor != 0) {
			//
			// this.image.fillRect (this.image.rect, fillColor);
			//
			// }
			#else
			this.image = new Image(null, 0, 0, width, height, fillColor);
			#end

			this.image.transparent = transparent;

			parent.__isValid = true;
			parent.readable = true;
		}
	}

	public applyFilter(sourceBitmapData: BitmapData, sourceRect: Rectangle, destPoint: Point, filter: BitmapFilter): void
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
			bitmapData2.__backend.image.version = this.image.version;
			this.image = bitmapData2.__backend.image;
		}

		this.image.dirty = true;
		this.image.version++;
	}

	public clone(): BitmapData
	{
		var bitmapData;

		if (!parent.__isValid)
		{
			bitmapData = new BitmapData(parent.width, parent.height, parent.transparent, 0);
		}
		else if (!parent.readable && this.image == null)
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
			bitmapData = BitmapData.fromImage(this.image.clone(), parent.transparent);
		}

		bitmapData.__worldTransform.copyFrom(parent.__worldTransform);
		bitmapData.__renderTransform.copyFrom(parent.__renderTransform);

		return bitmapData;
	}

	public colorTransform(rect: Rectangle, colorTransform: ColorTransform): void
	{
		this.image.colorTransform(rect, colorTransform.__toLimeColorMatrix());
	}

	public compare(otherBitmapData: BitmapData): Dynamic
	{
		if (this.image != null && otherBitmapData.__backend.image != null && this.image.format == otherBitmapData.__backend.image.format)
		{
			var bytes = this.image.data;
			var otherBytes = otherBitmapData.__backend.image.data;
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
			pixel: ARGB,
			otherPixel: ARGB,
			comparePixel: ARGB,
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

	public copyChannel(sourceBitmapData: BitmapData, sourceRect: Rectangle, destPoint: Point, sourceChannel: BitmapDataChannel,
		destChannel: BitmapDataChannel): void
	{
		var sourceChannel = switch (sourceChannel)
		{
			case 1: BitmapDataChannel.RED;
			case 2: BitmapDataChannel.GREEN;
			case 4: BitmapDataChannel.BLUE;
			case 8: BitmapDataChannel.ALPHA;
			default: return;
		}

		var destChannel = switch (destChannel)
		{
			case 1: BitmapDataChannel.RED;
			case 2: BitmapDataChannel.GREEN;
			case 4: BitmapDataChannel.BLUE;
			case 8: BitmapDataChannel.ALPHA;
			default: return;
		}

		this.image.copyChannel(sourceBitmapData.__backend.image, sourceRect, destPoint, sourceChannel, destChannel);
	}

	public copyPixels(sourceBitmapData: BitmapData, sourceRect: Rectangle, destPoint: Point, alphaBitmapData: BitmapData = null, alphaPoint: Point = null,
		mergeAlpha: boolean = false): void
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

			ImageCanvasUtil.convertToCanvas(copy.__backend.image);
			ImageCanvasUtil.convertToCanvas(sourceBitmapData.__backend.image);
			ImageCanvasUtil.convertToCanvas(alphaBitmapData.__backend.image);

			if (alphaPoint != null)
			{
				rect.x += alphaPoint.x;
				rect.y += alphaPoint.y;
			}

			copy.__backend.image.buffer.__srcContext.globalCompositeOperation = "source-over";
			copy.__backend.image.buffer.__srcContext.drawImage(alphaBitmapData.__backend.image.buffer.src,
				Std.int(rect.x + sourceBitmapData.__backend.image.offsetX), Std.int(rect.y + sourceBitmapData.__backend.image.offsetY), Std.int(rect.width),
				Std.int(rect.height), Std.int(point.x + this.image.offsetX), Std.int(point.y + this.image.offsetY), Std.int(rect.width), Std.int(rect.height));

			if (alphaPoint != null)
			{
				rect.x -= alphaPoint.x;
				rect.y -= alphaPoint.y;
			}

			copy.__backend.image.buffer.__srcContext.globalCompositeOperation = "source-in";
			copy.__backend.image.buffer.__srcContext.drawImage(sourceBitmapData.__backend.image.buffer.src,
				Std.int(rect.x + sourceBitmapData.__backend.image.offsetX), Std.int(rect.y + sourceBitmapData.__backend.image.offsetY), Std.int(rect.width),
				Std.int(rect.height), Std.int(point.x + this.image.offsetX), Std.int(point.y + this.image.offsetY), Std.int(rect.width), Std.int(rect.height));

			// TODO: Render directly for mergeAlpha=false?
			this.image.copyPixels(copy.__backend.image, copy.rect, destPoint, null, null, mergeAlpha);

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

		this.image.copyPixels(sourceBitmapData.__backend.image, sourceRect, destPoint, alphaBitmapData != null ? alphaBitmapData.__backend.image : null,
			alphaPoint != null ? BitmapData.__tempVector : null, mergeAlpha);
	}

	public dispose(): void
	{
		this.image = null;
		parent.__isValid = false;
		parent.__renderData.dispose();
	}

	public disposeImage(): void
	{
		parent.readable = false;
	}

	public draw(source: IBitmapDrawable, matrix: Matrix = null, colorTransform: ColorTransform = null, blendMode: BlendMode = null,
		clipRect: Rectangle = null, smoothing: boolean = false): void
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
			if (colorTransform != null)
			{
				var bounds = Rectangle.__pool.get();
				var boundsMatrix = Matrix.__pool.get();

				source.__getBounds(bounds, boundsMatrix);

				var width: number = Math.ceil(bounds.width);
				var height: number = Math.ceil(bounds.height);

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

			if (BitmapData.__softwareRenderer == null) BitmapData.__softwareRenderer = new CanvasRenderer(null);
			ImageCanvasUtil.convertToCanvas(this.image);
			var renderer: CanvasRenderer = cast BitmapData.__softwareRenderer;
			renderer.context = this.image.buffer.__srcContext;

			renderer.__allowSmoothing = smoothing;
			renderer.__overrideBlendMode = blendMode;

			renderer.__worldTransform = matrix;
			renderer.__worldAlpha = 1 / source.__worldAlpha;
			renderer.__worldColorTransform = _colorTransform;

			renderer.__drawBitmapData(parent, source, clipRect);
		}
	}

	public drawWithQuality(source: IBitmapDrawable, matrix: Matrix = null, colorTransform: ColorTransform = null, blendMode: BlendMode = null,
		clipRect: Rectangle = null, smoothing: boolean = false, quality: StageQuality = null): void
	{
		draw(source, matrix, colorTransform, blendMode, clipRect, quality != LOW ? smoothing : false);
	}

	public encode(rect: Rectangle, compressor: Object, byteArray: ByteArray = null): ByteArray
	{
		if (byteArray == null) byteArray = new ByteArray();

		var image = this.image;

		if (!rect.equals(parent.rect))
		{
			var matrix = Matrix.__pool.get();
			matrix.tx = Math.round(-rect.x);
			matrix.ty = Math.round(-rect.y);

			var bitmapData = new BitmapData(Math.ceil(rect.width), Math.ceil(rect.height), true, 0);
			bitmapData.draw(parent, matrix);

			image = bitmapData.__backend.image;

			Matrix.__pool.release(matrix);
		}

		if (Std.is(compressor, PNGEncoderOptions))
		{
			byteArray.writeBytes(ByteArray.fromBytes(this.image.encode(PNG)));
			return byteArray;
		}
		else if (Std.is(compressor, JPEGEncoderOptions))
		{
			byteArray.writeBytes(ByteArray.fromBytes(this.image.encode(JPEG, cast(compressor, JPEGEncoderOptions).quality)));
			return byteArray;
		}

		return byteArray = null;
	}

	public fillRect(rect: Rectangle, color: number): void
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
			this.image.fillRect(rect, color, ARGB32);
		}
	}

	public floodFill(x: number, y: number, color: number): void
	{
		this.image.floodFill(x, y, color, ARGB32);
	}

	public static fromBase64(base64: string, type: string): BitmapData
	{
		return null;
	}

	public static fromBytes(bytes: ByteArray, rawAlpha: ByteArray = null): BitmapData
	{
		return null;
	}

	public static fromCanvas(canvas: CanvasElement, transparent: boolean = true): BitmapData
	{
		if (canvas == null) return null;

		var bitmapData = new BitmapData(0, 0, transparent, 0);
		bitmapData.__backend.__fromImage(Image.fromCanvas(canvas));
		bitmapData.__backend.image.transparent = transparent;
		return bitmapData;
	}

	public static fromFile(path: string): BitmapData
	{
		return null;
	}

	public static fromImage(image: Image, transparent: boolean = true): BitmapData
	{
		if (image == null || image.buffer == null) return null;

		var bitmapData = new BitmapData(0, 0, transparent, 0);
		bitmapData.__backend.__fromImage(image);
		bitmapData.__backend.image.transparent = transparent;
		return bitmapData.__backend.image != null ? bitmapData : null;
	}

	public static fromTexture(texture: TextureBase): BitmapData
	{
		var bitmapData = new BitmapData(texture.__width, texture.__height, true, 0);
		bitmapData.readable = false;
		bitmapData.__renderData.texture = texture;
		bitmapData.__renderData.textureContext = texture.__context;
		bitmapData.__backend.image = null;
		return bitmapData;
	}

	public generateFilterRect(sourceRect: Rectangle, filter: BitmapFilter): Rectangle
	{
		return sourceRect.clone();
	}

	public getCanvas(clearData: boolean): CanvasElement
	{
		if (this.image == null) return null;
		ImageCanvasUtil.convertToCanvas(this.image, clearData);
		return this.image.buffer.__srcCanvas;
	}

	public getCanvasContext(clearData: boolean): Canvas2DRenderContext
	{
		if (this.image == null) return null;
		ImageCanvasUtil.convertToCanvas(this.image, clearData);
		return this.image.buffer.__srcContext;
	}

	public getJSImage(): JSImage
	{
		if (this.image == null) return null;
		return this.image.buffer.__srcImage;
	}

	public getElement(clearData: boolean): Dynamic
	{
		if (this.image == null) return null;
		if (this.image.type == DATA)
		{
			ImageCanvasUtil.convertToCanvas(this.image, clearData);
		}
		return this.image.src;
	}

	public getVersion(): number
	{
		return this.image.version;
	}

	public getColorBoundsRect(mask: number, color: number, findColor: boolean = true): Rectangle
	{
		if (!parent.transparent || ((mask >> 24) & 0xFF) > 0)
		{
			var color = (color: ARGB);
			if (color.a == 0) color = 0;
		}

		var rect = this.image.getColorBoundsRect(mask, color, findColor, ARGB32);
		return new Rectangle(rect.x, rect.y, rect.width, rect.height);
	}

	public getPixel(x: number, y: number): number
	{
		return this.image.getPixel(x, y, ARGB32);
	}

	public getPixel32(x: number, y: number): number
	{
		return this.image.getPixel32(x, y, ARGB32);
	}

	public getPixels(rect: Rectangle): ByteArray
	{
		if (rect == null) rect = parent.rect;
		var byteArray = ByteArray.fromBytes(this.image.getPixels(rect, ARGB32));
		// TODO: System endian order
		byteArray.endian = Endian.BIG_ENDIAN;
		return byteArray;
	}

	public getTexture(context: Context3D): TextureBase
	{
		if (!parent.readable
			&& this.image == null
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

		ImageCanvasUtil.sync(this.image, false);

		if (this.image != null && this.image.version > parent.__renderData.textureVersion)
		{
			var textureImage = this.image;

			if (#if openfl_power_of_two true || #end(!Context3D.__supportsBGRA && textureImage.format != RGBA32))
			{
				textureImage = textureImage.clone();
				textureImage.format = RGBA32;
				// textureImage.buffer.premultiplied = true;
				#if openfl_power_of_two
				textureImage.powerOfTwo = true;
				#end
			}

			parent.__renderData.texture.__baseBackend.uploadFromImage(textureImage);

			parent.__renderData.textureVersion = this.image.version;

			parent.__renderData.textureWidth = textureImage.buffer.width;
			parent.__renderData.textureHeight = textureImage.buffer.height;
		}

		if (!parent.readable && this.image != null)
		{
			this.image = null;
		}

		return parent.__renderData.texture;
	}

	public getVector(rect: Rectangle): Vector<UInt>
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

	public histogram(hRect: Rectangle = null): Array<Array<Int>>
	{
		var rect = hRect != null ? hRect : new Rectangle(0, 0, parent.width, parent.height);
		var pixels = parent.getPixels(rect);
		var result = [for (i in 0...4)[for (j in 0...256) 0]];

		for (i in 0...pixels.length)
		{
			++result[i % 4][pixels.readUnsignedByte()];
		}

		return result;
	}

	public hitTest(firstPoint: Point, firstAlphaThreshold: number, secondObject: Object, secondBitmapDataPoint: Point = null,
		secondAlphaThreshold: number = 1): boolean
	{
		if (Std.is(secondObject, Bitmap))
		{
			secondObject = cast(secondObject, Bitmap).__bitmapData;
		}

		if (Std.is(secondObject, Point))
		{
			var secondPoint: Point = cast secondObject;

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
			var secondBitmapData: BitmapData = cast secondObject;
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

	public static loadFromBase64(base64: string, type: string): Future<BitmapData>
	{
		return Image.loadFromBase64(base64, type).then(function (image)
		{
			return Future.withValue(BitmapData.fromImage(image));
		});
	}

	public static loadFromBytes(bytes: ByteArray, rawAlpha: ByteArray = null): Future<BitmapData>
	{
		return Image.loadFromBytes(bytes).then(function (image)
		{
			var bitmapData = BitmapData.fromImage(image);

			if (rawAlpha != null)
			{
				bitmapData.__backend.__applyAlpha(rawAlpha);
			}

			return Future.withValue(bitmapData);
		});
	}

	public static loadFromFile(path: string): Future<BitmapData>
	{
		return Image.loadFromFile(path).then(function (image)
		{
			return Future.withValue(BitmapData.fromImage(image));
		});
	}

	public lock(): void { }

	public merge(sourceBitmapData: BitmapData, sourceRect: Rectangle, destPoint: Point, redMultiplier: number, greenMultiplier: number, blueMultiplier: number,
		alphaMultiplier: number): void
	{
		this.image.merge(sourceBitmapData.__backend.image, sourceRect, destPoint, redMultiplier, greenMultiplier, blueMultiplier, alphaMultiplier);
	}

	public noise(randomSeed: number, low: number = 0, high: number = 255, channelOptions: number = 7, grayScale: boolean = false): void
	{
		// Seeded Random Number Generator
		var rand: void-> Int =
		{
			function func(): number
			{
				randomSeed = randomSeed * 1103515245 + 12345;
				return Std.int(Math.abs(randomSeed / 65536)) % 32768;
			}
		};
		rand();

		// Range of values to value to.
		var range: number = high - low;

		var redChannel: boolean = ((channelOptions & (1 << 0)) >> 0) == 1;
		var greenChannel: boolean = ((channelOptions & (1 << 1)) >> 1) == 1;
		var blueChannel: boolean = ((channelOptions & (1 << 2)) >> 2) == 1;
		var alphaChannel: boolean = ((channelOptions & (1 << 3)) >> 3) == 1;

		for (y in 0...parent.height)
		{
			for (x in 0...parent.width)
			{
				// Default channel colours if all channel options are false.
				var red: number = 0;
				var blue: number = 0;
				var green: number = 0;
				var alpha: number = 255;

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

				var rgb: number = alpha;
				rgb = (rgb << 8) + red;
				rgb = (rgb << 8) + green;
				rgb = (rgb << 8) + blue;

				setPixel32(x, y, rgb);
			}
		}
	}

	public paletteMap(sourceBitmapData: BitmapData, sourceRect: Rectangle, destPoint: Point, redArray: Array<Int> = null, greenArray: Array<Int> = null,
		blueArray: Array<Int> = null, alphaArray: Array<Int> = null): void
	{
		var sw: number = Std.int(sourceRect.width);
		var sh: number = Std.int(sourceRect.height);

		var pixels = sourceBitmapData.getPixels(sourceRect);

		var pixelValue: number, r: number, g: number, b: number, a: number, color: number;

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

	public perlinNoise(baseX: number, baseY: number, numOctaves: number, randomSeed: number, stitch: boolean, fractalNoise: boolean, channelOptions: number = 7,
		grayScale: boolean = false, offsets: Array<Point> = null): void
	{
		var noise = new PerlinNoise(randomSeed, numOctaves, channelOptions, grayScale, 0.5, stitch, 0.15);
		noise.fill(parent, baseX, baseY, 0);
	}

	public scroll(x: number, y: number): void
	{
		this.image.scroll(x, y);
	}

	public setDirty(): void
	{
		this.image.dirty = true;
		this.image.version++;
	}

	public setPixel(x: number, y: number, color: number): void
	{
		this.image.setPixel(x, y, color, ARGB32);
	}

	public setPixel32(x: number, y: number, color: number): void
	{
		this.image.setPixel32(x, y, color, ARGB32);
	}

	public setPixels(rect: Rectangle, byteArray: ByteArray): void
	{
		this.image.setPixels(rect, byteArray, ARGB32, byteArray.endian);
	}

	public setVector(rect: Rectangle, inputVector: Vector<UInt>): void
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

	public threshold(sourceBitmapData: BitmapData, sourceRect: Rectangle, destPoint: Point, operation: string, threshold: number, color: number = 0x00000000,
		mask: number = 0xFFFFFFFF, copySource: boolean = false): number
	{
		return this.image.threshold(sourceBitmapData.__backend.image, sourceRect, destPoint, operation, threshold, color, mask, copySource, ARGB32);
	}

	public unlock(changeRect: Rectangle = null): void { }

	private __applyAlpha(alpha: ByteArray): void
	{
		ImageCanvasUtil.convertToCanvas(this.image);
		ImageCanvasUtil.createImageData(this.image);

		var data = this.image.buffer.data;

		for (i in 0...alpha.length)
		{
			data[i * 4 + 3] = alpha.readUnsignedByte();
		}

		this.image.version++;
	}

	private inline __fromBase64(base64: string, type: string): void
	{
		var image = Image.fromBase64(base64, type);
		__fromImage(image);
	}

	private inline __fromBytes(bytes: ByteArray, rawAlpha: ByteArray = null): void
	{
		var image = Image.fromBytes(bytes);
		__fromImage(image);

		if (rawAlpha != null)
		{
			__applyAlpha(rawAlpha);
		}
	}

	private __fromFile(path: string): void
	{
		var image = Image.fromFile(path);
		__fromImage(image);
	}

	@SuppressWarnings("checkstyle:Dynamic")
	private __fromImage(image: Image): void
	{
		if (image != null && image.buffer != null)
		{
			this.image = image;

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

	private inline __loadFromBase64(base64: string, type: string): Future<BitmapData>
	{
		return Image.loadFromBase64(base64, type).then(function (image)
		{
			__fromImage(image);
			return Future.withValue(parent);
		});
	}

	private inline __loadFromBytes(bytes: ByteArray, rawAlpha: ByteArray = null): Future<BitmapData>
	{
		return Image.loadFromBytes(bytes).then(function (image)
		{
			__fromImage(image);

			if (rawAlpha != null)
			{
				__applyAlpha(rawAlpha);
			}

			return Future.withValue(parent);
		});
	}

	private __loadFromFile(path: string): Future<BitmapData>
	{
		return Image.loadFromFile(path).then(function (image)
		{
			__fromImage(image);
			return Future.withValue(parent);
		});
	}

	private inline __powerOfTwo(value: number): number
	{
		var newValue = 1;
		while (newValue < value)
		{
			newValue <<= 1;
		}
		return newValue;
	}

	private __resize(width: number, height: number): void
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

	private __sync(): void
	{
		ImageCanvasUtil.sync(this.image, false);
	}
}
#end
