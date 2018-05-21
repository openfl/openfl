package flash.geom {
	
	
	/**
	 * @externs
	 * The Matrix class represents a transformation matrix that determines how to
	 * map points from one coordinate space to another. You can perform various
	 * graphical transformations on a display object by setting the properties of
	 * a Matrix object, applying that Matrix object to the `matrix`
	 * property of a Transform object, and then applying that Transform object as
	 * the `transform` property of the display object. These
	 * transformation functions include translation(_x_ and _y_
	 * repositioning), rotation, scaling, and skewing.
	 *
	 * Together these types of transformations are known as _affine
	 * transformations_. Affine transformations preserve the straightness of
	 * lines while transforming, so that parallel lines stay parallel.
	 *
	 * To apply a transformation matrix to a display object, you create a
	 * Transform object, set its `matrix` property to the
	 * transformation matrix, and then set the `transform` property of
	 * the display object to the Transform object. Matrix objects are also used as
	 * parameters of some methods, such as the following:
	 *
	 * 
	 *  * The `draw()` method of a BitmapData object
	 *  * The `beginBitmapFill()` method,
	 * `beginGradientFill()` method, or
	 * `lineGradientStyle()` method of a Graphics object
	 * 
	 *
	 * A transformation matrix object is a 3 x 3 matrix with the following
	 * contents:
	 *
	 * In traditional transformation matrixes, the `u`,
	 * `v`, and `w` properties provide extra capabilities.
	 * The Matrix class can only operate in two-dimensional space, so it always
	 * assumes that the property values `u` and `v` are 0.0,
	 * and that the property value `w` is 1.0. The effective values of
	 * the matrix are as follows:
	 *
	 * You can get and set the values of all six of the other properties in a
	 * Matrix object: `a`, `b`, `c`,
	 * `d`, `tx`, and `ty`.
	 *
	 * The Matrix class supports the four major types of transformations:
	 * translation, scaling, rotation, and skewing. You can set three of these
	 * transformations by using specialized methods, as described in the following
	 * table: 
	 *
	 * Each transformation function alters the current matrix properties so
	 * that you can effectively combine multiple transformations. To do this, you
	 * call more than one transformation function before applying the matrix to
	 * its display object target(by using the `transform` property of
	 * that display object).
	 *
	 * Use the `new Matrix()` constructor to create a Matrix object
	 * before you can call the methods of the Matrix object.
	 */
	public class Matrix {
		
		
		/**
		 * The value that affects the positioning of pixels along the _x_ axis
		 * when scaling or rotating an image.
		 */
		public var a:Number;
		
		/**
		 * The value that affects the positioning of pixels along the _y_ axis
		 * when rotating or skewing an image.
		 */
		public var b:Number;
		
		/**
		 * The value that affects the positioning of pixels along the _x_ axis
		 * when rotating or skewing an image.
		 */
		public var c:Number;
		
		/**
		 * The value that affects the positioning of pixels along the _y_ axis
		 * when scaling or rotating an image.
		 */
		public var d:Number;
		
		/**
		 * The distance by which to translate each point along the _x_ axis.
		 */
		public var tx:Number;
		
		/**
		 * The distance by which to translate each point along the _y_ axis.
		 */
		public var ty:Number;
		
		
		/**
		 * Creates a new Matrix object with the specified parameters. In matrix
		 * notation, the properties are organized like this:
		 *
		 * If you do not provide any parameters to the `new Matrix()`
		 * constructor, it creates an _identity matrix_ with the following
		 * values:
		 *
		 * In matrix notation, the identity matrix looks like this:
		 * 
		 * @param a  The value that affects the positioning of pixels along the
		 *           _x_ axis when scaling or rotating an image.
		 * @param b  The value that affects the positioning of pixels along the
		 *           _y_ axis when rotating or skewing an image.
		 * @param c  The value that affects the positioning of pixels along the
		 *           _x_ axis when rotating or skewing an image.
		 * @param d  The value that affects the positioning of pixels along the
		 *           _y_ axis when scaling or rotating an image..
		 * @param tx The distance by which to translate each point along the _x_
		 *           axis.
		 * @param ty The distance by which to translate each point along the _y_
		 *           axis.
		 */
		public function Matrix (a:Number = 1, b:Number = 0, c:Number = 0, d:Number = 1, tx:Number = 0, ty:Number = 0) {}
		
		
		/**
		 * Returns a new Matrix object that is a clone of this matrix, with an exact
		 * copy of the contained object.
		 * 
		 * @return A Matrix object.
		 */
		//public inline function clone ():Matrix;
		public function clone ():Matrix { return null; }
		
		
		/**
		 * Concatenates a matrix with the current matrix, effectively combining the
		 * geometric effects of the two. In mathematical terms, concatenating two
		 * matrixes is the same as combining them using matrix multiplication.
		 *
		 * For example, if matrix `m1` scales an object by a factor of
		 * four, and matrix `m2` rotates an object by 1.5707963267949
		 * radians(`Math.PI/2`), then `m1.concat(m2)`
		 * transforms `m1` into a matrix that scales an object by a factor
		 * of four and rotates the object by `Math.PI/2` radians. 
		 *
		 * This method replaces the source matrix with the concatenated matrix. If
		 * you want to concatenate two matrixes without altering either of the two
		 * source matrixes, first copy the source matrix by using the
		 * `clone()` method, as shown in the Class Examples section.
		 * 
		 * @param m The matrix to be concatenated to the source matrix.
		 */
		public function concat (m:Matrix):void {}
		
		
		public function copyColumnFrom (column:int, vector3D:Vector3D):void {}
		
		
		public function copyColumnTo (column:int, vector3D:Vector3D):void {}
		
		
		public function copyFrom (sourceMatrix:Matrix):void {}
		
		
		public function copyRowFrom (row:int, vector3D:Vector3D):void {}
		
		
		public function copyRowTo (row:int, vector3D:Vector3D):void {}
		
		
		/**
		 * Includes parameters for scaling, rotation, and translation. When applied
		 * to a matrix it sets the matrix's values based on those parameters.
		 *
		 * Using the `createBox()` method lets you obtain the same
		 * matrix as you would if you applied the `identity()`,
		 * `rotate()`, `scale()`, and `translate()`
		 * methods in succession. For example, `mat1.createBox(2,2,Math.PI/4,
		 * 100, 100)` has the same effect as the following:
		 * 
		 * @param scaleX   The factor by which to scale horizontally.
		 * @param scaleY   The factor by which scale vertically.
		 * @param rotation The amount to rotate, in radians.
		 * @param tx       The number of pixels to translate(move) to the right
		 *                 along the _x_ axis.
		 * @param ty       The number of pixels to translate(move) down along the
		 *                 _y_ axis.
		 */
		public function createBox (scaleX:Number, scaleY:Number, rotation:Number = 0, tx:Number = 0, ty:Number = 0):void {}
		
		
		/**
		 * Creates the specific style of matrix expected by the
		 * `beginGradientFill()` and `lineGradientStyle()`
		 * methods of the Graphics class. Width and height are scaled to a
		 * `scaleX`/`scaleY` pair and the
		 * `tx`/`ty` values are offset by half the width and
		 * height.
		 *
		 * For example, consider a gradient with the following
		 * characteristics:
		 *
		 * 
		 *  * `GradientType.LINEAR`
		 *  * Two colors, green and blue, with the ratios array set to `[0,
		 * 255]`
		 *  * `SpreadMethod.PAD`
		 *  * `InterpolationMethod.LINEAR_RGB`
		 * 
		 *
		 * The following illustrations show gradients in which the matrix was
		 * defined using the `createGradientBox()` method with different
		 * parameter settings:
		 * 
		 * @param width    The width of the gradient box.
		 * @param height   The height of the gradient box.
		 * @param rotation The amount to rotate, in radians.
		 * @param tx       The distance, in pixels, to translate to the right along
		 *                 the _x_ axis. This value is offset by half of the
		 *                 `width` parameter.
		 * @param ty       The distance, in pixels, to translate down along the
		 *                 _y_ axis. This value is offset by half of the
		 *                 `height` parameter.
		 */
		public function createGradientBox (width:Number, height:Number, rotation:Number = 0, tx:Number = 0, ty:Number = 0):void {}
		
		
		/**
		 * Given a point in the pretransform coordinate space, returns the
		 * coordinates of that point after the transformation occurs. Unlike the
		 * standard transformation applied using the `transformPoint()`
		 * method, the `deltaTransformPoint()` method's transformation
		 * does not consider the translation parameters `tx` and
		 * `ty`.
		 * 
		 * @param point The point for which you want to get the result of the matrix
		 *              transformation.
		 * @return The point resulting from applying the matrix transformation.
		 */
		public function deltaTransformPoint (point:Point):Point { return null; }
		
		
		/**
		 * Sets each matrix property to a value that causes a null transformation. An
		 * object transformed by applying an identity matrix will be identical to the
		 * original.
		 *
		 * After calling the `identity()` method, the resulting matrix
		 * has the following properties: `a`=1, `b`=0,
		 * `c`=0, `d`=1, `tx`=0,
		 * `ty`=0.
		 *
		 * In matrix notation, the identity matrix looks like this:
		 * 
		 */
		public function identity ():void {}
		
		
		/**
		 * Performs the opposite transformation of the original matrix. You can apply
		 * an inverted matrix to an object to undo the transformation performed when
		 * applying the original matrix.
		 * 
		 */
		public function invert ():Matrix { return null; }
		
		
		/**
		 * Applies a rotation transformation to the Matrix object.
		 *
		 * The `rotate()` method alters the `a`,
		 * `b`, `c`, and `d` properties of the
		 * Matrix object. In matrix notation, this is the same as concatenating the
		 * current matrix with the following:
		 * 
		 * @param angle The rotation angle in radians.
		 */
		public function rotate (theta:Number):void {}
		
		
		/**
		 * Applies a scaling transformation to the matrix. The _x_ axis is
		 * multiplied by `sx`, and the _y_ axis it is multiplied by
		 * `sy`.
		 *
		 * The `scale()` method alters the `a` and
		 * `d` properties of the Matrix object. In matrix notation, this
		 * is the same as concatenating the current matrix with the following
		 * matrix:
		 * 
		 * @param sx A multiplier used to scale the object along the _x_ axis.
		 * @param sy A multiplier used to scale the object along the _y_ axis.
		 */
		public function scale (sx:Number, sy:Number):void {}
		
		
		public function setTo (a:Number, b:Number, c:Number, d:Number, tx:Number, ty:Number):void {}
		
		
		/**
		 * Returns a text value listing the properties of the Matrix object.
		 * 
		 * @return A string containing the values of the properties of the Matrix
		 *         object: `a`, `b`, `c`,
		 *         `d`, `tx`, and `ty`.
		 */
		//public inline function toString ():String;
		public function toString ():String { return null; }
		
		
		/**
		 * Returns the result of applying the geometric transformation represented by
		 * the Matrix object to the specified point.
		 * 
		 * @param point The point for which you want to get the result of the Matrix
		 *              transformation.
		 * @return The point resulting from applying the Matrix transformation.
		 */
		public function transformPoint (pos:Point):Point { return null; }
		
		
		/**
		 * Translates the matrix along the _x_ and _y_ axes, as specified
		 * by the `dx` and `dy` parameters.
		 * 
		 * @param dx The amount of movement along the _x_ axis to the right, in
		 *           pixels.
		 * @param dy The amount of movement down along the _y_ axis, in pixels.
		 */
		public function translate (dx:Number, dy:Number):void {}
		
		
	}
	
	
}