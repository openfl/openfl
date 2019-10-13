package openfl._internal.renderer.utils;

@SuppressWarnings("checkstyle:FieldDocComment")
class PolyK
{
	public static function triangulate(p:Array<Float>):Array<Int>
	{
		var sign = true;

		var n = p.length >> 1;
		if (n < 3) return [];

		var tgs:Array<Int> = [];
		var avl:Array<Int> = [for (i in 0...n) i];

		var i = 0;
		var al = n;
		var earFound = false;

		while (al > 3)
		{
			var i0 = avl[(i + 0) % al];
			var i1 = avl[(i + 1) % al];
			var i2 = avl[(i + 2) % al];

			var ax = p[2 * i0], ay = p[2 * i0 + 1];
			var bx = p[2 * i1], by = p[2 * i1 + 1];
			var cx = p[2 * i2], cy = p[2 * i2 + 1];

			earFound = false;

			if (PolyK._convex(ax, ay, bx, by, cx, cy, sign))
			{
				earFound = true;

				for (j in 0...al)
				{
					var vi = avl[j];
					if (vi == i0 || vi == i1 || vi == i2) continue;

					if (PolyK._PointInTriangle(p[2 * vi], p[2 * vi + 1], ax, ay, bx, by, cx, cy))
					{
						earFound = false;
						break;
					}
				}
			}

			if (earFound)
			{
				tgs.push(i0);
				tgs.push(i1);
				tgs.push(i2);
				avl.splice((i + 1) % al, 1);
				al--;
				i = 0;
			}
			else if (i++ > 3 * al)
			{
				if (sign)
				{
					tgs = [];
					avl = [for (k in 0...n) k];

					i = 0;
					al = n;
					sign = false;
				}
				else
				{
					trace("Warning: shape too complex to fill");
					return [];
				}
			}
		}

		tgs.push(avl[0]);
		tgs.push(avl[1]);
		tgs.push(avl[2]);
		return tgs;
	}

	public static function _PointInTriangle(px:Float, py:Float, ax:Float, ay:Float, bx:Float, by:Float, cx:Float, cy:Float):Bool
	{
		var v0x = Std.int(cx - ax);
		var v0y = Std.int(cy - ay);
		var v1x = Std.int(bx - ax);
		var v1y = Std.int(by - ay);
		var v2x = Std.int(px - ax);
		var v2y = Std.int(py - ay);

		var dot00 = (v0x * v0x) + (v0y * v0y);
		var dot01 = (v0x * v1x) + (v0y * v1y);
		var dot02 = (v0x * v2x) + (v0y * v2y);
		var dot11 = (v1x * v1x) + (v1y * v1y);
		var dot12 = (v1x * v2x) + (v1y * v2y);

		var invDenom = 1 / (dot00 * dot11 - dot01 * dot01);
		var u = (dot11 * dot02 - dot01 * dot12) * invDenom;
		var v = (dot00 * dot12 - dot01 * dot02) * invDenom;

		return (u >= 0) && (v >= 0) && (u + v < 1);
	}

	public static function _convex(ax:Float, ay:Float, bx:Float, by:Float, cx:Float, cy:Float, sign:Bool):Bool
	{
		return ((ay - by) * (cx - bx) + (bx - ax) * (cy - by) >= 0) == sign;
	}
}
