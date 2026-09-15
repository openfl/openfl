package openfl.filters;

#if !flash
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.DisplayObjectRenderer;
import openfl.display.Shader;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Vector;

/**
	The BitmapFilter class is the base class for all image filter effects.

	The BevelFilter, BlurFilter, ColorMatrixFilter, ConvolutionFilter,
	DisplacementMapFilter, DropShadowFilter, GlowFilter, GradientBevelFilter,
	and GradientGlowFilter classes all extend the BitmapFilter class. You can
	apply these filter effects to any display object.

	You can neither directly instantiate nor extend BitmapFilter.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class BitmapFilter
{
	@:noCompletion private var __bottomExtension:Int;
	@:noCompletion private var __leftExtension:Int;
	@:noCompletion private var __needSecondBitmapData:Bool;
	@:noCompletion private var __numShaderPasses:Int;
	@:noCompletion private var __preserveObject:Bool;
	@:noCompletion private var __renderDirty:Bool;
	@:noCompletion private var __rightExtension:Int;
	@:noCompletion private var __shaderBlendMode:BlendMode;
	@:noCompletion private var __smooth:Bool;
	@:noCompletion private var __topExtension:Int;

	/**
		Whether `__applyFilter` composites the original object into its own result.
	**/
	@:noCompletion private var __softwareComposite:Bool;

	/**
		Set by the display-list software path while `__applyFilter` runs where the
		object itself sits inside the padded cache bitmap it is given as source (in
		device pixels). `null` when the source is the object (BitmapData.applyFilter).
	**/
	@:noCompletion private var __objectRect:Rectangle;

	/**
		The device-pixel scale the filter is being rendered at.

		A filtered object is cached into a bitmap sized and drawn at the renderer's
		pixel ratio, so on a HiDPI display the object is (say) 1.5x larger in that
		bitmap. Filter distances, blur radius, and offsets are authored in
		*logical* pixels, so they must be scaled to match, otherwise the effect comes
		out 1/pixelRatio too small relative to its content.

		The renderer sets this before using the filter. It stays 1 for
		`BitmapData.applyFilter`, which works on the bitmap's own pixels.
	**/
	@:noCompletion private var __renderScale:Float;

	public function new()
	{
		__bottomExtension = 0;
		__leftExtension = 0;
		__needSecondBitmapData = true;
		__numShaderPasses = 0;
		__preserveObject = false;
		__rightExtension = 0;
		__shaderBlendMode = NORMAL;
		__topExtension = 0;
		__smooth = true;
		__renderScale = 1;
		__softwareComposite = false;
	}

	/**
		Returns a BitmapFilter object that is an exact copy of the original
		BitmapFilter object.

		@return A BitmapFilter object.
	**/
	public function clone():BitmapFilter
	{
		return new BitmapFilter();
	}

	@:noCompletion private function __applyFilter(bitmapData:BitmapData, sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point):BitmapData
	{
		return sourceBitmapData;
	}

	@:noCompletion private function __initShader(renderer:DisplayObjectRenderer, pass:Int, sourceBitmapData:BitmapData):Shader
	{
		// return renderer.__defaultShader;
		return null;
	}


	// Flash rounds a distance offset down
	@:noCompletion private static inline function __offsetFloor(v:Float):Int
	{
		return Math.floor(v);
	}

	/**
		The source's alpha channel as a 0..1 mask laid out on the destination
		grid, using the sourceRect/destPoint mapping `__applyFilter` is given.
		Samples outside the source read 0, matching the transparent border the GL
		path gets from its cache texture.
	**/
	@:noCompletion private static function __alphaMask(source:BitmapData, sourceRect:Rectangle, destPoint:Point, width:Int, height:Int):Array<Float>
	{
		var mask = [for (i in 0...width * height) 0.0];

		var pixels = source.getVector(sourceRect);

		var sw = Std.int(sourceRect.width);
		var sh = Std.int(sourceRect.height);

		var ox = Std.int(destPoint.x);
		var oy = Std.int(destPoint.y);

		for (y in 0...sh)
		{
			var dy = y + oy;
			if (dy < 0 || dy >= height) continue;
			for (x in 0...sw)
			{
				var dx = x + ox;
				if (dx < 0 || dx >= width) continue;
				mask[dy * width + dx] = ((pixels[y * sw + x] >>> 24) & 0xFF) / 255.0;
			}
		}
		return mask;
	}

	/**
		Box-blur a 0..1 mask in place, matching `BoxBlurShader`: `quality`
		iterations of one horizontal then one vertical pass.
	**/
	@:noCompletion private static function __blurMask(mask:Array<Float>, width:Int, height:Int, blurX:Float, blurY:Float, quality:Int):Array<Float>
	{
		var passes = (quality > 0) ? quality : 1;
		var scratch = [for (i in 0...mask.length) 0.0];

		for (i in 0...passes)
		{
			__blurMaskAxis(mask, scratch, width, height, blurX, true);
			__blurMaskAxis(scratch, mask, width, height, blurY, false);
		}
		return mask;
	}

	@:noCompletion private static function __blurMaskAxis(src:Array<Float>, dest:Array<Float>, width:Int, height:Int, blur:Float, horizontal:Bool):Void
	{
		var fullSize = (blur > 255) ? 255.0 : blur;

		if (fullSize <= 1)
		{
			for (i in 0...src.length)
				dest[i] = src[i];
			return;
		}

		var half = fullSize * 0.5;
		var n = Std.int(Math.floor(half - 0.5));
		if (n < 0) n = 0;
		var frac = Math.floor((half - (n + 0.5)) * 255) / 255;
		var edge = n + 1;

		for (y in 0...height)
		{
			for (x in 0...width)
			{
				var sum = __maskAt(src, width, height, x, y);

				for (i in 1...(n + 1))
				{
					if (horizontal) sum += __maskAt(src, width, height, x + i, y) + __maskAt(src, width, height, x - i, y);
					else sum += __maskAt(src, width, height, x, y + i) + __maskAt(src, width, height, x, y - i);
				}

				if (horizontal) sum += (__maskAt(src, width, height, x + edge, y) + __maskAt(src, width, height, x - edge, y)) * frac;
				else sum += (__maskAt(src, width, height, x, y + edge) + __maskAt(src, width, height, x, y - edge)) * frac;

				dest[y * width + x] = Math.floor((sum / fullSize) * 255) / 255;
			}
		}
	}

	@:noCompletion private static inline function __maskAt(mask:Array<Float>, width:Int, height:Int, x:Int, y:Int):Float
	{
		return (x < 0 || x >= width || y < 0 || y >= height) ? 0.0 : mask[y * width + x];
	}


	@:noCompletion private static function __maskAtFrac(mask:Array<Float>, width:Int, height:Int, fx:Float, fy:Float):Float
	{
		var x0 = Math.floor(fx), y0 = Math.floor(fy);
		var tx = fx - x0, ty = fy - y0;
		var top = __maskAt(mask, width, height, x0, y0) * (1 - tx) + __maskAt(mask, width, height, x0 + 1, y0) * tx;
		var bottom = __maskAt(mask, width, height, x0, y0 + 1) * (1 - tx) + __maskAt(mask, width, height, x0 + 1, y0 + 1) * tx;
		return top * (1 - ty) + bottom * ty;
	}

	/**
		Combine an effect layer with the source and write the result into `dest`,
		matching the GL combine shaders. The effect is supplied as premultiplied
		0..1 channels; `type` is INNER / OUTER / FULL.

		outer:    src + fx * (1 - src.a)
		inner:    rgb = src.rgb * (1 - fx.a) + fx.rgb * src.a,  a = src.a
		full:     src * (1 - fx.a) + fx
		knockout: the src term is dropped (outer keeps `fx * (1 - src.a)`,
		          inner keeps `fx * src.a`, full keeps `fx`)
	**/
	@:noCompletion private static function __compositeEffect(dest:BitmapData, source:BitmapData, sourceRect:Rectangle, destPoint:Point, fxR:Array<Float>,
			fxG:Array<Float>, fxB:Array<Float>, fxA:Array<Float>, type:BitmapFilterType, knockout:Bool):BitmapData
	{
		var width = dest.width;
		var height = dest.height;

		// source pixels on the destination grid, premultiplied
		var srcR = new Array<Float>();
		var srcG = new Array<Float>();
		var srcB = new Array<Float>();
		var srcA = new Array<Float>();

		var pixelCount = width * height;
		for (i in 0...pixelCount)
		{
			srcR.push(0.0);
			srcG.push(0.0);
			srcB.push(0.0);
			srcA.push(0.0);
		}

		var pixels = source.getVector(sourceRect);

		var sourceWidth = Std.int(sourceRect.width);
		var sourceHeight = Std.int(sourceRect.height);
		var destOffsetX = Std.int(destPoint.x);
		var destOffsetY = Std.int(destPoint.y);

		for (y in 0...sourceHeight)
		{
			var destY = y + destOffsetY;
			if (destY < 0 || destY >= height) continue;

			for (x in 0...sourceWidth)
			{
				var destX = x + destOffsetX;
				if (destX < 0 || destX >= width) continue;

				var argb = pixels[y * sourceWidth + x];
				var a = ((argb >>> 24) & 0xFF) / 255.0;
				var i = destY * width + destX;
				srcA[i] = a;
				srcR[i] = (((argb >> 16) & 0xFF) / 255.0) * a;
				srcG[i] = (((argb >> 8) & 0xFF) / 255.0) * a;
				srcB[i] = ((argb & 0xFF) / 255.0) * a;
			}
		}

		var out = new Vector<UInt>(width * height, true);

		for (i in 0...width * height)
		{
			var sourceR = srcR[i], sourceG = srcG[i], sourceB = srcB[i], sourceA = srcA[i];
			var effectR = fxR[i], effectG = fxG[i], effectB = fxB[i], effectA = fxA[i];
			var r:Float, g:Float, b:Float, a:Float;

			if (type == INNER)
			{
				// the effect confined to the shape: scaled by the source alpha
				var maskedR = effectR * sourceA, maskedG = effectG * sourceA, maskedB = effectB * sourceA, maskedA = effectA * sourceA;
				if (knockout)
				{
					r = maskedR;
					g = maskedG;
					b = maskedB;
					a = maskedA;
				}
				else
				{
					r = sourceR * (1 - effectA) + maskedR;
					g = sourceG * (1 - effectA) + maskedG;
					b = sourceB * (1 - effectA) + maskedB;
					a = sourceA;
				}
			}
			else if (type == FULL)
			{
				if (knockout)
				{
					r = effectR;
					g = effectG;
					b = effectB;
					a = effectA;
				}
				else
				{
					r = sourceR * (1 - effectA) + effectR;
					g = sourceG * (1 - effectA) + effectG;
					b = sourceB * (1 - effectA) + effectB;
					a = sourceA * (1 - effectA) + effectA;
				}
			}
			else // OUTER
			{
				var outside = 1 - sourceA; // how much of this pixel lies outside the shape
				if (knockout)
				{
					r = effectR * outside;
					g = effectG * outside;
					b = effectB * outside;
					a = effectA * outside;
				}
				else
				{
					r = sourceR + effectR * outside;
					g = sourceG + effectG * outside;
					b = sourceB + effectB * outside;
					a = sourceA + effectA * outside;
				}
			}

			out[i] = __toStraightARGB(r, g, b, a);
		}

		dest.setVector(dest.rect, out);
		return dest;
	}

	// premultiplied 0..1 -> straight 0xAARRGGBB
	@:noCompletion private static inline function __toStraightARGB(r:Float, g:Float, b:Float, a:Float):UInt
	{
		if (a <= 0) return 0;
		if (a > 1) a = 1;

		var ir = Std.int(__clamp01(r / a) * 255 + 0.5);
		var ig = Std.int(__clamp01(g / a) * 255 + 0.5);
		var ib = Std.int(__clamp01(b / a) * 255 + 0.5);
		var ia = Std.int(a * 255 + 0.5);

		return (ia << 24) | (ir << 16) | (ig << 8) | ib;
	}

	@:noCompletion private static inline function __clamp01(v:Float):Float
	{
		return v < 0 ? 0 : (v > 1 ? 1 : v);
	}
}
#else
typedef BitmapFilter = flash.filters.BitmapFilter;
#end
