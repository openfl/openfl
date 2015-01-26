package openfl.geom; #if !flash #if !lime_legacy


import lime.math.Rectangle in LimeRectangle;


/**
 * A Rectangle object is an area defined by its position, as indicated by its
 * top-left corner point(<i>x</i>, <i>y</i>) and by its width and its height.
 *
 *
 * <p>The <code>x</code>, <code>y</code>, <code>width</code>, and
 * <code>height</code> properties of the Rectangle class are independent of
 * each other; changing the value of one property has no effect on the others.
 * However, the <code>right</code> and <code>bottom</code> properties are
 * integrally related to those four properties. For example, if you change the
 * value of the <code>right</code> property, the value of the
 * <code>width</code> property changes; if you change the <code>bottom</code>
 * property, the value of the <code>height</code> property changes. </p>
 *
 * <p>The following methods and properties use Rectangle objects:</p>
 *
 * <ul>
 *   <li>The <code>applyFilter()</code>, <code>colorTransform()</code>,
 * <code>copyChannel()</code>, <code>copyPixels()</code>, <code>draw()</code>,
 * <code>fillRect()</code>, <code>generateFilterRect()</code>,
 * <code>getColorBoundsRect()</code>, <code>getPixels()</code>,
 * <code>merge()</code>, <code>paletteMap()</code>,
 * <code>pixelDisolve()</code>, <code>setPixels()</code>, and
 * <code>threshold()</code> methods, and the <code>rect</code> property of the
 * BitmapData class</li>
 *   <li>The <code>getBounds()</code> and <code>getRect()</code> methods, and
 * the <code>scrollRect</code> and <code>scale9Grid</code> properties of the
 * DisplayObject class</li>
 *   <li>The <code>getCharBoundaries()</code> method of the TextField
 * class</li>
 *   <li>The <code>pixelBounds</code> property of the Transform class</li>
 *   <li>The <code>bounds</code> parameter for the <code>startDrag()</code>
 * method of the Sprite class</li>
 *   <li>The <code>printArea</code> parameter of the <code>addPage()</code>
 * method of the PrintJob class</li>
 * </ul>
 *
 * <p>You can use the <code>new Rectangle()</code> constructor to create a
 * Rectangle object.</p>
 *
 * <p><b>Note:</b> The Rectangle class does not define a rectangular Shape
 * display object. To draw a rectangular Shape object onscreen, use the
 * <code>drawRect()</code> method of the Graphics class.</p>
 */
class Rectangle {
	
	
	/**
	 * The sum of the <code>y</code> and <code>height</code> properties.
	 */
	public var bottom (get, set):Float;
	
	/**
	 * The location of the Rectangle object's bottom-right corner, determined by
	 * the values of the <code>right</code> and <code>bottom</code> properties.
	 */
	public var bottomRight (get, set):Point;
	
	/**
	 * The height of the rectangle, in pixels. Changing the <code>height</code>
	 * value of a Rectangle object has no effect on the <code>x</code>,
	 * <code>y</code>, and <code>width</code> properties.
	 */
	public var height:Float;
	
	/**
	 * The <i>x</i> coordinate of the top-left corner of the rectangle. Changing
	 * the <code>left</code> property of a Rectangle object has no effect on the
	 * <code>y</code> and <code>height</code> properties. However it does affect
	 * the <code>width</code> property, whereas changing the <code>x</code> value
	 * does <i>not</i> affect the <code>width</code> property.
	 *
	 * <p>The value of the <code>left</code> property is equal to the value of
	 * the <code>x</code> property.</p>
	 */
	public var left (get, set):Float;
	
	/**
	 * The sum of the <code>x</code> and <code>width</code> properties.
	 */
	public var right (get, set):Float;
	
	/**
	 * The size of the Rectangle object, expressed as a Point object with the
	 * values of the <code>width</code> and <code>height</code> properties.
	 */
	public var size (get, set):Point;
	
