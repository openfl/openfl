package openfl.filters;

import haxe.Timer;
#if !flash
import openfl.display.BitmapData;
import openfl.display.DisplayObjectRenderer;
import openfl.display.Shader;
import openfl.geom.Point;
import openfl.geom.Rectangle;
#if lime
import lime._internal.graphics.ImageDataUtil; // TODO

#end

/**
	The BlurFilter class lets you apply a blur visual effect to display
	objects. A blur effect softens the details of an image. You can produce
	blurs that range from a softly unfocused look to a Gaussian blur, a hazy
	appearance like viewing an image through semi-opaque glass. When the
	`quality` property of this filter is set to low, the result is a
	softly unfocused look. When the `quality` property is set to
	high, it approximates a Gaussian blur filter. You can apply the filter to
	any display object(that is, objects that inherit from the DisplayObject
	class), such as MovieClip, SimpleButton, TextField, and Video objects, as
	well as to BitmapData objects.

	To create a new filter, use the constructor `new
	BlurFilter()`. The use of filters depends on the object to which you
	apply the filter:


	* To apply filters to movie clips, text fields, buttons, and video, use
	the `filters` property(inherited from DisplayObject). Setting
	the `filters` property of an object does not modify the object,
	and you can remove the filter by clearing the `filters`
	property.
	* To apply filters to BitmapData objects, use the
	`BitmapData.applyFilter()` method. Calling
	`applyFilter()` on a BitmapData object takes the source
	BitmapData object and the filter object and generates a filtered image as a
	result.


	If you apply a filter to a display object, the
	`cacheAsBitmap` property of the display object is set to
	`true`. If you remove all filters, the original value of
	`cacheAsBitmap` is restored.

	This filter supports Stage scaling. However, it does not support general
	scaling, rotation, and skewing. If the object itself is scaled
	(`scaleX` and `scaleY` are not set to 100%), the
	filter effect is not scaled. It is scaled only when the user zooms in on
	the Stage.

	A filter is not applied if the resulting image exceeds the maximum
	dimensions. In AIR 1.5 and Flash Player 10, the maximum is 8,191 pixels in
	width or height, and the total number of pixels cannot exceed 16,777,215
	pixels.(So, if an image is 8,191 pixels wide, it can only be 2,048 pixels
	high.) In Flash Player 9 and earlier and AIR 1.1 and earlier, the
	limitation is 2,880 pixels in height and 2,880 pixels in width. If, for
	example, you zoom in on a large movie clip with a filter applied, the
	filter is turned off if the resulting image exceeds the maximum
	dimensions.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.geom.Point)
@:access(openfl.geom.Rectangle)
@:final class BlurFilter extends BitmapFilter
{
	@:noCompletion private static var __blurShader:BlurShader = new BlurShader();

	/**
		The amount of horizontal blur. Valid values are from 0 to 255(floating
		point). The default value is 4. Values that are a power of 2(such as 2,
		4, 8, 16 and 32) are optimized to render more quickly than other values.
	**/
	public var blurX(get, set):Float;

	/**
		The amount of vertical blur. Valid values are from 0 to 255(floating
		point). The default value is 4. Values that are a power of 2(such as 2,
		4, 8, 16 and 32) are optimized to render more quickly than other values.
	**/
	public var blurY(get, set):Float;

	/**
		The number of times to perform the blur. The default value is
		`BitmapFilterQuality.LOW`, which is equivalent to applying the
		filter once. The value `BitmapFilterQuality.MEDIUM` applies the
		filter twice; the value `BitmapFilterQuality.HIGH` applies it
		three times and approximates a Gaussian blur. Filters with lower values
		are rendered more quickly.

		For most applications, a `quality` value of low, medium, or
		high is sufficient. Although you can use additional numeric values up to
		15 to increase the number of times the blur is applied, higher values are
		rendered more slowly. Instead of increasing the value of
		`quality`, you can often get a similar effect, and with faster
		rendering, by simply increasing the values of the `blurX` and
		`blurY` properties.

		You can use the following BitmapFilterQuality constants to specify
		values of the `quality` property:

		* `BitmapFilterQuality.LOW`
		* `BitmapFilterQuality.MEDIUM`
		* `BitmapFilterQuality.HIGH`
	**/
	public var quality(get, set):Int;

	@:noCompletion private var __blurX:Float;
	@:noCompletion private var __blurY:Float;
	@:noCompletion private var __horizontalPasses:Int;
	@:noCompletion private var __quality:Int;
	@:noCompletion private var __verticalPasses:Int;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperties(BlurFilter.prototype, {
			"blurX": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_blurX (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_blurX (v); }")
			},
			"blurY": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_blurY (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_blurY (v); }")
			},
			"quality": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_quality (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_quality (v); }")
			},
		});
	}
	#end

	/**
		Initializes the filter with the specified parameters. The default values
		create a soft, unfocused image.

		@param blurX   The amount to blur horizontally. Valid values are from 0 to
					   255.0(floating-point value).
		@param blurY   The amount to blur vertically. Valid values are from 0 to
					   255.0(floating-point value).
		@param quality The number of times to apply the filter. You can specify
					   the quality using the BitmapFilterQuality constants:


					  * `openfl.filters.BitmapFilterQuality.LOW`

					  * `openfl.filters.BitmapFilterQuality.MEDIUM`

					  * `openfl.filters.BitmapFilterQuality.HIGH`


					   High quality approximates a Gaussian blur. For most
					   applications, these three values are sufficient. Although
					   you can use additional numeric values up to 15 to achieve
					   different effects, be aware that higher values are rendered
					   more slowly.
	**/
	public function new(blurX:Float = 4, blurY:Float = 4, quality:Int = 1)
	{
		super();

		this.blurX = blurX;
		this.blurY = blurY;
		this.quality = quality;

		__needSecondBitmapData = true;
		__preserveObject = false;
		__renderDirty = true;
	}

	public override function clone():BitmapFilter
	{
		return new BlurFilter(__blurX, __blurY, __quality);
	}

	@:noCompletion private override function __applyFilter(bitmapData:BitmapData, sourceBitmapData:BitmapData, sourceRect:Rectangle,
			destPoint:Point):BitmapData
	{
		#if lime
		var time = Timer.stamp();
		var finalImage = ImageDataUtil.gaussianBlur(bitmapData.image, sourceBitmapData.image, sourceRect.__toLimeRectangle(), destPoint.__toLimeVector2(),
			__blurX, __blurY, __quality);
		var elapsed = Timer.stamp() - time;
		// trace("blurX: " + __blurX + " blurY: " + __blurY + " quality: " + __quality + " elapsed: " + elapsed * 1000 + "ms");
		if (finalImage == bitmapData.image) return bitmapData;
		#end
		return sourceBitmapData;
	}

	@:noCompletion private override function __initShader(renderer:DisplayObjectRenderer, pass:Int, sourceBitmapData:BitmapData):Shader
	{
		#if !macro
		if (pass < __horizontalPasses)
		{
			var scale = Math.pow(0.5, pass >> 1);
			__blurShader.uRadius.value[0] = blurX * scale;
			__blurShader.uRadius.value[1] = 0;
		}
		else
		{
			var scale = Math.pow(0.5, (pass - __horizontalPasses) >> 1);
			__blurShader.uRadius.value[0] = 0;
			__blurShader.uRadius.value[1] = blurY * scale;
		}
		#end

		return __blurShader;
	}

	// Get & Set Methods
	@:noCompletion private function get_blurX():Float
	{
		return __blurX;
	}

	@:noCompletion private function set_blurX(value:Float):Float
	{
		if (value != __blurX)
		{
			__blurX = value;
			__renderDirty = true;
			__leftExtension = (value > 0 ? Math.ceil(value) : 0);
			__rightExtension = __leftExtension;
		}
		return value;
	}

	@:noCompletion private function get_blurY():Float
	{
		return __blurY;
	}

	@:noCompletion private function set_blurY(value:Float):Float
	{
		if (value != __blurY)
		{
			__blurY = value;
			__renderDirty = true;
			__topExtension = (value > 0 ? Math.ceil(value) : 0);
			__bottomExtension = __topExtension;
		}
		return value;
	}

	@:noCompletion private function get_quality():Int
	{
		return __quality;
	}

	@:noCompletion private function set_quality(value:Int):Int
	{
		// TODO: Quality effect with fewer passes?

		__horizontalPasses = (__blurX <= 0) ? 0 : Math.round(__blurX * (value / 4)) + 1;
		__verticalPasses = (__blurY <= 0) ? 0 : Math.round(__blurY * (value / 4)) + 1;

		__numShaderPasses = __horizontalPasses + __verticalPasses;

		if (value != __quality) __renderDirty = true;
		return __quality = value;
	}
}

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
private class BlurShader extends BitmapFilterShader
{
	@:glFragmentSource("uniform sampler2D openfl_Texture;

		varying vec2 vBlurCoords[7];

		void main(void) {

			vec4 sum = vec4(0.0);
			sum += texture2D(openfl_Texture, vBlurCoords[0]) * 0.00443;
			sum += texture2D(openfl_Texture, vBlurCoords[1]) * 0.05399;
			sum += texture2D(openfl_Texture, vBlurCoords[2]) * 0.24197;
			sum += texture2D(openfl_Texture, vBlurCoords[3]) * 0.39894;
			sum += texture2D(openfl_Texture, vBlurCoords[4]) * 0.24197;
			sum += texture2D(openfl_Texture, vBlurCoords[5]) * 0.05399;
			sum += texture2D(openfl_Texture, vBlurCoords[6]) * 0.00443;

			gl_FragColor = sum;

		}")
	@:glVertexSource("attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;

		uniform mat4 openfl_Matrix;

		uniform vec2 uRadius;
		varying vec2 vBlurCoords[7];
		uniform vec2 uTextureSize;

		void main(void) {

			gl_Position = openfl_Matrix * openfl_Position;

			vec2 r = uRadius / uTextureSize;
			vBlurCoords[0] = openfl_TextureCoord - r;
			vBlurCoords[1] = openfl_TextureCoord - r * 0.75;
			vBlurCoords[2] = openfl_TextureCoord - r * 0.5;
			vBlurCoords[3] = openfl_TextureCoord;
			vBlurCoords[4] = openfl_TextureCoord + r * 0.5;
			vBlurCoords[5] = openfl_TextureCoord + r * 0.75;
			vBlurCoords[6] = openfl_TextureCoord + r;

		}")
	public function new()
	{
		super();

		#if !macro
		uRadius.value = [0, 0];
		#end
	}

	@:noCompletion private override function __update():Void
	{
		#if !macro
		uTextureSize.value = [__texture.input.width, __texture.input.height];
		#end

		super.__update();
	}
}
#else
typedef BlurFilter = flash.filters.BlurFilter;
#end
