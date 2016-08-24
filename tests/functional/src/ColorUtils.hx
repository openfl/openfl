import openfl.utils.ByteArray;

typedef RGB = {
	r:Float,
	g:Float,
	b:Float
}

typedef LCHab = {
	L:Float,
	C:Float,
	H:Float,
	a:Float,
	b:Float
}

/**
 * Note: no this is not random values :)
 *
 * sRGB to RGB : http://entropymine.com/imageworsener/srgbformula/
 * RGB to XYZ : http://www.brucelindbloom.com/Eqn_RGB_to_XYZ.html
 * XYZ to Lab : http://www.brucelindbloom.com/Eqn_XYZ_to_Lab.html
 * Lab to LCH(ab) : http://www.brucelindbloom.com/Eqn_Lab_to_LCH.html
 *
 * CMC(I,c) : http://www.brucelindbloom.com/index.html?Eqn_DeltaE_CMC.html
 */
class ColorUtils {

	/**
	 * Read 4 unsigned ARGB values from `data` and returns the pixel color as LCH(ab).
	 */
	public static function RGBtoLCHab (rgb:RGB):LCHab {

		var x=0.0, y=0.0, z=0.0, L=0.0, C=0.0, H=0.0, a=0.0;

		var r = rgb.r;
		var g = rgb.g;
		var b = rgb.b;

		// rRGB to RGB
		r = r <= 0.0404482362771082 ? r/12.92 : Math.pow ((r+0.055)/1.055, 2.4);
		g = g <= 0.0404482362771082 ? g/12.92 : Math.pow ((g+0.055)/1.055, 2.4);
		b = b <= 0.0404482362771082 ? b/12.92 : Math.pow ((b+0.055)/1.055, 2.4);

		// RGB to XYZ
		x = 0.5767309 * r + 0.1855540 * g + 0.1881852 * b;
		y = 0.2973769 * r + 0.6273491 * g + 0.0752741 * b;
		z  = 0.0270343 * r +0.0706872 * g + 0.9911085 * b;

		// XYZ to Lab
		x /= 95.047;
		y /= 100.000;
		z /= 108.883;

		x = x <= 0.008856 ? (903.3 * x + 16)/116 : Math.pow (x, 1/3);
		y = y <= 0.008856 ? (903.3 * y + 16)/116 : Math.pow (y, 1/3);
		z = z <= 0.008856 ? (903.3 * z + 16)/116 : Math.pow (z, 1/3);

		L = 116 * y - 16;
		a = 500 * (x - y);
		b = 200 * (y - z);

		// Lab to LCH(ab)
		C = Math.sqrt (a * a + b * b);
		H = atan2deg(b, a);

		return { L: L, C: C, H:H, a:a, b:b };

	}

	/**
	 * Compare p2 in reference to p1.
	 *
	 * Commonly used values for acceptability are CMC(2:1) and for perceptibility are CMC(1:1).
	 */
	public static function CMC (I:Int, c:Int, p1:LCHab, p2:LCHab) {

		var dL = p1.L - p2.L;
		var dC = p1.C - p2.C;
		var da = p1.a - p2.a;
		var db = p1.b - p2.b;
		var dH = Math.sqrt (da * da + db * db - dC * dC);

		var C14 = p1.C*p1.C*p1.C*p1.C;
		var H1 = atan2deg(p1.b, p1.a);
		var T = H1 >= 164 && H1 <= 345 ? 0.56 + Math.abs (0.2 * Math.cos (H1 + 168)) : 0.36 + Math.abs (0.4 * Math.cos (H1 + 35));
		var F = Math.sqrt (C14 / (C14 + 1900));

		var SL = p1.L < 16 ? 0.511 : (0.040978 * p1.L) / (1 + 0.01765 * p1.L);
		var SC = 0.0638 * p1.C / (1 + 0.0131 * p1.C) + 0.638;
		var SH = SC * (F*T + 1 - F);

		var x = dL / (I * SL);
		var y = dC / (c * SC);
		var z = dH / SH;

		return Math.sqrt (x * x + y * y + z * z);

	}

	public static inline function atan2deg (a:Float, b:Float) {

		var v = Math.atan2 (a, b);

		if (v < 0) {
			v += 360;
		}
		else if (v > 360) {
			v -= 360;
		}

		return v;

	}

	public static function equalRGB (a:RGB, b:RGB) {

		return a.r == b.r && a.g == b.g && a.b == b.b;

	}

}
