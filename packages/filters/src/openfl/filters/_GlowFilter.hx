package openfl.filters;

import openfl.display.BitmapData;
import openfl.display.DisplayObjectRenderer;
import openfl.display.Shader;
import openfl.geom.ColorTransform;
import openfl.geom.Point;
import openfl.geom.Rectangle;
#if lime
import lime._internal.graphics.ImageDataUtil;
#else
import openfl._internal.backend.lime_standalone.ImageDataUtil;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _GlowFilter extends _BitmapFilter
{
	public static var __invertAlphaShader = new InvertAlphaShader();
	public static var __blurAlphaShader = new BlurAlphaShader();
	public static var __combineShader = new CombineShader();
	public static var __innerCombineShader = new InnerCombineShader();
	public static var __combineKnockoutShader = new CombineKnockoutShader();
	public static var __innerCombineKnockoutShader = new InnerCombineKnockoutShader();

	public var alpha(get, set):Float;
	public var blurX(get, set):Float;
	public var blurY(get, set):Float;
	public var color(get, set):Int;
	public var inner(get, set):Bool;
	public var knockout(get, set):Bool;
	public var quality(get, set):Int;
	public var strength(get, set):Float;

	private var __alpha:Float;
	private var __blurX:Float;
	private var __blurY:Float;
	private var __color:Int;
	private var __horizontalPasses:Int;
	private var __inner:Bool;
	private var __knockout:Bool;
	private var __quality:Int;
	private var __strength:Float;
	private var __verticalPasses:Int;

	private var glowFilter:GlowFilter;

	public function new(glowFilter:GlowFilter, color:Int = 0xFF0000, alpha:Float = 1, blurX:Float = 6, blurY:Float = 6, strength:Float = 2, quality:Int = 1,
			inner:Bool = false, knockout:Bool = false)
	{
		this.glowFilter = glowFilter;

		super(glowFilter);

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
		__renderDirty = true;
	}

	public override function clone():GlowFilter
	{
		return new GlowFilter(__color, __alpha, __blurX, __blurY, __strength, __quality, __inner, __knockout);
	}

	public override function __applyFilter(bitmapData:BitmapData, sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point):BitmapData
	{
		#if (lime || openfl_html5)
		// TODO: Support knockout, inner

		var r = (__color >> 16) & 0xFF;
		var g = (__color >> 8) & 0xFF;
		var b = __color & 0xFF;

		if (__inner || __knockout)
		{
			sourceBitmapData.limeImage.colorTransform(sourceBitmapData.limeImage.rect, new ColorTransform(1, 1, 1, 0, 0, 0, 0, -255)._.__toLimeColorMatrix());
			sourceBitmapData.limeImage.dirty = true;
			sourceBitmapData.limeImage.version++;
			bitmapData = sourceBitmapData.clone();
			return bitmapData;
		}

		var finalImage = ImageDataUtil.gaussianBlur(bitmapData.limeImage, sourceBitmapData.limeImage, sourceRect._.__toLimeRectangle(),
			destPoint._.__toLimeVector2(), __blurX, __blurY, __quality, __strength);
		finalImage.colorTransform(finalImage.rect, new ColorTransform(0, 0, 0, __alpha, r, g, b, 0)._.__toLimeColorMatrix());

		if (finalImage == bitmapData.limeImage) return bitmapData;
		#end
		return sourceBitmapData;
	}

	public override function __initShader(renderer:DisplayObjectRenderer, pass:Int, sourceBitmapData:BitmapData):Shader
	{
		#if (!macro && openfl_gl)
		// First pass of inner glow is invert alpha
		if (__inner && pass == 0)
		{
			return __invertAlphaShader;
		}

		var blurPass = pass - (__inner ? 1 : 0);
		var numBlurPasses = __horizontalPasses + __verticalPasses;

		if (blurPass < numBlurPasses)
		{
			var shader = __blurAlphaShader;
			if (blurPass < __horizontalPasses)
			{
				var scale = Math.pow(0.5, blurPass >> 1) * 0.5;
				shader.uRadius.value[0] = blurX * scale;
				shader.uRadius.value[1] = 0;
			}
			else
			{
				var scale = Math.pow(0.5, (blurPass - __horizontalPasses) >> 1) * 0.5;
				shader.uRadius.value[0] = 0;
				shader.uRadius.value[1] = blurY * scale;
			}
			shader.uColor.value[0] = ((color >> 16) & 0xFF) / 255;
			shader.uColor.value[1] = ((color >> 8) & 0xFF) / 255;
			shader.uColor.value[2] = (color & 0xFF) / 255;
			shader.uColor.value[3] = alpha;
			shader.uStrength.value[0] = blurPass == (numBlurPasses - 1) ? __strength : 1.0;
			return shader;
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

	private function __updateSize():Void
	{
		__leftExtension = (__blurX > 0 ? Math.ceil(__blurX * 1.5) : 0);
		__rightExtension = __leftExtension;
		__topExtension = (__blurY > 0 ? Math.ceil(__blurY * 1.5) : 0);
		__bottomExtension = __topExtension;
		__calculateNumShaderPasses();
	}

	private function __calculateNumShaderPasses():Void
	{
		__horizontalPasses = (__blurX <= 0) ? 0 : Math.round(__blurX * (__quality / 4)) + 1;
		__verticalPasses = (__blurY <= 0) ? 0 : Math.round(__blurY * (__quality / 4)) + 1;
		__numShaderPasses = __horizontalPasses + __verticalPasses + (__inner ? 2 : 1);
	}

	// Get & Set Methods

	private function get_alpha():Float
	{
		return __alpha;
	}

	private function set_alpha(value:Float):Float
	{
		if (value != __alpha) __renderDirty = true;
		return __alpha = value;
	}

	private function get_blurX():Float
	{
		return __blurX;
	}

	private function set_blurX(value:Float):Float
	{
		if (value != __blurX)
		{
			__blurX = value;
			__renderDirty = true;
			__updateSize();
		}
		return value;
	}

	private function get_blurY():Float
	{
		return __blurY;
	}

	private function set_blurY(value:Float):Float
	{
		if (value != __blurY)
		{
			__blurY = value;
			__renderDirty = true;
			__updateSize();
		}
		return value;
	}

	private function get_color():Int
	{
		return __color;
	}

	private function set_color(value:Int):Int
	{
		if (value != __color) __renderDirty = true;
		return __color = value;
	}

	private function get_inner():Bool
	{
		return __inner;
	}

	private function set_inner(value:Bool):Bool
	{
		if (value != __inner)
		{
			__renderDirty = true;
			__calculateNumShaderPasses();
		}
		return __inner = value;
	}

	private function get_knockout():Bool
	{
		return __knockout;
	}

	private function set_knockout(value:Bool):Bool
	{
		if (value != __knockout)
		{
			__renderDirty = true;
			__calculateNumShaderPasses();
		}
		return __knockout = value;
	}

	private function get_quality():Int
	{
		return __quality;
	}

	private function set_quality(value:Int):Int
	{
		if (value != __quality)
		{
			__renderDirty = true;
			__calculateNumShaderPasses();
		}
		return __quality = value;
	}

	private function get_strength():Float
	{
		return __strength;
	}

	private function set_strength(value:Float):Float
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
private class BlurAlphaShader extends BitmapFilterShader
{
	@:glFragmentSource("
		uniform sampler2D openfl_Texture;
		uniform vec4 uColor;
		uniform float uStrength;
		varying vec2 vTexCoord;
		varying vec2 vBlurCoords[6];

		void main(void)
		{
            vec4 texel = texture2D(openfl_Texture, vTexCoord);

            vec3 contributions = vec3(0.00443, 0.05399, 0.24197);
            vec3 top = vec3(
                texture2D(openfl_Texture, vBlurCoords[0]).a,
                texture2D(openfl_Texture, vBlurCoords[1]).a,
                texture2D(openfl_Texture, vBlurCoords[2]).a
            );
            vec3 bottom = vec3(
                texture2D(openfl_Texture, vBlurCoords[3]).a,
                texture2D(openfl_Texture, vBlurCoords[4]).a,
                texture2D(openfl_Texture, vBlurCoords[5]).a
            );

            float a = texel.a * 0.39894;
			a += dot(top, contributions.xyz);
            a += dot(bottom, contributions.zyx);

			gl_FragColor = uColor * clamp(a * uStrength, 0.0, 1.0);
		}
	")
	@:glVertexSource("
		attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;

		uniform mat4 openfl_Matrix;
		uniform vec2 openfl_TextureSize;

		uniform vec2 uRadius;
		varying vec2 vTexCoord;
		varying vec2 vBlurCoords[6];

		void main(void) {

			gl_Position = openfl_Matrix * openfl_Position;
			vTexCoord = openfl_TextureCoord;

			vec3 offset = vec3(0.5, 0.75, 1.0);
			vec2 r = uRadius / openfl_TextureSize;
			vBlurCoords[0] = openfl_TextureCoord - r * offset.z;
			vBlurCoords[1] = openfl_TextureCoord - r * offset.y;
			vBlurCoords[2] = openfl_TextureCoord - r * offset.x;
			vBlurCoords[3] = openfl_TextureCoord + r * offset.x;
			vBlurCoords[4] = openfl_TextureCoord + r * offset.y;
			vBlurCoords[5] = openfl_TextureCoord + r * offset.z;
		}
	")
	public function new()
	{
		super();
		#if (!macro && openfl_gl)
		uRadius.value = [0, 0];
		uColor.value = [0, 0, 0, 0];
		uStrength.value = [1];
		#end
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
			vec4 glow = texture2D(openfl_Texture, textureCoords.zw);

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
		#if (!macro && openfl_gl)
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
		#if (!macro && openfl_gl)
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
			vec4 glow = texture2D(openfl_Texture, textureCoords.zw);

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
		#if (!macro && openfl_gl)
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
		#if (!macro && openfl_gl)
		offset.value = [0, 0];
		#end
	}
}
