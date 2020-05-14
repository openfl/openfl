package openfl.geom;

#if lime
import lime.math.Vector2;
#end
import openfl._internal.utils.ObjectPool;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _Point
{
	#if lime
	private static var __limeVector2:Vector2;
	#end
	public static var __pool:ObjectPool<Point> = new ObjectPool<Point>(function() return new Point(), function(point)
	{
		point.x = 0;
		point.y = 0;
	});

	public var length(get, never):Float;
	public var x:Float;
	public var y:Float;

	private var point:Point;

	public function new(point:Point, x:Float = 0, y:Float = 0)
	{
		this.point = point;

		this.x = x;
		this.y = y;
	}

	public function add(v:Point):Point
	{
		return new Point(v.x + x, v.y + y);
	}

	public function clone():Point
	{
		return new Point(x, y);
	}

	public function copyFrom(sourcePoint:Point):Void
	{
		x = sourcePoint.x;
		y = sourcePoint.y;
	}

	public static function distance(pt1:Point, pt2:Point):Float
	{
		var dx = pt1.x - pt2.x;
		var dy = pt1.y - pt2.y;
		return Math.sqrt(dx * dx + dy * dy);
	}

	public function equals(toCompare:Point):Bool
	{
		return toCompare != null && toCompare.x == x && toCompare.y == y;
	}

	public static function interpolate(pt1:Point, pt2:Point, f:Float):Point
	{
		return new Point(pt2.x + f * (pt1.x - pt2.x), pt2.y + f * (pt1.y - pt2.y));
	}

	public function normalize(thickness:Float):Void
	{
		if (x == 0 && y == 0)
		{
			return;
		}
		else
		{
			var norm = thickness / Math.sqrt(x * x + y * y);
			x *= norm;
			y *= norm;
		}
	}

	public function offset(dx:Float, dy:Float):Void
	{
		x += dx;
		y += dy;
	}

	public static function polar(len:Float, angle:Float):Point
	{
		return new Point(len * Math.cos(angle), len * Math.sin(angle));
	}

	public function setTo(xa:Float, ya:Float):Void
	{
		x = xa;
		y = ya;
	}

	public function subtract(v:Point):Point
	{
		return new Point(x - v.x, y - v.y);
	}

	public function toString():String
	{
		return '(x=$x, y=$y)';
	}

	#if lime
	public function __toLimeVector2():Vector2
	{
		if (__limeVector2 == null)
		{
			__limeVector2 = new Vector2();
		}

		__limeVector2.setTo(x, y);
		return __limeVector2;
	}
	#end

	// Get & Set Methods

	private function get_length():Float
	{
		return Math.sqrt(x * x + y * y);
	}
}
