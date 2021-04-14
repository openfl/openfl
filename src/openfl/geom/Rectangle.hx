package openfl.geom;

#if !flash
import openfl.utils.ObjectPool;
#if lime
import lime.math.Rectangle as LimeRectangle;
#end

/**
	A Rectangle object is an area defined by its position, as indicated by its
	top-left corner point(_x_, _y_) and by its width and its height.


	The `x`, `y`, `width`, and
	`height` properties of the Rectangle class are independent of
	each other; changing the value of one property has no effect on the others.
	However, the `right` and `bottom` properties are
	integrally related to those four properties. For example, if you change the
	value of the `right` property, the value of the
	`width` property changes; if you change the `bottom`
	property, the value of the `height` property changes.

	The following methods and properties use Rectangle objects:


	* The `applyFilter()`, `colorTransform()`,
	`copyChannel()`, `copyPixels()`, `draw()`,
	`fillRect()`, `generateFilterRect()`,
	`getColorBoundsRect()`, `getPixels()`,
	`merge()`, `paletteMap()`,
	`pixelDisolve()`, `setPixels()`, and
	`threshold()` methods, and the `rect` property of the
	BitmapData class
	* The `getBounds()` and `getRect()` methods, and
	the `scrollRect` and `scale9Grid` properties of the
	DisplayObject class
	* The `getCharBoundaries()` method of the TextField
	class
	* The `pixelBounds` property of the Transform class
	* The `bounds` parameter for the `startDrag()`
	method of the Sprite class
	* The `printArea` parameter of the `addPage()`
	method of the PrintJob class


	You can use the `new Rectangle()` constructor to create a
	Rectangle object.

	**Note:** The Rectangle class does not define a rectangular Shape
	display object. To draw a rectangular Shape object onscreen, use the
	`drawRect()` method of the Graphics class.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Rectangle
{
	#if lime
	@:noCompletion private static var __limeRectangle:LimeRectangle;
	#end
	@:noCompletion private static var __pool:ObjectPool<Rectangle> = new ObjectPool<Rectangle>(function() return new Rectangle(),
		function(r) r.setTo(0, 0, 0, 0));

	/**
		The sum of the `y` and `height` properties.

		![A rectangle image showing location and measurement properties.](/images/rectangle.jpg)
	**/
	public var bottom(get, set):Float;

	/**
		The location of the Rectangle object's bottom-right corner, determined
		by the values of the `right` and `bottom` properties.

		![A rectangle image showing location and measurement properties.](/images/rectangle.jpg)
	**/
	public var bottomRight(get, set):Point;

	/**
		The height of the rectangle, in pixels. Changing the `height` value of
		a Rectangle object has no effect on the `x`, `y`, and `width`
		properties.

		![A rectangle image showing location and measurement properties.](/images/rectangle.jpg)
	**/
	public var height:Float;

	/**
		The _x_ coordinate of the top-left corner of the rectangle. Changing
		the `left` property of a Rectangle object has no effect on the `y` and
		`height` properties. However it does affect the `width` property,
		whereas changing the `x` value does _not_ affect the `width` property.

		The value of the `left` property is equal to the value of the `x`
		property.

		![A rectangle image showing location and measurement properties.](/images/rectangle.jpg)
	**/
	public var left(get, set):Float;

	/**
		The sum of the `x` and `width` properties.

		![A rectangle image showing location and measurement properties.](/images/rectangle.jpg)
	**/
	public var right(get, set):Float;

	/**
		The size of the Rectangle object, expressed as a Point object with the
		values of the `width` and `height` properties.
	**/
	public var size(get, set):Point;

	/**
		The _y_ coordinate of the top-left corner of the rectangle. Changing
		the `top` property of a Rectangle object has no effect on the `x` and
		`width` properties. However it does affect the `height` property,
		whereas changing the `y` value does _not_ affect the `height`
		property.
		The value of the `top` property is equal to the value of the `y`
		property.

		![A rectangle image showing location and measurement properties.](/images/rectangle.jpg)
	**/
	public var top(get, set):Float;

	/**
		The location of the Rectangle object's top-left corner, determined by
		the _x_ and _y_ coordinates of the point.

		![A rectangle image showing location and measurement properties.](/images/rectangle.jpg)
	**/
	public var topLeft(get, set):Point;

	/**
		The width of the rectangle, in pixels. Changing the `width` value of a
		Rectangle object has no effect on the `x`, `y`, and `height`
		properties.

		![A rectangle image showing location and measurement properties.](/images/rectangle.jpg)
	**/
	public var width:Float;

	/**
		The _x_ coordinate of the top-left corner of the rectangle. Changing
		the value of the `x` property of a Rectangle object has no
		effect on the `y`, `width`, and `height`
		properties.

		The value of the `x` property is equal to the value of the
		`left` property.
	**/
	public var x:Float;

	/**
		The _y_ coordinate of the top-left corner of the rectangle. Changing
		the value of the `y` property of a Rectangle object has no
		effect on the `x`, `width`, and `height`
		properties.

		The value of the `y` property is equal to the value of the
		`top` property.
	**/
	public var y:Float;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperties(Rectangle.prototype, {
			"bottom": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_bottom (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_bottom (v); }")
			},
			"bottomRight": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_bottomRight (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_bottomRight (v); }")
			},
			"left": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_left (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_left (v); }")
			},
			"right": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_right (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_right (v); }")
			},
			"size": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_size (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_size (v); }")
			},
			"top": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_top (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_top (v); }")
			},
			"topLeft": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_topLeft (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_topLeft (v); }")
			},
		});
	}
	#end

	/**
		Creates a new Rectangle object with the top-left corner specified by the
		`x` and `y` parameters and with the specified
		`width` and `height` parameters. If you call this
		function without parameters, a rectangle with `x`,
		`y`, `width`, and `height` properties set
		to 0 is created.

		@param x      The _x_ coordinate of the top-left corner of the
					  rectangle.
		@param y      The _y_ coordinate of the top-left corner of the
					  rectangle.
		@param width  The width of the rectangle, in pixels.
		@param height The height of the rectangle, in pixels.
	**/
	public function new(x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0):Void
	{
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}

	/**
		Returns a new Rectangle object with the same values for the
		`x`, `y`, `width`, and
		`height` properties as the original Rectangle object.

		@return A new Rectangle object with the same values for the
				`x`, `y`, `width`, and
				`height` properties as the original Rectangle object.
	**/
	public function clone():Rectangle
	{
		return new Rectangle(x, y, width, height);
	}

	/**
		Determines whether the specified point is contained within the rectangular
		region defined by this Rectangle object.

		@param x The _x_ coordinate(horizontal position) of the point.
		@param y The _y_ coordinate(vertical position) of the point.
		@return A value of `true` if the Rectangle object contains the
				specified point; otherwise `false`.
	**/
	public function contains(x:Float, y:Float):Bool
	{
		return x >= this.x && y >= this.y && x < right && y < bottom;
	}

	/**
		Determines whether the specified point is contained within the rectangular
		region defined by this Rectangle object. This method is similar to the
		`Rectangle.contains()` method, except that it takes a Point
		object as a parameter.

		@param point The point, as represented by its _x_ and _y_
					 coordinates.
		@return A value of `true` if the Rectangle object contains the
				specified point; otherwise `false`.
	**/
	public function containsPoint(point:Point):Bool
	{
		return contains(point.x, point.y);
	}

	/**
		Determines whether the Rectangle object specified by the `rect`
		parameter is contained within this Rectangle object. A Rectangle object is
		said to contain another if the second Rectangle object falls entirely
		within the boundaries of the first.

		@param rect The Rectangle object being checked.
		@return A value of `true` if the Rectangle object that you
				specify is contained by this Rectangle object; otherwise
				`false`.
	**/
	public function containsRect(rect:Rectangle):Bool
	{
		if (rect.width <= 0 || rect.height <= 0)
		{
			return rect.x > x && rect.y > y && rect.right < right && rect.bottom < bottom;
		}
		else
		{
			return rect.x >= x && rect.y >= y && rect.right <= right && rect.bottom <= bottom;
		}
	}

	/**
		Copies all of rectangle data from the source Rectangle object into the calling
		Rectangle object.

		@param	sourceRect	The Rectangle object from which to copy the data.
	**/
	public function copyFrom(sourceRect:Rectangle):Void
	{
		x = sourceRect.x;
		y = sourceRect.y;
		width = sourceRect.width;
		height = sourceRect.height;
	}

	/**
		Determines whether the object specified in the `toCompare`
		parameter is equal to this Rectangle object. This method compares the
		`x`, `y`, `width`, and
		`height` properties of an object against the same properties of
		this Rectangle object.

		@param toCompare The rectangle to compare to this Rectangle object.
		@return A value of `true` if the object has exactly the same
				values for the `x`, `y`, `width`,
				and `height` properties as this Rectangle object;
				otherwise `false`.
	**/
	public function equals(toCompare:Rectangle):Bool
	{
		if (toCompare == this) return true;
		else
			return toCompare != null && x == toCompare.x && y == toCompare.y && width == toCompare.width && height == toCompare.height;
	}

	/**
		Increases the size of the Rectangle object by the specified amounts,
		in pixels. The center point of the Rectangle object stays the same,
		and its size increases to the left and right by the `dx` value, and to
		the top and the bottom by the `dy` value.

		@param dx The value to be added to the left and the right of the
				  Rectangle object. The following equation is used to
				  calculate the new width and position of the rectangle:

				  ```as3
				  x -= dx;
				  width += 2 * dx;
				  ```
		@param dy The value to be added to the top and the bottom of the
				  Rectangle. The following equation is used to calculate the
				  new height and position of the rectangle:

				  ```
				  y -= dy;
				  height += 2 * dy;
				  ```
	**/
	public function inflate(dx:Float, dy:Float):Void
	{
		x -= dx;
		width += dx * 2;
		y -= dy;
		height += dy * 2;
	}

	/**
		Increases the size of the Rectangle object. This method is similar to
		the `Rectangle.inflate()` method except it takes a Point object as a
		parameter.
		The following two code examples give the same result:

		```haxe
		var rect1 = new Rectangle(0,0,2,5);
		rect1.inflate(2,2);
		```
		```haxe
		var rect1 = new Rectangle(0,0,2,5);
		var pt1 = new Point(2,2);
		rect1.inflatePoint(pt1);
		```

		@param point The `x` property of this Point object is used to increase
					 the horizontal dimension of the Rectangle object. The `y`
					 property is used to increase the vertical dimension of
					 the Rectangle object.
	**/
	public function inflatePoint(point:Point):Void
	{
		inflate(point.x, point.y);
	}

	/**
		If the Rectangle object specified in the `toIntersect` parameter
		intersects with this Rectangle object, returns the area of
		intersection as a Rectangle object. If the rectangles do not
		intersect, this method returns an empty Rectangle object with its
		properties set to 0.

		![The resulting intersection rectangle.](/images/rectangle_intersect.jpg)

		@param toIntersect The Rectangle object to compare against to see if
						   it intersects with this Rectangle object.
		@return A Rectangle object that equals the area of intersection. If
				the rectangles do not intersect, this method returns an empty
				Rectangle object; that is, a rectangle with its `x`, `y`,
				`width`, and `height` properties set to 0.
	**/
	public function intersection(toIntersect:Rectangle):Rectangle
	{
		var x0 = x < toIntersect.x ? toIntersect.x : x;
		var x1 = right > toIntersect.right ? toIntersect.right : right;

		if (x1 <= x0)
		{
			return new Rectangle();
		}

		var y0 = y < toIntersect.y ? toIntersect.y : y;
		var y1 = bottom > toIntersect.bottom ? toIntersect.bottom : bottom;

		if (y1 <= y0)
		{
			return new Rectangle();
		}

		return new Rectangle(x0, y0, x1 - x0, y1 - y0);
	}

	/**
		Determines whether the object specified in the `toIntersect`
		parameter intersects with this Rectangle object. This method checks the
		`x`, `y`, `width`, and
		`height` properties of the specified Rectangle object to see if
		it intersects with this Rectangle object.

		@param toIntersect The Rectangle object to compare against this Rectangle
						   object.
		@return A value of `true` if the specified object intersects
				with this Rectangle object; otherwise `false`.
	**/
	public function intersects(toIntersect:Rectangle):Bool
	{
		var x0 = x < toIntersect.x ? toIntersect.x : x;
		var x1 = right > toIntersect.right ? toIntersect.right : right;

		if (x1 <= x0)
		{
			return false;
		}

		var y0 = y < toIntersect.y ? toIntersect.y : y;
		var y1 = bottom > toIntersect.bottom ? toIntersect.bottom : bottom;

		return y1 > y0;
	}

	/**
		Determines whether or not this Rectangle object is empty.

		@return A value of `true` if the Rectangle object's width or
				height is less than or equal to 0; otherwise `false`.
	**/
	public function isEmpty():Bool
	{
		return (width <= 0 || height <= 0);
	}

	/**
		Adjusts the location of the Rectangle object, as determined by its
		top-left corner, by the specified amounts.

		@param dx Moves the _x_ value of the Rectangle object by this amount.
		@param dy Moves the _y_ value of the Rectangle object by this amount.
	**/
	public function offset(dx:Float, dy:Float):Void
	{
		x += dx;
		y += dy;
	}

	/**
		Adjusts the location of the Rectangle object using a Point object as a
		parameter. This method is similar to the `Rectangle.offset()`
		method, except that it takes a Point object as a parameter.

		@param point A Point object to use to offset this Rectangle object.
	**/
	public function offsetPoint(point:Point):Void
	{
		x += point.x;
		y += point.y;
	}

	/**
		Sets all of the Rectangle object's properties to 0. A Rectangle object is
		empty if its width or height is less than or equal to 0.

		 This method sets the values of the `x`, `y`,
		`width`, and `height` properties to 0.

	**/
	public function setEmpty():Void
	{
		x = y = width = height = 0;
	}

	/**
		Sets the members of Rectangle to the specified values

		@param	xa	the values to set the rectangle to.
		@param	ya
		@param	widtha
		@param	heighta
	**/
	public function setTo(xa:Float, ya:Float, widtha:Float, heighta:Float):Void
	{
		x = xa;
		y = ya;
		width = widtha;
		height = heighta;
	}

	public function toString():String
	{
		return '(x=$x, y=$y, width=$width, height=$height)';
	}

	/**
		Adds two rectangles together to create a new Rectangle object, by
		filling in the horizontal and vertical space between the two
		rectangles.

		![The resulting union rectangle.](/images/rectangle_union.jpg)

		**Note:** The `union()` method ignores rectangles with `0` as the
		height or width value, such as: `var rect2:Rectangle = new Rectangle(300,300,50,0);`

		@param toUnion A Rectangle object to add to this Rectangle object.
		@return A new Rectangle object that is the union of the two
				rectangles.
	**/
	public function union(toUnion:Rectangle):Rectangle
	{
		if (width == 0 || height == 0)
		{
			return toUnion.clone();
		}
		else if (toUnion.width == 0 || toUnion.height == 0)
		{
			return clone();
		}

		var x0 = x > toUnion.x ? toUnion.x : x;
		var x1 = right < toUnion.right ? toUnion.right : right;
		var y0 = y > toUnion.y ? toUnion.y : y;
		var y1 = bottom < toUnion.bottom ? toUnion.bottom : bottom;

		return new Rectangle(x0, y0, x1 - x0, y1 - y0);
	}

	@:noCompletion private function __contract(x:Float, y:Float, width:Float, height:Float):Void
	{
		if (this.width == 0 && this.height == 0)
		{
			return;
		}

		var offsetX = 0.0;
		var offsetY = 0.0;
		var offsetRight = 0.0;
		var offsetBottom = 0.0;

		if (this.x < x) offsetX = x - this.x;
		if (this.y < y) offsetY = y - this.y;
		if (this.right > x + width) offsetRight = (x + width) - this.right;
		if (this.bottom > y + height) offsetBottom = (y + height) - this.bottom;

		this.x += offsetX;
		this.y += offsetY;
		this.width += offsetRight - offsetX;
		this.height += offsetBottom - offsetY;
	}

	@:noCompletion private function __expand(x:Float, y:Float, width:Float, height:Float):Void
	{
		if (this.width == 0 && this.height == 0)
		{
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

	#if lime
	@:noCompletion private function __toLimeRectangle():LimeRectangle
	{
		if (__limeRectangle == null)
		{
			__limeRectangle = new LimeRectangle();
		}

		__limeRectangle.setTo(x, y, width, height);
		return __limeRectangle;
	}
	#end

	@:noCompletion private function __transform(rect:Rectangle, m:Matrix):Void
	{
		var tx0 = m.a * x + m.c * y;
		var tx1 = tx0;
		var ty0 = m.b * x + m.d * y;
		var ty1 = ty0;

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

		rect.setTo(tx0 + m.tx, ty0 + m.ty, tx1 - tx0, ty1 - ty0);
	}

	// Getters & Setters
	@:noCompletion private function get_bottom():Float
	{
		return y + height;
	}

	@:noCompletion private function set_bottom(b:Float):Float
	{
		height = b - y;
		return b;
	}

	@:noCompletion private function get_bottomRight():Point
	{
		return new Point(x + width, y + height);
	}

	@:noCompletion private function set_bottomRight(p:Point):Point
	{
		width = p.x - x;
		height = p.y - y;
		return p.clone();
	}

	@:noCompletion private function get_left():Float
	{
		return x;
	}

	@:noCompletion private function set_left(l:Float):Float
	{
		width -= l - x;
		x = l;
		return l;
	}

	@:noCompletion private function get_right():Float
	{
		return x + width;
	}

	@:noCompletion private function set_right(r:Float):Float
	{
		width = r - x;
		return r;
	}

	@:noCompletion private function get_size():Point
	{
		return new Point(width, height);
	}

	@:noCompletion private function set_size(p:Point):Point
	{
		width = p.x;
		height = p.y;
		return p.clone();
	}

	@:noCompletion private function get_top():Float
	{
		return y;
	}

	@:noCompletion private function set_top(t:Float):Float
	{
		height -= t - y;
		y = t;
		return t;
	}

	@:noCompletion private function get_topLeft():Point
	{
		return new Point(x, y);
	}

	@:noCompletion private function set_topLeft(p:Point):Point
	{
		x = p.x;
		y = p.y;
		return p.clone();
	}
}
#else
typedef Rectangle = flash.geom.Rectangle;
#end
