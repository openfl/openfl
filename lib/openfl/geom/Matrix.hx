package openfl.geom;

#if (display || !flash)
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
@:jsRequire("openfl/geom/Matrix", "default")
extern class Matrix
{
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
	public function new(a:Float = 1, b:Float = 0, c:Float = 0, d:Float = 1, tx:Float = 0, ty:Float = 0);

	/**
		Returns a new Matrix object that is a clone of this matrix, with an exact
		copy of the contained object.

		@return A Matrix object.
	**/
	public function clone():Matrix;

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
	public function concat(m:Matrix):Void;

	/**
		Copies a Vector3D object into specific column of the calling Matrix3D object.

		@param	column	The column from which to copy the data from.
		@param	vector3D	The Vector3D object from which to copy the data.
	**/
	public function copyColumnFrom(column:Int, vector3D:Vector3D):Void;

	/**
		Copies specific column of the calling Matrix object into the Vector3D object. The
		`w` element of the Vector3D object will not be changed.

		@param	column	The column from which to copy the data from.
		@param	vector3D	The Vector3D object from which to copy the data.
	**/
	public function copyColumnTo(column:Int, vector3D:Vector3D):Void;
	
	/**
		Copies all of the matrix data from the source Point object into the calling Matrix
		object.

		@param	sourceMatrix	The Matrix object from which to copy the data.
	**/
	public function copyFrom(sourceMatrix:Matrix):Void;
	
	/**
		Copies a Vector3D object into specific row of the calling Matrix object.

		@param	row	The row from which to copy the data from.
		@param	vector3D	The Vector3D object from which to copy the data.
	**/
	public function copyRowFrom(row:Int, vector3D:Vector3D):Void;
	
	/**
		Copies specific row of the calling Matrix object into the Vector3D object. The `w`
		element of the Vector3D object will not be changed.

		@param	row	The row from which to copy the data from.
		@param	vector3D	The Vector3D object from which to copy the data.
	**/
	public function copyRowTo(row:Int, vector3D:Vector3D):Void;

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
	public function createBox(scaleX:Float, scaleY:Float, rotation:Float = 0, tx:Float = 0, ty:Float = 0):Void;

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
	public function createGradientBox(width:Float, height:Float, rotation:Float = 0, tx:Float = 0, ty:Float = 0):Void;

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
	public function deltaTransformPoint(point:Point):Point;

	/**
		Sets each matrix property to a value that causes a null
		transformation. An object transformed by applying an identity matrix
		will be identical to the original.
		After calling the `identity()` method, the resulting matrix has the
		following properties: `a`=1, `b`=0, `c`=0, `d`=1, `tx`=0, `ty`=0.

		In matrix notation, the identity matrix looks like this:

		![Matrix class properties in matrix notation](/images/matrix_identity.jpg)
	**/
	public function identity():Void;

	/**
		Performs the opposite transformation of the original matrix. You can apply
		an inverted matrix to an object to undo the transformation performed when
		applying the original matrix.

	**/
	public function invert():Matrix;

	/**
		Applies a rotation transformation to the Matrix object.
		The `rotate()` method alters the `a`, `b`, `c`, and `d` properties of
		the Matrix object. In matrix notation, this is the same as
		concatenating the current matrix with the following:

		![Matrix notation of scale method parameters](/images/matrix_rotate.jpg)

		@param angle The rotation angle in radians.
	**/
	public function rotate(theta:Float):Void;

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
	public function scale(sx:Float, sy:Float):Void;

	/**
		Sets the members of Matrix to the specified values

		@param	aa	the values to set the matrix to.
		@param	ba
		@param	ca
		@param	da
		@param	txa
		@param	tya
	**/
	public function setTo(a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float):Void;

	/**
		Returns a text value listing the properties of the Matrix object.

		@return A string containing the values of the properties of the Matrix
				object: `a`, `b`, `c`,
				`d`, `tx`, and `ty`.
	**/
	public function toString():String;

	/**
		Returns the result of applying the geometric transformation represented by
		the Matrix object to the specified point.

		@param point The point for which you want to get the result of the Matrix
					 transformation.
		@return The point resulting from applying the Matrix transformation.
	**/
	public function transformPoint(pos:Point):Point;

	/**
		Translates the matrix along the _x_ and _y_ axes, as specified
		by the `dx` and `dy` parameters.

		@param dx The amount of movement along the _x_ axis to the right, in
				  pixels.
		@param dy The amount of movement down along the _y_ axis, in pixels.
	**/
	public function translate(dx:Float, dy:Float):Void;
}
#else
typedef Matrix = flash.geom.Matrix;
#end
