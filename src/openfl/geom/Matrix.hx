package openfl.geom;

#if !flash
import openfl.utils.ObjectPool;
#if lime
import openfl.utils._internal.Float32Array;
import lime.math.Matrix3;
#end

/**
	The Matrix class represents a transformation matrix that determines how to
	map points from one coordinate space to another. You can perform various
	graphical transformations on a display object by setting the properties of
	a Matrix object, applying that Matrix object to the `matrix` property of a
	Transform object, and then applying that Transform object as the
	`transform` property of the display object. These transformation functions
	include translation (_x_ and _y_ repositioning), rotation, scaling, and
	skewing.
	Together these types of transformations are known as _affine
	transformations_. Affine transformations preserve the straightness of
	lines while transforming, so that parallel lines stay parallel.

	To apply a transformation matrix to a display object, you create a
	Transform object, set its `matrix` property to the transformation matrix,
	and then set the `transform` property of the display object to the
	Transform object. Matrix objects are also used as parameters of some
	methods, such as the following:

	* The `draw()` method of a BitmapData object
	* The `beginBitmapFill()` method, `beginGradientFill()` method, or
	`lineGradientStyle()` method of a Graphics object

	A transformation matrix object is a 3 x 3 matrix with the following
	contents:

	![Matrix class properties in matrix notation](/images/matrix_props1.jpg)

	In traditional transformation matrixes, the `u`, `v`, and `w` properties
	provide extra capabilities. The Matrix class can only operate in
	two-dimensional space, so it always assumes that the property values `u`
	and `v` are 0.0, and that the property value `w` is 1.0. The effective
	values of the matrix are as follows:

	![Matrix class properties in matrix notation showing assumed values for u, v, and w](/images/matrix_props2.jpg)

	You can get and set the values of all six of the other properties in a
	Matrix object: `a`, `b`, `c`, `d`, `tx`, and `ty`.

	The Matrix class supports the four major types of transformations:
	translation, scaling, rotation, and skewing. You can set three of these
	transformations by using specialized methods, as described in the
	following table:

	| Transformation | Method | Matrix values | Display result | Description |
	| --- | --- | --- | --- | --- |
	| Translation (displacement) | `translate(tx, ty)` | ![Matrix notation of translate method parameters](/images/matrix_translate.jpg) | ![Illustration of translate method effects](/images/matrix_translate_image.jpg) | Moves the image `tx` pixels to the right and `ty` pixels down. |
	| Scaling | `scale(sx, sy)` | ![Matrix notation of scale method parameters](/images/matrix_scale.jpg) | ![Illustration of scale method effects](/images/matrix_scale_image.jpg) | Resizes the image, multiplying the location of each pixel by `sx` on the _x_ axis and `sy` on the _y_ axis. |
	| Rotation | `rotate(q)` | ![Matrix notation of rotate method properties](/images/matrix_rotate.jpg) | ![Illustration of rotate method effects](/images/matrix_rotate_image.jpg) | Rotates the image by an angle `q`, which is measured in radians. |
	| Skewing or shearing | None; must set the properties `b` and `c` | ![Matrix notation of skew function properties](/images/matrix_skew.jpg) | ![Illustration of skew function effects](/images/matrix_skew_image.jpg) | Progressively slides the image in a direction parallel to the _x_ or _y_ axis. The `b` property of the Matrix object represents the tangent of the skew angle along the _y_ axis; the `c` property of the Matrix object represents the tangent of the skew angle along the _x_ axis. |

	Each transformation function alters the current matrix properties so that
	you can effectively combine multiple transformations. To do this, you call
	more than one transformation function before applying the matrix to its
	display object target (by using the `transform` property of that display
	object).

	Use the `new Matrix()` constructor to create a Matrix object before you
	can call the methods of the Matrix object.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Matrix
{
	@:noCompletion private static var __identity:Matrix = new Matrix();
	@:noCompletion private static var __pool:ObjectPool<Matrix> = new ObjectPool<Matrix>(function() return new Matrix(), function(m) m.identity());
	#if lime
	@:noCompletion private static var __matrix3:Matrix3 = new Matrix3();
	#end

	/**
		The value that affects the positioning of pixels along the _x_ axis
		when scaling or rotating an image.
	**/
	public var a:Float;

	/**
		The value that affects the positioning of pixels along the _y_ axis
		when rotating or skewing an image.
	**/
	public var b:Float;

	/**
		The value that affects the positioning of pixels along the _x_ axis
		when rotating or skewing an image.
	**/
	public var c:Float;

	/**
		The value that affects the positioning of pixels along the _y_ axis
		when scaling or rotating an image.
	**/
	public var d:Float;

	/**
		The distance by which to translate each point along the _x_ axis.
	**/
	public var tx:Float;

	/**
		The distance by which to translate each point along the _y_ axis.
	**/
	public var ty:Float;

	#if lime
	@:noCompletion private var __array:Float32Array;
	#end

	/**
		Creates a new Matrix object with the specified parameters. In matrix
		notation, the properties are organized like this:

		![Matrix class properties in matrix notation showing assumed values for u, v, and w](/images/matrix_props2.jpg)

		If you do not provide any parameters to the `new Matrix()`
		constructor, it creates an _identity matrix_ with the following
		values:

		| `a = 1` | `b = 0` |
		| `c = 0` | `d = 1` |
		| `tx = 0` | `ty = 0` |

		In matrix notation, the identity matrix looks like this:

		![Matrix class properties in matrix notation](/images/matrix_identity.jpg)

		@param a  The value that affects the positioning of pixels along the
				  _x_ axis when scaling or rotating an image.
		@param b  The value that affects the positioning of pixels along the
				  _y_ axis when rotating or skewing an image.
		@param c  The value that affects the positioning of pixels along the
				  _x_ axis when rotating or skewing an image.
		@param d  The value that affects the positioning of pixels along the
				  _y_ axis when scaling or rotating an image..
		@param tx The distance by which to translate each point along the _x_
				  axis.
		@param ty The distance by which to translate each point along the _y_
				  axis.
	**/
	public function new(a:Float = 1, b:Float = 0, c:Float = 0, d:Float = 1, tx:Float = 0, ty:Float = 0)
	{
		this.a = a;
		this.b = b;
		this.c = c;
		this.d = d;
		this.tx = tx;
		this.ty = ty;
	}

	/**
		Returns a new Matrix object that is a clone of this matrix, with an exact
		copy of the contained object.

		@return A Matrix object.
	**/
	public function clone():Matrix
	{
		return new Matrix(a, b, c, d, tx, ty);
	}

	/**
		Concatenates a matrix with the current matrix, effectively combining the
		geometric effects of the two. In mathematical terms, concatenating two
		matrixes is the same as combining them using matrix multiplication.

		For example, if matrix `m1` scales an object by a factor of
		four, and matrix `m2` rotates an object by 1.5707963267949
		radians(`Math.PI/2`), then `m1.concat(m2)`
		transforms `m1` into a matrix that scales an object by a factor
		of four and rotates the object by `Math.PI/2` radians.

		This method replaces the source matrix with the concatenated matrix. If
		you want to concatenate two matrixes without altering either of the two
		source matrixes, first copy the source matrix by using the
		`clone()` method, as shown in the Class Examples section.

		@param m The matrix to be concatenated to the source matrix.
	**/
	public function concat(m:Matrix):Void
	{
		var a1 = a * m.a + b * m.c;
		b = a * m.b + b * m.d;
		a = a1;

		var c1 = c * m.a + d * m.c;
		d = c * m.b + d * m.d;
		c = c1;

		var tx1 = tx * m.a + ty * m.c + m.tx;
		ty = tx * m.b + ty * m.d + m.ty;
		tx = tx1;

		// __cleanValues ();
	}

	/**
		Copies a Vector3D object into specific column of the calling Matrix3D object.

		@param	column	The column from which to copy the data from.
		@param	vector3D	The Vector3D object from which to copy the data.
	**/
	public function copyColumnFrom(column:Int, vector3D:Vector3D):Void
	{
		if (column > 2)
		{
			throw "Column " + column + " out of bounds (2)";
		}
		else if (column == 0)
		{
			a = vector3D.x;
			b = vector3D.y;
		}
		else if (column == 1)
		{
			c = vector3D.x;
			d = vector3D.y;
		}
		else
		{
			tx = vector3D.x;
			ty = vector3D.y;
		}
	}

	/**
		Copies specific column of the calling Matrix object into the Vector3D object. The
		`w` element of the Vector3D object will not be changed.

		@param	column	The column from which to copy the data from.
		@param	vector3D	The Vector3D object from which to copy the data.
	**/
	public function copyColumnTo(column:Int, vector3D:Vector3D):Void
	{
		if (column > 2)
		{
			throw "Column " + column + " out of bounds (2)";
		}
		else if (column == 0)
		{
			vector3D.x = a;
			vector3D.y = b;
			vector3D.z = 0;
		}
		else if (column == 1)
		{
			vector3D.x = c;
			vector3D.y = d;
			vector3D.z = 0;
		}
		else
		{
			vector3D.x = tx;
			vector3D.y = ty;
			vector3D.z = 1;
		}
	}

	/**
		Copies all of the matrix data from the source Point object into the calling Matrix
		object.

		@param	sourceMatrix	The Matrix object from which to copy the data.
	**/
	public function copyFrom(sourceMatrix:Matrix):Void
	{
		a = sourceMatrix.a;
		b = sourceMatrix.b;
		c = sourceMatrix.c;
		d = sourceMatrix.d;
		tx = sourceMatrix.tx;
		ty = sourceMatrix.ty;
	}

	/**
		Copies a Vector3D object into specific row of the calling Matrix object.

		@param	row	The row from which to copy the data from.
		@param	vector3D	The Vector3D object from which to copy the data.
	**/
	public function copyRowFrom(row:Int, vector3D:Vector3D):Void
	{
		if (row > 2)
		{
			throw "Row " + row + " out of bounds (2)";
		}
		else if (row == 0)
		{
			a = vector3D.x;
			c = vector3D.y;
			tx = vector3D.z;
		}
		else if (row == 1)
		{
			b = vector3D.x;
			d = vector3D.y;
			ty = vector3D.z;
		}
	}

	/**
		Copies specific row of the calling Matrix object into the Vector3D object. The `w`
		element of the Vector3D object will not be changed.

		@param	row	The row from which to copy the data from.
		@param	vector3D	The Vector3D object from which to copy the data.
	**/
	public function copyRowTo(row:Int, vector3D:Vector3D):Void
	{
		if (row > 2)
		{
			throw "Row " + row + " out of bounds (2)";
		}
		else if (row == 0)
		{
			vector3D.x = a;
			vector3D.y = c;
			vector3D.z = tx;
		}
		else if (row == 1)
		{
			vector3D.x = b;
			vector3D.y = d;
			vector3D.z = ty;
		}
		else
		{
			vector3D.setTo(0, 0, 1);
		}
	}

	/**
		Includes parameters for scaling, rotation, and translation. When
		applied to a matrix it sets the matrix's values based on those
		parameters.
		Using the `createBox()` method lets you obtain the same matrix as you
		would if you applied the `identity()`, `rotate()`, `scale()`, and
		`translate()` methods in succession. For example,
		`mat1.createBox(2,2,Math.PI/4, 100, 100)` has the same effect as the
		following:

		```haxe
		import openfl.geom.Matrix;

		var mat1 = new Matrix();
		mat1.identity();
		mat1.rotate(Math.PI/4);
		mat1.scale(2,2);
		mat1.translate(10,20);
		```

		@param scaleX   The factor by which to scale horizontally.
		@param scaleY   The factor by which scale vertically.
		@param rotation The amount to rotate, in radians.
		@param tx       The number of pixels to translate (move) to the right
						along the _x_ axis.
		@param ty       The number of pixels to translate (move) down along
						the _y_ axis.
	**/
	public function createBox(scaleX:Float, scaleY:Float, rotation:Float = 0, tx:Float = 0, ty:Float = 0):Void
	{
		// identity ();
		// rotate (rotation);
		// scale (scaleX, scaleY);
		// translate (tx, ty);

		if (rotation != 0)
		{
			var cos = Math.cos(rotation);
			var sin = Math.sin(rotation);

			a = cos * scaleX;
			b = sin * scaleY;
			c = -sin * scaleX;
			d = cos * scaleY;
		}
		else
		{
			a = scaleX;
			b = 0;
			c = 0;
			d = scaleY;
		}

		this.tx = tx;
		this.ty = ty;
	}

	/**
		Creates the specific style of matrix expected by the
		`beginGradientFill()` and `lineGradientStyle()` methods of the
		Graphics class. Width and height are scaled to a `scaleX`/`scaleY`
		pair and the `tx`/`ty` values are offset by half the width and height.

		For example, consider a gradient with the following characteristics:

		* `GradientType.LINEAR`
		* Two colors, green and blue, with the ratios array set to `[0, 255]`
		* `SpreadMethod.PAD`
		* `InterpolationMethod.LINEAR_RGB`

		The following illustrations show gradients in which the matrix was
		defined using the `createGradientBox()` method with different
		parameter settings:

		| `createGradientBox()` settings | Resulting gradient |
		| --- | --- |
		| `width = 25; height = 25; rotation = 0; tx = 0; ty = 0;` | ![resulting linear gradient](/images/createGradientBox-1.jpg) |
		| `width = 25; height = 25; rotation = 0; tx = 25; ty = 0;` | ![resulting linear gradient](/images/createGradientBox-2.jpg) |
		| `width = 50; height = 50; rotation = 0; tx = 0; ty = 0;` | ![resulting linear gradient](/images/createGradientBox-3.jpg) |
		| `width = 50; height = 50; rotation = Math.PI / 4; // 45 degrees tx = 0; ty = 0;` | ![resulting linear gradient](/images/createGradientBox-4.jpg) |

		@param width    The width of the gradient box.
		@param height   The height of the gradient box.
		@param rotation The amount to rotate, in radians.
		@param tx       The distance, in pixels, to translate to the right
						along the _x_ axis. This value is offset by half of
						the `width` parameter.
		@param ty       The distance, in pixels, to translate down along the
						_y_ axis. This value is offset by half of the `height`
						parameter.
	**/
	public function createGradientBox(width:Float, height:Float, rotation:Float = 0, tx:Float = 0, ty:Float = 0):Void
	{
		a = width / 1638.4;
		d = height / 1638.4;

		// rotation is clockwise
		if (rotation != 0)
		{
			var cos = Math.cos(rotation);
			var sin = Math.sin(rotation);

			b = sin * d;
			c = -sin * a;
			a *= cos;
			d *= cos;
		}
		else
		{
			b = 0;
			c = 0;
		}

		this.tx = tx + width / 2;
		this.ty = ty + height / 2;
	}

	/**
		Given a point in the pretransform coordinate space, returns the
		coordinates of that point after the transformation occurs. Unlike the
		standard transformation applied using the `transformPoint()`
		method, the `deltaTransformPoint()` method's transformation
		does not consider the translation parameters `tx` and
		`ty`.

		@param point The point for which you want to get the result of the matrix
					 transformation.
		@return The point resulting from applying the matrix transformation.
	**/
	public function deltaTransformPoint(point:Point):Point
	{
		return new Point(point.x * a + point.y * c, point.x * b + point.y * d);
	}

	@:dox(hide) @:noCompletion @SuppressWarnings("checkstyle:FieldDocComment") public function equals(matrix:Matrix):Bool
	{
		return (matrix != null && tx == matrix.tx && ty == matrix.ty && a == matrix.a && b == matrix.b && c == matrix.c && d == matrix.d);
	}

	/**
		Sets each matrix property to a value that causes a null
		transformation. An object transformed by applying an identity matrix
		will be identical to the original.
		After calling the `identity()` method, the resulting matrix has the
		following properties: `a`=1, `b`=0, `c`=0, `d`=1, `tx`=0, `ty`=0.

		In matrix notation, the identity matrix looks like this:

		![Matrix class properties in matrix notation](/images/matrix_identity.jpg)
	**/
	public function identity():Void
	{
		a = 1;
		b = 0;
		c = 0;
		d = 1;
		tx = 0;
		ty = 0;
	}

	/**
		Performs the opposite transformation of the original matrix. You can apply
		an inverted matrix to an object to undo the transformation performed when
		applying the original matrix.

	**/
	public function invert():Matrix
	{
		var norm = a * d - b * c;

		if (norm == 0)
		{
			a = b = c = d = 0;
			tx = -tx;
			ty = -ty;
		}
		else
		{
			norm = 1.0 / norm;
			var a1 = d * norm;
			d = a * norm;
			a = a1;
			b *= -norm;
			c *= -norm;

			var tx1 = -a * tx - c * ty;
			ty = -b * tx - d * ty;
			tx = tx1;
		}

		// __cleanValues ();

		return this;
	}

	/**
		Applies a rotation transformation to the Matrix object.
		The `rotate()` method alters the `a`, `b`, `c`, and `d` properties of
		the Matrix object. In matrix notation, this is the same as
		concatenating the current matrix with the following:

		![Matrix notation of scale method parameters](/images/matrix_rotate.jpg)

		@param angle The rotation angle in radians.
	**/
	public function rotate(theta:Float):Void
	{
		/**
			Rotate object "after" other transforms

			[  a  b   0 ][  ma mb  0 ]
			[  c  d   0 ][  mc md  0 ]
			[  tx ty  1 ][  mtx mty 1 ]

			ma = md = cos
			mb = sin
			mc = -sin
			mtx = my = 0
		**/

		var cos = Math.cos(theta);

		var sin = Math.sin(theta);

		var a1 = a * cos - b * sin;
		b = a * sin + b * cos;
		a = a1;

		var c1 = c * cos - d * sin;
		d = c * sin + d * cos;
		c = c1;

		var tx1 = tx * cos - ty * sin;
		ty = tx * sin + ty * cos;
		tx = tx1;

		// __cleanValues ();
	}

	/**
		Applies a scaling transformation to the matrix. The _x_ axis is
		multiplied by `sx`, and the _y_ axis it is multiplied by `sy`.
		The `scale()` method alters the `a` and `d` properties of the Matrix
		object. In matrix notation, this is the same as concatenating the
		current matrix with the following matrix:

		![Matrix notation of scale method parameters](/images/matrix_scale.jpg)

		@param sx A multiplier used to scale the object along the _x_ axis.
		@param sy A multiplier used to scale the object along the _y_ axis.
	**/
	public function scale(sx:Float, sy:Float):Void
	{
		/*

			Scale object "after" other transforms

			[  a  b   0 ][  sx  0   0 ]
			[  c  d   0 ][  0   sy  0 ]
			[  tx ty  1 ][  0   0   1 ]
		**/

		a *= sx;
		b *= sy;
		c *= sx;
		d *= sy;
		tx *= sx;
		ty *= sy;

		// __cleanValues ();
	}

	@:noCompletion private function setRotation(theta:Float, scale:Float = 1):Void
	{
		a = Math.cos(theta) * scale;
		c = Math.sin(theta) * scale;
		b = -c;
		d = a;

		// __cleanValues ();
	}

	/**
		Sets the members of Matrix to the specified values

		@param	aa	the values to set the matrix to.
		@param	ba
		@param	ca
		@param	da
		@param	txa
		@param	tya
	**/
	public function setTo(a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float):Void
	{
		this.a = a;
		this.b = b;
		this.c = c;
		this.d = d;
		this.tx = tx;
		this.ty = ty;
	}

	@SuppressWarnings("checkstyle:FieldDocComment")
	@:dox(hide) @:noCompletion public inline function to3DString(roundPixels:Bool = false):String
	{
		if (roundPixels)
		{
			return 'matrix3d($a, $b, 0, 0, $c, $d, 0, 0, 0, 0, 1, 0, ${Std.int(tx)}, ${Std.int(ty)}, 0, 1)';
		}
		else
		{
			return 'matrix3d($a, $b, 0, 0, $c, $d, 0, 0, 0, 0, 1, 0, $tx, $ty, 0, 1)';
		}
	}

	@SuppressWarnings("checkstyle:FieldDocComment")
	@:dox(hide) @:noCompletion public inline function toMozString():String
	{
		return 'matrix($a, $b, $c, $d, ${tx}px, ${ty}px)';
	}

	/**
		Returns a text value listing the properties of the Matrix object.

		@return A string containing the values of the properties of the Matrix
				object: `a`, `b`, `c`,
				`d`, `tx`, and `ty`.
	**/
	public function toString():String
	{
		return 'matrix($a, $b, $c, $d, $tx, $ty)';
	}

	/**
		Returns the result of applying the geometric transformation represented by
		the Matrix object to the specified point.

		@param point The point for which you want to get the result of the Matrix
					 transformation.
		@return The point resulting from applying the Matrix transformation.
	**/
	public function transformPoint(pos:Point):Point
	{
		return new Point(__transformX(pos.x, pos.y), __transformY(pos.x, pos.y));
	}

	/**
		Translates the matrix along the _x_ and _y_ axes, as specified
		by the `dx` and `dy` parameters.

		@param dx The amount of movement along the _x_ axis to the right, in
				  pixels.
		@param dy The amount of movement down along the _y_ axis, in pixels.
	**/
	public function translate(dx:Float, dy:Float):Void
	{
		tx += dx;
		ty += dy;
	}

	#if lime
	@:noCompletion private function toArray(transpose:Bool = false):Float32Array
	{
		if (__array == null)
		{
			__array = new Float32Array(9);
		}

		if (transpose)
		{
			__array[0] = a;
			__array[1] = b;
			__array[2] = 0;
			__array[3] = c;
			__array[4] = d;
			__array[5] = 0;
			__array[6] = tx;
			__array[7] = ty;
			__array[8] = 1;
		}
		else
		{
			__array[0] = a;
			__array[1] = c;
			__array[2] = tx;
			__array[3] = b;
			__array[4] = d;
			__array[5] = ty;
			__array[6] = 0;
			__array[7] = 0;
			__array[8] = 1;
		}

		return __array;
	}
	#end

	@:noCompletion private inline function __cleanValues():Void
	{
		a = Math.round(a * 1000) / 1000;
		b = Math.round(b * 1000) / 1000;
		c = Math.round(c * 1000) / 1000;
		d = Math.round(d * 1000) / 1000;
		tx = Math.round(tx * 10) / 10;
		ty = Math.round(ty * 10) / 10;
	}

	#if lime
	@:noCompletion private function __toMatrix3():Matrix3
	{
		__matrix3.setTo(a, b, c, d, tx, ty);
		return __matrix3;
	}
	#end

	@:noCompletion private inline function __transformInversePoint(point:Point):Void
	{
		var norm = a * d - b * c;

		if (norm == 0)
		{
			point.x = -tx;
			point.y = -ty;
		}
		else
		{
			var px = (1.0 / norm) * (c * (ty - point.y) + d * (point.x - tx));
			point.y = (1.0 / norm) * (a * (point.y - ty) + b * (tx - point.x));
			point.x = px;
		}
	}

	@:noCompletion private inline function __transformInverseX(px:Float, py:Float):Float
	{
		var norm = a * d - b * c;

		if (norm == 0)
		{
			return -tx;
		}
		else
		{
			return (1.0 / norm) * (c * (ty - py) + d * (px - tx));
		}
	}

	@:noCompletion private inline function __transformInverseY(px:Float, py:Float):Float
	{
		var norm = a * d - b * c;

		if (norm == 0)
		{
			return -ty;
		}
		else
		{
			return (1.0 / norm) * (a * (py - ty) + b * (tx - px));
		}
	}

	@:noCompletion private inline function __transformPoint(point:Point):Void
	{
		var px = point.x;
		var py = point.y;

		point.x = __transformX(px, py);
		point.y = __transformY(px, py);
	}

	@:noCompletion private inline function __transformX(px:Float, py:Float):Float
	{
		return px * a + py * c + tx;
	}

	@:noCompletion private inline function __transformY(px:Float, py:Float):Float
	{
		return px * b + py * d + ty;
	}

	@:noCompletion private inline function __translateTransformed(px:Float, py:Float):Void
	{
		tx = __transformX(px, py);
		ty = __transformY(px, py);

		// __cleanValues ();
	}
}
#else
typedef Matrix = flash.geom.Matrix;
#end
