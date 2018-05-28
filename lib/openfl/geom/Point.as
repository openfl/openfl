package openfl.geom {
	
	
	/**
	 * @externs
	 * The Point object represents a location in a two-dimensional coordinate
	 * system, where _x_ represents the horizontal axis and _y_
	 * represents the vertical axis.
	 *
	 * The following code creates a point at(0,0):
	 *
	 * Methods and properties of the following classes use Point objects:
	 *
	 * 
	 *  * BitmapData
	 *  * DisplayObject
	 *  * DisplayObjectContainer
	 *  * DisplacementMapFilter
	 *  * NativeWindow
	 *  * Matrix
	 *  * Rectangle
	 * 
	 *
	 * You can use the `new Point()` constructor to create a Point
	 * object.
	 */
	public class Point {
		
		
		/**
		 * The length of the line segment from(0,0) to this point.
		 */
		public function get length ():Number { return 0; }
		
		protected function get_length ():Number { return 0; }
		
		/**
		 * The horizontal coordinate of the point. The default value is 0.
		 */
		public var x:Number;
		
		/**
		 * The vertical coordinate of the point. The default value is 0.
		 */
		public var y:Number;
		
		
		/**
		 * Creates a new point. If you pass no parameters to this method, a point is
		 * created at(0,0).
		 * 
		 * @param x The horizontal coordinate.
		 * @param y The vertical coordinate.
		 */
		public function Point (x:Number = 0, y:Number = 0) {}
		
		
		/**
		 * Adds the coordinates of another point to the coordinates of this point to
		 * create a new point.
		 * 
		 * @param v The point to be added.
		 * @return The new point.
		 */
		public function add (v:Point):Point { return null; }
		
		
		/**
		 * Creates a copy of this Point object.
		 * 
		 * @return The new Point object.
		 */
		public function clone ():Point { return null; }
		
		
		public function copyFrom (sourcePoint:Point):void {}
		
		
		/**
		 * Returns the distance between `pt1` and `pt2`.
		 * 
		 * @param pt1 The first point.
		 * @param pt2 The second point.
		 * @return The distance between the first and second points.
		 */
		public static function distance (pt1:Point, pt2:Point):Number { return 0; }
		
		
		/**
		 * Determines whether two points are equal. Two points are equal if they have
		 * the same _x_ and _y_ values.
		 * 
		 * @param toCompare The point to be compared.
		 * @return A value of `true` if the object is equal to this Point
		 *         object; `false` if it is not equal.
		 */
		public function equals (toCompare:Point):Boolean { return false; }
		
		
		/**
		 * Determines a point between two specified points. The parameter
		 * `f` determines where the new interpolated point is located
		 * relative to the two end points specified by parameters `pt1`
		 * and `pt2`. The closer the value of the parameter `f`
		 * is to `1.0`, the closer the interpolated point is to the first
		 * point(parameter `pt1`). The closer the value of the parameter
		 * `f` is to 0, the closer the interpolated point is to the second
		 * point(parameter `pt2`).
		 * 
		 * @param pt1 The first point.
		 * @param pt2 The second point.
		 * @param f   The level of interpolation between the two points. Indicates
		 *            where the new point will be, along the line between
		 *            `pt1` and `pt2`. If `f`=1,
		 *            `pt1` is returned; if `f`=0,
		 *            `pt2` is returned.
		 * @return The new, interpolated point.
		 */
		public static function interpolate (pt1:Point, pt2:Point, f:Number):Point { return null; }
		
		
		/**
		 * Scales the line segment between(0,0) and the current point to a set
		 * length.
		 * 
		 * @param thickness The scaling value. For example, if the current point is
		 *                 (0,5), and you normalize it to 1, the point returned is
		 *                  at(0,1).
		 * @return The normalized point.
		 */
		public function normalize (thickness:Number):void {}
		
		
		/**
		 * Offsets the Point object by the specified amount. The value of
		 * `dx` is added to the original value of _x_ to create the
		 * new _x_ value. The value of `dy` is added to the original
		 * value of _y_ to create the new _y_ value.
		 * 
		 * @param dx The amount by which to offset the horizontal coordinate,
		 *           _x_.
		 * @param dy The amount by which to offset the vertical coordinate, _y_.
		 */
		public function offset (dx:Number, dy:Number):void {}
		
		
		/**
		 * Converts a pair of polar coordinates to a Cartesian point coordinate.
		 * 
		 * @param len   The length coordinate of the polar pair.
		 * @param angle The angle, in radians, of the polar pair.
		 * @return The Cartesian point.
		 */
		public static function polar (len:Number, angle:Number):Point { return null; }
		
		
		//public inline function setTo (xa:Number, ya:Number):void;
		public function setTo (xa:Number, ya:Number):void {}
		
		
		/**
		 * Subtracts the coordinates of another point from the coordinates of this
		 * point to create a new point.
		 * 
		 * @param v The point to be subtracted.
		 * @return The new point.
		 */
		public function subtract (v:Point):Point { return null; }
		
		
		/**
		 * Returns a string that contains the values of the _x_ and _y_
		 * coordinates. The string has the form `"(x=_x_,
		 * y=_y_)"`, so calling the `toString()` method for a
		 * point at 23,17 would return `"(x=23, y=17)"`.
		 * 
		 * @return The string representation of the coordinates.
		 */
		public function toString ():String { return null; }
		
		
	}
	
	
}