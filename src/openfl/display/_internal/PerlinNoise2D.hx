package openfl.display._internal;

#if !flash
/**

	Inspired by Stefan Gustavson, Linköping University, Sweden
	http://staffwww.itn.liu.se/~stegu/simplexnoise/simplexnoise.pdf

**/
import openfl.display.BitmapDataChannel;
import openfl.display.BitmapData;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
class PerlinNoise2D extends AbstractNoise
{
	private static var grad3:Array<Array<Int>> = [
		[1, 1, 0], [-1, 1, 0], [1, -1, 0], [-1, -1, 0], [1, 0, 1], [-1, 0, 1], [1, 0, -1], [-1, 0, -1], [0, 1, 1], [0, -1, 1], [0, 1, -1], [0, -1, -1]];
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

	public function new(seed:Int, octaves:Int, channels:Int, grayScale:Bool, falloff:Float, stitch:Bool = false, stitch_threshold:Float = 0.05)
	{
		super(seed, octaves, channels, grayScale, falloff, stitch, stitch_threshold);

		p_perm = [];

		for (i in 0...512)
		{
			p_perm[i] = P[i & 255];
		}
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

		for (py in 0...height)
		{
			var py_delta_g:Float = py - 10.0;
			var py_delta_b:Float = py + 10.0;

			for (px in 0...width)
			{
				var color1 = 0.0;
				var color2 = 0.0;
				var color3 = 0.0;

				var px_delta_g:Float = px - 10.0;
				var px_delta_b:Float = px + 10.0;

				for (i in 0...octaves)
				{
					var frequency = octaves_frequencies[i];
					var persistence = octaves_persistences[i];

					color1 += this.noise(px * (1.0 / _scale_x) * frequency, py * (1.0 / _scale_y) * frequency, 0.0) * persistence;

					if (!grayscale)
					{
						if (1 < channels)
						{
							color2 += this.noise((px + px_delta_g) * (1.0 / _scale_x) * frequency, (py + py_delta_g) * (1.0 / _scale_y) * frequency,
								0.0) * persistence;
						}

						if (2 < channels)
						{
							color3 += this.noise((px + px_delta_b) * (1.0 / _scale_x) * frequency, (py + py_delta_b) * (1.0 / _scale_y) * frequency,
								0.0) * persistence;
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
			}
		}
	}

	override private function noiseToColor(noise:Float):Int
	{
		return Std.int(((noise * this.persistence_max + 1.0) * 0.5) * 255);
	}

	private function noise(xin:Float, yin:Float, zin:Float):Float
	{
		var X:Int = fastfloor(xin);
		var Y:Int = fastfloor(yin);
		var Z:Int = fastfloor(zin);

		var x = xin - X;
		var y = yin - Y;
		var z = zin - Z;

		var X = X & 255;
		var Y = Y & 255;
		var Z = Z & 255;

		var gi000:Int = p_perm[X + p_perm[Y + p_perm[Z]]] % 12;
		var gi001:Int = p_perm[X + p_perm[Y + p_perm[Z + 1]]] % 12;
		var gi010:Int = p_perm[X + p_perm[Y + 1 + p_perm[Z]]] % 12;
		var gi011:Int = p_perm[X + p_perm[Y + 1 + p_perm[Z + 1]]] % 12;
		var gi100:Int = p_perm[X + 1 + p_perm[Y + p_perm[Z]]] % 12;
		var gi101:Int = p_perm[X + 1 + p_perm[Y + p_perm[Z + 1]]] % 12;
		var gi110:Int = p_perm[X + 1 + p_perm[Y + 1 + p_perm[Z]]] % 12;
		var gi111:Int = p_perm[X + 1 + p_perm[Y + 1 + p_perm[Z + 1]]] % 12;

		var n000:Float = this.dot(grad3[gi000], x, y, z);
		var n100:Float = this.dot(grad3[gi100], x - 1, y, z);
		var n010:Float = this.dot(grad3[gi010], x, y - 1, z);
		var n110:Float = this.dot(grad3[gi110], x - 1, y - 1, z);
		var n001:Float = this.dot(grad3[gi001], x, y, z - 1);
		var n101:Float = this.dot(grad3[gi101], x - 1, y, z - 1);
		var n011:Float = this.dot(grad3[gi011], x, y - 1, z - 1);
		var n111:Float = this.dot(grad3[gi111], x - 1, y - 1, z - 1);

		var u:Float = this.fade(x);
		var v:Float = this.fade(y);
		var w:Float = this.fade(z);

		var nx00:Float = this.mix(n000, n100, u);
		var nx01:Float = this.mix(n001, n101, u);
		var nx10:Float = this.mix(n010, n110, u);
		var nx11:Float = this.mix(n011, n111, u);

		var nxy0:Float = this.mix(nx00, nx10, v);
		var nxy1:Float = this.mix(nx01, nx11, v);

		var nxyz:Float = this.mix(nxy0, nxy1, w);

		return nxyz;
	}
}
#end
