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
import openfl.display.BitmapDataChannel;
import openfl.display.BitmapData;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
class PerlinNoise extends AbstractNoise
{
	@SuppressWarnings("checkstyle:ConstantName")
	private static var P:Array<Int> = [
		151, 160, 137, 91, 90, 15, 131, 13, 201, 95, 96, 53, 194, 233, 7, 225, 140, 36, 103, 30, 69, 142, 8, 99, 37, 240, 21, 10, 23, 190, 6, 148, 247, 120,
		234, 75, 0, 26, 197, 62, 94, 252, 219, 203, 117, 35, 11, 32, 57, 177, 33, 88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168, 68, 175, 74, 165, 71,
		134, 139, 48, 27, 166, 77, 146, 158, 231, 83, 111, 229, 122, 60, 211, 133, 230, 220, 105, 92, 41, 55, 46, 245, 40, 244, 102, 143, 54, 65, 25, 63, 161,
		1, 216, 80, 73, 209, 76, 132, 187, 208, 89, 18, 169, 200, 196, 135, 130, 116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 3, 64, 52, 217, 226, 250,
		124, 123, 5, 202, 38, 147, 118, 126, 255, 82, 85, 212, 207, 206, 59, 227, 47, 16, 58, 17, 182, 189, 28, 42, 223, 183, 170, 213, 119, 248, 152, 2, 44,
		154, 163, 70, 221, 153, 101, 155, 167, 43, 172, 9, 129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 185, 112, 104, 218, 246, 97, 228, 251,
		34, 242, 193, 238, 210, 144, 12, 191, 179, 162, 241, 81, 51, 145, 235, 249, 14, 239, 107, 49, 192, 214, 31, 181, 199, 106, 157, 184, 84, 204, 176,
		115, 121, 50, 45, 127, 4, 150, 254, 138, 236, 205, 93, 222, 114, 67, 29, 24, 72, 243, 141, 128, 195, 78, 66, 215, 61, 156, 180, 151, 160, 137, 91, 90,
		15, 131, 13, 201, 95, 96, 53, 194, 233, 7, 225, 140, 36, 103, 30, 69, 142, 8, 99, 37, 240, 21, 10, 23, 190, 6, 148, 247, 120, 234, 75, 0, 26, 197, 62,
		94, 252, 219, 203, 117, 35, 11, 32, 57, 177, 33, 88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168, 68, 175, 74, 165, 71, 134, 139, 48, 27, 166, 77,
		146, 158, 231, 83, 111, 229, 122, 60, 211, 133, 230, 220, 105, 92, 41, 55, 46, 245, 40, 244, 102, 143, 54, 65, 25, 63, 161, 1, 216, 80, 73, 209, 76,
		132, 187, 208, 89, 18, 169, 200, 196, 135, 130, 116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 3, 64, 52, 217, 226, 250, 124, 123, 5, 202, 38, 147,
		118, 126, 255, 82, 85, 212, 207, 206, 59, 227, 47, 16, 58, 17, 182, 189, 28, 42, 223, 183, 170, 213, 119, 248, 152, 2, 44, 154, 163, 70, 221, 153,
		101, 155, 167, 43, 172, 9, 129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 185, 112, 104, 218, 246, 97, 228, 251, 34, 242, 193, 238, 210,
		144, 12, 191, 179, 162, 241, 81, 51, 145, 235, 249, 14, 239, 107, 49, 192, 214, 31, 181, 199, 106, 157, 184, 84, 204, 176, 115, 121, 50, 45, 127, 4,
		150, 254, 138, 236, 205, 93, 222, 114, 67, 29, 24, 72, 243, 141, 128, 195, 78, 66, 215, 61, 156, 180
	];

	private var p_perm(null, null):Array<Int>;
	private var x_offset(null, null):Float;
	private var y_offset(null, null):Float;
	private var z_offset(null, null):Float;
	private var base_factor(null, null):Float;

