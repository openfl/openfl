import ObjectPool from "../_internal/utils/ObjectPool";
import Matrix from "../geom/Matrix";
import Point from "../geom/Point";

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
export default class Rectangle
{
	protected static __pool: ObjectPool<Rectangle> = new ObjectPool<Rectangle>(() => new Rectangle(),
		(r) => r.setTo(0, 0, 0, 0));

	/**
		The height of the rectangle, in pixels. Changing the `height` value of
		a Rectangle object has no effect on the `x`, `y`, and `width`
		properties.

		![A rectangle image showing location and measurement properties.](/images/rectangle.jpg)
	**/
	public height: number;

	/**
		The width of the rectangle, in pixels. Changing the `width` value of a
		Rectangle object has no effect on the `x`, `y`, and `height`
		properties.

		![A rectangle image showing location and measurement properties.](/images/rectangle.jpg)
	**/
	public width: number;

	/**
		The _x_ coordinate of the top-left corner of the rectangle. Changing
		the value of the `x` property of a Rectangle object has no
		effect on the `y`, `width`, and `height`
		properties.

		The value of the `x` property is equal to the value of the
		`left` property.
	**/
	public x: number;

	/**
		The _y_ coordinate of the top-left corner of the rectangle. Changing
		the value of the `y` property of a Rectangle object has no
		effect on the `x`, `width`, and `height`
		properties.

		The value of the `y` property is equal to the value of the
		`top` property.
	**/
	public y: number;

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
	public constructor(x: number = 0, y: number = 0, width: number = 0, height: number = 0)
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
	public clone(): Rectangle
	{
		return new Rectangle(this.x, this.y, this.width, this.height);
	}

