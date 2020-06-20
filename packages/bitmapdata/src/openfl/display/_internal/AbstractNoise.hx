package openfl.display._internal;

/**
	Title:      Perlin noise
	Version:    1.3
	Author:      Ron Valstar
	Author URI:    http://www.sjeiti.com/
	Original code port from http://mrl.nyu.edu/~perlin/noise/
	and some help from http://freespace.virgin.net/hugo.elias/models/m_perlin.htm
	AS3 optimizations by Mario Klingemann http://www.quasimondo.com
	Haxe port and optimization by Nicolas Cannasse http://haxe.org
**/
import openfl.display.BitmapData;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
class AbstractNoise
{
	private var octaves(null, null):Int;
	private var stitch(null, null):Bool;
	private var stitch_threshold(null, null):Float;
	private var channels(null, null):Int;
	private var grayscale(null, null):Bool;
	private var octaves_frequencies(null, null):Array<Float>; // frequency per octave
	private var octaves_persistences(null, null):Array<Float>; // persistence per octave
	private var persistence_max(null, null):Float; // 1 / max persistence

	public function new(seed:Int, octaves:Int, channels:Int, grayScale:Bool, falloff:Float, stitch:Bool = false, stitch_threshold:Float = 0.05)
	{
		this.stitch = stitch;
		this.stitch_threshold = stitch_threshold;

		this.octaves = octaves;

		this.channels = channels;
		this.grayscale = grayScale;

		this.calculateOctaves(falloff);
	}

	public function fill(bitmap:BitmapData, _scale_x:Float, _scale_y:Float, _scale_z:Float):Void
	{
		// put your noise code in here ...
	}

	private function stitching(bitmap:BitmapData, color:Int, px:Int, py:Int, stitch_w:Int, stitch_h:Int, width:Int, height:Int):Int
	{
		var r:Int = (color >> 16) & 255;
		var g:Int = (color >> 8) & 255;
		var b:Int = (color) & 255;

		if (width - stitch_w < px)
		{
			var dest:Int = bitmap.getPixel32(width - px, py);
			var dest_r:Int = (dest >> 16) & 255;
			var dest_g:Int = (dest >> 8) & 255;
			var dest_b:Int = (dest) & 255;

			var u:Float = (width - px) / stitch_w;
			var uu:Float = u * u;

			r = mixI(dest_r, r, u);
			g = mixI(dest_g, g, u);
			b = mixI(dest_b, b, u);
		}

		if (height - stitch_h < py)
		{
			var dest:Int = bitmap.getPixel32(px, height - py);
			var dest_r:Int = (dest >> 16) & 255;
			var dest_g:Int = (dest >> 8) & 255;
			var dest_b:Int = (dest) & 255;

			var u:Float = (height - py) / stitch_h;
			var uu:Float = u * u;

			r = mixI(dest_r, r, u);
			g = mixI(dest_g, g, u);
			b = mixI(dest_b, b, u);
		}

		return 0xFF000000 | r << 16 | g << 8 | b;
	}

	private function color(r_noise:Null<Float>, g_noise:Null<Float>, b_noise:Null<Float>):Int
	{
		var color_r:Int = 0;
		var color_g:Int = 0;
		var color_b:Int = 0;

		if (null != r_noise)
		{
			color_r = this.noiseToColor(r_noise);
		}

		if (null != g_noise)
		{
			color_g = this.noiseToColor(g_noise);
		}

		if (null != b_noise)
		{
			color_b = this.noiseToColor(b_noise);
		}

		return 0xFF000000 | color_r << 16 | color_g << 8 | color_b;
	}

	private function noiseToColor(noise:Float):Int
	{
		return Std.int((noise * this.persistence_max + 1.0) * 128);
	}

	private function fade(t:Float):Float
	{
		return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
	}

	private function mixI(x:Int, y:Int, t:Float):Int
	{
		return Std.int((1.0 - t) * x + t * y);
	}

	private function mix(x:Float, y:Float, t:Float):Float
	{
		return (1.0 - t) * x + t * y;
	}

	private function fastfloor(x:Float):Int
	{
		return x > 0 ? Std.int(x) : Std.int(x - 1);
	}

	private function dot2d(grad:Array<Int>, x:Float, y:Float):Float
	{
		return grad[0] * x + grad[1] * y;
	}

	private function dot(grad:Array<Int>, x:Float, y:Float, z:Float):Float
	{
		return grad[0] * x + grad[1] * y + grad[2] * z;
	}

	private function calculateOctaves(fPersistence:Float):Void
	{
		var fFreq:Float, fPers:Float;

		this.octaves_frequencies = [];
		this.octaves_persistences = [];
		this.persistence_max = 0;

		for (i in 0...this.octaves)
		{
			fFreq = Math.pow(2.0, i);
			fPers = Math.pow(fPersistence, i);

			this.persistence_max += fPers;
			this.octaves_frequencies.push(fFreq);
			this.octaves_persistences.push(fPers);
		}

		this.persistence_max = 1.0 / this.persistence_max;
	}
}
