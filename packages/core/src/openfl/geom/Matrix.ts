import ObjectPool from "../_internal/utils/ObjectPool";
import Point from "../geom/Point";
import Vector3D from "../geom/Vector3D";

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
	| Skewing or shearing | None; must set the properties `b` and `c` | ![Matrix notation of skew properties](/images/matrix_skew.jpg) | ![Illustration of skew effects](/images/matrix_skew_image.jpg) | Progressively slides the image in a direction parallel to the _x_ or _y_ axis. The `b` property of the Matrix object represents the tangent of the skew angle along the _y_ axis; the `c` property of the Matrix object represents the tangent of the skew angle along the _x_ axis. |

	Each transformation alters the current matrix properties so that
	you can effectively combine multiple transformations. To do this, you call
	more than one transformation before applying the matrix to its
	display object target (by using the `transform` property of that display
	object).

	Use the `new Matrix()` constructor to create a Matrix object before you
	can call the methods of the Matrix object.
**/
export default class Matrix
{
	protected static __identity: Matrix = new Matrix();
	protected static __pool: ObjectPool<Matrix> = new ObjectPool<Matrix>(() => new Matrix(), (m) => m.identity());

	/**
		The value that affects the positioning of pixels along the _x_ axis
		when scaling or rotating an image.
	**/
	public a: number;

	/**
		The value that affects the positioning of pixels along the _y_ axis
		when rotating or skewing an image.
	**/
	public b: number;

	/**
		The value that affects the positioning of pixels along the _x_ axis
		when rotating or skewing an image.
	**/
	public c: number;

	/**
		The value that affects the positioning of pixels along the _y_ axis
		when scaling or rotating an image.
	**/
	public d: number;

	/**
		The distance by which to translate each point along the _x_ axis.
	**/
	public tx: number;

	/**
		The distance by which to translate each point along the _y_ axis.
	**/
	public ty: number;

