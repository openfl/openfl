/**

	Inspired by Stefan Gustavson, Linköping University, Sweden
	http://staffwww.itn.liu.se/~stegu/simplexnoise/simplexnoise.pdf

**/
import BitmapDataChannel from "../../display/BitmapDataChannel";
import BitmapData from "../../display/BitmapData";
import AbstractNoise from "./AbstractNoise";

export default class SimplexNoise2D extends AbstractNoise
{
	private static grad3: Array<Array<number>> = [
		[1, 1, 0], [-1, 1, 0], [1, -1, 0], [-1, -1, 0], [1, 0, 1], [-1, 0, 1], [1, 0, -1], [-1, 0, -1], [0, 1, 1], [0, -1, 1], [0, 1, -1], [0, -1, -1]];

	private static P: Array<number> = [
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

	private p_perm: Array<number>;

	public constructor(seed: number, octaves: number, channels: number, grayScale: boolean, falloff: number, stitch: boolean = false, stitch_threshold: number = 0.05)
	{
		super(seed, octaves, channels, grayScale, falloff, stitch, stitch_threshold);

		this.p_perm = [];

		for (let i = 0; i < 512; i++)
		{
			this.p_perm[i] = SimplexNoise2D.P[i & 255];
		}
	}

	public fill(bitmap: BitmapData, _scale_x: number, _scale_y: number, _scale_z: number): void
	{
		var width: number = bitmap.width;
		var height: number = bitmap.height;

		var octaves: number = this.octaves;
		var octaves_frequencies: Array<number> = this.octaves_frequencies;
		var octaves_persistences: Array<number> = this.octaves_persistences;

		var isRed: boolean = (BitmapDataChannel.RED & this.channels) == BitmapDataChannel.RED;
		var isGreen: boolean = (BitmapDataChannel.GREEN & this.channels) == BitmapDataChannel.GREEN;
		var isBlue: boolean = (BitmapDataChannel.BLUE & this.channels) == BitmapDataChannel.BLUE;

		var channels: number = 0;

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

		var grayscale: boolean = this.grayscale;

		var stitch_w: number = Math.floor(this.stitch_threshold * width);
		var stitch_h: number = Math.floor(this.stitch_threshold * height);

		for (let py = 0; py < height; py++)
		{
			var py_delta_g: number = py - 10.0;
			var py_delta_b: number = py + 10.0;

			for (let px = 0; px < width; px++)
			{
				var color1 = 0.0;
				var color2 = 0.0;
				var color3 = 0.0;

				var px_delta_g: number = px - 10.0;
				var px_delta_b: number = px + 10.0;

				for (let i = 0; i < octaves; i++)
				{
					var frequency = octaves_frequencies[i];
					var persistence = octaves_persistences[i];

					color1 += this.noise(px * (1.0 / _scale_x) * frequency, py * (1.0 / _scale_y) * frequency) * persistence;

					if (!grayscale)
					{
						if (1 < channels)
						{
							color2 += this.noise((px + px_delta_g) * (1.0 / _scale_x) * frequency,
								(py + py_delta_g) * (1.0 / _scale_y) * frequency) * persistence;
						}

						if (2 < channels)
						{
							color3 += this.noise((px + px_delta_b) * (1.0 / _scale_x) * frequency,
								(py + py_delta_b) * (1.0 / _scale_y) * frequency) * persistence;
						}
					}
				}

				var color: number = 0;

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

	protected noiseToColor(noise: number): number
	{
		return Math.floor(((noise * this.persistence_max + 1.0) * 0.5) * 255);
	}

	private noise(xin: number, yin: number): number
	{
		var n0: number, n1: number, n2: number;

		var sqrt3: number = Math.sqrt(3.0);

		var f2: number = 0.5 * (sqrt3 - 1.0);
		var s: number = (xin + yin) * f2;

		var i: number = this.fastfloor(xin + s);
		var j: number = this.fastfloor(yin + s);

		var g2: number = (3.0 - sqrt3) / 6.0;

		var t: number = (i + j) * g2;
		var X0: number = i - t;
		var Y0: number = j - t;

		var x0: number = xin - X0;
		var y0: number = yin - Y0;

		var i1: number, j1: number;

		if (x0 > y0)
		{
			i1 = 1;
			j1 = 0;
		}
		else
		{
			i1 = 0;
			j1 = 1;
		}

		var x1: number = x0 - i1 + g2;
		var y1: number = y0 - j1 + g2;
		var x2: number = x0 - 1.0 + 2.0 * g2;
		var y2: number = y0 - 1.0 + 2.0 * g2;

		var ii: number = i & 255;
		var jj: number = j & 255;

		var gi0: number = this.p_perm[ii + this.p_perm[jj]] % 12;
		var gi1: number = this.p_perm[ii + i1 + this.p_perm[jj + j1]] % 12;
		var gi2: number = this.p_perm[ii + 1 + this.p_perm[jj + 1]] % 12;

		var t0: number = 0.5 - x0 * x0 - y0 * y0;

		if (t0 < 0)
		{
			n0 = 0.0;
		}
		else
		{
			t0 *= t0;
			n0 = t0 * t0 * this.dot2d(SimplexNoise2D.grad3[gi0], x0, y0);
		}

		var t1 = 0.5 - x1 * x1 - y1 * y1;
		if (t1 < 0)
		{
			n1 = 0.0;
		}
		else
		{
			t1 *= t1;
			n1 = t1 * t1 * this.dot2d(SimplexNoise2D.grad3[gi1], x1, y1);
		}

		var t2 = 0.5 - x2 * x2 - y2 * y2;
		if (t2 < 0)
		{
			n2 = 0.0;
		}
		else
		{
			t2 *= t2;
			n2 = t2 * t2 * this.dot2d(SimplexNoise2D.grad3[gi2], x2, y2);
		}

		return 70.0 * (n0 + n1 + n2);
	}
}
