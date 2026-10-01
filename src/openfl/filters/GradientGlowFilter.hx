package openfl.filters;

#if !flash
import openfl.display.BitmapData;
import openfl.display.DisplayObjectRenderer;
import openfl.display.Shader;
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
	The GradientGlowFilter class lets you apply a gradient glow effect to display objects.
	The glow colours come from a gradient defined by `colors`/`alphas`/`ratios` instead of a single colour.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.filters.BlurFilter)
@:access(openfl.geom.Point)
@:access(openfl.geom.Rectangle)
@:final class GradientGlowFilter extends BitmapFilter
{
	@:noCompletion private static var __gradientShader = new GradientGlowShader();

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
	@:noCompletion private var __offsetX:Int;
	@:noCompletion private var __offsetY:Int;
	@:noCompletion private var __horizontalPasses:Int;
	@:noCompletion private var __verticalPasses:Int;
	@:noCompletion private var __ramp:BitmapData;
	@:noCompletion private var __rampDirty:Bool;

	public function new(distance:Float = 4, angle:Float = 45, colors:Array<Int> = null, alphas:Array<Float> = null, ratios:Array<Int> = null,
			blurX:Float = 4, blurY:Float = 4, strength:Float = 1, quality:Int = 1, type:BitmapFilterType = OUTER, knockout:Bool = false)
	{
		super();

		__distance = distance;
		__angle = angle;
		__colors = (colors != null) ? colors : [0xFFFFFF, 0xFFFFFF];
		__alphas = (alphas != null) ? alphas : [0, 1];
		__ratios = (ratios != null) ? ratios : [0, 255];
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
		return new GradientGlowFilter(__distance, __angle, __colors.copy(), __alphas.copy(), __ratios.copy(), __blurX, __blurY, __strength, __quality,
			__type, __knockout);
	}

	@:noCompletion private override function __applyFilter(bitmapData:BitmapData, sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point):BitmapData
	{
		var width = bitmapData.width;
		var height = bitmapData.height;

		// blurred source alpha, read back shifted by distance/angle (as the GL path samples the mask at coord - offset)
		var mask = BitmapFilter.__alphaMask(sourceBitmapData, sourceRect, destPoint, width, height);
		BitmapFilter.__blurMask(mask, width, height, __blurX * __renderScale, __blurY * __renderScale, __quality);

		if (__rampDirty) __buildRamp();
		var ramp = __rampChannels();

		// exact (fractional) offset, read with bilinear filtering as the GPU path does
		var glowOffsetX = __distance * Math.cos(__angle * Math.PI / 180) * __renderScale;
		var glowOffsetY = __distance * Math.sin(__angle * Math.PI / 180) * __renderScale;

		var clipX0 = 0.0, clipY0 = 0.0, clipX1:Float = width, clipY1:Float = height;

		if (__type != INNER)
		{
			// the object: the source rect itself, or its place inside a padded cache bitmap
			var objX = __objectRect != null ? __objectRect.x : destPoint.x;
			var objY = __objectRect != null ? __objectRect.y : destPoint.y;
			var objW = __objectRect != null ? __objectRect.width : sourceRect.width;
			var objH = __objectRect != null ? __objectRect.height : sourceRect.height;
			var reachX = BlurFilter.__effectExtension(__blurX, __quality) * __renderScale;
			var reachY = BlurFilter.__effectExtension(__blurY, __quality) * __renderScale;
			var offX = __offsetX * __renderScale, offY = __offsetY * __renderScale;
			clipX0 = Math.min(objX, objX + offX - reachX);
			clipX1 = Math.max(objX + objW, objX + objW + offX + reachX);
			clipY0 = Math.min(objY, objY + offY - reachY);
			clipY1 = Math.max(objY + objH, objY + objH + offY + reachY);
		}

		var fxR = new Array<Float>(), fxG = new Array<Float>(), fxB = new Array<Float>(), fxA = new Array<Float>();
		for (y in 0...height)
		{
			for (x in 0...width)
			{
				if (x < clipX0 || x >= clipX1 || y < clipY0 || y >= clipY1)
				{
					fxR.push(0);
					fxG.push(0);
					fxB.push(0);
					fxA.push(0);
					continue;
				}
				var glowCoverage = BitmapFilter.__maskAtFrac(mask, width, height, x - glowOffsetX, y - glowOffsetY) * __strength;
				if (glowCoverage > 1) glowCoverage = 1;
				else if (glowCoverage < 0) glowCoverage = 0;

				// index the ramp by the mask, exactly as GradientGlowShader does
				var i = Std.int(glowCoverage * 255 + 0.5) * 4;
				fxR.push(ramp[i]);
				fxG.push(ramp[i + 1]);
				fxB.push(ramp[i + 2]);
				fxA.push(ramp[i + 3]);
			}
		}

		return BitmapFilter.__compositeEffect(bitmapData, sourceBitmapData, sourceRect, destPoint, fxR, fxG, fxB, fxA, __type, __knockout);
	}

	// 256-entry ramp as flat premultiplied [r,g,b,a] floats, matching how the ramp BitmapData is premultiplied when uploaded as a texture.
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
			// blur the object's alpha into a soft distance field (reuse BlurFilter)
			var horizontal = pass < __horizontalPasses;
			return BlurFilter.__setupBlurShader(horizontal, (horizontal ? __blurX : __blurY) * __renderScale);
		}

		if (__rampDirty) __buildRamp();

		var shader = __gradientShader;
		shader.sourceBitmap.input = sourceBitmapData;
		shader.gradientRamp.input = __ramp;
		// drawn at the exact offset; the floored __offsetX / __offsetY size the bitmap
		shader.offset.value[0] = __distance * Math.cos(__angle * Math.PI / 180) * __renderScale;
		shader.offset.value[1] = __distance * Math.sin(__angle * Math.PI / 180) * __renderScale;
		shader.uStrength.value[0] = __strength;
		shader.uInner.value[0] = (__type == INNER) ? 1.0 : 0.0;
		shader.uFull.value[0] = (__type == FULL) ? 1.0 : 0.0;
		shader.uKnockout.value[0] = __knockout ? 1.0 : 0.0;

		var w = sourceBitmapData.width, h = sourceBitmapData.height;
		var ox = __offsetX * __renderScale, oy = __offsetY * __renderScale;

		shader.uClip.value[0] = (__type != INNER && ox > 0) ? ox / w : 0.0;
		shader.uClip.value[1] = (__type != INNER && oy > 0) ? oy / h : 0.0;
		shader.uClip.value[2] = (__type != INNER && ox < 0) ? 1.0 + ox / w : 1.0;
		shader.uClip.value[3] = (__type != INNER && oy < 0) ? 1.0 + oy / h : 1.0;

		return shader;
		#else
		return null;
		#end
	}

	// Build the 256-entry straight-ARGB gradient ramp (one texel per output index 0..255) from the (colors, alphas, ratios).
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

				// blend = how far `index` sits between the two stops (0 at the low
				// stop, 1 at the high stop)
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
		__offsetX = BitmapFilter.__offsetFloor(__distance * Math.cos(__angle * Math.PI / 180));
		__offsetY = BitmapFilter.__offsetFloor(__distance * Math.sin(__angle * Math.PI / 180));

		var exX = BlurFilter.__effectExtension(__blurX, __quality);
		var exY = BlurFilter.__effectExtension(__blurY, __quality);

		var absX = __offsetX < 0 ? -__offsetX : __offsetX;
		var absY = __offsetY < 0 ? -__offsetY : __offsetY;
		if (__type == INNER)
		{
			__leftExtension = __rightExtension = exX + absX;
			__topExtension = __bottomExtension = exY + absY;
		}
		else
		{
			__leftExtension = exX + (__offsetX < 0 ? absX : 0);
			__rightExtension = exX + (__offsetX > 0 ? absX : 0);
			__topExtension = exY + (__offsetY < 0 ? absY : 0);
			__bottomExtension = exY + (__offsetY > 0 ? absY : 0);
		}

		var q = (__quality > 0) ? __quality : 1;
		__horizontalPasses = (__blurX <= 0) ? 0 : q;
		__verticalPasses = (__blurY <= 0) ? 0 : q;
		__numShaderPasses = __horizontalPasses + __verticalPasses + 1;
	}

	@:noCompletion private function get_distance():Float return __distance;

	@:noCompletion private function set_distance(v:Float):Float
	{
		if (v != __distance) { __distance = v; __updateSize(); __renderDirty = true; }
		return v;
	}

	@:noCompletion private function get_angle():Float return __angle;

	@:noCompletion private function set_angle(v:Float):Float
	{
		if (v != __angle) { __angle = v; __updateSize(); __renderDirty = true; }
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
private class GradientGlowShader extends BitmapFilterShader
{
	@:glFragmentSource("
		uniform sampler2D openfl_Texture;
		uniform sampler2D sourceBitmap;
		uniform sampler2D gradientRamp;
		uniform float uStrength;
		uniform float uInner;
		uniform float uFull;
		uniform float uKnockout;
		uniform vec4 uClip;          // painted rect (x0, y0, x1, y1) in bitmap UV
		varying vec4 textureCoords;

		void main(void) {
			vec4 src = texture2D(sourceBitmap, textureCoords.xy);
			vec2 uv = textureCoords.xy;
			if (uv.x < uClip.x || uv.x > uClip.z || uv.y < uClip.y || uv.y > uClip.w) {
				gl_FragColor = src;   // outside Flash's filter rect nothing is painted
				return;
			}
			vec2 maskUV = textureCoords.zw;
			float mask = (maskUV.x < 0.0 || maskUV.x > 1.0 || maskUV.y < 0.0 || maskUV.y > 1.0) ? 0.0 : texture2D(openfl_Texture, maskUV).a;
			float f = clamp(mask * uStrength, 0.0, 1.0);

			// index the ramp by the distance field (high near the shape = inner
			// ratio 255, low far away = outer ratio 0), same for every type.
			vec4 g = texture2D(gradientRamp, vec2(f, 0.5));

			if (uInner > 0.5) {
				vec4 inner = g * src.a;
				if (uKnockout > 0.5) gl_FragColor = inner;
				else gl_FragColor = src * (1.0 - inner.a) + inner;
			} else if (uFull > 0.5) {
				if (uKnockout > 0.5) gl_FragColor = g;
				else gl_FragColor = src * (1.0 - g.a) + g;
			} else {
				vec4 outer = g * (1.0 - src.a);
				if (uKnockout > 0.5) gl_FragColor = outer;
				else gl_FragColor = src + outer;
			}
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
		uClip.value = [0, 0, 1, 1];
		uStrength.value = [1];
		uInner.value = [0];
		uFull.value = [0];
		uKnockout.value = [0];
		#end
	}
}
#else
typedef GradientGlowFilter = flash.filters.GradientGlowFilter;
#end