	/**
		Determines whether the specified point is contained within the rectangular
		region defined by this Rectangle object.

		@param x The _x_ coordinate(horizontal position) of the point.
		@param y The _y_ coordinate(vertical position) of the point.
		@return A value of `true` if the Rectangle object contains the
				specified point; otherwise `false`.
	**/
	public contains(x: number, y: number): boolean
	{
		return x >= this.x && y >= this.y && x < this.right && y < this.bottom;
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
	public containsPoint(point: Point): boolean
	{
		return this.contains(point.x, point.y);
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
	public containsRect(rect: Rectangle): boolean
	{
		if (rect.width <= 0 || rect.height <= 0)
		{
			return rect.x > this.x && rect.y > this.y && rect.right < this.right && rect.bottom < this.bottom;
		}
		else
		{
			return rect.x >= this.x && rect.y >= this.y && rect.right <= this.right && rect.bottom <= this.bottom;
		}
	}

	/**
		Copies all of rectangle data from the source Rectangle object into the calling
		Rectangle object.

		@param	sourceRect	The Rectangle object from which to copy the data.
	**/
	public copyFrom(sourceRect: Rectangle): void
	{
		this.x = sourceRect.x;
		this.y = sourceRect.y;
		this.width = sourceRect.width;
		this.height = sourceRect.height;
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
	public equals(toCompare: Rectangle): boolean
	{
		if (toCompare == this) return true;
		else
			return toCompare != null && this.x == toCompare.x && this.y == toCompare.y && this.width == toCompare.width && this.height == toCompare.height;
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
	public inflate(dx: number, dy: number): void
	{
		this.x -= dx;
		this.width += dx * 2;
		this.y -= dy;
		this.height += dy * 2;
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
	public inflatePoint(point: Point): void
	{
		this.inflate(point.x, point.y);
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
	public intersection(toIntersect: Rectangle): Rectangle
	{
		var x0 = this.x < toIntersect.x ? toIntersect.x : this.x;
		var x1 = this.right > toIntersect.right ? toIntersect.right : this.right;

		if (x1 <= x0)
		{
			return new Rectangle();
		}

		var y0 = this.y < toIntersect.y ? toIntersect.y : this.y;
		var y1 = this.bottom > toIntersect.bottom ? toIntersect.bottom : this.bottom;

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
	public intersects(toIntersect: Rectangle): boolean
	{
		var x0 = this.x < toIntersect.x ? toIntersect.x : this.x;
		var x1 = this.right > toIntersect.right ? toIntersect.right : this.right;

		if (x1 <= x0)
		{
			return false;
		}

		var y0 = this.y < toIntersect.y ? toIntersect.y : this.y;
		var y1 = this.bottom > toIntersect.bottom ? toIntersect.bottom : this.bottom;

		return y1 > y0;
	}

	/**
		Determines whether or not this Rectangle object is empty.

		@return A value of `true` if the Rectangle object's width or
				height is less than or equal to 0; otherwise `false`.
	**/
	public isEmpty(): boolean
	{
		return (this.width <= 0 || this.height <= 0);
	}

	/**
		Adjusts the location of the Rectangle object, as determined by its
		top-left corner, by the specified amounts.

		@param dx Moves the _x_ value of the Rectangle object by this amount.
		@param dy Moves the _y_ value of the Rectangle object by this amount.
	**/
	public offset(dx: number, dy: number): void
	{
		this.x += dx;
		this.y += dy;
	}

	/**
		Adjusts the location of the Rectangle object using a Point object as a
		parameter. This method is similar to the `Rectangle.offset()`
		method, except that it takes a Point object as a parameter.

		@param point A Point object to use to offset this Rectangle object.
	**/
	public offsetPoint(point: Point): void
	{
		this.x += point.x;
		this.y += point.y;
	}

	/**
		Sets all of the Rectangle object's properties to 0. A Rectangle object is
		empty if its width or height is less than or equal to 0.

		 This method sets the values of the `x`, `y`,
		`width`, and `height` properties to 0.

	**/
	public setEmpty(): void
	{
		this.x = this.y = this.width = this.height = 0;
	}

	/**
		Sets the members of Rectangle to the specified values

		@param	xa	the values to set the rectangle to.
		@param	ya
		@param	widtha
		@param	heighta
	**/
	public setTo(xa: number, ya: number, widtha: number, heighta: number): void
	{
		this.x = xa;
		this.y = ya;
		this.width = widtha;
		this.height = heighta;
	}

	public toString(): string
	{
		return `(x=${this.x}, y=${this.y}, width=${this.width}, height=${this.height})`;
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
	public union(toUnion: Rectangle): Rectangle
	{
		if (this.width == 0 || this.height == 0)
		{
			return toUnion.clone();
		}
		else if (toUnion.width == 0 || toUnion.height == 0)
		{
			return this.clone();
		}

		var x0 = this.x > toUnion.x ? toUnion.x : this.x;
		var x1 = this.right < toUnion.right ? toUnion.right : this.right;
		var y0 = this.y > toUnion.y ? toUnion.y : this.y;
		var y1 = this.bottom < toUnion.bottom ? toUnion.bottom : this.bottom;

		return new Rectangle(x0, y0, x1 - x0, y1 - y0);
	}

	protected __contract(x: number, y: number, width: number, height: number): void
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

	protected __expand(x: number, y: number, width: number, height: number): void
	{
		if (this.width == 0 && this.height == 0)
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			return;
		}

		var cacheRight = this.right;
		var cacheBottom = this.bottom;

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

	protected __transform(rect: Rectangle, m: Matrix): void
	{
		var tx0 = m.a * this.x + m.c * this.y;
		var tx1 = tx0;
		var ty0 = m.b * this.x + m.d * this.y;
		var ty1 = ty0;

		var tx = m.a * (this.x + this.width) + m.c * this.y;
		var ty = m.b * (this.x + this.width) + m.d * this.y;

		if (tx < tx0) tx0 = tx;
		if (ty < ty0) ty0 = ty;
		if (tx > tx1) tx1 = tx;
		if (ty > ty1) ty1 = ty;

		tx = m.a * (this.x + this.width) + m.c * (this.y + this.height);
		ty = m.b * (this.x + this.width) + m.d * (this.y + this.height);

		if (tx < tx0) tx0 = tx;
		if (ty < ty0) ty0 = ty;
		if (tx > tx1) tx1 = tx;
		if (ty > ty1) ty1 = ty;

		tx = m.a * this.x + m.c * (this.y + this.height);
		ty = m.b * this.x + m.d * (this.y + this.height);

		if (tx < tx0) tx0 = tx;
		if (ty < ty0) ty0 = ty;
		if (tx > tx1) tx1 = tx;
		if (ty > ty1) ty1 = ty;

		rect.setTo(tx0 + m.tx, ty0 + m.ty, tx1 - tx0, ty1 - ty0);
	}

	// Getters & Setters

	/**
		The sum of the `y` and `height` properties.

		![A rectangle image showing location and measurement properties.](/images/rectangle.jpg)
	**/
	public get bottom(): number
	{
		return this.y + this.height;
	}

	public set bottom(b: number)
	{
		this.height = b - this.y;
	}

	/**
		The location of the Rectangle object's bottom-right corner, determined
		by the values of the `right` and `bottom` properties.

		![A rectangle image showing location and measurement properties.](/images/rectangle.jpg)
	**/
	public get bottomRight(): Point
	{
		return new Point(this.x + this.width, this.y + this.height);
	}

	public set bottomRight(p: Point)
	{
		this.width = p.x - this.x;
		this.height = p.y - this.y;
	}

	/**
		The _x_ coordinate of the top-left corner of the rectangle. Changing
		the `left` property of a Rectangle object has no effect on the `y` and
		`height` properties. However it does affect the `width` property,
		whereas changing the `x` value does _not_ affect the `width` property.

		The value of the `left` property is equal to the value of the `x`
		property.

		![A rectangle image showing location and measurement properties.](/images/rectangle.jpg)
	**/
	public get left(): number
	{
		return this.x;
	}

	public set left(l: number)
	{
		this.width -= l - this.x;
		this.x = l;
	}

	/**
		The sum of the `x` and `width` properties.

		![A rectangle image showing location and measurement properties.](/images/rectangle.jpg)
	**/
	public get right(): number
	{
		return this.x + this.width;
	}

	public set right(r: number)
	{
		this.width = r - this.x;
	}

	/**
		The size of the Rectangle object, expressed as a Point object with the
		values of the `width` and `height` properties.
	**/
	public get size(): Point
	{
		return new Point(this.width, this.height);
	}

	public set size(p: Point)
	{
		this.width = p.x;
		this.height = p.y;
	}

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
	public get top(): number
	{
		return this.y;
	}

	public set top(t: number)
	{
		this.height -= t - this.y;
		this.y = t;
	}

	/**
		The location of the Rectangle object's top-left corner, determined by
		the _x_ and _y_ coordinates of the point.

		![A rectangle image showing location and measurement properties.](/images/rectangle.jpg)
	**/
	public get topLeft(): Point
	{
		return new Point(this.x, this.y);
	}

	public set topLeft(p: Point)
	{
		this.x = p.x;
		this.y = p.y;
	}
}