	/**
	 * The <i>y</i> coordinate of the top-left corner of the rectangle. Changing
	 * the <code>top</code> property of a Rectangle object has no effect on the
	 * <code>x</code> and <code>width</code> properties. However it does affect
	 * the <code>height</code> property, whereas changing the <code>y</code>
	 * value does <i>not</i> affect the <code>height</code> property.
	 *
	 * <p>The value of the <code>top</code> property is equal to the value of the
	 * <code>y</code> property.</p>
	 */
	public var top (get, set):Float;
	
	/**
	 * The location of the Rectangle object's top-left corner, determined by the
	 * <i>x</i> and <i>y</i> coordinates of the point.
	 */
	public var topLeft (get, set):Point;
	
	/**
	 * The width of the rectangle, in pixels. Changing the <code>width</code>
	 * value of a Rectangle object has no effect on the <code>x</code>,
	 * <code>y</code>, and <code>height</code> properties.
	 */
	public var width:Float;
	
	/**
	 * The <i>x</i> coordinate of the top-left corner of the rectangle. Changing
	 * the value of the <code>x</code> property of a Rectangle object has no
	 * effect on the <code>y</code>, <code>width</code>, and <code>height</code>
	 * properties.
	 *
	 * <p>The value of the <code>x</code> property is equal to the value of the
	 * <code>left</code> property.</p>
	 */
	public var x:Float;
	
