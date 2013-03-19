package flash.geom;
#if (flash || display)


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
extern class Point {

	/**
	 * The length of the line segment from(0,0) to this point.
	 */
	var length(default,null) : Float;

	/**
	 * The horizontal coordinate of the point. The default value is 0.
	 */
	var x : Float;

	/**
	 * The vertical coordinate of the point. The default value is 0.
	 */
	var y : Float;

	/**
	 * Creates a new point. If you pass no parameters to this method, a point is
	 * created at(0,0).
	 * 
	 * @param x The horizontal coordinate.
	 * @param y The vertical coordinate.
	 */
	function new(x : Float = 0, y : Float = 0) : Void;

	/**
	 * Adds the coordinates of another point to the coordinates of this point to
	 * create a new point.
	 * 
	 * @param v The point to be added.
	 * @return The new point.
	 */
	function add(v : Point) : Point;

	/**
	 * Creates a copy of this Point object.
	 * 
	 * @return The new Point object.
	 */
	function clone() : Point;
	@:require(flash11) function copyFrom(sourcePoint : Point) : Void;

	/**
	 * Determines whether two points are equal. Two points are equal if they have
	 * the same <i>x</i> and <i>y</i> values.
	 * 
	 * @param toCompare The point to be compared.
	 * @return A value of <code>true</code> if the object is equal to this Point
	 *         object; <code>false</code> if it is not equal.
	 */
	function equals(toCompare : Point) : Bool;

	/**
	 * Scales the line segment between(0,0) and the current point to a set
	 * length.
	 * 
	 * @param thickness The scaling value. For example, if the current point is
	 *                 (0,5), and you normalize it to 1, the point returned is
	 *                  at(0,1).
	 * @return The normalized point.
	 */
	function normalize(thickness : Float) : Void;

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
	function offset(dx : Float, dy : Float) : Void;
	@:require(flash11) function setTo(xa : Float, ya : Float) : Void;

	/**
	 * Subtracts the coordinates of another point from the coordinates of this
	 * point to create a new point.
	 * 
	 * @param v The point to be subtracted.
	 * @return The new point.
	 */
	function subtract(v : Point) : Point;

	/**
	 * Returns a string that contains the values of the <i>x</i> and <i>y</i>
	 * coordinates. The string has the form <code>"(x=<i>x</i>,
	 * y=<i>y</i>)"</code>, so calling the <code>toString()</code> method for a
	 * point at 23,17 would return <code>"(x=23, y=17)"</code>.
	 * 
	 * @return The string representation of the coordinates.
	 */
	function toString() : String;

	/**
	 * Returns the distance between <code>pt1</code> and <code>pt2</code>.
	 * 
	 * @param pt1 The first point.
	 * @param pt2 The second point.
	 * @return The distance between the first and second points.
	 */
	static function distance(pt1 : Point, pt2 : Point) : Float;

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
	static function interpolate(pt1 : Point, pt2 : Point, f : Float) : Point;

	/**
	 * Converts a pair of polar coordinates to a Cartesian point coordinate.
	 * 
	 * @param len   The length coordinate of the polar pair.
	 * @param angle The angle, in radians, of the polar pair.
	 * @return The Cartesian point.
	 */
	static function polar(len : Float, angle : Float) : Point;
}


#end
