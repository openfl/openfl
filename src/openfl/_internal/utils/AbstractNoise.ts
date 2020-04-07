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
import BitmapData from "../../display/BitmapData";

export default abstract class AbstractNoise
{
	protected octaves: number;
	protected stitch: boolean;
	protected stitch_threshold: number;
	protected channels: number;
	protected grayscale: boolean;
	protected octaves_frequencies: Array<number>; // frequency per octave
	protected octaves_persistences: Array<number>; // persistence per octave
	protected persistence_max: number; // 1 / max persistence

	public constructor(seed: number, octaves: number, channels: number, grayScale: boolean, falloff: number, stitch: boolean = false, stitch_threshold: number = 0.05)
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

	protected stitching(bitmap: BitmapData, color: number, px: number, py: number, stitch_w: number, stitch_h: number, width: number, height: number): number
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

			r = this.mixI(dest_r, r, u);
			g = this.mixI(dest_g, g, u);
			b = this.mixI(dest_b, b, u);
		}

		if (height - stitch_h < py)
		{
			var dest: number = bitmap.getPixel32(px, height - py);
			var dest_r: number = (dest >> 16) & 255;
			var dest_g: number = (dest >> 8) & 255;
			var dest_b: number = (dest) & 255;

			var u: number = (height - py) / stitch_h;
			var uu: number = u * u;

			r = this.mixI(dest_r, r, u);
			g = this.mixI(dest_g, g, u);
			b = this.mixI(dest_b, b, u);
		}

		return 0xFF000000 | r << 16 | g << 8 | b;
	}

	protected color(r_noise: null | number, g_noise: null | number, b_noise: null | number): number
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

	protected noiseToColor(noise: number): number
	{
		return Math.floor((noise * this.persistence_max + 1.0) * 128);
	}

	protected fade(t: number): number
	{
		return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
	}

	protected mixI(x: number, y: number, t: number): number
	{
		return Math.floor((1.0 - t) * x + t * y);
	}

	protected mix(x: number, y: number, t: number): number
	{
		return (1.0 - t) * x + t * y;
	}

	protected fastfloor(x: number): number
	{
		return x > 0 ? Math.floor(x) : Math.floor(x - 1);
	}

	protected dot2d(grad: Array<number>, x: number, y: number): number
	{
		return grad[0] * x + grad[1] * y;
	}

	protected dot(grad: Array<number>, x: number, y: number, z: number): number
	{
		return grad[0] * x + grad[1] * y + grad[2] * z;
	}

	protected calculateOctaves(fPersistence: number): void
	{
		var fFreq: number, fPers: number;

		this.octaves_frequencies = [];
		this.octaves_persistences = [];
		this.persistence_max = 0;

		for (let i = 0; i < this.octaves; i++)
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