	/**
	 * The <i>y</i> coordinate of the top-left corner of the rectangle. Changing
	 * the value of the <code>y</code> property of a Rectangle object has no
	 * effect on the <code>x</code>, <code>width</code>, and <code>height</code>
	 * properties.
	 *
	 * <p>The value of the <code>y</code> property is equal to the value of the
	 * <code>top</code> property.</p>
	 */
	public var y:Float;
	
	
	/**
	 * Creates a new Rectangle object with the top-left corner specified by the
	 * <code>x</code> and <code>y</code> parameters and with the specified
	 * <code>width</code> and <code>height</code> parameters. If you call this
	 * function without parameters, a rectangle with <code>x</code>,
	 * <code>y</code>, <code>width</code>, and <code>height</code> properties set
	 * to 0 is created.
	 * 
	 * @param x      The <i>x</i> coordinate of the top-left corner of the
	 *               rectangle.
	 * @param y      The <i>y</i> coordinate of the top-left corner of the
	 *               rectangle.
	 * @param width  The width of the rectangle, in pixels.
	 * @param height The height of the rectangle, in pixels.
	 */
	public function new (x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0):Void {
		
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		
	}
	
	
	/**
	 * Returns a new Rectangle object with the same values for the
	 * <code>x</code>, <code>y</code>, <code>width</code>, and
	 * <code>height</code> properties as the original Rectangle object.
	 * 
	 * @return A new Rectangle object with the same values for the
	 *         <code>x</code>, <code>y</code>, <code>width</code>, and
	 *         <code>height</code> properties as the original Rectangle object.
	 */
	public function clone ():Rectangle {
		
		return new Rectangle (x, y, width, height);
		
	}
	
	
	/**
	 * Determines whether the specified point is contained within the rectangular
	 * region defined by this Rectangle object.
	 * 
	 * @param x The <i>x</i> coordinate(horizontal position) of the point.
	 * @param y The <i>y</i> coordinate(vertical position) of the point.
	 * @return A value of <code>true</code> if the Rectangle object contains the
	 *         specified point; otherwise <code>false</code>.
	 */
	public function contains (x:Float, y:Float):Bool {
		
		return x >= this.x && y >= this.y && x < right && y < bottom;
		
	}
	
	
	/**
	 * Determines whether the specified point is contained within the rectangular
	 * region defined by this Rectangle object. This method is similar to the
	 * <code>Rectangle.contains()</code> method, except that it takes a Point
	 * object as a parameter.
	 * 
	 * @param point The point, as represented by its <i>x</i> and <i>y</i>
	 *              coordinates.
	 * @return A value of <code>true</code> if the Rectangle object contains the
	 *         specified point; otherwise <code>false</code>.
	 */
	public function containsPoint (point:Point):Bool {
		
		return contains (point.x, point.y);
		
	}
	
	
	/**
	 * Determines whether the Rectangle object specified by the <code>rect</code>
	 * parameter is contained within this Rectangle object. A Rectangle object is
	 * said to contain another if the second Rectangle object falls entirely
	 * within the boundaries of the first.
	 * 
	 * @param rect The Rectangle object being checked.
	 * @return A value of <code>true</code> if the Rectangle object that you
	 *         specify is contained by this Rectangle object; otherwise
	 *         <code>false</code>.
	 */
	public function containsRect (rect:Rectangle):Bool {
		
		if (rect.width <= 0 || rect.height <= 0) {
			
			return rect.x > x && rect.y > y && rect.right < right && rect.bottom < bottom;
			
		} else {
			
			return rect.x >= x && rect.y >= y && rect.right <= right && rect.bottom <= bottom;
			
		}
		
	}
	
	
	public function copyFrom (sourceRect:Rectangle):Void {
		
		x = sourceRect.x;
		y = sourceRect.y;
		width = sourceRect.width;
		height = sourceRect.height;
		
	}
	
	
	/**
	 * Determines whether the object specified in the <code>toCompare</code>
	 * parameter is equal to this Rectangle object. This method compares the
	 * <code>x</code>, <code>y</code>, <code>width</code>, and
	 * <code>height</code> properties of an object against the same properties of
	 * this Rectangle object.
	 * 
	 * @param toCompare The rectangle to compare to this Rectangle object.
	 * @return A value of <code>true</code> if the object has exactly the same
	 *         values for the <code>x</code>, <code>y</code>, <code>width</code>,
	 *         and <code>height</code> properties as this Rectangle object;
	 *         otherwise <code>false</code>.
	 */
	public function equals (toCompare:Rectangle):Bool {
		
		return toCompare != null && x == toCompare.x && y == toCompare.y && width == toCompare.width && height == toCompare.height;
		
	}
	
	
	/**
	 * Increases the size of the Rectangle object by the specified amounts, in
	 * pixels. The center point of the Rectangle object stays the same, and its
	 * size increases to the left and right by the <code>dx</code> value, and to
	 * the top and the bottom by the <code>dy</code> value.
	 * 
	 * @param dx The value to be added to the left and the right of the Rectangle
	 *           object. The following equation is used to calculate the new
	 *           width and position of the rectangle:
	 * @param dy The value to be added to the top and the bottom of the
	 *           Rectangle. The following equation is used to calculate the new
	 *           height and position of the rectangle:
	 */
	public function inflate (dx:Float, dy:Float):Void {
		
		x -= dx; width += dx * 2;
		y -= dy; height += dy * 2;
		
	}
	
	
	/**
	 * Increases the size of the Rectangle object. This method is similar to the
	 * <code>Rectangle.inflate()</code> method except it takes a Point object as
	 * a parameter.
	 *
	 * <p>The following two code examples give the same result:</p>
	 * 
	 * @param point The <code>x</code> property of this Point object is used to
	 *              increase the horizontal dimension of the Rectangle object.
	 *              The <code>y</code> property is used to increase the vertical
	 *              dimension of the Rectangle object.
	 */
	public function inflatePoint (point:Point):Void {
		
		inflate (point.x, point.y);
		
	}
	
	
	/**
	 * If the Rectangle object specified in the <code>toIntersect</code>
	 * parameter intersects with this Rectangle object, returns the area of
	 * intersection as a Rectangle object. If the rectangles do not intersect,
	 * this method returns an empty Rectangle object with its properties set to
	 * 0.
	 * 
	 * @param toIntersect The Rectangle object to compare against to see if it
	 *                    intersects with this Rectangle object.
	 * @return A Rectangle object that equals the area of intersection. If the
	 *         rectangles do not intersect, this method returns an empty
	 *         Rectangle object; that is, a rectangle with its <code>x</code>,
	 *         <code>y</code>, <code>width</code>, and <code>height</code>
	 *         properties set to 0.
	 */
	public function intersection (toIntersect:Rectangle):Rectangle {
		
		var x0 = x < toIntersect.x ? toIntersect.x : x;
		var x1 = right > toIntersect.right ? toIntersect.right : right;
		
		if (x1 <= x0) {
			
			return new Rectangle ();
			
		}
		
		var y0 = y < toIntersect.y ? toIntersect.y : y;
		var y1 = bottom > toIntersect.bottom ? toIntersect.bottom : bottom;
		
		if (y1 <= y0) {
			
			return new Rectangle ();
			
		}
		
		return new Rectangle (x0, y0, x1 - x0, y1 - y0);
		
	}
	
	
	/**
	 * Determines whether the object specified in the <code>toIntersect</code>
	 * parameter intersects with this Rectangle object. This method checks the
	 * <code>x</code>, <code>y</code>, <code>width</code>, and
	 * <code>height</code> properties of the specified Rectangle object to see if
	 * it intersects with this Rectangle object.
	 * 
	 * @param toIntersect The Rectangle object to compare against this Rectangle
	 *                    object.
	 * @return A value of <code>true</code> if the specified object intersects
	 *         with this Rectangle object; otherwise <code>false</code>.
	 */
	public function intersects (toIntersect:Rectangle):Bool {
		
		var x0 = x < toIntersect.x ? toIntersect.x : x;
		var x1 = right > toIntersect.right ? toIntersect.right : right;
		
		if (x1 <= x0) {
			
			return false;
			
		}
		
		var y0 = y < toIntersect.y ? toIntersect.y : y;
		var y1 = bottom > toIntersect.bottom ? toIntersect.bottom : bottom;
		
		return y1 > y0;
		
	}
	
	
	/**
	 * Determines whether or not this Rectangle object is empty.
	 * 
	 * @return A value of <code>true</code> if the Rectangle object's width or
	 *         height is less than or equal to 0; otherwise <code>false</code>.
	 */
	public function isEmpty ():Bool {
		
		return (width <= 0 || height <= 0);
		
	}
	
	
	/**
	 * Adjusts the location of the Rectangle object, as determined by its
	 * top-left corner, by the specified amounts.
	 * 
	 * @param dx Moves the <i>x</i> value of the Rectangle object by this amount.
	 * @param dy Moves the <i>y</i> value of the Rectangle object by this amount.
	 */
	public function offset (dx:Float, dy:Float):Void {
		
		x += dx;
		y += dy;
		
	}
	
	
	/**
	 * Adjusts the location of the Rectangle object using a Point object as a
	 * parameter. This method is similar to the <code>Rectangle.offset()</code>
	 * method, except that it takes a Point object as a parameter.
	 * 
	 * @param point A Point object to use to offset this Rectangle object.
	 */
	public function offsetPoint (point:Point):Void {
		
		x += point.x;
		y += point.y;
		
	}
	
	
	/**
	 * Sets all of the Rectangle object's properties to 0. A Rectangle object is
	 * empty if its width or height is less than or equal to 0.
	 *
	 * <p> This method sets the values of the <code>x</code>, <code>y</code>,
	 * <code>width</code>, and <code>height</code> properties to 0.</p>
	 * 
	 */
	public function setEmpty ():Void {
		
		x = y = width = height = 0;
		
	}
	
	
	public function setTo (xa:Float, ya:Float, widtha:Float, heighta:Float):Void {
		
		x = xa;
		y = ya;
		width = widtha;
		height = heighta;
		
	}
	
	
	public function transform (m:Matrix):Rectangle {
		
		var tx0 = m.a * x + m.c * y;
		var tx1 = tx0;
		var ty0 = m.b * x + m.d * y;
		var ty1 = tx0;

		var tx = m.a * (x + width) + m.c * y;
		var ty = m.b * (x + width) + m.d * y;
		
		if (tx < tx0) tx0 = tx;
		if (ty < ty0) ty0 = ty;
		if (tx > tx1) tx1 = tx;
		if (ty > ty1) ty1 = ty;
		
		tx = m.a * (x + width) + m.c * (y + height);
		ty = m.b * (x + width) + m.d * (y + height);
		
		if (tx < tx0) tx0 = tx;
		if (ty < ty0) ty0 = ty;
		if (tx > tx1) tx1 = tx;
		if (ty > ty1) ty1 = ty;

		tx = m.a * x + m.c * (y + height);
		ty = m.b * x + m.d * (y + height);
		
		if (tx < tx0) tx0 = tx;
		if (ty < ty0) ty0 = ty;
		if (tx > tx1) tx1 = tx;
		if (ty > ty1) ty1 = ty;
		
		return new Rectangle (tx0 + m.tx, ty0 + m.ty, tx1 - tx0, ty1 - ty0);
		
	}
	
	
	/**
	 * Adds two rectangles together to create a new Rectangle object, by filling
	 * in the horizontal and vertical space between the two rectangles.
	 *
	 * <p><b>Note:</b> The <code>union()</code> method ignores rectangles with
	 * <code>0</code> as the height or width value, such as: <code>var
	 * rect2:Rectangle = new Rectangle(300,300,50,0);</code></p>
	 * 
	 * @param toUnion A Rectangle object to add to this Rectangle object.
	 * @return A new Rectangle object that is the union of the two rectangles.
	 */
	public function union (toUnion:Rectangle):Rectangle {
		
		if (width == 0 || height == 0) {
			
			return toUnion.clone ();
			
		} else if (toUnion.width == 0 || toUnion.height == 0) {
			
			return clone ();
			
		}
		
		var x0 = x > toUnion.x ? toUnion.x : x;
		var x1 = right < toUnion.right ? toUnion.right : right;
		var y0 = y > toUnion.y ? toUnion.y : y;
		var y1 = bottom < toUnion.bottom ? toUnion.bottom : bottom;
		
		return new Rectangle (x0, y0, x1 - x0, y1 - y0);
		
	}
	
	
	@:noCompletion public function __contract (x:Float, y:Float, width:Float, height:Float):Void {
		
		if (this.width == 0 && this.height == 0) {
			
			return;
			
		}
		
		var cacheRight = right;
		var cacheBottom = bottom;
		
		if (this.x < x) this.x = x;
		if (this.y < y) this.y = y;
		if (this.right > x + width) this.width = x + width - this.x;
		if (this.bottom > y + height) this.height = y + height - this.y;
		
	}
	
	
	@:noCompletion public function __expand (x:Float, y:Float, width:Float, height:Float):Void {
		
		if (this.width == 0 && this.height == 0) {
			
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			return;
			
		}
		
		var cacheRight = right;
		var cacheBottom = bottom;
		
		if (this.x > x)
		{
			this.x = x;
			this.width = cacheRight - x;
		}
		if (this.y > y)
		{
			this.y = y;
			this.height = cacheBottom - y;
		}
		if (cacheRight < x + width) this.width = x + width - this.x;
		if (cacheBottom < y + height) this.height = y + height - this.y;
		
	}
	
	
	@:noCompletion private function __toLimeRectangle ():LimeRectangle {
		
		return new LimeRectangle (x, y, width, height);
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	@:noCompletion private function get_bottom ():Float { return y + height; }
	@:noCompletion private function set_bottom (b:Float):Float { height = b - y; return b; }
	@:noCompletion private function get_bottomRight ():Point { return new Point (x + width, y + height); }
	@:noCompletion private function set_bottomRight (p:Point):Point { width = p.x - x; height = p.y - y; return p.clone (); }
	@:noCompletion private function get_left ():Float { return x; }
	@:noCompletion private function set_left (l:Float):Float { width -= l - x; x = l; return l; }
	@:noCompletion private function get_right ():Float { return x + width; }
	@:noCompletion private function set_right (r:Float):Float { width = r - x; return r; }
	@:noCompletion private function get_size ():Point { return new Point (width, height); }
	@:noCompletion private function set_size (p:Point):Point { width = p.x; height = p.y; return p.clone (); }
	@:noCompletion private function get_top ():Float { return y; }
	@:noCompletion private function set_top (t:Float):Float { height -= t - y; y = t; return t; }
	@:noCompletion private function get_topLeft ():Point { return new Point (x, y); }
	@:noCompletion private function set_topLeft (p:Point):Point { x = p.x; y = p.y; return p.clone (); }
	
	
}


#else
typedef Rectangle = openfl._v2.geom.Rectangle;
#end
#else
typedef Rectangle = flash.geom.Rectangle;
#end