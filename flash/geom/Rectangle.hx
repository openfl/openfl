package flash.geom;
#if (flash || display)


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
extern class Rectangle {

	/**
	 * The sum of the <code>y</code> and <code>height</code> properties.
	 */
	var bottom : Float;

	/**
	 * The location of the Rectangle object's bottom-right corner, determined by
	 * the values of the <code>right</code> and <code>bottom</code> properties.
	 */
	var bottomRight : Point;

	/**
	 * The height of the rectangle, in pixels. Changing the <code>height</code>
	 * value of a Rectangle object has no effect on the <code>x</code>,
	 * <code>y</code>, and <code>width</code> properties.
	 */
	var height : Float;

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
	var left : Float;

	/**
	 * The sum of the <code>x</code> and <code>width</code> properties.
	 */
	var right : Float;

	/**
	 * The size of the Rectangle object, expressed as a Point object with the
	 * values of the <code>width</code> and <code>height</code> properties.
	 */
	var size : Point;

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
	var top : Float;

	/**
	 * The location of the Rectangle object's top-left corner, determined by the
	 * <i>x</i> and <i>y</i> coordinates of the point.
	 */
	var topLeft : Point;

	/**
	 * The width of the rectangle, in pixels. Changing the <code>width</code>
	 * value of a Rectangle object has no effect on the <code>x</code>,
	 * <code>y</code>, and <code>height</code> properties.
	 */
	var width : Float;

	/**
	 * The <i>x</i> coordinate of the top-left corner of the rectangle. Changing
	 * the value of the <code>x</code> property of a Rectangle object has no
	 * effect on the <code>y</code>, <code>width</code>, and <code>height</code>
	 * properties.
	 *
	 * <p>The value of the <code>x</code> property is equal to the value of the
	 * <code>left</code> property.</p>
	 */
	var x : Float;

	/**
	 * The <i>y</i> coordinate of the top-left corner of the rectangle. Changing
	 * the value of the <code>y</code> property of a Rectangle object has no
	 * effect on the <code>x</code>, <code>width</code>, and <code>height</code>
	 * properties.
	 *
	 * <p>The value of the <code>y</code> property is equal to the value of the
	 * <code>top</code> property.</p>
	 */
	var y : Float;

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
	function new(x : Float = 0, y : Float = 0, width : Float = 0, height : Float = 0) : Void;

	/**
	 * Returns a new Rectangle object with the same values for the
	 * <code>x</code>, <code>y</code>, <code>width</code>, and
	 * <code>height</code> properties as the original Rectangle object.
	 * 
	 * @return A new Rectangle object with the same values for the
	 *         <code>x</code>, <code>y</code>, <code>width</code>, and
	 *         <code>height</code> properties as the original Rectangle object.
	 */
	function clone() : Rectangle;

	/**
	 * Determines whether the specified point is contained within the rectangular
	 * region defined by this Rectangle object.
	 * 
	 * @param x The <i>x</i> coordinate(horizontal position) of the point.
	 * @param y The <i>y</i> coordinate(vertical position) of the point.
	 * @return A value of <code>true</code> if the Rectangle object contains the
	 *         specified point; otherwise <code>false</code>.
	 */
	function contains(x : Float, y : Float) : Bool;

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
	function containsPoint(point : Point) : Bool;

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
	function containsRect(rect : Rectangle) : Bool;
	@:require(flash11) function copyFrom(sourceRect : Rectangle) : Void;

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
	function equals(toCompare : Rectangle) : Bool;

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
	function inflate(dx : Float, dy : Float) : Void;

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
	function inflatePoint(point : Point) : Void;

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
	function intersection(toIntersect : Rectangle) : Rectangle;

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
	function intersects(toIntersect : Rectangle) : Bool;

	/**
	 * Determines whether or not this Rectangle object is empty.
	 * 
	 * @return A value of <code>true</code> if the Rectangle object's width or
	 *         height is less than or equal to 0; otherwise <code>false</code>.
	 */
	function isEmpty() : Bool;

	/**
	 * Adjusts the location of the Rectangle object, as determined by its
	 * top-left corner, by the specified amounts.
	 * 
	 * @param dx Moves the <i>x</i> value of the Rectangle object by this amount.
	 * @param dy Moves the <i>y</i> value of the Rectangle object by this amount.
	 */
	function offset(dx : Float, dy : Float) : Void;

	/**
	 * Adjusts the location of the Rectangle object using a Point object as a
	 * parameter. This method is similar to the <code>Rectangle.offset()</code>
	 * method, except that it takes a Point object as a parameter.
	 * 
	 * @param point A Point object to use to offset this Rectangle object.
	 */
	function offsetPoint(point : Point) : Void;

	/**
	 * Sets all of the Rectangle object's properties to 0. A Rectangle object is
	 * empty if its width or height is less than or equal to 0.
	 *
	 * <p> This method sets the values of the <code>x</code>, <code>y</code>,
	 * <code>width</code>, and <code>height</code> properties to 0.</p>
	 * 
	 */
	function setEmpty() : Void;
	@:require(flash11) function setTo(xa : Float, ya : Float, widtha : Float, heighta : Float) : Void;

	/**
	 * Builds and returns a string that lists the horizontal and vertical
	 * positions and the width and height of the Rectangle object.
	 * 
	 * @return A string listing the value of each of the following properties of
	 *         the Rectangle object: <code>x</code>, <code>y</code>,
	 *         <code>width</code>, and <code>height</code>.
	 */
	function toString() : String;

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
	function union(toUnion : Rectangle) : Rectangle;
}


#end