	public function new(seed:Int, octaves:Int, channels:Int, grayScale:Bool, falloff:Float, stitch:Bool = false, stitch_threshold:Float = 0.05)
	{
		super(seed, octaves, channels, grayScale, falloff, stitch, stitch_threshold);

		p_perm = [];

		for (i in 0...512)
		{
			p_perm[i] = P[i & 255];
		}

		this.base_factor = 1 / 32;

		this.setSeed(seed);
	}

	override public function fill(bitmap:BitmapData, _scale_x:Float, _scale_y:Float, _scale_z:Float):Void
	{
		var width:Int = bitmap.width;
		var height:Int = bitmap.height;

		var octaves:Int = this.octaves;
		var octaves_frequencies:Array<Float> = this.octaves_frequencies;
		var octaves_persistences:Array<Float> = this.octaves_persistences;

		var isRed:Bool = BitmapDataChannel.RED & this.channels == BitmapDataChannel.RED;
		var isGreen:Bool = BitmapDataChannel.GREEN & this.channels == BitmapDataChannel.GREEN;
		var isBlue:Bool = BitmapDataChannel.BLUE & this.channels == BitmapDataChannel.BLUE;

		var channels:Int = 0;

		if (isRed)
		{
			channels++;
		}

		if (isGreen)
		{
			channels++;
		}

		if (isBlue)
		{
			channels++;
		}

		var grayscale:Bool = this.grayscale;

		var stitch_w:Int = Std.int(this.stitch_threshold * width);
		var stitch_h:Int = Std.int(this.stitch_threshold * height);

		var base_x:Float = _scale_x * this.base_factor + this.x_offset;

		_scale_y = _scale_y * this.base_factor + this.y_offset;
		_scale_z = _scale_z * this.base_factor + this.z_offset;

		var g_offset:Float = 1.0;
		var b_offset:Float = 2.0;

		for (py in 0...height)
		{
			_scale_x = base_x;

			for (px in 0...width)
			{
				var color1 = 0.0;
				var color2 = 0.0;
				var color3 = 0.0;

				for (i in 0...octaves)
				{
					var frequency:Float = octaves_frequencies[i];
					var persistence:Float = octaves_persistences[i];

					color1 += this.noise(_scale_x * frequency, _scale_y * frequency, _scale_z * frequency) * persistence;

					if (!grayscale)
					{
						if (1 < channels)
						{
							color2 += this.noise((_scale_x + g_offset) * frequency, (_scale_y + g_offset) * frequency, _scale_z * frequency) * persistence;
						}

						if (2 < channels)
						{
							color3 += this.noise((_scale_x + b_offset) * frequency, (_scale_y + b_offset) * frequency, _scale_z * frequency) * persistence;
						}
					}
				}

				var color:Int = 0;

				if (grayscale)
				{
					color = this.color(color1, color1, color1);
				}
				else if (isRed && isGreen && isBlue)
				{
					color = this.color(color1, color2, color3);
				}
				else if (isRed && isGreen)
				{
					color = this.color(color1, color2, null);
				}
				else if (isRed && isBlue)
				{
					color = this.color(color1, null, color2);
				}
				else if (isGreen && isBlue)
				{
					color = this.color(null, color1, color2);
				}
				else if (isRed)
				{
					color = this.color(color1, null, null);
				}
				else if (isGreen)
				{
					color = this.color(null, color1, null);
				}
				else if (isBlue)
				{
					color = this.color(null, null, color1);
				}

				if (this.stitch)
				{
					color = this.stitching(bitmap, color, px, py, stitch_w, stitch_h, width, height);
				}

				bitmap.setPixel32(px, py, color);

				_scale_x += this.base_factor;
			}

			_scale_y += this.base_factor;
		}
	}

