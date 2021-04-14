package openfl.geom;

#if !flash
import openfl.utils.ObjectPool;
#if lime
import lime.math.Vector2;
#end

/**
	The Point object represents a location in a two-dimensional coordinate
	system, where _x_ represents the horizontal axis and _y_
	represents the vertical axis.

	The following code creates a point at(0,0):

	Methods and properties of the following classes use Point objects:


	* BitmapData
	* DisplayObject
	* DisplayObjectContainer
	* DisplacementMapFilter
	* NativeWindow
	* Matrix
	* Rectangle


	You can use the `new Point()` constructor to create a Point
	object.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Point
{
	@:noCompletion private static var __pool:ObjectPool<Point> = new ObjectPool<Point>(function() return new Point(), function(p) p.setTo(0, 0));
	#if lime
	@:noCompletion private static var __limeVector2:Vector2;
	#end

	/**
		The length of the line segment from(0,0) to this point.
	**/
	public var length(get, never):Float;

	/**
		The horizontal coordinate of the point. The default value is 0.
	**/
	public var x:Float;

	/**
		The vertical coordinate of the point. The default value is 0.
	**/
	public var y:Float;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperty(Point.prototype, "length", {
			get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_length (); }")
		});
	}
	#end

	/**
		Creates a new point. If you pass no parameters to this method, a point is
		created at(0,0).

		@param x The horizontal coordinate.
		@param y The vertical coordinate.
	**/
	public function new(x:Float = 0, y:Float = 0)
	{
		this.x = x;
		this.y = y;
	}

	/**
		Adds the coordinates of another point to the coordinates of this point to
		create a new point.

		@param v The point to be added.
		@return The new point.
	**/
	public function add(v:Point):Point
	{
		return new Point(v.x + x, v.y + y);
	}

	/**
		Creates a copy of this Point object.

		@return The new Point object.
	**/
	public function clone():Point
	{
		return new Point(x, y);
	}

	/**
		Copies all of the point data from the source Point object into the calling Point
		object.

		@param	sourcePoint	The Point object from which to copy the data.
	**/
	public function copyFrom(sourcePoint:Point):Void
	{
		x = sourcePoint.x;
		y = sourcePoint.y;
	}

	/**
		Returns the distance between `pt1` and `pt2`.

		@param pt1 The first point.
		@param pt2 The second point.
		@return The distance between the first and second points.
	**/
	public static function distance(pt1:Point, pt2:Point):Float
	{
		var dx = pt1.x - pt2.x;
		var dy = pt1.y - pt2.y;
		return Math.sqrt(dx * dx + dy * dy);
	}

	/**
		Determines whether two points are equal. Two points are equal if they have
		the same _x_ and _y_ values.

		@param toCompare The point to be compared.
		@return A value of `true` if the object is equal to this Point
				object; `false` if it is not equal.
	**/
	public function equals(toCompare:Point):Bool
	{
		return toCompare != null && toCompare.x == x && toCompare.y == y;
	}

	/**
		Determines a point between two specified points. The parameter
		`f` determines where the new interpolated point is located
		relative to the two end points specified by parameters `pt1`
		and `pt2`. The closer the value of the parameter `f`
		is to `1.0`, the closer the interpolated point is to the first
		point(parameter `pt1`). The closer the value of the parameter
		`f` is to 0, the closer the interpolated point is to the second
		point(parameter `pt2`).

		@param pt1 The first point.
		@param pt2 The second point.
		@param f   The level of interpolation between the two points. Indicates
				   where the new point will be, along the line between
				   `pt1` and `pt2`. If `f`=1,
				   `pt1` is returned; if `f`=0,
				   `pt2` is returned.
		@return The new, interpolated point.
	**/
	public static function interpolate(pt1:Point, pt2:Point, f:Float):Point
	{
		return new Point(pt2.x + f * (pt1.x - pt2.x), pt2.y + f * (pt1.y - pt2.y));
	}

	/**
		Scales the line segment between(0,0) and the current point to a set
		length.

		@param thickness The scaling value. For example, if the current point is
						(0,5), and you normalize it to 1, the point returned is
						 at(0,1).
		@return The normalized point.
	**/
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

	/**
		Offsets the Point object by the specified amount. The value of
		`dx` is added to the original value of _x_ to create the
		new _x_ value. The value of `dy` is added to the original
		value of _y_ to create the new _y_ value.

		@param dx The amount by which to offset the horizontal coordinate,
				  _x_.
		@param dy The amount by which to offset the vertical coordinate, _y_.
	**/
	public function offset(dx:Float, dy:Float):Void
	{
		x += dx;
		y += dy;
	}

	/**
		Converts a pair of polar coordinates to a Cartesian point coordinate.

		@param len   The length coordinate of the polar pair.
		@param angle The angle, in radians, of the polar pair.
		@return The Cartesian point.
	**/
	public static function polar(len:Float, angle:Float):Point
	{
		return new Point(len * Math.cos(angle), len * Math.sin(angle));
	}

	/**
		Sets the members of Point to the specified values

		@param	xa	the values to set the point to.
		@param	ya
	**/
	public function setTo(xa:Float, ya:Float):Void
	{
		x = xa;
		y = ya;
	}

	/**
		Subtracts the coordinates of another point from the coordinates of this
		point to create a new point.

		@param v The point to be subtracted.
		@return The new point.
	**/
	public function subtract(v:Point):Point
	{
		return new Point(x - v.x, y - v.y);
	}

	/**
		Returns a string that contains the values of the _x_ and _y_
		coordinates. The string has the form `"(x=_x_,
		y=_y_)"`, so calling the `toString()` method for a
		point at 23,17 would return `"(x=23, y=17)"`.

		@return The string representation of the coordinates.
	**/
	public function toString():String
	{
		return '(x=$x, y=$y)';
	}

	#if lime
	@:noCompletion private function __toLimeVector2():Vector2
	{
		if (__limeVector2 == null)
		{
			__limeVector2 = new Vector2();
		}

		__limeVector2.setTo(x, y);
		return __limeVector2;
	}
	#end

	// Getters & Setters
	@:noCompletion private function get_length():Float
	{
		return Math.sqrt(x * x + y * y);
	}
}
#else
typedef Point = flash.geom.Point;
#end
