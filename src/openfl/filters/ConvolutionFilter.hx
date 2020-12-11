package openfl.filters;

#if !flash
import openfl.display.BitmapData;
import openfl.display.DisplayObjectRenderer;
import openfl.display.Shader;

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
	}

	public override function clone():BitmapFilter
	{
		return new ConvolutionFilter(matrixX, matrixY, __matrix, divisor, bias, preserveAlpha, clamp, color, alpha);
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

		void main(void) {

			vec4 tc = texture2D (openfl_Texture, vBlurCoords[4]);
			vec4 c = vec4 (0.0);

			c += texture2D (openfl_Texture, vBlurCoords[0]) * uConvoMatrix[0][0];
			c += texture2D (openfl_Texture, vBlurCoords[1]) * uConvoMatrix[0][1];
			c += texture2D (openfl_Texture, vBlurCoords[2]) * uConvoMatrix[0][2];

			c += texture2D (openfl_Texture, vBlurCoords[3]) * uConvoMatrix[1][0];
			c += tc * uConvoMatrix[1][1];
			c += texture2D (openfl_Texture, vBlurCoords[5]) * uConvoMatrix[1][2];

			c += texture2D (openfl_Texture, vBlurCoords[6]) * uConvoMatrix[2][0];
			c += texture2D (openfl_Texture, vBlurCoords[7]) * uConvoMatrix[2][1];
			c += texture2D (openfl_Texture, vBlurCoords[8]) * uConvoMatrix[2][2];

			if (uDivisor > 0.0) {

				c /= vec4 (uDivisor, uDivisor, uDivisor, uDivisor);

			}

			c += vec4 (uBias, uBias, uBias, uBias);

			if (uPreserveAlpha) {

				c.a = tc.a;

			}

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