	private function noise(x:Float, y:Float, z:Float):Float
	{
		var xf = x - (x % 1);
		var yf = y - (y % 1);
		var zf = z - (z % 1);

		x -= xf;
		y -= yf;
		z -= zf;

		var X:Int = Std.int(xf) & 255;
		var Y:Int = Std.int(yf) & 255;
		var Z:Int = Std.int(zf) & 255;

		var u = this.fade(x);
		var v = this.fade(y);
		var w = this.fade(z);

		var A = (p_perm[X]) + Y;
		var AA = (p_perm[A]) + Z;
		var AB = (p_perm[A + 1]) + Z;
		var B = (p_perm[X + 1]) + Y;
		var BA = (p_perm[B]) + Z;
		var BB = (p_perm[B + 1]) + Z;

		var x1 = x - 1;
		var y1 = y - 1;
		var z1 = z - 1;

		var hash = (p_perm[BB + 1]) & 15;
		var g1 = ((hash & 1) == 0 ? (hash < 8 ? x1 : y1) : (hash < 8 ? -x1 : -y1))
			+ ((hash & 2) == 0 ? hash < 4 ? y1 : (hash == 12 ? x1 : z1) : hash < 4 ? -y1 : (hash == 14 ? -x1 : -z1));

		hash = (p_perm[AB + 1]) & 15;
		var g2 = ((hash & 1) == 0 ? (hash < 8 ? x : y1) : (hash < 8 ? -x : -y1))
			+ ((hash & 2) == 0 ? hash < 4 ? y1 : (hash == 12 ? x : z1) : hash < 4 ? -y1 : (hash == 14 ? -x : -z1));

		hash = (p_perm[BA + 1]) & 15;
		var g3 = ((hash & 1) == 0 ? (hash < 8 ? x1 : y) : (hash < 8 ? -x1 : -y))
			+ ((hash & 2) == 0 ? hash < 4 ? y : (hash == 12 ? x1 : z1) : hash < 4 ? -y : (hash == 14 ? -x1 : -z1));

		hash = (p_perm[AA + 1]) & 15;
		var g4 = ((hash & 1) == 0 ? (hash < 8 ? x : y) : (hash < 8 ? -x : -y))
			+ ((hash & 2) == 0 ? hash < 4 ? y : (hash == 12 ? x : z1) : hash < 4 ? -y : (hash == 14 ? -x : -z1));

		hash = (p_perm[BB]) & 15;
		var g5 = ((hash & 1) == 0 ? (hash < 8 ? x1 : y1) : (hash < 8 ? -x1 : -y1))
			+ ((hash & 2) == 0 ? hash < 4 ? y1 : (hash == 12 ? x1 : z) : hash < 4 ? -y1 : (hash == 14 ? -x1 : -z));

		hash = (p_perm[AB]) & 15;
		var g6 = ((hash & 1) == 0 ? (hash < 8 ? x : y1) : (hash < 8 ? -x : -y1))
			+ ((hash & 2) == 0 ? hash < 4 ? y1 : (hash == 12 ? x : z) : hash < 4 ? -y1 : (hash == 14 ? -x : -z));

		hash = (p_perm[BA]) & 15;
		var g7 = ((hash & 1) == 0 ? (hash < 8 ? x1 : y) : (hash < 8 ? -x1 : -y))
			+ ((hash & 2) == 0 ? hash < 4 ? y : (hash == 12 ? x1 : z) : hash < 4 ? -y : (hash == 14 ? -x1 : -z));

		hash = (p_perm[AA]) & 15;
		var g8 = ((hash & 1) == 0 ? (hash < 8 ? x : y) : (hash < 8 ? -x : -y))
			+ ((hash & 2) == 0 ? hash < 4 ? y : (hash == 12 ? x : z) : hash < 4 ? -y : (hash == 14 ? -x : -z));

		g2 += u * (g1 - g2);
		g4 += u * (g3 - g4);
		g6 += u * (g5 - g6);
		g8 += u * (g7 - g8);

		g4 += v * (g2 - g4);
		g8 += v * (g6 - g8);

		return (g8 + w * (g4 - g8));
	}

	private function setSeed(seed:Int):Void
	{
		this.x_offset = seed = Std.int((seed * 16807.0) % 2147483647);
		this.y_offset = seed = Std.int((seed * 16807.0) % 2147483647);
		this.z_offset = seed = Std.int((seed * 16807.0) % 2147483647);
	}
}
