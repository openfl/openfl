package openfl._internal.backend.lime_standalone; #if openfl_html5

import openfl.geom.Point;
import openfl.geom.Rectangle;

// Ported from https://github.com/CreateJS/EaselJS/blob/master/src/easeljs/filters/BlurFilter.js
class StackBlur
{
	private static var MUL_TABLE:Array<Int> = [
		1, 171, 205, 293, 57, 373, 79, 137, 241, 27, 391, 357, 41, 19, 283, 265, 497, 469, 443, 421, 25, 191, 365, 349, 335, 161, 155, 149, 9, 278, 269, 261,
		505, 245, 475, 231, 449, 437, 213, 415, 405, 395, 193, 377, 369, 361, 353, 345, 169, 331, 325, 319, 313, 307, 301, 37, 145, 285, 281, 69, 271, 267,
		263, 259, 509, 501, 493, 243, 479, 118, 465, 459, 113, 446, 55, 435, 429, 423, 209, 413, 51, 403, 199, 393, 97, 3, 379, 375, 371, 367, 363, 359, 355,
		351, 347, 43, 85, 337, 333, 165, 327, 323, 5, 317, 157, 311, 77, 305, 303, 75, 297, 294, 73, 289, 287, 71, 141, 279, 277, 275, 68, 135, 67, 133, 33,
		262, 260, 129, 511, 507, 503, 499, 495, 491, 61, 121, 481, 477, 237, 235, 467, 232, 115, 457, 227, 451, 7, 445, 221, 439, 218, 433, 215, 427, 425,
		211, 419, 417, 207, 411, 409, 203, 202, 401, 399, 396, 197, 49, 389, 387, 385, 383, 95, 189, 47, 187, 93, 185, 23, 183, 91, 181, 45, 179, 89, 177, 11,
		175, 87, 173, 345, 343, 341, 339, 337, 21, 167, 83, 331, 329, 327, 163, 81, 323, 321, 319, 159, 79, 315, 313, 39, 155, 309, 307, 153, 305, 303, 151,
		75, 299, 149, 37, 295, 147, 73, 291, 145, 289, 287, 143, 285, 71, 141, 281, 35, 279, 139, 69, 275, 137, 273, 17, 271, 135, 269, 267, 133, 265, 33,
		263, 131, 261, 130, 259, 129, 257, 1
	];
	private static var SHG_TABLE:Array<Int> = [
		0, 9, 10, 11, 9, 12, 10, 11, 12, 9, 13, 13, 10, 9, 13, 13, 14, 14, 14, 14, 10, 13, 14, 14, 14, 13, 13, 13, 9, 14, 14, 14, 15, 14, 15, 14, 15, 15, 14,
		15, 15, 15, 14, 15, 15, 15, 15, 15, 14, 15, 15, 15, 15, 15, 15, 12, 14, 15, 15, 13, 15, 15, 15, 15, 16, 16, 16, 15, 16, 14, 16, 16, 14, 16, 13, 16,
		16, 16, 15, 16, 13, 16, 15, 16, 14, 9, 16, 16, 16, 16, 16, 16, 16, 16, 16, 13, 14, 16, 16, 15, 16, 16, 10, 16, 15, 16, 14, 16, 16, 14, 16, 16, 14, 16,
		16, 14, 15, 16, 16, 16, 14, 15, 14, 15, 13, 16, 16, 15, 17, 17, 17, 17, 17, 17, 14, 15, 17, 17, 16, 16, 17, 16, 15, 17, 16, 17, 11, 17, 16, 17, 16,
		17, 16, 17, 17, 16, 17, 17, 16, 17, 17, 16, 16, 17, 17, 17, 16, 14, 17, 17, 17, 17, 15, 16, 14, 16, 15, 16, 13, 16, 15, 16, 14, 16, 15, 16, 12, 16,
		15, 16, 17, 17, 17, 17, 17, 13, 16, 15, 17, 17, 17, 16, 15, 17, 17, 17, 16, 15, 17, 17, 14, 16, 17, 17, 16, 17, 17, 16, 15, 17, 16, 14, 17, 16, 15,
		17, 16, 17, 17, 16, 17, 15, 16, 17, 14, 17, 16, 15, 17, 16, 17, 13, 17, 16, 17, 17, 16, 17, 14, 17, 16, 17, 16, 17, 16, 17, 9
	];

	public static function blur(dest:Image, source:Image, sourceRect:Rectangle, destPoint:Point, blurX:Float, blurY:Float, quality:Int)
	{
		dest.copyPixels(source, sourceRect, destPoint);
		__stackBlurCanvasRGBA(dest, Std.int(sourceRect.width), Std.int(sourceRect.height), blurX, blurY, quality);
	}

