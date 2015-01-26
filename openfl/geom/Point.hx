package openfl.geom; #if !flash #if !lime_legacy


import lime.math.Vector2;


/**
 * The Point object represents a location in a two-dimensional coordinate
 * system, where <i>x</i> represents the horizontal axis and <i>y</i>
 * represents the vertical axis.
 *
 * <p>The following code creates a point at(0,0):</p>
 *
 * <p>Methods and properties of the following classes use Point objects:</p>
 *
 * <ul>
 *   <li>BitmapData</li>
 *   <li>DisplayObject</li>
 *   <li>DisplayObjectContainer</li>
 *   <li>DisplacementMapFilter</li>
 *   <li>NativeWindow</li>
 *   <li>Matrix</li>
 *   <li>Rectangle</li>
 * </ul>
 *
 * <p>You can use the <code>new Point()</code> constructor to create a Point
 * object.</p>
 */
class Point {
	
	
	/**
	 * The length of the line segment from(0,0) to this point.
	 */
	public var length (get, null):Float;
	
	/**
	 * The horizontal coordinate of the point. The default value is 0.
	 */
	public var x:Float;
	
	/**
	 * The vertical coordinate of the point. The default value is 0.
	 */
	public var y:Float;
	
	
	/**
	 * Creates a new point. If you pass no parameters to this method, a point is
	 * created at(0,0).
	 * 
	 * @param x The horizontal coordinate.
	 * @param y The vertical coordinate.
	 */
	public function new (x:Float = 0, y:Float = 0) {
		
		this.x = x;
		this.y = y;
		
	}
	
	
	/**
	 * Adds the coordinates of another point to the coordinates of this point to
	 * create a new point.
	 * 
	 * @param v The point to be added.
	 * @return The new point.
	 */
	public function add (v:Point):Point {
		
		return new Point (v.x + x, v.y + y);
		
	}
	
	
	/**
	 * Creates a copy of this Point object.
	 * 
	 * @return The new Point object.
	 */
	public function clone ():Point {
		
		return new Point (x, y);
		
	}
	
	
	public function copyFrom (sourcePoint:Point):Void {
		
		x = sourcePoint.x;
		y = sourcePoint.y;
		
	}
	
	
	/**
	 * Returns the distance between <code>pt1</code> and <code>pt2</code>.
	 * 
	 * @param pt1 The first point.
	 * @param pt2 The second point.
	 * @return The distance between the first and second points.
	 */
	public static function distance (pt1:Point, pt2:Point):Float {
		
		var dx = pt1.x - pt2.x;
		var dy = pt1.y - pt2.y;
		return Math.sqrt (dx * dx + dy * dy);
		
	}
	
	
	/**
	 * Determines whether two points are equal. Two points are equal if they have
	 * the same <i>x</i> and <i>y</i> values.
	 * 
	 * @param toCompare The point to be compared.
	 * @return A value of <code>true</code> if the object is equal to this Point
	 *         object; <code>false</code> if it is not equal.
	 */
	public function equals (toCompare:Point):Bool {
		
		return toCompare != null && toCompare.x == x && toCompare.y == y;
		
	}
	
	
	/**
	 * Determines a point between two specified points. The parameter
	 * <code>f</code> determines where the new interpolated point is located
	 * relative to the two end points specified by parameters <code>pt1</code>
	 * and <code>pt2</code>. The closer the value of the parameter <code>f</code>
	 * is to <code>1.0</code>, the closer the interpolated point is to the first
	 * point(parameter <code>pt1</code>). The closer the value of the parameter
	 * <code>f</code> is to 0, the closer the interpolated point is to the second
	 * point(parameter <code>pt2</code>).
	 * 
	 * @param pt1 The first point.
	 * @param pt2 The second point.
	 * @param f   The level of interpolation between the two points. Indicates
	 *            where the new point will be, along the line between
	 *            <code>pt1</code> and <code>pt2</code>. If <code>f</code>=1,
	 *            <code>pt1</code> is returned; if <code>f</code>=0,
	 *            <code>pt2</code> is returned.
	 * @return The new, interpolated point.
	 */
	public static function interpolate (pt1:Point, pt2:Point, f:Float):Point {
		
		return new Point (pt2.x + f * (pt1.x - pt2.x), pt2.y + f * (pt1.y - pt2.y));
		
	}
	
	
	/**
	 * Scales the line segment between(0,0) and the current point to a set
	 * length.
	 * 
	 * @param thickness The scaling value. For example, if the current point is
	 *                 (0,5), and you normalize it to 1, the point returned is
	 *                  at(0,1).
	 * @return The normalized point.
	 */
	public function normalize (thickness:Float):Void {
		
		if (x == 0 && y == 0) {
			
			return;
			
		} else {
			
			var norm = thickness / Math.sqrt (x * x + y * y);
			x *= norm;
			y *= norm;
			
		}
		
	}
	
	
	/**
	 * Offsets the Point object by the specified amount. The value of
	 * <code>dx</code> is added to the original value of <i>x</i> to create the
	 * new <i>x</i> value. The value of <code>dy</code> is added to the original
	 * value of <i>y</i> to create the new <i>y</i> value.
	 * 
	 * @param dx The amount by which to offset the horizontal coordinate,
	 *           <i>x</i>.
	 * @param dy The amount by which to offset the vertical coordinate, <i>y</i>.
	 */
	public function offset (dx:Float, dy:Float):Void {
		
		x += dx;
		y += dy;
		
	}
	
	
	/**
	 * Converts a pair of polar coordinates to a Cartesian point coordinate.
	 * 
	 * @param len   The length coordinate of the polar pair.
	 * @param angle The angle, in radians, of the polar pair.
	 * @return The Cartesian point.
	 */
	public static function polar (len:Float, angle:Float):Point {
		
		return new Point (len * Math.cos (angle), len * Math.sin (angle));
		
	}
	
	
	public inline function setTo (xa:Float, ya:Float):Void {	
		
		x = xa;
		y = ya;
	}
	
	
	/**
	 * Subtracts the coordinates of another point from the coordinates of this
	 * point to create a new point.
	 * 
	 * @param v The point to be subtracted.
	 * @return The new point.
	 */
	public function subtract (v:Point):Point {
		
		return new Point (x - v.x, y - v.y);
		
	}
	
	
	/**
	 * Returns a string that contains the values of the <i>x</i> and <i>y</i>
	 * coordinates. The string has the form <code>"(x=<i>x</i>,
	 * y=<i>y</i>)"</code>, so calling the <code>toString()</code> method for a
	 * point at 23,17 would return <code>"(x=23, y=17)"</code>.
	 * 
	 * @return The string representation of the coordinates.
	 */
	public function toString ():String {
		
		return "(x=" + x + ", y=" + y + ")";
		
	}
	
	
	@:noCompletion private function __toLimeVector2 ():Vector2 {
		
		return new Vector2 (x, y);
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	@:noCompletion private function get_length ():Float {
		
		return Math.sqrt (x * x + y * y);
		
	}
	
	
}


#else
typedef Point = openfl._v2.geom.Point;
#end
#else
typedef Point = flash.geom.Point;
#end
