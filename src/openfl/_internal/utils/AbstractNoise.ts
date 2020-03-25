namespace openfl._internal.utils;

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

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
class AbstractNoise
{
	private octaves(null, null): number;
	private stitch(null, null): boolean;
	private stitch_threshold(null, null): number;
	private channels(null, null): number;
	private grayscale(null, null): boolean;
	private octaves_frequencies(null, null): Array<Float>; // frequency per octave
	private octaves_persistences(null, null): Array<Float>; // persistence per octave
	private persistence_max(null, null): number; // 1 / max persistence

	public new(seed: number, octaves: number, channels: number, grayScale: boolean, falloff: number, stitch: boolean = false, stitch_threshold: number = 0.05)
	{
		this.stitch = stitch;
		this.stitch_threshold = stitch_threshold;

		this.octaves = octaves;

		this.channels = channels;
		this.grayscale = grayScale;

		this.calculateOctaves(falloff);
	}

	public fill(bitmap: BitmapData, _scale_x: number, _scale_y: number, _scale_z: number): void
	{
		// put your noise code in here ...
	}

	private stitching(bitmap: BitmapData, color: number, px: number, py: number, stitch_w: number, stitch_h: number, width: number, height: number): number
	{
		var r: number = (color >> 16) & 255;
		var g: number = (color >> 8) & 255;
		var b: number = (color) & 255;

		if (width - stitch_w < px)
		{
			var dest: number = bitmap.getPixel32(width - px, py);
			var dest_r: number = (dest >> 16) & 255;
			var dest_g: number = (dest >> 8) & 255;
			var dest_b: number = (dest) & 255;

			var u: number = (width - px) / stitch_w;
			var uu: number = u * u;

			r = mixI(dest_r, r, u);
			g = mixI(dest_g, g, u);
			b = mixI(dest_b, b, u);
		}

		if (height - stitch_h < py)
		{
			var dest: number = bitmap.getPixel32(px, height - py);
			var dest_r: number = (dest >> 16) & 255;
			var dest_g: number = (dest >> 8) & 255;
			var dest_b: number = (dest) & 255;

			var u: number = (height - py) / stitch_h;
			var uu: number = u * u;

			r = mixI(dest_r, r, u);
			g = mixI(dest_g, g, u);
			b = mixI(dest_b, b, u);
		}

		return 0xFF000000 | r << 16 | g << 8 | b;
	}

	private color(r_noise: null | number, g_noise: null | number, b_noise: null | number): number
	{
		var color_r: number = 0;
		var color_g: number = 0;
		var color_b: number = 0;

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

	private noiseToColor(noise: number): number
	{
		return Std.int((noise * this.persistence_max + 1.0) * 128);
	}

	private fade(t: number): number
	{
		return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
	}

	private mixI(x: number, y: number, t: number): number
	{
		return Std.int((1.0 - t) * x + t * y);
	}

	private mix(x: number, y: number, t: number): number
	{
		return (1.0 - t) * x + t * y;
	}

	private fastfloor(x: number): number
	{
		return x > 0 ? Std.int(x) : Std.int(x - 1);
	}

	private dot2d(grad: Array<Int>, x: number, y: number): number
	{
		return grad[0] * x + grad[1] * y;
	}

	private dot(grad: Array<Int>, x: number, y: number, z: number): number
	{
		return grad[0] * x + grad[1] * y + grad[2] * z;
	}

	private calculateOctaves(fPersistence: number): void
	{
		var fFreq: number, fPers: number;

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