	private static function __stackBlurCanvasRGBA(image:Image, width:Int, height:Int, blurX:Float, blurY:Float, quality:Int)
	{
		// TODO: Handle pixel order
		// TODO: Support blur without unmultiplying alpha

		var radiusX = Math.round(blurX) >> 1;
		var radiusY = Math.round(blurY) >> 1;

		if (MUL_TABLE == null) return; // can be null due to static initialization order
		if (radiusX >= MUL_TABLE.length) radiusX = MUL_TABLE.length - 1;
		if (radiusY >= MUL_TABLE.length) radiusY = MUL_TABLE.length - 1;
		if (radiusX < 0 || radiusY < 0) return;

		var iterations = quality;
		if (iterations < 1) iterations = 1;
		if (iterations > 3) iterations = 3;

		var px = image.data;
		var x:Int, y:Int, i:Int, p:Int, yp:Int, yi:Int, yw:Int;
		var r:Int, g:Int, b:Int, a:Int, pr:Int, pg:Int, pb:Int, pa:Int;
		var f:Float;

		var divx = (radiusX + radiusX + 1);
		var divy = (radiusY + radiusY + 1);
		var w = width;
		var h = height;

		var w1 = w - 1;
		var h1 = h - 1;
		var rxp1 = radiusX + 1;
		var ryp1 = radiusY + 1;

		var ssx = new BlurStack();
		var sx = ssx;
		for (i in 1...divx)
		{
			sx = sx.n = new BlurStack();
		}
		sx.n = ssx;

		var ssy = new BlurStack();
		var sy = ssy;
		for (i in 1...divy)
		{
			sy = sy.n = new BlurStack();
		}
		sy.n = ssy;

		var si = null;

		var mtx = MUL_TABLE[radiusX];
		var stx = SHG_TABLE[radiusX];
		var mty = MUL_TABLE[radiusY];
		var sty = SHG_TABLE[radiusY];

		while (iterations > 0)
		{
			iterations--;
			yw = yi = 0;
			var ms = mtx;
			var ss = stx;
			y = h;
			do
			{
				r = rxp1 * (pr = px[yi]);
				g = rxp1 * (pg = px[yi + 1]);
				b = rxp1 * (pb = px[yi + 2]);
				a = rxp1 * (pa = px[yi + 3]);
				sx = ssx;
				i = rxp1;
				do
				{
					sx.r = pr;
					sx.g = pg;
					sx.b = pb;
					sx.a = pa;
					sx = sx.n;
				}
				while (--i > -1);

				for (i in 1...rxp1)
				{
					p = yi + ((w1 < i ? w1 : i) << 2);
					r += (sx.r = px[p]);
					g += (sx.g = px[p + 1]);
					b += (sx.b = px[p + 2]);
					a += (sx.a = px[p + 3]);
					sx = sx.n;
				}

				si = ssx;
				for (x in 0...w)
				{
					px[yi++] = (r * ms) >>> ss;
					px[yi++] = (g * ms) >>> ss;
					px[yi++] = (b * ms) >>> ss;
					px[yi++] = (a * ms) >>> ss;
					p = (yw + ((p = x + radiusX + 1) < w1 ? p : w1)) << 2;
					r -= si.r - (si.r = px[p]);
					g -= si.g - (si.g = px[p + 1]);
					b -= si.b - (si.b = px[p + 2]);
					a -= si.a - (si.a = px[p + 3]);
					si = si.n;
				}
				yw += w;
			}
			while (--y > 0);

			ms = mty;
			ss = sty;
			for (x in 0...w)
			{
				yi = x << 2;
				r = ryp1 * (pr = px[yi]);
				g = ryp1 * (pg = px[yi + 1]);
				b = ryp1 * (pb = px[yi + 2]);
				a = ryp1 * (pa = px[yi + 3]);
				sy = ssy;
				for (i in 0...ryp1)
				{
					sy.r = pr;
					sy.g = pg;
					sy.b = pb;
					sy.a = pa;
					sy = sy.n;
				}
				yp = w;
				for (i in 1...(radiusY + 1))
				{
					yi = (yp + x) << 2;
					r += (sy.r = px[yi]);
					g += (sy.g = px[yi + 1]);
					b += (sy.b = px[yi + 2]);
					a += (sy.a = px[yi + 3]);
					sy = sy.n;
					if (i < h1)
					{
						yp += w;
					}
				}
				yi = x;
				si = ssy;

				if (iterations > 0)
				{
					for (y in 0...h)
					{
						p = yi << 2;
						px[p + 3] = pa = (a * ms) >>> ss;
						if (pa > 0)
						{
							px[p] = ((r * ms) >>> ss);
							px[p + 1] = ((g * ms) >>> ss);
							px[p + 2] = ((b * ms) >>> ss);
						}
						else
						{
							px[p] = px[p + 1] = px[p + 2] = 0;
						}
						p = (x + (((p = y + ryp1) < h1 ? p : h1) * w)) << 2;
						r -= si.r - (si.r = px[p]);
						g -= si.g - (si.g = px[p + 1]);
						b -= si.b - (si.b = px[p + 2]);
						a -= si.a - (si.a = px[p + 3]);
						si = si.n;
						yi += w;
					}
				}
				else
				{
					for (y in 0...h)
					{
						p = yi << 2;
						px[p + 3] = pa = (a * ms) >>> ss;
						if (pa > 0)
						{
							f = 255 / pa;
							pr = Std.int(((r * ms) >>> ss) * f);
							pg = Std.int(((g * ms) >>> ss) * f);
							pb = Std.int(((b * ms) >>> ss) * f);
							px[p] = pr > 255 ? 255 : pr;
							px[p + 1] = pg > 255 ? 255 : pg;
							px[p + 2] = pb > 255 ? 255 : pb;
						}
						else
						{
							px[p] = px[p + 1] = px[p + 2] = 0;
						}
						p = (x + (((p = y + ryp1) < h1 ? p : h1) * w)) << 2;
						r -= si.r - (si.r = px[p]);
						g -= si.g - (si.g = px[p + 1]);
						b -= si.b - (si.b = px[p + 2]);
						a -= si.a - (si.a = px[p + 3]);
						si = si.n;
						yi += w;
					}
				}
			}
		}
	}
}

class BlurStack
{
	public var r:Int;
	public var g:Int;
	public var b:Int;
	public var a:Int;
	public var n:BlurStack;

	public function new()
	{
		this.r = 0;
		this.g = 0;
		this.b = 0;
		this.a = 0;
		this.n = null;
	}
}
#end
