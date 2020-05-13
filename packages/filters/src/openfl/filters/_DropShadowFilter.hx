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
@:access(openfl.filters.GlowFilter)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Point)
@:access(openfl.geom.Rectangle)
@:noCompletion
class _DropShadowFilter extends _BitmapFilter
{
	private static var __hideShader = new HideShader();

	public var alpha(get, set):Float;
	public var angle(get, set):Float;
	public var blurX(get, set):Float;
	public var blurY(get, set):Float;
	public var color(get, set):Int;
	public var distance(get, set):Float;
	public var hideObject(get, set):Bool;
	public var inner(get, set):Bool;
	public var knockout(get, set):Bool;
	public var quality(get, set):Int;
	public var strength(get, set):Float;

	private var __alpha:Float;
	private var __angle:Float;
	private var __blurX:Float;
	private var __blurY:Float;
	private var __color:Int;
	private var __distance:Float;
	private var __hideObject:Bool;
	private var __horizontalPasses:Int;
	private var __inner:Bool;
	private var __knockout:Bool;
	private var __offsetX:Float;
	private var __offsetY:Float;
	private var __quality:Int;
	private var __strength:Float;
	private var __verticalPasses:Int;

	public function new(distance:Float = 4, angle:Float = 45, color:Int = 0, alpha:Float = 1, blurX:Float = 4, blurY:Float = 4, strength:Float = 1,
			quality:Int = 1, inner:Bool = false, knockout:Bool = false, hideObject:Bool = false)
	{
		super();

		__offsetX = 0;
		__offsetY = 0;

		__distance = distance;
		__angle = angle;
		__color = color;
		__alpha = alpha;
		__blurX = blurX;
		__blurY = blurY;
		__strength = strength;
		__quality = quality;
		__inner = inner;
		__knockout = knockout;
		__hideObject = hideObject;

		__updateSize();

		__needSecondBitmapData = true;
		__preserveObject = true;
		__renderDirty = true;
	}

	public override function clone():DropShadowFilter
	{
		return new DropShadowFilter(__distance, __angle, __color, __alpha, __blurX, __blurY, __strength, __quality, __inner, __knockout, __hideObject);
	}

	public override function __applyFilter(bitmapData:BitmapData, sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point):BitmapData
	{
		#if (lime || openfl_html5)
		// TODO: Support knockout, inner

		var r = (__color >> 16) & 0xFF;
		var g = (__color >> 8) & 0xFF;
		var b = __color & 0xFF;

		var point = new Point(destPoint.x + __offsetX, destPoint.y + __offsetY);

		var finalImage = ImageDataUtil.gaussianBlur(bitmapData.limeImage, sourceBitmapData.limeImage, sourceRect._.__toLimeRectangle(),
			point._.__toLimeVector2(), __blurX, __blurY, __quality, __strength);
		finalImage.colorTransform(finalImage.rect, new ColorTransform(0, 0, 0, __alpha, r, g, b, 0)._.__toLimeColorMatrix());

		if (finalImage == bitmapData.limeImage) return bitmapData;
		#end
		return sourceBitmapData;
	}

	public override function __initShader(renderer:DisplayObjectRenderer, pass:Int, sourceBitmapData:BitmapData):Shader
	{
		#if (!macro && openfl_gl)
		// Drop shadow is glow with an offset
		if (__inner && pass == 0)
		{
			return _GlowFilter.__invertAlphaShader;
		}

		var blurPass = pass - (__inner ? 1 : 0);
		var numBlurPasses = __horizontalPasses + __verticalPasses;

		if (blurPass < numBlurPasses)
		{
			var shader = _GlowFilter.__blurAlphaShader;
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
			if (__knockout || __hideObject)
			{
				var shader = _GlowFilter.__innerCombineKnockoutShader;
				shader.sourceBitmap.input = sourceBitmapData;
				shader.offset.value[0] = __offsetX;
				shader.offset.value[1] = __offsetY;
				return shader;
			}
			var shader = _GlowFilter.__innerCombineShader;
			shader.sourceBitmap.input = sourceBitmapData;
			shader.offset.value[0] = __offsetX;
			shader.offset.value[1] = __offsetY;
			return shader;
		}
		else
		{
			if (__knockout)
			{
				var shader = _GlowFilter.__combineKnockoutShader;
				shader.sourceBitmap.input = sourceBitmapData;
				shader.offset.value[0] = __offsetX;
				shader.offset.value[1] = __offsetY;
				return shader;
			}
			else if (__hideObject)
			{
				var shader = __hideShader;
				shader.sourceBitmap.input = sourceBitmapData;
				shader.offset.value[0] = __offsetX;
				shader.offset.value[1] = __offsetY;
				return shader;
			}
			var shader = _GlowFilter.__combineShader;
			shader.sourceBitmap.input = sourceBitmapData;
			shader.offset.value[0] = __offsetX;
			shader.offset.value[1] = __offsetY;
			return shader;
		}
		#else
		return null;
		#end
	}

	private function __updateSize():Void
	{
		__offsetX = Std.int(__distance * Math.cos(__angle * Math.PI / 180));
		__offsetY = Std.int(__distance * Math.sin(__angle * Math.PI / 180));
		__topExtension = Math.ceil((__offsetY < 0 ? -__offsetY : 0) + __blurY);
		__bottomExtension = Math.ceil((__offsetY > 0 ? __offsetY : 0) + __blurY);
		__leftExtension = Math.ceil((__offsetX < 0 ? -__offsetX : 0) + __blurX);
		__rightExtension = Math.ceil((__offsetX > 0 ? __offsetX : 0) + __blurX);
		__calculateNumShaderPasses();
	}

	private function __calculateNumShaderPasses():Void
	{
		__horizontalPasses = Math.round(__blurX * (__quality / 4)) + 1;
		__verticalPasses = Math.round(__blurY * (__quality / 4)) + 1;
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

	private function get_angle():Float
	{
		return __angle;
	}

	private function set_angle(value:Float):Float
	{
		if (value != __angle)
		{
			__angle = value;
			__renderDirty = true;
			__updateSize();
		}
		return value;
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

	private function get_distance():Float
	{
		return __distance;
	}

	private function set_distance(value:Float):Float
	{
		if (value != __distance)
		{
			__distance = value;
			__renderDirty = true;
			__updateSize();
		}
		return value;
	}

	private function get_hideObject():Bool
	{
		return __hideObject;
	}

	private function set_hideObject(value:Bool):Bool
	{
		if (value != __hideObject)
		{
			__renderDirty = true;
		}
		return __hideObject = value;
	}

	private function get_inner():Bool
	{
		return __inner;
	}

	private function set_inner(value:Bool):Bool
	{
		if (value != __inner) __renderDirty = true;
		return __inner = value;
	}

	private function get_knockout():Bool
	{
		return __knockout;
	}

	private function set_knockout(value:Bool):Bool
	{
		if (value != __knockout) __renderDirty = true;
		return __knockout = value;
	}

	private function get_quality():Int
	{
		return __quality;
	}

	private function set_quality(value:Int):Int
	{
		if (value != __quality) __renderDirty = true;
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
private class HideShader extends BitmapFilterShader
{
	@:glFragmentSource("
		uniform sampler2D openfl_Texture;
		uniform sampler2D sourceBitmap;
		varying vec4 textureCoords;

		void main(void) {
			gl_FragColor = texture2D(openfl_Texture, textureCoords.zw);
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
