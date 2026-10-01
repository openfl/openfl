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
	object (that is, objects that inherit from the DisplayObject class), such
	as MovieClip, SimpleButton, TextField, and Video objects, as well as to
	BitmapData objects.

	The use of filters depends on the object to which you apply the
	filter:

	* To apply filters to display objects, use the `filters`
	property (inherited from DisplayObject). Setting the `filters`
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
	scaling, rotation, and skewing. If the object itself is scaled (if
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

	@see `openfl.display.DisplayObject.filters`
	@see `openfl.display.BitmapData.applyFilter`
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Point)
@:access(openfl.geom.Rectangle)
@:access(openfl.filters.BlurFilter)
@:final class GlowFilter extends BitmapFilter
{
	@:noCompletion private static var __invertAlphaShader = new InvertAlphaShader();
	@:noCompletion private static var __blurAlphaShader = new BoxBlurAlphaShader();
	@:noCompletion private static var __combineShader = new CombineShader();
	@:noCompletion private static var __innerCombineShader = new InnerCombineShader();
	@:noCompletion private static var __combineKnockoutShader = new CombineKnockoutShader();
	@:noCompletion private static var __innerCombineKnockoutShader = new InnerCombineKnockoutShader();

	/**
		The alpha transparency value for the color. Valid values are 0 to 1. For
		example, .25 sets a transparency value of 25%. The default value is 1.
	**/
	public var alpha(get, set):Float;

	/**
		The amount of horizontal blur. Valid values are 0 to 255 (floating point).
		The default value is 6. Values that are a power of 2 (such as 2, 4, 8, 16,
		and 32) are optimized to render more quickly than other values.
	**/
	public var blurX(get, set):Float;

	/**
		The amount of vertical blur. Valid values are 0 to 255 (floating point).
		The default value is 6. Values that are a power of 2 (such as 2, 4, 8, 16,
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
			"alpha": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_alpha (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_alpha (v); }")
			},
			"blurX": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_blurX (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_blurX (v); }")
			},
			"blurY": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_blurY (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_blurY (v); }")
			},
			"color": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_color (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_color (v); }")
			},
			"inner": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_inner (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_inner (v); }")
			},
			"knockout": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_knockout (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_knockout (v); }")
			},
			"quality": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_quality (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_quality (v); }")
			},
			"strength": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_strength (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_strength (v); }")
			},
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
					   (floating point). Values that are a power of 2 (such as 2,
						4, 8, 16 and 32) are optimized to render more quickly than
						other values.
		@param blurY    The amount of vertical blur. Valid values are 0 to 255
					   (floating point). Values that are a power of 2 (such as 2,
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
						`false` specifies an outer glow (a glow around
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
		__blurX = blurX;
		__blurY = blurY;
		__strength = strength;
		__inner = inner;
		__knockout = knockout;
		__quality = quality;

		__updateSize();

		__needSecondBitmapData = true;
		__preserveObject = true;
		__softwareComposite = true;
		__renderDirty = true;
	}

	public override function clone():BitmapFilter
	{
		return new GlowFilter(__color, __alpha, __blurX, __blurY, __strength, __quality, __inner, __knockout);
	}

	@:noCompletion private override function __applyFilter(bitmapData:BitmapData, sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point):BitmapData
	{
		var width = bitmapData.width;
		var height = bitmapData.height;

		// blur the source alpha into the glow's coverage mask, then colourise it
		var mask = BitmapFilter.__alphaMask(sourceBitmapData, sourceRect, destPoint, width, height);
		if (__inner)
		{
			for (i in 0...mask.length)
				mask[i] = 1 - mask[i];
		}
		BitmapFilter.__blurMask(mask, width, height, __blurX * __renderScale, __blurY * __renderScale, __quality);

		var colorR = (((__color >> 16) & 0xFF) / 255.0) * __alpha;
		var colorG = (((__color >> 8) & 0xFF) / 255.0) * __alpha;
		var colorB = ((__color & 0xFF) / 255.0) * __alpha;

		var fxR = new Array<Float>(), fxG = new Array<Float>(), fxB = new Array<Float>(), fxA = new Array<Float>();
		for (i in 0...width * height)
		{
			var glowCoverage = mask[i] * __strength;
			if (glowCoverage > 1) glowCoverage = 1;
			else if (glowCoverage < 0) glowCoverage = 0;
			fxR.push(colorR * glowCoverage);
			fxG.push(colorG * glowCoverage);
			fxB.push(colorB * glowCoverage);
			fxA.push(__alpha * glowCoverage);
		}

		return BitmapFilter.__compositeEffect(bitmapData, sourceBitmapData, sourceRect, destPoint, fxR, fxG, fxB, fxA, __inner ? INNER : OUTER, __knockout);
	}

	@:noCompletion private override function __initShader(renderer:DisplayObjectRenderer, pass:Int, sourceBitmapData:BitmapData):Shader
	{
		#if !macro
		// First pass of inner glow is invert alpha
		if (__inner && pass == 0)
		{
			return __invertAlphaShader;
		}

		var blurPass = pass - (__inner ? 1 : 0);
		var numBlurPasses = __horizontalPasses + __verticalPasses;

		if (blurPass < numBlurPasses)
		{
			//NOTE: strength and alpha only applied on last pass.
			var lastPass = blurPass == (numBlurPasses - 1);
			var strength = lastPass ? __strength : 1.0;
			var passAlpha = lastPass ? __alpha : 1.0;
			var horizontal = blurPass < __horizontalPasses;

			return __setupBlurAlphaShader(horizontal, (horizontal ? blurX : blurY) * __renderScale, color, passAlpha, strength);
		}
		if (__inner)
		{
			if (__knockout)
			{
				var shader = __innerCombineKnockoutShader;
				shader.sourceBitmap.input = sourceBitmapData;
				shader.offset.value[0] = 0.0;
				shader.offset.value[1] = 0.0;
				return shader;
			}
			var shader = __innerCombineShader;
			shader.sourceBitmap.input = sourceBitmapData;
			shader.offset.value[0] = 0.0;
			shader.offset.value[1] = 0.0;
			return shader;
		}
		else
		{
			if (__knockout)
			{
				var shader = __combineKnockoutShader;
				shader.sourceBitmap.input = sourceBitmapData;
				shader.offset.value[0] = 0.0;
				shader.offset.value[1] = 0.0;
				return shader;
			}
			var shader = __combineShader;
			shader.sourceBitmap.input = sourceBitmapData;
			shader.offset.value[0] = 0.0;
			shader.offset.value[1] = 0.0;
			return shader;
		}
		#else
		return null;
		#end
	}

	@:noCompletion private function __updateSize():Void
	{
		__leftExtension = __rightExtension = BlurFilter.__effectExtension(__blurX, __quality);
		__topExtension = __bottomExtension = BlurFilter.__effectExtension(__blurY, __quality);
		__calculateNumShaderPasses();
	}

	@:noCompletion private function __calculateNumShaderPasses():Void
	{
		// one horizontal + one vertical box pass per quality iteration
		var q = (__quality > 0) ? __quality : 1;
		__horizontalPasses = (__blurX <= 0) ? 0 : q;
		__verticalPasses = (__blurY <= 0) ? 0 : q;
		__numShaderPasses = __horizontalPasses + __verticalPasses + (__inner ? 2 : 1);
	}

	@:noCompletion private static function __setupBlurAlphaShader(horizontal:Bool, v:Float, color:Int, alpha:Float, strength:Float):BitmapFilterShader
	{
		var shader = __blurAlphaShader;
		shader.uDir.value[0] = horizontal ? 1.0 : 0.0;
		shader.uDir.value[1] = horizontal ? 0.0 : 1.0;

		shader.uFullSize.value[0] = v > 255 ? 255.0 : v;

		shader.uColor.value[0] = (((color >> 16) & 0xFF) / 255) * alpha;
		shader.uColor.value[1] = (((color >> 8) & 0xFF) / 255) * alpha;
		shader.uColor.value[2] = ((color & 0xFF) / 255) * alpha;
		shader.uColor.value[3] = alpha;

		shader.uStrength.value[0] = strength;
		return shader;
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
			__updateSize();
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
			__updateSize();
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
		if (value != __inner)
		{
			__renderDirty = true;
			__calculateNumShaderPasses();
		}
		return __inner = value;
	}

	@:noCompletion private function get_knockout():Bool
	{
		return __knockout;
	}

	@:noCompletion private function set_knockout(value:Bool):Bool
	{
		if (value != __knockout)
		{
			__renderDirty = true;
			__calculateNumShaderPasses();
		}
		return __knockout = value;
	}

	@:noCompletion private function get_quality():Int
	{
		return __quality;
	}

	@:noCompletion private function set_quality(value:Int):Int
	{
		if (value != __quality)
		{
			__renderDirty = true;
			__quality = value;
			__updateSize(); // quality affects the size
		}
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
private class InvertAlphaShader extends BitmapFilterShader
{
	@:glFragmentSource("
		uniform sampler2D openfl_Texture;
		varying vec2 vTexCoord;

		void main(void) {
			vec4 texel = texture2D(openfl_Texture, vTexCoord);
			gl_FragColor = vec4(texel.rgb, 1.0 - texel.a);
		}
	")
	@:glVertexSource("
		attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;
		uniform mat4 openfl_Matrix;
		varying vec2 vTexCoord;

		void main(void) {
			gl_Position = openfl_Matrix * openfl_Position;
			vTexCoord = openfl_TextureCoord;
		}
	")
	public function new()
	{
		super();
	}
}

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
private class BoxBlurAlphaShader extends BitmapFilterShader
{
	@:glFragmentSource("#pragma header

		uniform vec4 uColor;
		uniform float uStrength;
		uniform vec2 uTextureSize;
		uniform vec2 uDir;          // blur axis: (1,0) horizontal, (0,1) vertical
		uniform float uFullSize;    // box width = the blur amount

		// Beyond the bitmap there is nothing (Flash pads with transparent), so
		// samples outside it must read 0 -- the texture would otherwise clamp
		// and repeat its edge pixel into the blur.
		float tapA(vec2 uv) {
			if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) return 0.0;
			return texture2D(openfl_Texture, uv).a;
		}

		void main(void)
		{
			vec2 direction = uDir / uTextureSize;
			float fullSize = min(uFullSize, 255.0);
			float a;

			if (fullSize <= 1.0) {
				a = texture2D(openfl_Texture, openfl_TextureCoordv).a;
			} else {
				float halfW = fullSize * 0.5;
				int   n     = int(floor(halfW - 0.5));
				float frac  = halfW - (float(n) + 0.5);
				frac = floor(frac * 255.0) / 255.0;

				float sum = tapA(openfl_TextureCoordv);   // centre
				for (int i = 1; i <= 128; i++) {                                // full interior
					if (i > n) break;
					vec2 off = float(i) * direction;
					sum += tapA(openfl_TextureCoordv + off);
					sum += tapA(openfl_TextureCoordv - off);
				}
				vec2 edge = float(n + 1) * direction;                          // fractional edges
				sum += tapA(openfl_TextureCoordv + edge) * frac;
				sum += tapA(openfl_TextureCoordv - edge) * frac;

				a = sum / fullSize;
			}

			gl_FragColor = uColor * clamp(a * uStrength, 0.0, 1.0);
		}")
	@:glVertexSource("#pragma header

		void main(void) {

			#pragma body

		}")
	public function new()
	{
		super();
		#if !macro
		uColor.value = [0, 0, 0, 0];
		uStrength.value = [1];
		uDir.value = [1, 0];
		uFullSize.value = [1];
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

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
private class CombineShader extends BitmapFilterShader
{
	@:glFragmentSource("
		uniform sampler2D openfl_Texture;
		uniform sampler2D sourceBitmap;
		varying vec4 textureCoords;

		void main(void) {
			vec4 src = texture2D(sourceBitmap, textureCoords.xy);
			vec2 glowUV = textureCoords.zw;
			// the shifted read can leave the bitmap; there is nothing there
			vec4 glow = (glowUV.x < 0.0 || glowUV.x > 1.0 || glowUV.y < 0.0 || glowUV.y > 1.0) ? vec4(0.0) : texture2D(openfl_Texture, glowUV);

			gl_FragColor = src + glow * (1.0 - src.a);
		}
	")
	@:glVertexSource("attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;
		uniform mat4 openfl_Matrix;
		uniform vec2 openfl_TextureSize;
		uniform vec2 offset;
		varying vec4 textureCoords;

		void main(void) {
			gl_Position = openfl_Matrix * openfl_Position;
			textureCoords = vec4(openfl_TextureCoord, openfl_TextureCoord - offset / openfl_TextureSize);
		}
	")
	public function new()
	{
		super();
		#if !macro
		offset.value = [0, 0];
		#end
	}
}

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
private class InnerCombineShader extends BitmapFilterShader
{
	@:glFragmentSource("
		uniform sampler2D openfl_Texture;
		uniform sampler2D sourceBitmap;
		varying vec4 textureCoords;

		void main(void) {
			vec4 src = texture2D(sourceBitmap, textureCoords.xy);
			vec4 glow = texture2D(openfl_Texture, textureCoords.zw);

			gl_FragColor = vec4((src.rgb * (1.0 - glow.a)) + (glow.rgb * src.a), src.a);
		}
	")
	@:glVertexSource("attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;
		uniform mat4 openfl_Matrix;
		uniform vec2 openfl_TextureSize;
		uniform vec2 offset;
		varying vec4 textureCoords;

		void main(void) {
			gl_Position = openfl_Matrix * openfl_Position;
			textureCoords = vec4(openfl_TextureCoord, openfl_TextureCoord - offset / openfl_TextureSize);
		}
	")
	public function new()
	{
		super();
		#if !macro
		offset.value = [0, 0];
		#end
	}
}

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
private class CombineKnockoutShader extends BitmapFilterShader
{
	@:glFragmentSource("
		uniform sampler2D openfl_Texture;
		uniform sampler2D sourceBitmap;
		varying vec4 textureCoords;

		void main(void) {
			vec4 src = texture2D(sourceBitmap, textureCoords.xy);
			vec2 glowUV = textureCoords.zw;
			// the shifted read can leave the bitmap; there is nothing there
			vec4 glow = (glowUV.x < 0.0 || glowUV.x > 1.0 || glowUV.y < 0.0 || glowUV.y > 1.0) ? vec4(0.0) : texture2D(openfl_Texture, glowUV);

			gl_FragColor = glow * (1.0 - src.a);
		}
	")
	@:glVertexSource("attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;
		uniform mat4 openfl_Matrix;
		uniform vec2 openfl_TextureSize;
		uniform vec2 offset;
		varying vec4 textureCoords;

		void main(void) {
			gl_Position = openfl_Matrix * openfl_Position;
			textureCoords = vec4(openfl_TextureCoord, openfl_TextureCoord - offset / openfl_TextureSize);
		}
	")
	public function new()
	{
		super();
		#if !macro
		offset.value = [0, 0];
		#end
	}
}

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
private class InnerCombineKnockoutShader extends BitmapFilterShader
{
	@:glFragmentSource("
		uniform sampler2D openfl_Texture;
		uniform sampler2D sourceBitmap;
		varying vec4 textureCoords;

		void main(void) {
			vec4 src = texture2D(sourceBitmap, textureCoords.xy);
			vec4 glow = texture2D(openfl_Texture, textureCoords.zw);

			gl_FragColor = glow * src.a;
		}
	")
	@:glVertexSource("attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;
		uniform mat4 openfl_Matrix;
		uniform vec2 openfl_TextureSize;
		uniform vec2 offset;
		varying vec4 textureCoords;

		void main(void) {
			gl_Position = openfl_Matrix * openfl_Position;
			textureCoords = vec4(openfl_TextureCoord, openfl_TextureCoord - offset / openfl_TextureSize);
		}
	")
	public function new()
	{
		super();
		#if !macro
		offset.value = [0, 0];
		#end
	}
}
#else
typedef GlowFilter = flash.filters.GlowFilter;
#end