	protected __array: Float32Array;

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
	public constructor(a: number = 1, b: number = 0, c: number = 0, d: number = 1, tx: number = 0, ty: number = 0)
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
	public clone(): Matrix
	{
		return new Matrix(this.a, this.b, this.c, this.d, this.tx, this.ty);
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
	public concat(m: Matrix): void
	{
		var a1 = this.a * m.a + this.b * m.c;
		this.b = this.a * m.b + this.b * m.d;
		this.a = a1;

		var c1 = this.c * m.a + this.d * m.c;
		this.d = this.c * m.b + this.d * m.d;
		this.c = c1;

		var tx1 = this.tx * m.a + this.ty * m.c + m.tx;
		this.ty = this.tx * m.b + this.ty * m.d + m.ty;
		this.tx = tx1;

		// __cleanValues ();
	}

	/**
		Copies a Vector3D object into specific column of the calling Matrix3D object.

		@param	column	The column from which to copy the data from.
		@param	vector3D	The Vector3D object from which to copy the data.
	**/
	public copyColumnFrom(column: number, vector3D: Vector3D): void
	{
		if (column > 2)
		{
			throw "Column " + column + " out of bounds (2)";
		}
		else if (column == 0)
		{
			this.a = vector3D.x;
			this.b = vector3D.y;
		}
		else if (column == 1)
		{
			this.c = vector3D.x;
			this.d = vector3D.y;
		}
		else
		{
			this.tx = vector3D.x;
			this.ty = vector3D.y;
		}
	}

	/**
		Copies specific column of the calling Matrix object into the Vector3D object. The
		`w` element of the Vector3D object will not be changed.

		@param	column	The column from which to copy the data from.
		@param	vector3D	The Vector3D object from which to copy the data.
	**/
	public copyColumnTo(column: number, vector3D: Vector3D): void
	{
		if (column > 2)
		{
			throw "Column " + column + " out of bounds (2)";
		}
		else if (column == 0)
		{
			vector3D.x = this.a;
			vector3D.y = this.b;
			vector3D.z = 0;
		}
		else if (column == 1)
		{
			vector3D.x = this.c;
			vector3D.y = this.d;
			vector3D.z = 0;
		}
		else
		{
			vector3D.x = this.tx;
			vector3D.y = this.ty;
			vector3D.z = 1;
		}
	}

	/**
		Copies all of the matrix data from the source Point object into the calling Matrix
		object.

		@param	sourceMatrix	The Matrix object from which to copy the data.
	**/
	public copyFrom(sourceMatrix: Matrix): void
	{
		this.a = sourceMatrix.a;
		this.b = sourceMatrix.b;
		this.c = sourceMatrix.c;
		this.d = sourceMatrix.d;
		this.tx = sourceMatrix.tx;
		this.ty = sourceMatrix.ty;
	}

	/**
		Copies a Vector3D object into specific row of the calling Matrix object.

		@param	row	The row from which to copy the data from.
		@param	vector3D	The Vector3D object from which to copy the data.
	**/
	public copyRowFrom(row: number, vector3D: Vector3D): void
	{
		if (row > 2)
		{
			throw "Row " + row + " out of bounds (2)";
		}
		else if (row == 0)
		{
			this.a = vector3D.x;
			this.c = vector3D.y;
			this.tx = vector3D.z;
		}
		else if (row == 1)
		{
			this.b = vector3D.x;
			this.d = vector3D.y;
			this.ty = vector3D.z;
		}
	}

	/**
		Copies specific row of the calling Matrix object into the Vector3D object. The `w`
		element of the Vector3D object will not be changed.

		@param	row	The row from which to copy the data from.
		@param	vector3D	The Vector3D object from which to copy the data.
	**/
	public copyRowTo(row: number, vector3D: Vector3D): void
	{
		if (row > 2)
		{
			throw "Row " + row + " out of bounds (2)";
		}
		else if (row == 0)
		{
			vector3D.x = this.a;
			vector3D.y = this.c;
			vector3D.z = this.tx;
		}
		else if (row == 1)
		{
			vector3D.x = this.b;
			vector3D.y = this.d;
			vector3D.z = this.ty;
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
		import Matrix from "../geom/Matrix";

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
	public createBox(scaleX: number, scaleY: number, rotation: number = 0, tx: number = 0, ty: number = 0): void
	{
		// identity ();
		// rotate (rotation);
		// scale (scaleX, scaleY);
		// translate (tx, ty);

		if (rotation != 0)
		{
			var cos = Math.cos(rotation);
			var sin = Math.sin(rotation);

			this.a = cos * scaleX;
			this.b = sin * scaleY;
			this.c = -sin * scaleX;
			this.d = cos * scaleY;
		}
		else
		{
			this.a = scaleX;
			this.b = 0;
			this.c = 0;
			this.d = scaleY;
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
	public createGradientBox(width: number, height: number, rotation: number = 0, tx: number = 0, ty: number = 0): void
	{
		this.a = width / 1638.4;
		this.d = height / 1638.4;

		// rotation is clockwise
		if (rotation != 0)
		{
			var cos = Math.cos(rotation);
			var sin = Math.sin(rotation);

			this.b = sin * this.d;
			this.c = -sin * this.a;
			this.a *= cos;
			this.d *= cos;
		}
		else
		{
			this.b = 0;
			this.c = 0;
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
	public deltaTransformPoint(point: Point): Point
	{
		return new Point(point.x * this.a + point.y * this.c, point.x * this.b + point.y * this.d);
	}

	/** @hidden */
	public equals(matrix: Matrix): boolean
	{
		return (matrix != null && this.tx == matrix.tx && this.ty == matrix.ty && this.a == matrix.a && this.b == matrix.b && this.c == matrix.c && this.d == matrix.d);
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
	public identity(): void
	{
		this.a = 1;
		this.b = 0;
		this.c = 0;
		this.d = 1;
		this.tx = 0;
		this.ty = 0;
	}

	/**
		Performs the opposite transformation of the original matrix. You can apply
		an inverted matrix to an object to undo the transformation performed when
		applying the original matrix.

	**/
	public invert(): Matrix
	{
		var norm = this.a * this.d - this.b * this.c;

		if (norm == 0)
		{
			this.a = this.b = this.c = this.d = 0;
			this.tx = -this.tx;
			this.ty = -this.ty;
		}
		else
		{
			norm = 1.0 / norm;
			var a1 = this.d * norm;
			this.d = this.a * norm;
			this.a = a1;
			this.b *= -norm;
			this.c *= -norm;

			var tx1 = -this.a * this.tx - this.c * this.ty;
			this.ty = -this.b * this.tx - this.d * this.ty;
			this.tx = tx1;
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
	public rotate(theta: number): void
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

		var a1 = this.a * cos - this.b * sin;
		this.b = this.a * sin + this.b * cos;
		this.a = a1;

		var c1 = this.c * cos - this.d * sin;
		this.d = this.c * sin + this.d * cos;
		this.c = c1;

		var tx1 = this.tx * cos - this.ty * sin;
		this.ty = this.tx * sin + this.ty * cos;
		this.tx = tx1;

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
	public scale(sx: number, sy: number): void
	{
		/*

			Scale object "after" other transforms

			[  a  b   0 ][  sx  0   0 ]
			[  c  d   0 ][  0   sy  0 ]
			[  tx ty  1 ][  0   0   1 ]
		**/

		this.a *= sx;
		this.b *= sy;
		this.c *= sx;
		this.d *= sy;
		this.tx *= sx;
		this.ty *= sy;

		// __cleanValues ();
	}

	protected setRotation(theta: number, scale: number = 1): void
	{
		this.a = Math.cos(theta) * scale;
		this.c = Math.sin(theta) * scale;
		this.b = -this.c;
		this.d = this.a;

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
	public setTo(a: number, b: number, c: number, d: number, tx: number, ty: number): void
	{
		this.a = a;
		this.b = b;
		this.c = c;
		this.d = d;
		this.tx = tx;
		this.ty = ty;
	}

	/** @hidden */
	public to3DString(roundPixels: boolean = false): string
	{
		if (roundPixels)
		{
			return `matrix3d(${this.a}, ${this.b}, 0, 0, ${this.c}, ${this.d}, 0, 0, 0, 0, 1, 0, ${Math.round(this.tx)}, ${Math.round(this.ty)}, 0, 1)`;
		}
		else
		{
			return `matrix3d(${this.a}, ${this.b}, 0, 0, ${this.c}, ${this.d}, 0, 0, 0, 0, 1, 0, ${this.tx}, ${this.ty}, 0, 1)`;
		}
	}

	/**
		Returns a text value listing the properties of the Matrix object.

		@return A string containing the values of the properties of the Matrix
				object: `a`, `b`, `c`,
				`d`, `tx`, and `ty`.
	**/
	public toString(): string
	{
		return `matrix(${this.a}, ${this.b}, ${this.c}, ${this.d}, ${this.tx}, ${this.ty})`;
	}

	/**
		Returns the result of applying the geometric transformation represented by
		the Matrix object to the specified point.

		@param point The point for which you want to get the result of the Matrix
					 transformation.
		@return The point resulting from applying the Matrix transformation.
	**/
	public transformPoint(pos: Point): Point
	{
		return new Point(this.__transformX(pos.x, pos.y), this.__transformY(pos.x, pos.y));
	}

	/**
		Translates the matrix along the _x_ and _y_ axes, as specified
		by the `dx` and `dy` parameters.

		@param dx The amount of movement along the _x_ axis to the right, in
				  pixels.
		@param dy The amount of movement down along the _y_ axis, in pixels.
	**/
	public translate(dx: number, dy: number): void
	{
		this.tx += dx;
		this.ty += dy;
	}

	protected toArray(transpose: boolean = false): Float32Array
	{
		if (this.__array == null)
		{
			this.__array = new Float32Array(9);
		}

		if (transpose)
		{
			this.__array[0] = this.a;
			this.__array[1] = this.b;
			this.__array[2] = 0;
			this.__array[3] = this.c;
			this.__array[4] = this.d;
			this.__array[5] = 0;
			this.__array[6] = this.tx;
			this.__array[7] = this.ty;
			this.__array[8] = 1;
		}
		else
		{
			this.__array[0] = this.a;
			this.__array[1] = this.c;
			this.__array[2] = this.tx;
			this.__array[3] = this.b;
			this.__array[4] = this.d;
			this.__array[5] = this.ty;
			this.__array[6] = 0;
			this.__array[7] = 0;
			this.__array[8] = 1;
		}

		return this.__array;
	}

	protected __cleanValues(): void
	{
		this.a = Math.round(this.a * 1000) / 1000;
		this.b = Math.round(this.b * 1000) / 1000;
		this.c = Math.round(this.c * 1000) / 1000;
		this.d = Math.round(this.d * 1000) / 1000;
		this.tx = Math.round(this.tx * 10) / 10;
		this.ty = Math.round(this.ty * 10) / 10;
	}

	protected __transformInversePoint(point: Point): void
	{
		var norm = this.a * this.d - this.b * this.c;

		if (norm == 0)
		{
			point.x = -this.tx;
			point.y = -this.ty;
		}
		else
		{
			var px = (1.0 / norm) * (this.c * (this.ty - point.y) + this.d * (point.x - this.tx));
			point.y = (1.0 / norm) * (this.a * (point.y - this.ty) + this.b * (this.tx - point.x));
			point.x = px;
		}
	}

	protected __transformInverseX(px: number, py: number): number
	{
		var norm = this.a * this.d - this.b * this.c;

		if (norm == 0)
		{
			return -this.tx;
		}
		else
		{
			return (1.0 / norm) * (this.c * (this.ty - py) + this.d * (px - this.tx));
		}
	}

	protected __transformInverseY(px: number, py: number): number
	{
		var norm = this.a * this.d - this.b * this.c;

		if (norm == 0)
		{
			return -this.ty;
		}
		else
		{
			return (1.0 / norm) * (this.a * (py - this.ty) + this.b * (this.tx - px));
		}
	}

	protected __transformPoint(point: Point): void
	{
		var px = point.x;
		var py = point.y;

		point.x = this.__transformX(px, py);
		point.y = this.__transformY(px, py);
	}

	protected __transformX(px: number, py: number): number
	{
		return px * this.a + py * this.c + this.tx;
	}

	protected __transformY(px: number, py: number): number
	{
		return px * this.b + py * this.d + this.ty;
	}

	protected __translateTransformed(px: number, py: number): void
	{
		this.tx = this.__transformX(px, py);
		this.ty = this.__transformY(px, py);

		// __cleanValues ();
	}
}
