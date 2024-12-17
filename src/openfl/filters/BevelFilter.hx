package openfl.filters;

import haxe.Timer;
#if !flash
import openfl.display.BitmapData;
import openfl.display.DisplayObjectRenderer;
import openfl.display.Shader;
import openfl.display.ShaderInput;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.filters.BitmapFilterType;
#if lime
import lime._internal.graphics.ImageDataUtil; // TODO

#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.geom.Point)
@:access(openfl.geom.Rectangle)
@:access(openfl.filters.BlurFilter)
@:final class BevelFilter extends BitmapFilter
{
	@:noCompletion private var __bevelShader:BevelShader = new BevelShader();

	public var blurX(get, set):Float;

	public var blurY(get, set):Float;

	public var distance(get, set):Float;

	public var angle(get, set):Float;

	public var highlightColor(get, set):UInt;

	public var highlightAlpha(get, set):Float;

	public var shadowColor(get, set):UInt;

	public var shadowAlpha(get, set):Float;

	public var quality(get, set):Int;

	public var strength(get, set):Float;

	public var type(get, set):String;

	public var knockout(get, set):Bool;

	@:noCompletion private var __blurX:Float;
	@:noCompletion private var __blurY:Float;
	@:noCompletion private var __horizontalPasses:Int;
	@:noCompletion private var __quality:Int;
	@:noCompletion private var __verticalPasses:Int;
	@:noCompletion private var __angle:Float;
	@:noCompletion private var __distance:Float;
	@:noCompletion private var __highlightColor:UInt;
	@:noCompletion private var __highlightAlpha:Float;
	@:noCompletion private var __shadowColor:UInt;
	@:noCompletion private var __shadowAlpha:Float;
	@:noCompletion private var __strength:Float;
	@:noCompletion private var __type:String;
	@:noCompletion private var __knockout:Bool;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperties(BevelFilter.prototype, {
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
			"angle": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_angle (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_angle (v); }")
			},
			"distance": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_distance (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_distance (v); }")
			},
			"highlightColor": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_highlightColor (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_highlightColor (v); }")
			},
			"highlightAlpha": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_highlightAlpha (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_highlightAlpha (v); }")
			},
			"shadowColor": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_shadowColor (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_shadowColor (v); }")
			},
			"shadowAlpha": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_shadowAlpha (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_shadowAlpha (v); }")
			},
			"strength": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_strength (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_strength (v); }")
			},
			"type": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_type (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_type (v); }")
			},
			"knockout": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_knockout (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_knockout (v); }")
			}
		});
	}
	#end

	public function new(distance:Float = 4.0, angle:Float = 45, highlightColor:UInt = 0xFFFFFF, highlightAlpha:Float = 1.0, shadowColor:UInt = 0x000000, shadowAlpha:Float = 1.0, blurX:Float = 4.0, blurY:Float = 4.0, strength:Float = 1, quality:Int = 1, type:String = "inner", knockout:Bool = false)
	{
		super();
		this.distance = distance;
		this.angle = angle;
		this.highlightColor = highlightColor;
		this.highlightAlpha = highlightAlpha;
		this.shadowColor = shadowColor;
		this.shadowAlpha = shadowAlpha;	
		this.blurX = blurX;
		this.blurY = blurY;
		this.quality = quality;
		this.strength = strength;
		this.knockout = knockout;
		this.type = type;
	
		__updateSize();
	
		__needSecondBitmapData = true;
		__preserveObject = true;
		__renderDirty = true;
	}

	public override function clone():BitmapFilter
	{
		return new BevelFilter(__distance, __angle, __highlightColor, __highlightAlpha, __shadowColor, __shadowAlpha, __blurX, __blurY, __strength, __quality, __type, __knockout);
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
		var blurPass = pass;
		var numBlurPasses = __horizontalPasses + __verticalPasses;
		if (blurPass < numBlurPasses)
		{
			var shader = BlurFilter.__blurShader;
			if (pass < __horizontalPasses)
			{
				var scale = Math.pow(0.5, pass >> 1);
				shader.uRadius.value[0] = blurX * scale;
				shader.uRadius.value[1] = 0;
			}
			else
			{
				var scale = Math.pow(0.5, (pass - __horizontalPasses) >> 1);
				shader.uRadius.value[0] = 0;
				shader.uRadius.value[1] = blurY * scale;
			}
			return shader;
		}		
		
		__bevelShader.sourceBitmap.input = sourceBitmapData;

		#end

		return __bevelShader;
	}

	// Get & Set Methods
	@:noCompletion private function get_blurX():Float
	{
		return __blurX;
	}

	@:noCompletion private function set_blurX(value:Float):Float
	{
		value = value < 0 ? 0 : value;
		value = value > 255 ? 255 : value;		
		if (value != __blurX)
		{
			__blurX = value;
			__renderDirty = true;
			__updateSize();
		}
		return value;
	}

	@:noCompletion private function get_distance():Float
	{
		return __distance;
	}

	@:noCompletion private function set_distance(value:Float):Float
	{
		if (value != __distance)
		{
			__distance = value;
			__updateTransform();
			__updateSize();
			__renderDirty = true;
		}
		return value;
	}

	@:noCompletion private function get_angle():Float
	{
		return __angle;
	}

	@:noCompletion private function set_angle(value:Float):Float
	{
		if (value != __angle)
		{
			__angle = value;
			__updateTransform();
			__updateSize();
			__renderDirty = true;
		}
		return value;
	}

	@:noCompletion private function get_highlightColor():UInt
	{
		return __highlightColor;
	}

	@:noCompletion private function set_highlightColor(value:UInt):UInt
	{
		value = value > 0xFFFFFF ? 0xFFFFFF : value;
		if (value != __highlightColor)
		{
			__highlightColor = value;
			__updateColors();
			__renderDirty = true;
		}
		return value;
	}

	@:noCompletion private function get_highlightAlpha():Float
	{
		return __highlightAlpha;
	}

	@:noCompletion private function set_highlightAlpha(value:Float):Float
	{
		value = value < 0 ? 0 : value;
		value = value > 1 ? 1 : value;
		if (value != __highlightAlpha)
		{
			__highlightAlpha = value;
			__updateColors();
			__renderDirty = true;
		}
		return value;
	}

	@:noCompletion private function get_shadowColor():UInt
	{
		return __shadowColor;
	}

	@:noCompletion private function set_shadowColor(value:UInt):UInt
	{
		value = value > 0xFFFFFF ? 0xFFFFFF : value;
		if (value != __shadowColor)
		{
			__shadowColor = value;
			__updateColors();
			__renderDirty = true;
		}
		return value;
	}

	@:noCompletion private function get_shadowAlpha():Float
	{
		return __shadowAlpha;
	}

	@:noCompletion private function set_shadowAlpha(value:Float):Float
	{
		value = value < 0 ? 0 : value;
		value = value > 1 ? 1 : value;	
		if (value != __shadowAlpha)
		{
			__shadowAlpha = value;
			__updateColors();
			__renderDirty = true;
		}
		return value;
	}

	@:noCompletion private function get_blurY():Float
	{
		return __blurY;
	}

	@:noCompletion private function set_blurY(value:Float):Float
	{
		value = value < 0 ? 0 : value;
		value = value > 255 ? 255 : value;		
		if (value != __blurY)
		{
			__blurY = value;
			__renderDirty = true;
			__updateSize();
		}
		return value;
	}

	@:noCompletion private function get_quality():Int
	{
		return __quality;
	}

	@:noCompletion private function set_quality(value:Int):Int
	{
		value = value < 1 ? 1 : value;
		value = value > 15 ? 15 : value;
		
		__horizontalPasses = (__blurX <= 0) ? 0 : Math.round(__blurX * (value / 4));
		__verticalPasses = (__blurY <= 0) ? 0 : Math.round(__blurY * (value / 4));

		__numShaderPasses = __horizontalPasses + __verticalPasses + 1;

		if (value != __quality) __renderDirty = true;
		return __quality = value;
	}

	@:noCompletion private function get_strength():Float
	{
		return __strength;
	}

	@:noCompletion private function set_strength(value:Float):Float
	{
		if (value != __strength)
		{
			value = value > 255 ? 255 : value;
			value = value < 1 ? 1 : value;
			__strength = value;
			__bevelShader.uStrength.value[0] = __strength;
			__renderDirty = true;
		}
		return value;
	}

	@:noCompletion private function get_type():String
	{
		return __type;
	}

	@:noCompletion private function set_type(value:String):String
	{
		if (value != __type)
		{
		switch(value)
		{
			case "inner":
				__bevelShader.uBevelType.value[0] = 0.0;
			case "outer":
				__bevelShader.uBevelType.value[0] = 1.0;
			default:
				__bevelShader.uBevelType.value[0] = 2.0;
				value="full";
		}
			__type = value;
			__renderDirty = true;
		}
		return value;
	}

	@:noCompletion private function get_knockout():Bool
	{
		return __knockout;
	}

	@:noCompletion private function set_knockout(value:Bool):Bool
	{
		if (value != __knockout)
		{
			__knockout = value;
			__renderDirty = true;
		}

		__bevelShader.uKnockout.value[0] = value;
		return value;
	}

	@:noCompletion private function __updateTransform():Void
	{
		var rad:Float = __angle * Math.PI / 180;
		__bevelShader.uTransformX.value[0] = (__distance * Math.cos(rad));
		__bevelShader.uTransformY.value[0] = (__distance * Math.sin(rad));	
	}

	@:noCompletion private function __updateColors():Void
	{
			var r:UInt = (__highlightColor >> 16) & 0xFF;
			var g:UInt = (__highlightColor >> 8) & 0xFF;
			var b:UInt = __highlightColor & 0xFF;		
			__bevelShader.uLightColor.value[0] = (r / 255) * __highlightAlpha;
			__bevelShader.uLightColor.value[1] = (g / 255) * __highlightAlpha;
			__bevelShader.uLightColor.value[2] = (b / 255) * __highlightAlpha;
			__bevelShader.uLightColor.value[3] = __highlightAlpha;
		
			r = (__shadowColor >> 16) & 0xFF;
			g = (__shadowColor >> 8) & 0xFF;
			b = __shadowColor & 0xFF;		
			__bevelShader.uShadowColor.value[0] = (r / 255) * __shadowAlpha;
			__bevelShader.uShadowColor.value[1] = (g / 255) * __shadowAlpha;
			__bevelShader.uShadowColor.value[2] = (b / 255) * __shadowAlpha;
			__bevelShader.uShadowColor.value[3] = __shadowAlpha;
	}

	@:noCompletion private function __updateSize():Void
	{
		var offsetX:Int = __type!="inner" ? Math.ceil(__distance * Math.cos(__angle * Math.PI / 180)) : 0;
		var offsetY:Int = __type!="inner" ? Math.ceil(__distance * Math.sin(__angle * Math.PI / 180)) : 0;
		__topExtension = Math.ceil((offsetY < 0 ? -offsetY : 0) + __blurY);
		__bottomExtension = Math.ceil((offsetY > 0 ? offsetY : 0) + __blurY);
		__leftExtension = Math.ceil((offsetX < 0 ? -offsetX : 0) + __blurX);
		__rightExtension = Math.ceil((offsetX > 0 ? offsetX : 0) + __blurX);

	}
}

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
private class BevelShader extends BitmapFilterShader
{
	@:glFragmentSource("uniform sampler2D openfl_Texture;
		uniform sampler2D sourceBitmap;
		uniform vec4 uLightColor;
		uniform vec4 uShadowColor;
		uniform float uBevelType;
		uniform bool uKnockout;
		uniform float uStrength;
		varying vec2 vTextureCoord;
		varying vec2 vTransform;

		void main(void)
			{
				vec4 dest = texture2D(sourceBitmap, vTextureCoord);
				vec2 blurUVLeft = vec2(vTextureCoord + vTransform);
				vec2 blurUVRight = vec2(vTextureCoord - vTransform);
				float blurLeft = texture2D(openfl_Texture, blurUVLeft).a;
				float blurRight = texture2D(openfl_Texture, blurUVRight).a;

				if (blurUVLeft.x<0.0 || blurUVLeft.x>1.0 || blurUVLeft.y<0.0 || blurUVLeft.y>1.0)
				{
					blurLeft = 0.0;
				}
				if (blurUVRight.x<0.0 || blurUVRight.x>1.0 || blurUVRight.y<0.0 || blurUVRight.y>1.0)
				{
					blurRight = 0.0;
				}

				float highlightAlpha = clamp((blurLeft - blurRight) * uStrength, 0.0, 1.0);
				float shadowAlpha = clamp((blurRight - blurLeft) * uStrength, 0.0, 1.0);
				vec4 glow = uLightColor * highlightAlpha + uShadowColor * shadowAlpha;

				if (uBevelType == 0.0)
				{
					if (uKnockout)
					{
						gl_FragColor = glow * dest.a;
					}
					else
					{
						gl_FragColor = glow * dest.a + dest * (1.0 - glow.a);
					}
				}
				else
				if (uBevelType == 1.0)
				{
					if (uKnockout)
					{
						gl_FragColor = glow - glow * dest.a;
					}
					else
					{
						gl_FragColor = dest + glow - glow * dest.a;
					}
				}
				else
				{
					if (uKnockout)
					{
						gl_FragColor = glow;
					}
					else
					{
						gl_FragColor = dest - dest * glow.a + glow;
					}
				}
		}")
	@:glVertexSource("attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;
		uniform mat4 openfl_Matrix;
		uniform vec2 uTextureSize;
		uniform float uTransformX;
		uniform float uTransformY;
		uniform vec4 uLightColor;
		uniform vec4 uShadowColor;
		uniform float uBevelType;
		uniform bool uKnockout;
		uniform float uStrength;
		varying vec2 vTextureCoord;
		varying vec2 vTransform;

		void main(void)
			{
				gl_Position = openfl_Matrix * openfl_Position;
				vTextureCoord = openfl_TextureCoord;
				vTransform = vec2(uTransformX / uTextureSize.x, uTransformY / uTextureSize.y);
		}")
	
	public function new()
	{
		super();

		#if !macro
		uTransformX.value = [0];
		uTransformY.value = [0];
		uLightColor.value = [0, 0, 0, 0];
		uShadowColor.value = [0, 0, 0, 0];	
		uBevelType.value = [0.0];
		uKnockout.value = [false];
		uStrength.value = [1];
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
typedef BevelFilter = flash.filters.BevelFilter;
#end
