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
	The ColorMatrixFilter class lets you apply a 4 x 5 matrix transformation
	on the RGBA color and alpha values of every pixel in the input image to
	produce a result with a new set of RGBA color and alpha values. It allows
	saturation changes, hue rotation, luminance to alpha, and various other
	effects. You can apply the filter to any display object (that is, objects
	that inherit from the DisplayObject class), such as MovieClip,
	SimpleButton, TextField, and Video objects, as well as to BitmapData
	objects.
	**Note:** For RGBA values, the most significant byte represents the red
	channel value, followed by green, blue, and then alpha.

	To create a new color matrix filter, use the syntax `new
	ColorMatrixFilter()`. The use of filters depends on the object to which
	you apply the filter:

	* To apply filters to movie clips, text fields, buttons, and video, use
	the `filters` property (inherited from DisplayObject). Setting the
	`filters` property of an object does not modify the object, and you can
	remove the filter by clearing the `filters` property.
	* To apply filters to BitmapData objects, use the
	`BitmapData.applyFilter()` method. Calling `applyFilter()` on a BitmapData
	object takes the source BitmapData object and the filter object and
	generates a filtered image as a result.

	If you apply a filter to a display object, the `cacheAsBitmap` property of
	the display object is set to `true`. If you remove all filters, the
	original value of `cacheAsBitmap` is restored.

	A filter is not applied if the resulting image exceeds the maximum
	dimensions. In AIR 1.5 and Flash Player 10, the maximum is 8,191 pixels in
	width or height, and the total number of pixels cannot exceed 16,777,215
	pixels. (So, if an image is 8,191 pixels wide, it can only be 2,048 pixels
	high.) In Flash Player 9 and earlier and AIR 1.1 and earlier, the
	limitation is 2,880 pixels in height and 2,880 pixels in width. For
	example, if you zoom in on a large movie clip with a filter applied, the
	filter is turned off if the resulting image reaches the maximum
	dimensions.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class ColorMatrixFilter extends BitmapFilter
{
	@:noCompletion private static var __colorMatrixShader:ColorMatrixShader = new ColorMatrixShader();

	/**
		An array of 20 items for 4 x 5 color transform. The `matrix` property
		cannot be changed by directly modifying its value (for example,
		`myFilter.matrix[2] = 1;`). Instead, you must get a reference to the
		array, make the change to the reference, and reset the value.
		The color matrix filter separates each source pixel into its red,
		green, blue, and alpha components as srcR, srcG, srcB, srcA. To
		calculate the result of each of the four channels, the value of each
		pixel in the image is multiplied by the values in the transformation
		matrix. An offset, between -255 and 255, can optionally be added to
		each result (the fifth item in each row of the matrix). The filter
		combines each color component back into a single pixel and writes out
		the result. In the following formula, a[0] through a[19] correspond to
		entries 0 through 19 in the 20-item array that is passed to the
		`matrix` property:

		```
		redResult   = (a[0]  * srcR) + (a[1]  * srcG) + (a[2]  * srcB) + (a[3]  * srcA) + a[4]
		greenResult = (a[5]  * srcR) + (a[6]  * srcG) + (a[7]  * srcB) + (a[8]  * srcA) + a[9]
		blueResult  = (a[10] * srcR) + (a[11] * srcG) + (a[12] * srcB) + (a[13] * srcA) + a[14]
		alphaResult = (a[15] * srcR) + (a[16] * srcG) + (a[17] * srcB) + (a[18] * srcA) + a[19]
		```

		For each color value in the array, a value of 1 is equal to 100% of
		that channel being sent to the output, preserving the value of the
		color channel.

		The calculations are performed on unmultiplied color values. If the
		input graphic consists of premultiplied color values, those values are
		automatically converted into unmultiplied color values for this
		operation.

		Two optimized modes are available:

		**Alpha only.** When you pass to the filter a matrix that adjusts only
		the alpha component, as shown here, the filter optimizes its
		performance:

		```
		1 0 0 0 0
		0 1 0 0 0
		0 0 1 0 0
		0 0 0 N 0  (where N is between 0.0 and 1.0)
		```

		**Faster version**. Available only with SSE/AltiVec
		accelerator-enabled processors, such as Intel<sup>®</sup>
		Pentium<sup>®</sup> 3 and later and Apple<sup>®</sup> G4 and later.
		The accelerator is used when the multiplier terms are in the range
		-15.99 to 15.99 and the adder terms a[4], a[9], a[14], and a[19] are
		in the range -8000 to 8000.

		@throws TypeError The Array is `null` when being set
	**/
	public var matrix(get, set):Array<Float>;

	@:noCompletion private var __matrix:Array<Float>;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperties(ColorMatrixFilter.prototype, {
			"matrix": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_matrix (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_matrix (v); }")
			},
		});
	}
	#end

	/**
		Initializes a new ColorMatrixFilter instance with the specified
		parameters.
	**/
	public function new(matrix:Array<Float> = null)
	{
		super();

		this.matrix = matrix;

		__numShaderPasses = 1;
		__needSecondBitmapData = false;
	}

	public override function clone():BitmapFilter
	{
		return new ColorMatrixFilter(__matrix);
	}

	@:noCompletion private override function __applyFilter(destBitmapData:BitmapData, sourceBitmapData:BitmapData, sourceRect:Rectangle,
			destPoint:Point):BitmapData
	{
		#if lime
		var sourceImage = sourceBitmapData.image;
		var image = destBitmapData.image;

		#if (js && html5)
		ImageCanvasUtil.convertToData(sourceImage);
		ImageCanvasUtil.convertToData(image);
		#end

		var sourceData = sourceImage.data;
		var destData = image.data;

		var offsetX = Std.int(destPoint.x - sourceRect.x);
		var offsetY = Std.int(destPoint.y - sourceRect.y);
		var sourceStride = sourceBitmapData.width * 4;
		var destStride = destBitmapData.width * 4;

		var sourceFormat = sourceImage.buffer.format;
		var destFormat = image.buffer.format;
		var sourcePremultiplied = sourceImage.buffer.premultiplied;
		var destPremultiplied = image.buffer.premultiplied;

		var sourcePixel:RGBA = 0, destPixel:RGBA = 0;
		var sourceOffset:Int, destOffset:Int;

		for (row in Std.int(sourceRect.y)...Std.int(sourceRect.height))
		{
			for (column in Std.int(sourceRect.x)...Std.int(sourceRect.width))
			{
				sourceOffset = (row * sourceStride) + (column * 4);
				destOffset = ((row + offsetX) * destStride) + ((column + offsetY) * 4);

				sourcePixel.readUInt8(sourceData, sourceOffset, sourceFormat, sourcePremultiplied);

				if (sourcePixel.a == 0)
				{
					destPixel = 0;
				}
				else
				{
					destPixel.r = Std.int(Math.max(0,
						Math.min((__matrix[0] * sourcePixel.r) + (__matrix[1] * sourcePixel.g) + (__matrix[2] * sourcePixel.b)
							+ (__matrix[3] * sourcePixel.a) + __matrix[4],
							255)));
					destPixel.g = Std.int(Math.max(0,
						Math.min((__matrix[5] * sourcePixel.r) + (__matrix[6] * sourcePixel.g) + (__matrix[7] * sourcePixel.b)
							+ (__matrix[8] * sourcePixel.a) + __matrix[9],
							255)));
					destPixel.b = Std.int(Math.max(0,
						Math.min((__matrix[10] * sourcePixel.r) + (__matrix[11] * sourcePixel.g) + (__matrix[12] * sourcePixel.b)
							+ (__matrix[13] * sourcePixel.a) + __matrix[14],
							255)));
					destPixel.a = Std.int(Math.max(0,
						Math.min((__matrix[15] * sourcePixel.r) + (__matrix[16] * sourcePixel.g) + (__matrix[17] * sourcePixel.b)
							+ (__matrix[18] * sourcePixel.a) + __matrix[19],
							255)));
				}

				destPixel.writeUInt8(destData, destOffset, destFormat, destPremultiplied);
			}
		}

		destBitmapData.image.dirty = true;
		#end
		return destBitmapData;
	}

	@:noCompletion private override function __initShader(renderer:DisplayObjectRenderer, pass:Int, sourceBitmapData:BitmapData):Shader
	{
		__colorMatrixShader.init(matrix);
		return __colorMatrixShader;
	}

	// Get & Set Methods
	@:noCompletion private function get_matrix():Array<Float>
	{
		return __matrix;
	}

	@:noCompletion private function set_matrix(value:Array<Float>):Array<Float>
	{
		if (value == null)
		{
			value = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];
		}

		return __matrix = value;
	}
}

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
private class ColorMatrixShader extends BitmapFilterShader
{
	@:glFragmentSource("varying vec2 openfl_TextureCoordv;
		uniform sampler2D openfl_Texture;

		uniform mat4 uMultipliers;
		uniform vec4 uOffsets;

		void main(void) {

			vec4 color = texture2D (openfl_Texture, openfl_TextureCoordv);

			if (color.a == 0.0) {

				gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);

			} else {

				color = vec4 (color.rgb / color.a, color.a);
				color = uOffsets + color * uMultipliers;

				gl_FragColor = vec4 (color.rgb * color.a, color.a);

			}

		}")
	public function new()
	{
		super();

		#if !macro
		uMultipliers.value = [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1];
		uOffsets.value = [0, 0, 0, 0];
		#end
	}

	public function init(matrix:Array<Float>):Void
	{
		#if !macro
		var multipliers = uMultipliers.value;
		var offsets = uOffsets.value;

		multipliers[0] = matrix[0];
		multipliers[1] = matrix[1];
		multipliers[2] = matrix[2];
		multipliers[3] = matrix[3];
		multipliers[4] = matrix[5];
		multipliers[5] = matrix[6];
		multipliers[6] = matrix[7];
		multipliers[7] = matrix[8];
		multipliers[8] = matrix[10];
		multipliers[9] = matrix[11];
		multipliers[10] = matrix[12];
		multipliers[11] = matrix[13];
		multipliers[12] = matrix[15];
		multipliers[13] = matrix[16];
		multipliers[14] = matrix[17];
		multipliers[15] = matrix[18];

		offsets[0] = matrix[4] / 255.0;
		offsets[1] = matrix[9] / 255.0;
		offsets[2] = matrix[14] / 255.0;
		offsets[3] = matrix[19] / 255.0;
		#end
	}
}
#else
typedef ColorMatrixFilter = flash.filters.ColorMatrixFilter;
#end
