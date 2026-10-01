package openfl.filters;

#if !flash
import openfl.display.BitmapData;
import openfl.display.DisplayObjectRenderer;
import openfl.display.Shader;
import openfl.geom.Point;
import openfl.geom.Rectangle;
#if lime
import lime._internal.graphics.ImageCanvasUtil; // TODO
import lime.math.RGBA;
#end

/**
	The ConvolutionFilter class applies a matrix convolution filter effect. A
	convolution combines pixels in the input image with neighboring pixels to
	produce an image. A wide variety of image effects can be achieved through
	convolutions, including blurring, edge detection, sharpening, embossing,
	and beveling. You can apply the filter to any display object (that is,
	objects that inherit from the DisplayObject class), such as MovieClip,
	SimpleButton, TextField, and Video objects, as well as to BitmapData
	objects.

	To create a convolution filter, use the syntax `new ConvolutionFilter()`.
	The use of filters depends on the object to which you apply the filter:

	* To apply filters to movie clips, text fields, buttons, and video, use
	the `filters` property (inherited from DisplayObject). Setting the
	`filters` property of an object does not modify the object, and you can
	remove the filter by clearing the `filters` property.
	* To apply filters to BitmapData objects, use the
	`BitmapData.applyFilter()` method. Calling `applyFilter()` on a BitmapData
	object takes the source BitmapData object and the filter object and
	generates a filtered image as a result.

	If you apply a filter to a display object, the value of the
	`cacheAsBitmap` property of the object is set to `true`. If you clear all
	filters, the original value of `cacheAsBitmap` is restored.

	A filter is not applied if the resulting image exceeds the maximum
	dimensions. In AIR 1.5 and Flash Player 10, the maximum is 8,191 pixels in
	width or height, and the total number of pixels cannot exceed 16,777,215
	pixels. (So, if an image is 8,191 pixels wide, it can only be 2,048 pixels
	high.) In Flash Player 9 and earlier and AIR 1.1 and earlier, the
	limitation is 2,880 pixels in height and 2,880 pixels in width. For
	example, if you zoom in on a large movie clip with a filter applied, the
	filter is turned off if the resulting image exceeds maximum dimensions.

	@see `openfl.display.DisplayObject.filters`
	@see `openfl.display.BitmapData.applyFilter`
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class ConvolutionFilter extends BitmapFilter
{
	@:noCompletion private static var __convolutionShader:ConvolutionShader = new ConvolutionShader();

	/**
		The alpha transparency value of the substitute color. Valid values are
		0 to 1.0. The default is 0. For example, .25 sets a transparency value
		of 25%.
	**/
	public var alpha:Float;

	/**
		The amount of bias to add to the result of the matrix transformation.
		The bias increases the color value of each channel, so that dark
		colors appear brighter. The default value is 0.
	**/
	public var bias:Float;

	/**
		Indicates whether the image should be clamped. For pixels off the
		source image, a value of `true` indicates that the input image is
		extended along each of its borders as necessary by duplicating the
		color values at each respective edge of the input image. A value of
		`false` indicates that another color should be used, as specified in
		the `color` and `alpha` properties. The default is `true`.
	**/
	public var clamp:Bool;

	/**
		The hexadecimal color to substitute for pixels that are off the source
		image. It is an RGB value with no alpha component. The default is 0.
	**/
	public var color:Int;

	/**
		The divisor used during matrix transformation. The default value is 1.
		A divisor that is the sum of all the matrix values smooths out the
		overall color intensity of the result. A value of 0 is ignored and the
		default is used instead.
	**/
	public var divisor:Float;

	/**
		An array of values used for matrix transformation. The number of items
		in the array must equal `matrixX * matrixY`.
		A matrix convolution is based on an _n_ x _m_ matrix, which describes
		how a given pixel value in the input image is combined with its
		neighboring pixel values to produce a resulting pixel value. Each
		result pixel is determined by applying the matrix to the corresponding
		source pixel and its neighboring pixels.

		For a 3 x 3 matrix convolution, the following formula is used for each
		independent color channel:

		```
		dst (x, y) = ((src (x-1, y-1) * a0 + src(x, y-1) * a1....
					   src(x, y+1) * a7 + src (x+1,y+1) * a8) / divisor) + bias
		```

		Certain filter specifications perform faster when run by a processor
		that offers SSE (Streaming SIMD Extensions). The following are
		criteria for faster convolution operations:

		* The filter must be a 3x3 filter.
		* All the filter terms must be integers between -127 and +127.
		* The sum of all the filter terms must not have an absolute value
		greater than 127.
		* If any filter term is negative, the divisor must be between 2.00001
		and 256.
		* If all filter terms are positive, the divisor must be between 1.1
		and 256.
		* The bias must be an integer.

		**Note:** If you create a ConvolutionFilter instance using the
		constructor without parameters, the order you assign values to matrix
		properties affects the behavior of the filter. In the following case,
		the matrix array is assigned while the `matrixX` and `matrixY`
		properties are still set to `0` (the default value):

		```haxe
		public var myfilter = new ConvolutionFilter();
		myfilter.matrix = [0, 0, 0, 0, 1, 0, 0, 0, 0];
		myfilter.matrixX = 3;
		myfilter.matrixY = 3;
		```

		In the following case, the matrix array is assigned while the
		`matrixX` and `matrixY` properties are set to `3`:

		```haxe
		public var myfilter = new ConvolutionFilter();
		myfilter.matrixX = 3;
		myfilter.matrixY = 3;
		myfilter.matrix = [0, 0, 0, 0, 1, 0, 0, 0, 0];
		```

		@throws TypeError The Array is null when being set
	**/
	public var matrix(get, set):Array<Float>;

	/**
		The _x_ dimension of the matrix (the number of columns in the matrix).
		The default value is 0.
	**/
	public var matrixX:Int;

	/**
		The _y_ dimension of the matrix (the number of rows in the matrix).
		The default value is 0.
	**/
	public var matrixY:Int;

	/**
		Indicates if the alpha channel is preserved without the filter effect
		or if the convolution filter is applied to the alpha channel as well
		as the color channels. A value of `false` indicates that the
		convolution applies to all channels, including the alpha channel. A
		value of `true` indicates that the convolution applies only to the
		color channels. The default value is `true`.
	**/
	public var preserveAlpha:Bool;

	@:noCompletion private var __matrix:Array<Float>;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperties(ConvolutionFilter.prototype, {
			"matrix": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_matrix (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_matrix (v); }")
			},
		});
	}
	#end

	/**
		Initializes a ConvolutionFilter instance with the specified
		parameters.

		@param matrixX       The _x_ dimension of the matrix (the number of
							 columns in the matrix). The default value is 0.
		@param matrixY       The _y_ dimension of the matrix (the number of
							 rows in the matrix). The default value is 0.
		@param divisor       The divisor used during matrix transformation.
							 The default value is 1. A divisor that is the sum
							 of all the matrix values evens out the overall
							 color intensity of the result. A value of 0 is
							 ignored and the default is used instead.
		@param bias          The bias to add to the result of the matrix
							 transformation. The default value is 0.
		@param preserveAlpha A value of `false` indicates that the alpha value
							 is not preserved and that the convolution applies
							 to all channels, including the alpha channel. A
							 value of `true` indicates that the convolution
							 applies only to the color channels. The default
							 value is `true`.
		@param clamp         For pixels that are off the source image, a value
							 of `true` indicates that the input image is
							 extended along each of its borders as necessary
							 by duplicating the color values at the given edge
							 of the input image. A value of `false` indicates
							 that another color should be used, as specified
							 in the `color` and `alpha` properties. The
							 default is `true`.
		@param color         The hexadecimal color to substitute for pixels
							 that are off the source image.
		@param alpha         The alpha of the substitute color.
	**/
	public function new(matrixX:Int = 0, matrixY:Int = 0, matrix:Array<Float> = null, divisor:Float = 1.0, bias:Float = 0.0, preserveAlpha:Bool = true,
			clamp:Bool = true, color:Int = 0, alpha:Float = 0.0)
	{
		super();

		this.matrixX = matrixX;
		this.matrixY = matrixY;
		__matrix = matrix;
		this.divisor = divisor;
		this.bias = bias;
		this.preserveAlpha = preserveAlpha;
		this.clamp = clamp;
		this.color = color;
		this.alpha = alpha;

		__numShaderPasses = 1;
		// the software path reads the whole source before writing, so it can run in place
		__needSecondBitmapData = false;
	}

	public override function clone():BitmapFilter
	{
		return new ConvolutionFilter(matrixX, matrixY, __matrix, divisor, bias, preserveAlpha, clamp, color, alpha);
	}

	@:noCompletion private override function __applyFilter(bitmapData:BitmapData, sourceBitmapData:BitmapData, sourceRect:Rectangle,
			destPoint:Point):BitmapData
	{
		#if lime
		var sourceImage = sourceBitmapData.image;
		var image = bitmapData.image;

		#if (js && html5)
		ImageCanvasUtil.convertToData(sourceImage);
		ImageCanvasUtil.convertToData(image);
		#end

		var sourceData = sourceImage.data;
		var destData = image.data;
		var sourceFormat = sourceImage.buffer.format;
		var destFormat = image.buffer.format;
		var sourcePremultiplied = sourceImage.buffer.premultiplied;
		var destPremultiplied = image.buffer.premultiplied;
		var sourceStride = sourceBitmapData.width * 4;
		var destStride = bitmapData.width * 4;

		var sx = Std.int(sourceRect.x), sy = Std.int(sourceRect.y);
		var width = Std.int(sourceRect.width), height = Std.int(sourceRect.height);
		var dx = Std.int(destPoint.x), dy = Std.int(destPoint.y);
		if (width <= 0 || height <= 0) return bitmapData;

		var mx = matrixX, my = matrixY;
		var kernel = __matrix;
		var identity = (kernel == null || mx <= 0 || my <= 0 || kernel.length < mx * my);

		// On native targets the pixel bytes are read and written through
		// haxe.io.Bytes, a plain memory access, typed-array element access is a
		// call per byte there. The byte order and the premultiplied conversion
		// follow lime.math.RGBA exactly. On js RGBA is used as is.
		#if js
		var direct = false;
		#else
		var direct = true;
		#end
		var sourceBytes:haxe.io.Bytes = direct ? sourceData.buffer : null;
		var destBytes:haxe.io.Bytes = direct ? destData.buffer : null;
		var sr = 0, sg = 1, sb = 2, sa = 3; // channel byte positions in the source
		switch (sourceFormat)
		{
			case ARGB32: sr = 1; sg = 2; sb = 3; sa = 0;
			case BGRA32: sr = 2; sg = 1; sb = 0; sa = 3;
			default:
		}
		var dr = 0, dg = 1, db = 2, da = 3;
		switch (destFormat)
		{
			case ARGB32: dr = 1; dg = 2; db = 3; da = 0;
			case BGRA32: dr = 2; dg = 1; db = 0; da = 3;
			default:
		}

		// the source region as straight ARGB channels, read once
		var src = new Array<Int>();
		src[width * height * 4 - 1] = 0;
		var pixel:RGBA = 0;
		var k = 0;
		for (y in 0...height)
		{
			var offset = (sy + y) * sourceStride + sx * 4;
			if (direct)
			{
				for (x in 0...width)
				{
					var r = sourceBytes.get(offset + sr), g = sourceBytes.get(offset + sg), b = sourceBytes.get(offset + sb), a = sourceBytes.get(offset + sa);
					if (sourcePremultiplied && a != 0 && a != 0xFF)
					{
						var unmult = 255.0 / a;
						r = Math.round(r * unmult);
						g = Math.round(g * unmult);
						b = Math.round(b * unmult);
						if (r > 255) r = 255;
						if (g > 255) g = 255;
						if (b > 255) b = 255;
					}
					src[k] = r;
					src[k + 1] = g;
					src[k + 2] = b;
					src[k + 3] = a;
					k += 4;
					offset += 4;
				}
			}
			else
			{
				for (x in 0...width)
				{
					pixel.readUInt8(sourceData, offset, sourceFormat, sourcePremultiplied);
					src[k] = pixel.r;
					src[k + 1] = pixel.g;
					src[k + 2] = pixel.b;
					src[k + 3] = pixel.a;
					k += 4;
					offset += 4;
				}
			}
		}

		var scale = 1.0 / (divisor != 0 ? divisor : 1.0);
		var cx = mx >> 1, cy = my >> 1;
		var subR = (color >> 16) & 0xFF, subG = (color >> 8) & 0xFF, subB = color & 0xFF;
		var subA = Std.int(Math.max(0, Math.min(1, alpha)) * 255);

		// the non-zero taps as offsets into the source array (interior pixels
		// only need these, no bounds checks)
		var tapOffset = new Array<Int>();
		var tapWeight = new Array<Float>();
		var tapX = new Array<Int>();
		var tapY = new Array<Int>();

		if (!identity)
		{
			for (j in 0...my)
				for (i in 0...mx)
				{
					var weight = kernel[j * mx + i];
					if (weight == 0) continue;
					tapX.push(i - cx);
					tapY.push(j - cy);
					tapOffset.push(((j - cy) * width + (i - cx)) * 4);
					tapWeight.push(weight);
				}
		}
		var taps = tapWeight.length;
		var innerX0 = cx;
		var innerY0 = cy;
		var innerX1 = width - (mx - 1 - cx);
		var innerY1 = height - (my - 1 - cy);

		for (y in 0...height)
		{
			var ty = dy + y;
			if (ty < 0 || ty >= bitmapData.height) continue;

			var inRow = y >= innerY0 && y < innerY1;
			for (x in 0...width)
			{
				var tx = dx + x;
				if (tx < 0 || tx >= bitmapData.width) continue;

				var s = (y * width + x) * 4;

				if (identity)
				{
					pixel.r = src[s];
					pixel.g = src[s + 1];
					pixel.b = src[s + 2];
					pixel.a = src[s + 3];
				}
				else
				{
					var r = 0.0, g = 0.0, b = 0.0, a = 0.0;
					if (inRow && x >= innerX0 && x < innerX1)
					{
						for (t in 0...taps)
						{
							var q = s + tapOffset[t];
							var weight = tapWeight[t];
							r += src[q] * weight;
							g += src[q + 1] * weight;
							b += src[q + 2] * weight;
							a += src[q + 3] * weight;
						}
					}
					else
					{
						for (t in 0...taps)
						{
							var weight = tapWeight[t];
							var px = x + tapX[t], py = y + tapY[t];
							if (px < 0 || px >= width || py < 0 || py >= height)
							{
								if (clamp)
								{
									var qx = px < 0 ? 0 : (px >= width ? width - 1 : px);
									var qy = py < 0 ? 0 : (py >= height ? height - 1 : py);
									var q = (qy * width + qx) * 4;
									r += src[q] * weight;
									g += src[q + 1] * weight;
									b += src[q + 2] * weight;
									a += src[q + 3] * weight;
								}
								else
								{
									r += subR * weight;
									g += subG * weight;
									b += subB * weight;
									a += subA * weight;
								}
							}
							else
							{
								var q = (py * width + px) * 4;
								r += src[q] * weight;
								g += src[q + 1] * weight;
								b += src[q + 2] * weight;
								a += src[q + 3] * weight;
							}
						}
					}
					pixel.r = __clampChannel(r * scale + bias);
					pixel.g = __clampChannel(g * scale + bias);
					pixel.b = __clampChannel(b * scale + bias);
					pixel.a = preserveAlpha ? src[s + 3] : __clampChannel(a * scale + bias);
				}

				var d = ty * destStride + tx * 4;
				if (direct)
				{
					var r = pixel.r, g = pixel.g, b = pixel.b, a = pixel.a;
					if (destPremultiplied)
					{
						if (a == 0)
						{
							r = g = b = 0;
						}
						else if (a != 0xFF)
						{
							var a16 = Math.ceil(a * ((1 << 16) / 0xFF));
							r = (r * a16) >> 16;
							g = (g * a16) >> 16;
							b = (b * a16) >> 16;
						}
					}
					destBytes.set(d + dr, r);
					destBytes.set(d + dg, g);
					destBytes.set(d + db, b);
					destBytes.set(d + da, a);
				}
				else
				{
					pixel.writeUInt8(destData, d, destFormat, destPremultiplied);
				}
			}
		}

		image.dirty = true;
		image.version++;
		#end
		return bitmapData;
	}

	@:noCompletion private static inline function __clampChannel(value:Float):Int
	{
		return value <= 0 ? 0 : (value >= 255 ? 255 : Std.int(value + 0.5));
	}

	@:noCompletion private override function __initShader(renderer:DisplayObjectRenderer, pass:Int, sourceBitmapData:BitmapData):Shader
	{
		#if !macro
		__convolutionShader.uConvoMatrix.value = matrix;
		__convolutionShader.uDivisor.value[0] = divisor;
		__convolutionShader.uBias.value[0] = bias;
		__convolutionShader.uPreserveAlpha.value[0] = preserveAlpha;
		#end

		return __convolutionShader;
	}

	// Get & Set Methods
	@:noCompletion private function get_matrix():Array<Float>
	{
		return __matrix;
	}

	@:noCompletion private function set_matrix(v:Array<Float>):Array<Float>
	{
		if (v == null)
		{
			v = [0, 0, 0, 0, 1, 0, 0, 0, 0];
		}

		if (v.length != 9)
		{
			throw "Only a 3x3 matrix is supported";
		}

		return __matrix = v;
	}
}

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
private class ConvolutionShader extends BitmapFilterShader
{
	@:glFragmentSource("varying vec2 vBlurCoords[9];

		uniform sampler2D openfl_Texture;

		uniform float uBias;
		uniform mat3 uConvoMatrix;
		uniform float uDivisor;
		uniform bool uPreserveAlpha;

		// The texture holds premultiplied colours (each colour channel is already multiplied by its alpha).
	    // Flash applies the matrix to the straight colours, so we divide the alpha out before weighting the
	    // taps and multiply it back in before writing the result.
		vec4 straight (vec2 uv) {
			vec4 t = texture2D (openfl_Texture, uv);
			if (t.a > 0.0) t.rgb /= t.a;
			return t;
		}

		void main(void) {

			vec4 tc = straight (vBlurCoords[4]);
			vec4 c = vec4 (0.0);

			c += straight (vBlurCoords[0]) * uConvoMatrix[0][0];
			c += straight (vBlurCoords[1]) * uConvoMatrix[0][1];
			c += straight (vBlurCoords[2]) * uConvoMatrix[0][2];

			c += straight (vBlurCoords[3]) * uConvoMatrix[1][0];
			c += tc * uConvoMatrix[1][1];
			c += straight (vBlurCoords[5]) * uConvoMatrix[1][2];

			c += straight (vBlurCoords[6]) * uConvoMatrix[2][0];
			c += straight (vBlurCoords[7]) * uConvoMatrix[2][1];
			c += straight (vBlurCoords[8]) * uConvoMatrix[2][2];

			if (uDivisor > 0.0) {

				c /= vec4 (uDivisor, uDivisor, uDivisor, uDivisor);

			}

			// bias is in 0..255 colour units
			c += vec4 (uBias / 255.0);

			if (uPreserveAlpha) {

				c.a = tc.a;

			}

			c = clamp (c, 0.0, 1.0);
			c.rgb *= c.a;
			gl_FragColor = c;

		}")
	@:glVertexSource("attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;

		varying vec2 vBlurCoords[9];

		uniform mat4 openfl_Matrix;
		uniform vec2 openfl_TextureSize;

		void main(void) {

			vec2 r = vec2 (1.0, 1.0) / openfl_TextureSize;
			vec2 t = openfl_TextureCoord;

			vBlurCoords[0] = t + r * vec2 (-1.0, -1.0);
			vBlurCoords[1] = t + r * vec2 (0.0, -1.0);
			vBlurCoords[2] = t + r * vec2 (1.0, -1.0);

			vBlurCoords[3] = t + r * vec2 (-1.0, 0.0);
			vBlurCoords[4] = t;
			vBlurCoords[5] = t + r * vec2 (1.0, 0.0);

			vBlurCoords[6] = t + r * vec2 (-1.0, 1.0);
			vBlurCoords[7] = t + r * vec2 (0.0, 1.0);
			vBlurCoords[8] = t + r * vec2 (1.0, 1.0);

			gl_Position = openfl_Matrix * openfl_Position;

		}")
	public function new()
	{
		super();

		#if !macro
		uDivisor.value = [1];
		uBias.value = [0];
		uPreserveAlpha.value = [true];
		#end
	}
}
#else
typedef ConvolutionFilter = flash.filters.ConvolutionFilter;
#end
