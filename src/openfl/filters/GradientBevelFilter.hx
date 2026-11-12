package openfl.filters;

#if !flash
import openfl.display.BitmapData;
import openfl.display.DisplayObjectRenderer;
import openfl.display.Shader;
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
	The GradientBevelFilter class lets you apply a gradient bevel effect to display objects.
	The bevel's colours come from a gradient defined by `colors`/`alphas`/`ratios` instead of separate highlight/shadow colours.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.filters.BlurFilter)
@:access(openfl.geom.Point)
@:access(openfl.geom.Rectangle)
@:final class GradientBevelFilter extends BitmapFilter
{
	@:noCompletion private static var __gradientShader = new GradientBevelShader();

	public var distance(get, set):Float;
	public var angle(get, set):Float;
	public var colors(get, set):Array<Int>;
	public var alphas(get, set):Array<Float>;
	public var ratios(get, set):Array<Int>;
	public var blurX(get, set):Float;
	public var blurY(get, set):Float;
	public var strength(get, set):Float;
	public var quality(get, set):Int;
	public var type(get, set):BitmapFilterType;
	public var knockout(get, set):Bool;

	@:noCompletion private var __distance:Float;
	@:noCompletion private var __angle:Float;
	@:noCompletion private var __colors:Array<Int>;
	@:noCompletion private var __alphas:Array<Float>;
	@:noCompletion private var __ratios:Array<Int>;
	@:noCompletion private var __blurX:Float;
	@:noCompletion private var __blurY:Float;
	@:noCompletion private var __strength:Float;
	@:noCompletion private var __quality:Int;
	@:noCompletion private var __type:BitmapFilterType;
	@:noCompletion private var __knockout:Bool;
	@:noCompletion private var __horizontalPasses:Int;
	@:noCompletion private var __verticalPasses:Int;
	@:noCompletion private var __ramp:BitmapData;
	@:noCompletion private var __rampDirty:Bool;

	public function new(distance:Float = 4, angle:Float = 45, colors:Array<Int> = null, alphas:Array<Float> = null, ratios:Array<Int> = null,
			blurX:Float = 4, blurY:Float = 4, strength:Float = 1, quality:Int = 1, type:BitmapFilterType = INNER, knockout:Bool = false)
	{
		super();

		__distance = distance;
		__angle = angle;
		__colors = (colors != null) ? colors : [0xFFFFFF, 0x808080, 0x000000];
		__alphas = (alphas != null) ? alphas : [1, 0, 1];
		__ratios = (ratios != null) ? ratios : [0, 128, 255];
		__blurX = blurX;
		__blurY = blurY;
		__strength = strength;
		__quality = quality;
		__type = type;
		__knockout = knockout;
		__rampDirty = true;

		__needSecondBitmapData = true;
		__preserveObject = true;
		__softwareComposite = true;
		__renderDirty = true;

		__updateSize();
	}

	public override function clone():BitmapFilter
	{
		return new GradientBevelFilter(__distance, __angle, __colors.copy(), __alphas.copy(), __ratios.copy(), __blurX, __blurY, __strength, __quality,
			__type, __knockout);
	}

	@:noCompletion private override function __applyFilter(bitmapData:BitmapData, sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point):BitmapData
	{
		var width = bitmapData.width;
		var height = bitmapData.height;

		var mask = BitmapFilter.__alphaMask(sourceBitmapData, sourceRect, destPoint, width, height);
		BitmapFilter.__blurMask(mask, width, height, __blurX * __renderScale, __blurY * __renderScale, __quality);

		if (__rampDirty) __buildRamp();
		var ramp = __rampChannels();

		var rad = __angle * Math.PI / 180;
		// exact (fractional) step along the light angle, sampled bilinearly
		var offsetX = __distance * Math.cos(rad) * __renderScale;
		var offsetY = __distance * Math.sin(rad) * __renderScale;

		var fxR = new Array<Float>(), fxG = new Array<Float>(), fxB = new Array<Float>(), fxA = new Array<Float>();
		for (y in 0...height)
		{
			for (x in 0...width)
			{
				// mask sampled along the light angle: +offset is the way a shadow falls,
				// -offset points toward the light (Flash's `angle` is where light comes from)
				var maskTowardShadow = BitmapFilter.__maskAtFrac(mask, width, height, x + offsetX, y + offsetY);
				var maskTowardLight = BitmapFilter.__maskAtFrac(mask, width, height, x - offsetX, y - offsetY);
				// signed edge slope -> ramp index, as GradientBevelShader does: positive on
				// the edge facing the light, negative on the far edge, zero on flat areas.
				// -1 is one edge, 0 the (usually transparent) middle stop, +1 the other
				var edgeSlope = (maskTowardShadow - maskTowardLight) * __strength;
				if (edgeSlope > 1) edgeSlope = 1;
				else if (edgeSlope < -1) edgeSlope = -1;

				var i = Std.int((edgeSlope * 0.5 + 0.5) * 255 + 0.5) * 4;
				fxR.push(ramp[i]);
				fxG.push(ramp[i + 1]);
				fxB.push(ramp[i + 2]);
				fxA.push(ramp[i + 3]);
			}
		}

		return BitmapFilter.__compositeEffect(bitmapData, sourceBitmapData, sourceRect, destPoint, fxR, fxG, fxB, fxA, __type, __knockout);
	}

	@:noCompletion private function __rampChannels():Array<Float>
	{
		var out = new Array<Float>();
		var pixels = __ramp.getVector(__ramp.rect);
		for (i in 0...256)
		{
			var argb = pixels[i];
			var a = ((argb >>> 24) & 0xFF) / 255.0;
			out.push((((argb >> 16) & 0xFF) / 255.0) * a);
			out.push((((argb >> 8) & 0xFF) / 255.0) * a);
			out.push(((argb & 0xFF) / 255.0) * a);
			out.push(a);
		}
		return out;
	}

	@:noCompletion private override function __initShader(renderer:DisplayObjectRenderer, pass:Int, sourceBitmapData:BitmapData):Shader
	{
		#if !macro
		var numBlurPasses = __horizontalPasses + __verticalPasses;
		if (pass < numBlurPasses)
		{
			var horizontal = pass < __horizontalPasses;
			return BlurFilter.__setupBlurShader(horizontal, (horizontal ? __blurX : __blurY) * __renderScale);
		}

		if (__rampDirty) __buildRamp();

		var rad = __angle * Math.PI / 180;
		var shader = __gradientShader;
		shader.sourceBitmap.input = sourceBitmapData;
		shader.gradientRamp.input = __ramp;
		shader.uTransformX.value[0] = __distance * Math.cos(rad) * __renderScale;
		shader.uTransformY.value[0] = __distance * Math.sin(rad) * __renderScale;
		shader.uStrength.value[0] = __strength;
		shader.uBevelType.value[0] = (__type == INNER) ? 0.0 : (__type == OUTER ? 1.0 : 2.0);
		shader.uKnockout.value[0] = __knockout;
		return shader;
		#else
		return null;
		#end
	}

	// 256-entry straight-ARGB gradient ramp (one texel per output index 0..255) from the (colors, alphas, ratios).
	// Each index is the colour and alpha linearly interpolated between the two stops it falls between.
	@:noCompletion private function __buildRamp():Void
	{
		if (__ramp == null) __ramp = new BitmapData(256, 1, true, 0);
		var stopCount = __colors.length;
		var stop = 0; // the stop at or just before the current ramp index

		for (index in 0...256)
		{
			// advance to the stop pair whose ratio range contains `index`
			while (stop < stopCount - 1 && __ratios[stop + 1] < index) stop++;

			var colorLo = __colors[stop];
			var alphaLo = __alphas[stop];
			var r:Float, g:Float, b:Float, a:Float;

			if (stop >= stopCount - 1 || index <= __ratios[stop])
			{
				// before the first stop, or past the last one: hold this stop's colour flat
				r = (colorLo >> 16) & 0xFF;
				g = (colorLo >> 8) & 0xFF;
				b = colorLo & 0xFF;
				a = alphaLo * 255;
			}
			else
			{
				var ratioLo = __ratios[stop];
				var ratioHi = __ratios[stop + 1];
				var colorHi = __colors[stop + 1];
				var alphaHi = __alphas[stop + 1];

				// blend = how far `index` sits between the two stops (0 at the low stop, 1 at the high stop)
				var blend = (ratioHi > ratioLo) ? (index - ratioLo) / (ratioHi - ratioLo) : 0.0;

				r = lerp((colorLo >> 16) & 0xFF, (colorHi >> 16) & 0xFF, blend);
				g = lerp((colorLo >> 8) & 0xFF, (colorHi >> 8) & 0xFF, blend);
				b = lerp(colorLo & 0xFF, colorHi & 0xFF, blend);
				a = lerp(alphaLo, alphaHi, blend) * 255;
			}

			var argb = (Std.int(a) << 24) | (Std.int(r) << 16) | (Std.int(g) << 8) | Std.int(b);
			__ramp.setPixel32(index, 0, argb);
		}
		__rampDirty = false;
	}

	@:noCompletion private static inline function lerp(a:Float, b:Float, t:Float):Float
	{
		return a + (b - a) * t;
	}

	@:noCompletion private function __updateSize():Void
	{
		// blur growth plus the floored offset on every side.
		// Visible here because the ramp's middle stop is painted flat out to these bounds.
		var rad = __angle * Math.PI / 180;

		var offsetX:Int = (__type != INNER) ? BitmapFilter.__offsetFloor(__distance * Math.cos(rad)) : 0;
		var offsetY:Int = (__type != INNER) ? BitmapFilter.__offsetFloor(__distance * Math.sin(rad)) : 0;

		if (offsetX < 0) offsetX = -offsetX;
		if (offsetY < 0) offsetY = -offsetY;

		var exX = BlurFilter.__effectExtension(__blurX, __quality);
		var exY = BlurFilter.__effectExtension(__blurY, __quality);

		__leftExtension = __rightExtension = exX + offsetX;
		__topExtension = __bottomExtension = exY + offsetY;

		var q = (__quality > 0) ? __quality : 1;
		__horizontalPasses = (__blurX <= 0) ? 0 : q;
		__verticalPasses = (__blurY <= 0) ? 0 : q;
		__numShaderPasses = __horizontalPasses + __verticalPasses + 1;
	}

	// Getters / setters
	@:noCompletion private function get_distance():Float return __distance;

	@:noCompletion private function set_distance(v:Float):Float
	{
		if (v != __distance) { __distance = v; __updateSize(); __renderDirty = true; }
		return v;
	}

	@:noCompletion private function get_angle():Float return __angle;

	@:noCompletion private function set_angle(v:Float):Float
	{
		if (v != __angle) { __angle = v; __renderDirty = true; }
		return v;
	}

	@:noCompletion private function get_colors():Array<Int> return __colors;

	@:noCompletion private function set_colors(v:Array<Int>):Array<Int>
	{
		__colors = v; __rampDirty = true; __renderDirty = true;
		return v;
	}

	@:noCompletion private function get_alphas():Array<Float> return __alphas;

	@:noCompletion private function set_alphas(v:Array<Float>):Array<Float>
	{
		__alphas = v; __rampDirty = true; __renderDirty = true;
		return v;
	}

	@:noCompletion private function get_ratios():Array<Int> return __ratios;

	@:noCompletion private function set_ratios(v:Array<Int>):Array<Int>
	{
		__ratios = v; __rampDirty = true; __renderDirty = true;
		return v;
	}

	@:noCompletion private function get_blurX():Float return __blurX;

	@:noCompletion private function set_blurX(v:Float):Float
	{
		if (v != __blurX) { __blurX = v; __updateSize(); __renderDirty = true; }
		return v;
	}

	@:noCompletion private function get_blurY():Float return __blurY;

	@:noCompletion private function set_blurY(v:Float):Float
	{
		if (v != __blurY) { __blurY = v; __updateSize(); __renderDirty = true; }
		return v;
	}

	@:noCompletion private function get_strength():Float return __strength;

	@:noCompletion private function set_strength(v:Float):Float
	{
		if (v != __strength) { __strength = v; __renderDirty = true; }
		return v;
	}

	@:noCompletion private function get_quality():Int return __quality;

	@:noCompletion private function set_quality(v:Int):Int
	{
		if (v != __quality) { __quality = v; __updateSize(); __renderDirty = true; }
		return v;
	}

	@:noCompletion private function get_type():BitmapFilterType return __type;

	@:noCompletion private function set_type(v:BitmapFilterType):BitmapFilterType
	{
		if (v != __type) { __type = v; __renderDirty = true; }
		return v;
	}

	@:noCompletion private function get_knockout():Bool return __knockout;

	@:noCompletion private function set_knockout(v:Bool):Bool
	{
		if (v != __knockout) { __knockout = v; __renderDirty = true; }
		return v;
	}
}

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
private class GradientBevelShader extends BitmapFilterShader
{
	@:glFragmentSource("uniform sampler2D openfl_Texture;
		uniform sampler2D sourceBitmap;
		uniform sampler2D gradientRamp;
		uniform float uBevelType;
		uniform bool uKnockout;
		uniform float uStrength;
		varying vec2 vTextureCoord;
		varying vec2 vTransform;

		void main(void) {
			vec4 dest = texture2D(sourceBitmap, vTextureCoord);
			vec2 uvTowardShadow = vTextureCoord + vTransform;
			vec2 uvTowardLight = vTextureCoord - vTransform;
			float maskTowardShadow = texture2D(openfl_Texture, uvTowardShadow).a;
			float maskTowardLight = texture2D(openfl_Texture, uvTowardLight).a;
			if (uvTowardShadow.x<0.0||uvTowardShadow.x>1.0||uvTowardShadow.y<0.0||uvTowardShadow.y>1.0) maskTowardShadow = 0.0;
			if (uvTowardLight.x<0.0||uvTowardLight.x>1.0||uvTowardLight.y<0.0||uvTowardLight.y>1.0) maskTowardLight = 0.0;

			// signed distance field -> ramp index (-1 = one edge/ratio 0,
			// 0 = base/ratio 128, +1 = other edge/ratio 255)
			float sd = clamp((maskTowardShadow - maskTowardLight) * uStrength, -1.0, 1.0);
			vec4 glow = texture2D(gradientRamp, vec2(sd * 0.5 + 0.5, 0.5));

			if (uBevelType == 0.0) {
				if (uKnockout) gl_FragColor = glow * dest.a;
				else gl_FragColor = glow * dest.a + dest * (1.0 - glow.a);
			} else if (uBevelType == 1.0) {
				if (uKnockout) gl_FragColor = glow - glow * dest.a;
				else gl_FragColor = dest + glow - glow * dest.a;
			} else {
				if (uKnockout) gl_FragColor = glow;
				else gl_FragColor = dest - dest * glow.a + glow;
			}
		}")

	@:glVertexSource("attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;
		uniform mat4 openfl_Matrix;
		uniform vec2 uTextureSize;
		uniform float uTransformX;
		uniform float uTransformY;
		varying vec2 vTextureCoord;
		varying vec2 vTransform;

		void main(void) {
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
typedef GradientBevelFilter = flash.filters.GradientBevelFilter;
#end
