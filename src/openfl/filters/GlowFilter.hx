package openfl.filters;

#if !flash
import openfl.display.BitmapData;
import openfl.display.DisplayObjectRenderer;
import openfl.display.Shader;
import openfl.geom.ColorTransform;
import openfl.geom.Point;
import openfl.geom.Rectangle;
#if lime
import lime._internal.graphics.ImageDataUtil; // TODO

#end

/**
	The GlowFilter class lets you apply a glow effect to display objects. You
	have several options for the style of the glow, including inner or outer
	glow and knockout mode. The glow filter is similar to the drop shadow
	filter with the `distance` and `angle` properties of
	the drop shadow filter set to 0. You can apply the filter to any display
	object(that is, objects that inherit from the DisplayObject class), such
	as MovieClip, SimpleButton, TextField, and Video objects, as well as to
	BitmapData objects.

	The use of filters depends on the object to which you apply the
	filter:


	* To apply filters to display objects, use the `filters`
	property(inherited from DisplayObject). Setting the `filters`
	property of an object does not modify the object, and you can remove the
	filter by clearing the `filters` property.
	* To apply filters to BitmapData objects, use the
	`BitmapData.applyFilter()` method. Calling
	`applyFilter()` on a BitmapData object takes the source
	BitmapData object and the filter object and generates a filtered image as a
	result.


	If you apply a filter to a display object, the
	`cacheAsBitmap` property of the display object is set to
	`true`. If you clear all filters, the original value of
	`cacheAsBitmap` is restored.

	This filter supports Stage scaling. However, it does not support general
	scaling, rotation, and skewing. If the object itself is scaled(if
	`scaleX` and `scaleY` are set to a value other than
	1.0), the filter is not scaled. It is scaled only when the user zooms in on
	the Stage.

	A filter is not applied if the resulting image exceeds the maximum
	dimensions. In AIR 1.5 and Flash Player 10, the maximum is 8,191 pixels in
	width or height, and the total number of pixels cannot exceed 16,777,215
	pixels.(So, if an image is 8,191 pixels wide, it can only be 2,048 pixels
	high.) In Flash Player 9 and earlier and AIR 1.1 and earlier, the
	limitation is 2,880 pixels in height and 2,880 pixels in width. For
	example, if you zoom in on a large movie clip with a filter applied, the
	filter is turned off if the resulting image exceeds the maximum
	dimensions.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Point)
@:access(openfl.geom.Rectangle)
@:final class GlowFilter extends BitmapFilter
{
	@:noCompletion private static var __glowShader:GlowShader = new GlowShader();

	/**
		The alpha transparency value for the color. Valid values are 0 to 1. For
		example, .25 sets a transparency value of 25%. The default value is 1.
	**/
	public var alpha(get, set):Float;

	/**
		The amount of horizontal blur. Valid values are 0 to 255(floating point).
		The default value is 6. Values that are a power of 2(such as 2, 4, 8, 16,
		and 32) are optimized to render more quickly than other values.
	**/
	public var blurX(get, set):Float;

	/**
		The amount of vertical blur. Valid values are 0 to 255(floating point).
		The default value is 6. Values that are a power of 2(such as 2, 4, 8, 16,
		and 32) are optimized to render more quickly than other values.
	**/
	public var blurY(get, set):Float;

	/**
		The color of the glow. Valid values are in the hexadecimal format
		0x_RRGGBB_. The default value is 0xFF0000.
	**/
	public var color(get, set):Int;

	/**
		Specifies whether the glow is an inner glow. The value `true`
		indicates an inner glow. The default is `false`, an outer glow
		(a glow around the outer edges of the object).
	**/
	public var inner(get, set):Bool;

	/**
		Specifies whether the object has a knockout effect. A value of
		`true` makes the object's fill transparent and reveals the
		background color of the document. The default value is `false`
		(no knockout effect).
	**/
	public var knockout(get, set):Bool;

	/**
		The number of times to apply the filter. The default value is
		`BitmapFilterQuality.LOW`, which is equivalent to applying the
		filter once. The value `BitmapFilterQuality.MEDIUM` applies the
		filter twice; the value `BitmapFilterQuality.HIGH` applies it
		three times. Filters with lower values are rendered more quickly.

		For most applications, a `quality` value of low, medium, or
		high is sufficient. Although you can use additional numeric values up to
		15 to achieve different effects, higher values are rendered more slowly.
		Instead of increasing the value of `quality`, you can often get
		a similar effect, and with faster rendering, by simply increasing the
		values of the `blurX` and `blurY` properties.
	**/
	public var quality(get, set):Int;

	/**
		The strength of the imprint or spread. The higher the value, the more
		color is imprinted and the stronger the contrast between the glow and the
		background. Valid values are 0 to 255. The default is 2.
	**/
	public var strength(get, set):Float;

	@:noCompletion private var __alpha:Float;
	@:noCompletion private var __blurX:Float;
	@:noCompletion private var __blurY:Float;
	@:noCompletion private var __color:Int;
	@:noCompletion private var __horizontalPasses:Int;
	@:noCompletion private var __inner:Bool;
	@:noCompletion private var __knockout:Bool;
	@:noCompletion private var __quality:Int;
	@:noCompletion private var __strength:Float;
	@:noCompletion private var __verticalPasses:Int;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperties(GlowFilter.prototype, {
			"alpha": {get: untyped __js__("function () { return this.get_alpha (); }"), set: untyped __js__("function (v) { return this.set_alpha (v); }")},
			"blurX": {get: untyped __js__("function () { return this.get_blurX (); }"), set: untyped __js__("function (v) { return this.set_blurX (v); }")},
			"blurY": {get: untyped __js__("function () { return this.get_blurY (); }"), set: untyped __js__("function (v) { return this.set_blurY (v); }")},
			"color": {get: untyped __js__("function () { return this.get_color (); }"), set: untyped __js__("function (v) { return this.set_color (v); }")},
			"inner": {get: untyped __js__("function () { return this.get_inner (); }"), set: untyped __js__("function (v) { return this.set_inner (v); }")},
			"knockout": {get: untyped __js__("function () { return this.get_knockout (); }"),
				set: untyped __js__("function (v) { return this.set_knockout (v); }")},
			"quality": {get: untyped __js__("function () { return this.get_quality (); }"),
				set: untyped __js__("function (v) { return this.set_quality (v); }")},
			"strength": {get: untyped __js__("function () { return this.get_strength (); }"),
				set: untyped __js__("function (v) { return this.set_strength (v); }")},
		});
	}
	#end

	/**
		Initializes a new GlowFilter instance with the specified parameters.

		@param color    The color of the glow, in the hexadecimal format
						0x_RRGGBB_. The default value is 0xFF0000.
		@param alpha    The alpha transparency value for the color. Valid values
						are 0 to 1. For example, .25 sets a transparency value of
						25%.
		@param blurX    The amount of horizontal blur. Valid values are 0 to 255
					   (floating point). Values that are a power of 2(such as 2,
						4, 8, 16 and 32) are optimized to render more quickly than
						other values.
		@param blurY    The amount of vertical blur. Valid values are 0 to 255
					   (floating point). Values that are a power of 2(such as 2,
						4, 8, 16 and 32) are optimized to render more quickly than
						other values.
		@param strength The strength of the imprint or spread. The higher the
						value, the more color is imprinted and the stronger the
						contrast between the glow and the background. Valid values
						are 0 to 255.
		@param quality  The number of times to apply the filter. Use the
						BitmapFilterQuality constants:

						 * `BitmapFilterQuality.LOW`
						 * `BitmapFilterQuality.MEDIUM`
						 * `BitmapFilterQuality.HIGH`


						For more information, see the description of the
						`quality` property.
		@param inner    Specifies whether the glow is an inner glow. The value
						` true` specifies an inner glow. The value
						`false` specifies an outer glow(a glow around
						the outer edges of the object).
		@param knockout Specifies whether the object has a knockout effect. The
						value `true` makes the object's fill
						transparent and reveals the background color of the
						document.
	**/
	public function new(color:Int = 0xFF0000, alpha:Float = 1, blurX:Float = 6, blurY:Float = 6, strength:Float = 2, quality:Int = 1, inner:Bool = false,
			knockout:Bool = false)
	{
		super();

		__color = color;
		__alpha = alpha;
		this.blurX = blurX;
		this.blurY = blurY;
		__strength = strength;
		this.quality = quality;
		__inner = inner;
		__knockout = knockout;

		__needSecondBitmapData = true;
		__preserveObject = true;
		__renderDirty = true;
	}

	public override function clone():BitmapFilter
	{
		return new GlowFilter(__color, __alpha, __blurX, __blurY, __strength, __quality, __inner, __knockout);
	}

	@:noCompletion private override function __applyFilter(bitmapData:BitmapData, sourceBitmapData:BitmapData, sourceRect:Rectangle,
			destPoint:Point):BitmapData
	{
		// TODO: Support knockout, inner

		#if lime
		var r = (__color >> 16) & 0xFF;
		var g = (__color >> 8) & 0xFF;
		var b = __color & 0xFF;

		var finalImage = ImageDataUtil.gaussianBlur(bitmapData.image, sourceBitmapData.image, sourceRect.__toLimeRectangle(), destPoint.__toLimeVector2(),
			__blurX, __blurY, __quality, __strength);
		finalImage.colorTransform(finalImage.rect, new ColorTransform(0, 0, 0, __alpha, r, g, b, 0).__toLimeColorMatrix());

		if (finalImage == bitmapData.image) return bitmapData;
		#end
		return sourceBitmapData;
	}

	@:noCompletion private override function __initShader(renderer:DisplayObjectRenderer, pass:Int):Shader
	{
		#if !macro
		if (pass <= __horizontalPasses)
		{
			var scale = Math.pow(0.5, pass >> 1);
			__glowShader.uRadius.value[0] = blurX * scale;
			__glowShader.uRadius.value[1] = 0;
		}
		else
		{
			var scale = Math.pow(0.5, (pass - __horizontalPasses) >> 1);
			__glowShader.uRadius.value[0] = 0;
			__glowShader.uRadius.value[1] = blurY * scale;
		}

		__glowShader.uColor.value[0] = ((color >> 16) & 0xFF) / 255;
		__glowShader.uColor.value[1] = ((color >> 8) & 0xFF) / 255;
		__glowShader.uColor.value[2] = (color & 0xFF) / 255;
		__glowShader.uColor.value[3] = alpha * (__strength / __numShaderPasses);
		#end

		return __glowShader;
	}

	// Get & Set Methods
	@:noCompletion private function get_alpha():Float
	{
		return __alpha;
	}

	@:noCompletion private function set_alpha(value:Float):Float
	{
		if (value != __alpha) __renderDirty = true;
		return __alpha = value;
	}

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
			__leftExtension = (value > 0 ? Math.ceil(value * 1.5) : 0);
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
			__topExtension = (value > 0 ? Math.ceil(value * 1.5) : 0);
			__bottomExtension = __topExtension;
		}
		return value;
	}

	@:noCompletion private function get_color():Int
	{
		return __color;
	}

	@:noCompletion private function set_color(value:Int):Int
	{
		if (value != __color) __renderDirty = true;
		return __color = value;
	}

	@:noCompletion private function get_inner():Bool
	{
		return __inner;
	}

	@:noCompletion private function set_inner(value:Bool):Bool
	{
		if (value != __inner) __renderDirty = true;
		return __inner = value;
	}

	@:noCompletion private function get_knockout():Bool
	{
		return __knockout;
	}

	@:noCompletion private function set_knockout(value:Bool):Bool
	{
		if (value != __knockout) __renderDirty = true;
		return __knockout = value;
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

	@:noCompletion private function get_strength():Float
	{
		return __strength;
	}

	@:noCompletion private function set_strength(value:Float):Float
	{
		if (value != __strength) __renderDirty = true;
		return __strength = value;
	}
}

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
private class GlowShader extends BitmapFilterShader
{
	@:glFragmentSource("uniform sampler2D openfl_Texture;
		
		uniform vec4 uColor;
		
		varying vec2 vBlurCoords[7];
		
		void main(void) {
			
			float a = 0.0;
			a += texture2D(openfl_Texture, vBlurCoords[0]).a * 0.00443;
			a += texture2D(openfl_Texture, vBlurCoords[1]).a * 0.05399;
			a += texture2D(openfl_Texture, vBlurCoords[2]).a * 0.24197;
			a += texture2D(openfl_Texture, vBlurCoords[3]).a * 0.39894;
			a += texture2D(openfl_Texture, vBlurCoords[4]).a * 0.24197;
			a += texture2D(openfl_Texture, vBlurCoords[5]).a * 0.05399;
			a += texture2D(openfl_Texture, vBlurCoords[6]).a * 0.00443;
			a *= uColor.a;
			
			gl_FragColor = vec4(uColor.rgb * a, a);
			
		}")
	@:glVertexSource("attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;
		
		uniform mat4 openfl_Matrix;
		uniform vec2 openfl_TextureSize;
		
		uniform vec2 uRadius;
		varying vec2 vBlurCoords[7];
		
		void main(void) {
			
			gl_Position = openfl_Matrix * openfl_Position;
			
			vec2 r = uRadius / openfl_TextureSize;
			vBlurCoords[0] = openfl_TextureCoord - r * 1.0;
			vBlurCoords[1] = openfl_TextureCoord - r * 0.75;
			vBlurCoords[2] = openfl_TextureCoord - r * 0.5;
			vBlurCoords[3] = openfl_TextureCoord;
			vBlurCoords[4] = openfl_TextureCoord + r * 0.5;
			vBlurCoords[5] = openfl_TextureCoord + r * 0.75;
			vBlurCoords[6] = openfl_TextureCoord + r * 1.0;
			
		}")
	public function new()
	{
		super();

		#if !macro
		uRadius.value = [0, 0];
		uColor.value = [0, 0, 0, 0];
		#end
	}
}
#else
typedef GlowFilter = flash.filters.GlowFilter;
#end
