package openfl.geom;

#if !flash
/**
	The Vector3D class represents a point or a location in the three-dimensional space using
	the Cartesian coordinates x, y, and z. As in a two-dimensional space, the `x` property
	represents the horizontal axis and the `y` property represents the vertical axis. In
	three-dimensional space, the `z` property represents depth. The value of the `x` property increases as the object moves to the right. The value of the `y` property
	increases as the object moves down. The `z` property increases as the object moves
	farther from the point of view. Using perspective projection and scaling, the object is
	seen to be bigger when near and smaller when farther away from the screen. As in a
	right-handed three-dimensional coordinate system, the positive z-axis points away from
	the viewer and the value of the `z` property increases as the object moves away from the
	viewer's eye. The origin point (0,0,0) of the global space is the upper-left corner of
	the stage.

	![X, Y, Z Axes](/images/xyzAxes.jpg)

	The Vector3D class can also represent a direction, an arrow pointing from the origin of
	the coordinates, such as (0,0,0), to an endpoint; or a floating-point component of an
	RGB (Red, Green, Blue) color model.

	Quaternion notation introduces a fourth element, the `w` property, which provides
	additional orientation information. For example, the `w` property can define an angle
	of rotation of a Vector3D object. The combination of the angle of rotation and the
	coordinates `x`, `y`, and `z` can determine the display object's orientation. Here is
	a representation of Vector3D elements in matrix notation:

	![Vector3D elements](/images/Vector3Delements.jpg)
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Vector3D
{
	/**
		The x axis defined as a Vector3D object with coordinates (1,0,0).
	**/
	public static var X_AXIS(get, never):Vector3D;

	/**
		The y axis defined as a Vector3D object with coordinates (0,1,0).
	**/
	public static var Y_AXIS(get, never):Vector3D;

	/**
		The z axis defined as a Vector3D object with coordinates (0,0,1).
	**/
	public static var Z_AXIS(get, never):Vector3D;

	/**
		The length, magnitude, of the current Vector3D object from the origin (0,0,0) to
		the object's x, y, and z coordinates. The `w` property is ignored. A unit vector has
		a length or magnitude of one.
	**/
	public var length(get, never):Float;

	/**
		The square of the length of the current Vector3D object, calculated using the `x`,
		`y`, and `z` properties. The `w` property is ignored. Use the `lengthSquared()`
		method whenever possible instead of the slower `Math.sqrt()` method call of the
		`Vector3D.length()` method.
	**/
	public var lengthSquared(get, never):Float;

	/**
		The fourth element of a Vector3D object (in addition to the `x`, `y`, and `z`
		properties) can hold data such as the angle of rotation. The default value is 0.

		Quaternion notation employs an angle as the fourth element in its calculation of
		three-dimensional rotation. The w property can be used to define the angle of
		rotation about the Vector3D object. The combination of the rotation angle and the
		coordinates (x,y,z) determines the display object's orientation.

		In addition, the w property can be used as a perspective warp factor for a
		projected three-dimensional position or as a projection transform value in
		representing a three-dimensional coordinate projected into the two-dimensional
		space. For example, you can create a projection matrix using the `Matrix3D.rawData`
		property, that, when applied to a Vector3D object, produces a transform value in
		the Vector3D object's fourth element (the `w` property). Dividing the Vector3D
		object's other elements by the transform value then produces a projected Vector3D
		object. You can use the `Vector3D.project()` method to divide the first three
		elements of a Vector3D object by its fourth element.
	**/
	public var w:Float;

	/**
		The first element of a Vector3D object, such as the x coordinate of a point in
		the three-dimensional space. The default value is 0.
	**/
	public var x:Float;

	/**
		The second element of a Vector3D object, such as the y coordinate of a point in
		the three-dimensional space. The default value is 0.
	**/
	public var y:Float;

	/**
		The third element of a Vector3D object, such as the z coordinate of a point in
		three-dimensional space. The default value is 0.
	**/
	public var z:Float;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperties(Vector3D, {
			"X_AXIS": {
				get: function()
				{
					return Vector3D.get_X_AXIS();
				}
			},
			"Y_AXIS": {
				get: function()
				{
					return Vector3D.get_Y_AXIS();
				}
			},
			"Z_AXIS": {
				get: function()
				{
					return Vector3D.get_Z_AXIS();
				}
			}
		});

		untyped Object.defineProperties(Vector3D.prototype, {
			"length": {get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_length (); }")},
			"lengthSquared": {get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_lengthSquared (); }")},
		});
	}
	#end

	/**
		Creates an instance of a Vector3D object. If you do not specify a parameter for
		the constructor, a Vector3D object is created with the elements (0,0,0,0).

		@param	x	The first element, such as the x coordinate.
		@param	y	The second element, such as the y coordinate.
		@param	z	The third element, such as the z coordinate.
		@param	w	An optional element for additional data such as the angle of rotation.
	**/
	public function new(x:Float = 0, y:Float = 0, z:Float = 0, w:Float = 0)
	{
		this.w = w;
		this.x = x;
		this.y = y;
		this.z = z;
	}

	/**
		Adds the value of the x, y, and z elements of the current Vector3D object to the
		values of the x, y, and z elements of another Vector3D object. The `add()` method
		does not change the current Vector3D object. Instead, it returns a new Vector3D
		object with the new values.

		The result of adding two vectors together is a resultant vector. One way to
		visualize the result is by drawing a vector from the origin or tail of the first
		vector to the end or head of the second vector. The resultant vector is the
		distance between the origin point of the first vector and the end point of the
		second vector.

		![Resultant Vector3D](/images/resultantVector3D.jpg)

		@param	a	A Vector3D object to be added to the current Vector3D object.
		@returns	A Vector3D object that is the result of adding the current Vector3D
		object to another Vector3D object.
	**/
	public function add(a:Vector3D):Vector3D
	{
		return new Vector3D(this.x + a.x, this.y + a.y, this.z + a.z);
	}

	/**
		Returns the angle in radians between two vectors. The returned angle is the
		smallest radian the first Vector3D object rotates until it aligns with the
		second Vector3D object.

		The `angleBetween()` method is a static method. You can use it directly as a method
		of the Vector3D class.

		To convert a degree to a radian, you can use the following formula:

		```haxe
		radian = Math.PI/180 * degree
		```

		@param	a	The first Vector3D object.
		@param	b	The second Vector3D object.
		@returns	The angle between two Vector3D objects.

	**/
	public static function angleBetween(a:Vector3D, b:Vector3D):Float
	{
		var la = a.length;
		var lb = b.length;
		var dot = a.dotProduct(b);

		if (la != 0)
		{
			dot /= la;
		}

		if (lb != 0)
		{
			dot /= lb;
		}

		return Math.acos(dot);
	}

	/**
		Returns a new Vector3D object that is an exact copy of the current Vector3D object.

		@returns	A new Vector3D object that is a copy of the current Vector3D object.
	**/
	public function clone():Vector3D
	{
		return new Vector3D(x, y, z, w);
	}

	/**
		Copies all of vector data from the source Vector3D object into the calling Vector3D
		object.

		@param	sourceVector3D	The Vector3D object from which to copy the data.
	**/
	public function copyFrom(sourceVector3D:Vector3D):Void
	{
		x = sourceVector3D.x;
		y = sourceVector3D.y;
		z = sourceVector3D.z;
	}

	/**
		Returns a new Vector3D object that is perpendicular (at a right angle) to the
		current Vector3D and another Vector3D object. If the returned Vector3D object's
		coordinates are (0,0,0), then the two Vector3D objects are parallel to each other.

		![Cross Product](/images/crossproduct.jpg)

		You can use the normalized cross product of two vertices of a polygon surface with
		the normalized vector of the camera or eye viewpoint to get a dot product. The
		value of the dot product can identify whether a surface of a three-dimensional
		object is hidden from the viewpoint.

		@param	a	A second Vector3D object.
		@returns	A new Vector3D object that is perpendicular to the current Vector3D
		object and the Vector3D object specified as the parameter.
	**/
	public function crossProduct(a:Vector3D):Vector3D
	{
		return new Vector3D(y * a.z - z * a.y, z * a.x - x * a.z, x * a.y - y * a.x, 1);
	}

	/**
		Decrements the value of the x, y, and z elements of the current Vector3D object by
		the values of the x, y, and z elements of specified Vector3D object. Unlike the
		`Vector3D.subtract()` method, the `decrementBy()` method changes the current
		Vector3D object and does not return a new Vector3D object.

		@param	a	The Vector3D object containing the values to subtract from the current
		Vector3D object.
	**/
	public function decrementBy(a:Vector3D):Void
	{
		x -= a.x;
		y -= a.y;
		z -= a.z;
	}

	/**
		Returns the distance between two Vector3D objects. The `distance()` method is a
		static method. You can use it directly as a method of the Vector3D class to get
		the Euclidean distance between two three-dimensional points.

		@param	pt1	A Vector3D object as the first three-dimensional point.
		@param	pt2	A Vector3D object as the second three-dimensional point.
		@returns	The distance between two Vector3D objects.
	**/
	public static function distance(pt1:Vector3D, pt2:Vector3D):Float
	{
		var x:Float = pt2.x - pt1.x;
		var y:Float = pt2.y - pt1.y;
		var z:Float = pt2.z - pt1.z;

		return Math.sqrt(x * x + y * y + z * z);
	}

	/**
		If the current Vector3D object and the one specified as the parameter are unit
		vertices, this method returns the cosine of the angle between the two vertices.
		Unit vertices are vertices that point to the same direction but their length is
		one. They remove the length of the vector as a factor in the result. You can use
		the `normalize()` method to convert a vector to a unit vector.

		The `dotProduct()` method finds the angle between two vertices. It is also used in
		backface culling or lighting calculations. Backface culling is a procedure for
		determining which surfaces are hidden from the viewpoint. You can use the
		normalized vertices from the camera, or eye, viewpoint and the cross product of
		the vertices of a polygon surface to get the dot product. If the dot product is less
		than zero, then the surface is facing the camera or the viewer. If the two unit
		vertices are perpendicular to each other, they are orthogonal and the dot product
		is zero. If the two vertices are parallel to each other, the dot product is one.

		@param	a	The second Vector3D object.
		@returns	A scalar which is the dot product of the current Vector3D object and
		the specified Vector3D object.
	**/
	public function dotProduct(a:Vector3D):Float
	{
		return x * a.x + y * a.y + z * a.z;
	}

	/**
		Determines whether two Vector3D objects are equal by comparing the x, y, and z
		elements of the current Vector3D object with a specified Vector3D object. If the
		values of these elements are the same, the two Vector3D objects are equal. If the
		second optional parameter is set to `true`, all four elements of the Vector3D
		objects, including the `w` property, are compared.

		@param	toCompare	The Vector3D object to be compared with the current Vector3D
		object.
		@param	allFour	An optional parameter that specifies whether the `w` property of
		the Vector3D objects is used in the comparison.
		@returns	A value of `true` if the specified Vector3D object is equal to the current Vector3D object; `false` if it is not equal.
	**/
	public function equals(toCompare:Vector3D, allFour:Bool = false):Bool
	{
		return x == toCompare.x && y == toCompare.y && z == toCompare.z && (!allFour || w == toCompare.w);
	}

	/**
		Increments the value of the x, y, and z elements of the current Vector3D object by
		the values of the x, y, and z elements of a specified Vector3D object. Unlike the
		`Vector3D.add()` method, the `incrementBy()` method changes the current Vector3D
		object and does not return a new Vector3D object.

		@param	a	The Vector3D object to be added to the current Vector3D object.
	**/
	public function incrementBy(a:Vector3D):Void
	{
		x += a.x;
		y += a.y;
		z += a.z;
	}

	/**
		Compares the elements of the current Vector3D object with the elements of a
		specified Vector3D object to determine whether they are nearly equal. The two
		Vector3D objects are nearly equal if the value of all the elements of the two
		vertices are equal, or the result of the comparison is within the tolerance range.
		The difference between two elements must be less than the number specified as the
		tolerance parameter. If the third optional parameter is set to true, all four
		elements of the Vector3D objects, including the w property, are compared.
		Otherwise, only the x, y, and z elements are included in the comparison.

		@param	toCompare	The Vector3D object to be compared with the current Vector3D
		object.
		@param	tolerance	A number determining the tolerance factor. If the difference
		between the values of the Vector3D element specified in the toCompare parameter
		and the current Vector3D element is less than the tolerance number, the two values
		are considered nearly equal.
		@param	allFour	An optional parameter that specifies whether the `w` property of
		the Vector3D objects is used in the comparison.
		@returns	A value of `true` if the specified Vector3D object is nearly equal to the current Vector3D object; `false` if it is not equal.
	**/
	public function nearEquals(toCompare:Vector3D, tolerance:Float, ?allFour:Bool = false):Bool
	{
		return Math.abs(x - toCompare.x) < tolerance
			&& Math.abs(y - toCompare.y) < tolerance
			&& Math.abs(z - toCompare.z) < tolerance
			&& (!allFour || Math.abs(w - toCompare.w) < tolerance);
	}

	/**
		Sets the current Vector3D object to its inverse. The inverse object is also
		considered the opposite of the original object. The value of the `x`, `y`, and `z`
		properties of the current Vector3D object is changed to -x, -y, and -z.
	**/
	public function negate():Void
	{
		x *= -1;
		y *= -1;
		z *= -1;
	}

	/**
		Converts a Vector3D object to a unit vector by dividing the first three elements
		(x, y, z) by the length of the vector. Unit vertices are vertices that have a
		direction but their `length` is one. They simplify vector calculations by removing `length` as a factor.

		@returns	The length of the current Vector3D object.
	**/
	public function normalize():Float
	{
		var l = length;

		if (l != 0)
		{
			x /= l;
			y /= l;
			z /= l;
		}

		return l;
	}

	/**
		Divides the value of the `x`, `y`, and `z` properties of the current Vector3D
		object by the value of its `w` property.

		If the current Vector3D object is the result of multiplying a Vector3D object by a
		projection Matrix3D object, the `w` property can hold the transform value. The
		`project()` method then can complete the projection by dividing the elements by the
		`w` property. Use the Matrix3D.rawData property to create a projection Matrix3D
		object.
	**/
	public function project():Void
	{
		x /= w;
		y /= w;
		z /= w;
	}

	/**
		Scales the current Vector3D object by a scalar, a magnitude. The Vector3D object's
		x, y, and z elements are multiplied by the scalar number specified in the
		parameter. For example, if the vector is scaled by ten, the result is a vector
		that is ten times longer. The scalar can also change the direction of the vector.
		Multiplying the vector by a negative number reverses its direction.

		@param	s	A multiplier (scalar) used to scale a Vector3D object.
	**/
	public function scaleBy(s:Float):Void
	{
		x *= s;
		y *= s;
		z *= s;
	}

	/**
		Sets the members of Vector3D to the specified values

		@param	xa	the values to set the vector to.
		@param	ya
		@param	za
	**/
	public function setTo(xa:Float, ya:Float, za:Float):Void
	{
		x = xa;
		y = ya;
		z = za;
	}

	/**
		Subtracts the value of the x, y, and z elements of the current Vector3D object
		from the values of the x, y, and z elements of another Vector3D object. The
		`subtract()` method does not change the current Vector3D object. Instead, this
		method returns a new Vector3D object with the new values.

		@param	a	The Vector3D object to be subtracted from the current Vector3D object.
		@returns	A new Vector3D object that is the difference between the current
		Vector3D and the specified Vector3D object.
	**/
	public function subtract(a:Vector3D):Vector3D
	{
		return new Vector3D(x - a.x, y - a.y, z - a.z);
	}

	/**
		Returns a string representation of the current Vector3D object. The string contains
		the values of the x, y, and z properties.

		@returns	A string containing the values of the x, y, and z properties.
	**/
	public function toString():String
	{
		return 'Vector3D($x, $y, $z)';
	}

	// Getters & Setters
	@:noCompletion private function get_length():Float
	{
		return Math.sqrt(x * x + y * y + z * z);
	}

	@:noCompletion private function get_lengthSquared():Float
	{
		return x * x + y * y + z * z;
	}

	private inline static function get_X_AXIS():Vector3D
	{
		return new Vector3D(1, 0, 0);
	}

	private inline static function get_Y_AXIS():Vector3D
	{
		return new Vector3D(0, 1, 0);
	}

	private inline static function get_Z_AXIS():Vector3D
	{
		return new Vector3D(0, 0, 1);
	}
}
#else
typedef Vector3D = flash.geom.Vector3D;
#end
