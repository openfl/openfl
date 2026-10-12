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
import lime._internal.graphics.ImageDataUtil;
#end

/**
	@see `openfl.display.DisplayObject.filters`
	@see `openfl.display.BitmapData.applyFilter`
**/
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

	@:noCompletion private var __blurX:Float = 0.0;
	@:noCompletion private var __blurY:Float = 0.0;
	@:noCompletion private var __horizontalPasses:Int = 0;
	@:noCompletion private var __quality:Int = 0;
	@:noCompletion private var __verticalPasses:Int = 0;
	@:noCompletion private var __angle:Float = 0.0;
	@:noCompletion private var __distance:Float = 0;
	@:noCompletion private var __highlightColor:UInt = 0x808080;
	@:noCompletion private var __highlightAlpha:Float = 0.0;
	@:noCompletion private var __shadowColor:UInt = 0x808080;
	@:noCompletion private var __shadowAlpha:Float = 0.0;
	@:noCompletion private var __strength:Float = 0;
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

	public function new(distance:Float = 4.0, angle:Float = 45, highlightColor:UInt = 0xFFFFFF, highlightAlpha:Float = 1.0, shadowColor:UInt = 0x000000,
			shadowAlpha:Float = 1.0, blurX:Float = 4.0, blurY:Float = 4.0, strength:Float = 1, quality:Int = 1, type:String = "inner", knockout:Bool = false)
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
		__softwareComposite = true;
		__renderDirty = true;
	}

	public override function clone():BitmapFilter
	{
		return new BevelFilter(__distance, __angle, __highlightColor, __highlightAlpha, __shadowColor, __shadowAlpha, __blurX, __blurY, __strength, __quality,
			__type, __knockout);
	}

	@:noCompletion private override function __applyFilter(bitmapData:BitmapData, sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point):BitmapData
	{
		var width = bitmapData.width;
		var height = bitmapData.height;

		// Same Shader: blur the source alpha, then compare the mask either side of the light direction.
		// The signed difference drives the highlight (light side) and the shadow (dark side).
		var mask = BitmapFilter.__alphaMask(sourceBitmapData, sourceRect, destPoint, width, height);
		BitmapFilter.__blurMask(mask, width, height, __blurX * __renderScale, __blurY * __renderScale, __quality);

		var rad = __angle * Math.PI / 180;
		// exact (fractional) step along the light angle, sampled bilinearly as the shader does
		var dx = __distance * Math.cos(rad) * __renderScale;
		var dy = __distance * Math.sin(rad) * __renderScale;

		// highlight / shadow colours, each channel premultiplied by its alpha
		// the same values the shader receives as uLightColor / uShadowColor
		var highlightR = (((__highlightColor >> 16) & 0xFF) / 255.0) * __highlightAlpha;
		var highlightG = (((__highlightColor >> 8) & 0xFF) / 255.0) * __highlightAlpha;
		var highlightB = ((__highlightColor & 0xFF) / 255.0) * __highlightAlpha;
		var shadowR = (((__shadowColor >> 16) & 0xFF) / 255.0) * __shadowAlpha;
		var shadowG = (((__shadowColor >> 8) & 0xFF) / 255.0) * __shadowAlpha;
		var shadowB = ((__shadowColor & 0xFF) / 255.0) * __shadowAlpha;

		var fxR = new Array<Float>(), fxG = new Array<Float>(), fxB = new Array<Float>(), fxA = new Array<Float>();
		for (y in 0...height)
		{
			for (x in 0...width)
			{
				// Sample the blurred mask a short way along the light angle in both
				// directions. Flash's `angle` is where the light comes from, so `+offset`
				// points the way a shadow falls and `-offset` points toward the light.
				// (called  blurLeft / blurRight in BevelShader)
				var maskTowardShadow = BitmapFilter.__maskAtFrac(mask, width, height, x + dx, y + dy);
				var maskTowardLight = BitmapFilter.__maskAtFrac(mask, width, height, x - dx, y - dy);
				var dist = (maskTowardShadow - maskTowardLight) * __strength;

				var highlight = dist > 1 ? 1.0 : (dist < 0 ? 0.0 : dist);
				var shadow = -dist > 1 ? 1.0 : (-dist < 0 ? 0.0 : -dist);

				fxR.push(highlightR * highlight + shadowR * shadow);
				fxG.push(highlightG * highlight + shadowG * shadow);
				fxB.push(highlightB * highlight + shadowB * shadow);
				fxA.push(__highlightAlpha * highlight + __shadowAlpha * shadow);
			}
		}

		var type:BitmapFilterType = (__type == "inner") ? INNER : ((__type == "outer") ? OUTER : FULL);
		return BitmapFilter.__compositeEffect(bitmapData, sourceBitmapData, sourceRect, destPoint, fxR, fxG, fxB, fxA, type, __knockout);
	}

	@:noCompletion private override function __initShader(renderer:DisplayObjectRenderer, pass:Int, sourceBitmapData:BitmapData):Shader
	{
		#if !macro
		var blurPass = pass;
		var numBlurPasses = __horizontalPasses + __verticalPasses;
		if (blurPass < numBlurPasses)
		{
			var horizontal = pass < __horizontalPasses;
			return BlurFilter.__setupBlurShader(horizontal, (horizontal ? blurX : blurY) * __renderScale);
		}

		// transform is scaled by __renderScale, which is not known until render time
		__updateTransform();
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

		__horizontalPasses = (__blurX <= 0) ? 0 : value;
		__verticalPasses = (__blurY <= 0) ? 0 : value;

		__numShaderPasses = __horizontalPasses + __verticalPasses + 1;

		if (value != __quality) __renderDirty = true;
		__quality = value;
		__updateSize(); // depends on filter's quality settings
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
			switch (value)
			{
				case "inner":
					__bevelShader.uBevelType.value[0] = 0.0;
				case "outer":
					__bevelShader.uBevelType.value[0] = 1.0;
				default:
					__bevelShader.uBevelType.value[0] = 2.0;
					value = "full";
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
		__bevelShader.uTransformX.value[0] = (__distance * Math.cos(rad)) * __renderScale;
		__bevelShader.uTransformY.value[0] = (__distance * Math.sin(rad)) * __renderScale;
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
		var offsetX:Int = __type != "inner" ? BitmapFilter.__offsetFloor(__distance * Math.cos(__angle * Math.PI / 180)) : 0;
		var offsetY:Int = __type != "inner" ? BitmapFilter.__offsetFloor(__distance * Math.sin(__angle * Math.PI / 180)) : 0;

		if (offsetX < 0) offsetX = -offsetX;
		if (offsetY < 0) offsetY = -offsetY;

		var exX = BlurFilter.__effectExtension(__blurX, __quality);
		var exY = BlurFilter.__effectExtension(__blurY, __quality);

		__leftExtension = __rightExtension = exX + offsetX;
		__topExtension = __bottomExtension = exY + offsetY;
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
