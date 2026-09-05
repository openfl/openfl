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
	any display object (that is, objects that inherit from the DisplayObject
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
	@:noCompletion private static var __blurShader:BoxBlurShader = new BoxBlurShader();

	// Flash quality settings have a range 0-15 so we can store values in a lookup table.
	// These values are bases on best effort measurement of how flash does things and has been sampled from Flash/Air tests.
	// Flash store values as 32-bit floats so 1.05 or 1.55 cannot be stored exactly (they are held as 1.04999995 and 1.54999995)
	// it also seems like based on measurements that Flash do some operations or logic based on 1/4 pixels.
	// so in order to get the best approximation to Flash we do have to use some magic numbers in the methods below
	@:noCompletion private static var __growthByQuality:Array<Float> = [
		for (twentieths in [0, 10, 21, 27, 31, 35, 38, 40, 42, 44, 46, 50, 60, 60, 70, 70]) twentieths / 20
	];

	// the reach in pixels (step 1); quality below 1 is treated as 1 and above 15 as 15
	@:noCompletion private static function __reach(blur:Float, quality:Int):Float
	{
		return (blur < 1 ? 1 : blur) * __growthByQuality[quality < 1 ? 1 : (quality > 15 ? 15 : quality)];
	}

	// whole-pixel growth for the effect filters (step 2, first rule)
	@:noCompletion private static function __effectExtension(blur:Float, quality:Int):Int
	{
		var reach = __reach(blur, quality);
		var extension = Math.ceil(reach);
		if (extension == reach && (extension % 2) == 1) extension++; // exact odd integer -> next even
		return extension + (quality <= 1 ? 1 : 0); // the extra painted pixel at quality 1
	}

	// whole-pixel growth for BlurFilter (up from 1/4 pixel)
	@:noCompletion private static function __extension(blur:Float, quality:Int):Int
	{
		return Math.floor(__reach(blur, quality) + 0.75);
	}


	/**
		The amount of horizontal blur. Valid values are from 0 to 255(floating
		point). The default value is 4. Values that are a power of 2 (such as 2,
		4, 8, 16 and 32) are optimized to render more quickly than other values.
	**/
	public var blurX(get, set):Float;

	/**
		The amount of vertical blur. Valid values are from 0 to 255(floating
		point). The default value is 4. Values that are a power of 2 (such as 2,
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

	@:noCompletion private override function __applyFilter(bitmapData:BitmapData, sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point):BitmapData
	{
		#if lime
		var time = Timer.stamp();
		var finalImage = ImageDataUtil.gaussianBlur(bitmapData.image, sourceBitmapData.image, sourceRect.__toLimeRectangle(), destPoint.__toLimeVector2(),
			__blurX * __renderScale, __blurY * __renderScale, __quality);
		var elapsed = Timer.stamp() - time;
		// trace("blurX: " + __blurX + " blurY: " + __blurY + " quality: " + __quality + " elapsed: " + elapsed * 1000 + "ms");
		if (finalImage == bitmapData.image) return bitmapData;
		#end
		return sourceBitmapData;
	}

	@:noCompletion private override function __initShader(renderer:DisplayObjectRenderer, pass:Int, sourceBitmapData:BitmapData):Shader
	{
		#if !macro
		// passes alternate horizontal / vertical, each applies one full box blur for its axis, iterated `quality` times
		var horizontal = (pass % 2 == 0);
		return __setupBlurShader(horizontal, (horizontal ? blurX : blurY) * __renderScale);
		#else
		return __blurShader;
		#end
	}

	// Configure the box-blur shader for one axis of one pass.
	@:noCompletion private static function __setupBlurShader(horizontal:Bool, v:Float):BitmapFilterShader
	{
		var shader = __blurShader;
		shader.uDir.value[0] = horizontal ? 1.0 : 0.0;
		shader.uDir.value[1] = horizontal ? 0.0 : 1.0;
		shader.uFullSize.value[0] = v > 255 ? 255.0 : v;
		return shader;
	}

	// blur growth per axis (see __extension above).
	// Depends on quality as well as the blur, so every setter recomputes it.
	@:noCompletion private function __updateSize():Void
	{
		__leftExtension = __rightExtension = __extension(__blurX, __quality);
		__topExtension = __bottomExtension = __extension(__blurY, __quality);
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
		}
		__updateSize();
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
		}
		__updateSize();
		return value;
	}

	@:noCompletion private function get_quality():Int
	{
		return __quality;
	}

	@:noCompletion private function set_quality(value:Int):Int
	{

		// one horizontal + one vertical box pass per quality iteration
		var passes = (value > 0) ? value : 1;
		__horizontalPasses = passes;
		__verticalPasses = passes;
		__numShaderPasses = passes * 2;

		if (value != __quality) __renderDirty = true;
		__quality = value;
		__updateSize();
		return __quality;
	}
}

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
private class BoxBlurShader extends BitmapFilterShader
{
	@:glVertexSource("#pragma header

		void main(void) {

			#pragma body

		}")
	@:glFragmentSource("#pragma header

		uniform vec2 uTextureSize;
		uniform vec2 uDir;          // blur axis: (1,0) horizontal, (0,1) vertical
		uniform float uFullSize;    // box width = the blur amount

		// Beyond the bitmap there is nothing (Flash pads with transparent), so
		// samples outside it must read 0 -- the texture would otherwise clamp
		// and repeat its edge pixel into the blur.
		vec4 tap(vec2 uv) {
			if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) return vec4(0.0);
			return texture2D(openfl_Texture, uv);
		}

		void main(void) {

			vec2 direction = uDir / uTextureSize;
			float fullSize = min(uFullSize, 255.0);

			if (fullSize <= 1.0) {
				gl_FragColor = texture2D(openfl_Texture, openfl_TextureCoordv);
				return;
			}

			float halfW = fullSize * 0.5;
			int   n     = int(floor(halfW - 0.5));           // full interior texels per side
			float frac  = halfW - (float(n) + 0.5);          // fractional edge weight
			frac = floor(frac * 255.0) / 255.0;              // 8-bit weight (Flash fixed point)

			vec4 sum = tap(openfl_TextureCoordv);   // centre
			for (int i = 1; i <= 128; i++) {                             // full interior pairs
				if (i > n) break;
				vec2 off = float(i) * direction;
				sum += tap(openfl_TextureCoordv + off);
				sum += tap(openfl_TextureCoordv - off);
			}
			vec2 edge = float(n + 1) * direction;                        // fractional edges
			sum += tap(openfl_TextureCoordv + edge) * frac;
			sum += tap(openfl_TextureCoordv - edge) * frac;

			vec4 result = sum / fullSize;
			gl_FragColor = floor(result * 255.0) / 255.0;               // 8-bit round each pass

		}")
	public function new()
	{
		super();

		#if !macro
		uDir.value = [1.0, 0.0];
		uFullSize.value = [1.0];
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
