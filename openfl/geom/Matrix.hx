package openfl.geom; #if !flash #if !lime_legacy


import openfl.geom.Point;
import lime.utils.Float32Array;


/**
 * The Matrix class represents a transformation matrix that determines how to
 * map points from one coordinate space to another. You can perform various
 * graphical transformations on a display object by setting the properties of
 * a Matrix object, applying that Matrix object to the <code>matrix</code>
 * property of a Transform object, and then applying that Transform object as
 * the <code>transform</code> property of the display object. These
 * transformation functions include translation(<i>x</i> and <i>y</i>
 * repositioning), rotation, scaling, and skewing.
 *
 * <p>Together these types of transformations are known as <i>affine
 * transformations</i>. Affine transformations preserve the straightness of
 * lines while transforming, so that parallel lines stay parallel.</p>
 *
 * <p>To apply a transformation matrix to a display object, you create a
 * Transform object, set its <code>matrix</code> property to the
 * transformation matrix, and then set the <code>transform</code> property of
 * the display object to the Transform object. Matrix objects are also used as
 * parameters of some methods, such as the following:</p>
 *
 * <ul>
 *   <li>The <code>draw()</code> method of a BitmapData object</li>
 *   <li>The <code>beginBitmapFill()</code> method,
 * <code>beginGradientFill()</code> method, or
 * <code>lineGradientStyle()</code> method of a Graphics object</li>
 * </ul>
 *
 * <p>A transformation matrix object is a 3 x 3 matrix with the following
 * contents:</p>
 *
 * <p>In traditional transformation matrixes, the <code>u</code>,
 * <code>v</code>, and <code>w</code> properties provide extra capabilities.
 * The Matrix class can only operate in two-dimensional space, so it always
 * assumes that the property values <code>u</code> and <code>v</code> are 0.0,
 * and that the property value <code>w</code> is 1.0. The effective values of
 * the matrix are as follows:</p>
 *
 * <p>You can get and set the values of all six of the other properties in a
 * Matrix object: <code>a</code>, <code>b</code>, <code>c</code>,
 * <code>d</code>, <code>tx</code>, and <code>ty</code>.</p>
 *
 * <p>The Matrix class supports the four major types of transformations:
 * translation, scaling, rotation, and skewing. You can set three of these
 * transformations by using specialized methods, as described in the following
 * table: </p>
 *
 * <p>Each transformation function alters the current matrix properties so
 * that you can effectively combine multiple transformations. To do this, you
 * call more than one transformation function before applying the matrix to
 * its display object target(by using the <code>transform</code> property of
 * that display object).</p>
 *
 * <p>Use the <code>new Matrix()</code> constructor to create a Matrix object
 * before you can call the methods of the Matrix object.</p>
 */
class Matrix {
	
	
	/**
	 * The value that affects the positioning of pixels along the <i>x</i> axis
	 * when scaling or rotating an image.
	 */
	public var a:Float;
	
	/**
	 * The value that affects the positioning of pixels along the <i>y</i> axis
	 * when rotating or skewing an image.
	 */
	public var b:Float;
	
	/**
	 * The value that affects the positioning of pixels along the <i>x</i> axis
	 * when rotating or skewing an image.
	 */
	public var c:Float;
	
	/**
	 * The value that affects the positioning of pixels along the <i>y</i> axis
	 * when scaling or rotating an image.
	 */
	public var d:Float;
	
	/**
	 * The distance by which to translate each point along the <i>x</i> axis.
	 */
	public var tx:Float;
	
	/**
	 * The distance by which to translate each point along the <i>y</i> axis.
	 */
	public var ty:Float;
	
	@:noCompletion private var __array:Float32Array;

	@:noCompletion private static var __identity = new Matrix ();
	
	
	/**
	 * Creates a new Matrix object with the specified parameters. In matrix
	 * notation, the properties are organized like this:
	 *
	 * <p>If you do not provide any parameters to the <code>new Matrix()</code>
	 * constructor, it creates an <i>identity matrix</i> with the following
	 * values:</p>
	 *
	 * <p>In matrix notation, the identity matrix looks like this:</p>
	 * 
	 * @param a  The value that affects the positioning of pixels along the
	 *           <i>x</i> axis when scaling or rotating an image.
	 * @param b  The value that affects the positioning of pixels along the
	 *           <i>y</i> axis when rotating or skewing an image.
	 * @param c  The value that affects the positioning of pixels along the
	 *           <i>x</i> axis when rotating or skewing an image.
	 * @param d  The value that affects the positioning of pixels along the
	 *           <i>y</i> axis when scaling or rotating an image..
	 * @param tx The distance by which to translate each point along the <i>x</i>
	 *           axis.
	 * @param ty The distance by which to translate each point along the <i>y</i>
	 *           axis.
	 */
	public function new (a:Float = 1, b:Float = 0, c:Float = 0, d:Float = 1, tx:Float = 0, ty:Float = 0) {
		
		this.a = a;
		this.b = b;
		this.c = c;
		this.d = d;
		this.tx = tx;
		this.ty = ty;

		__array = new Float32Array([a, b, c, d, tx, ty, 0, 0, 1]);
		
	}
	
	
	/**
	 * Returns a new Matrix object that is a clone of this matrix, with an exact
	 * copy of the contained object.
	 * 
	 * @return A Matrix object.
	 */
	public inline function clone ():Matrix {
		
		return new Matrix (a, b, c, d, tx, ty);
		
	}
	
	
	/**
	 * Concatenates a matrix with the current matrix, effectively combining the
	 * geometric effects of the two. In mathematical terms, concatenating two
	 * matrixes is the same as combining them using matrix multiplication.
	 *
	 * <p>For example, if matrix <code>m1</code> scales an object by a factor of
	 * four, and matrix <code>m2</code> rotates an object by 1.5707963267949
	 * radians(<code>Math.PI/2</code>), then <code>m1.concat(m2)</code>
	 * transforms <code>m1</code> into a matrix that scales an object by a factor
	 * of four and rotates the object by <code>Math.PI/2</code> radians. </p>
	 *
	 * <p>This method replaces the source matrix with the concatenated matrix. If
	 * you want to concatenate two matrixes without altering either of the two
	 * source matrixes, first copy the source matrix by using the
	 * <code>clone()</code> method, as shown in the Class Examples section.</p>
	 * 
	 * @param m The matrix to be concatenated to the source matrix.
	 */
	public function concat (m:Matrix):Void {
		
		var a1 = a * m.a + b * m.c;
		b = a * m.b + b * m.d;
		a = a1;

		var c1 = c * m.a + d * m.c;
		d = c * m.b + d * m.d;
		c = c1;
		
		var tx1 = tx * m.a + ty * m.c + m.tx;
		ty = tx * m.b + ty * m.d + m.ty;
		tx = tx1;
		
		//__cleanValues ();
		
	}
	
	
	public function copyColumnFrom (column:Int, vector3D:Vector3D):Void {
		
		if (column > 2) {
			
			throw "Column " + column + " out of bounds (2)";
			
		} else if (column == 0) {
			
			a = vector3D.x;
			c = vector3D.y;
			
		}else if (column == 1) {
			
			b = vector3D.x;
			d = vector3D.y;
			
		}else {
			
			tx = vector3D.x;
			ty = vector3D.y;
			
		}
		
	}
	
	
	public function copyColumnTo (column:Int, vector3D:Vector3D):Void {
		
		if (column > 2) {
			
			throw "Column " + column + " out of bounds (2)";
			
		} else if (column == 0) {
			
			vector3D.x = a;
			vector3D.y = c;
			vector3D.z = 0;
			
		} else if (column == 1) {
			
			vector3D.x = b;
			vector3D.y = d;
			vector3D.z = 0;
			
		} else {
			
			vector3D.x = tx;
			vector3D.y = ty;
			vector3D.z = 1;
			
		}
		
	}
	
	
	public function copyFrom (sourceMatrix:Matrix):Void {
		
		a = sourceMatrix.a;
		b = sourceMatrix.b;
		c = sourceMatrix.c;
		d = sourceMatrix.d;
		tx = sourceMatrix.tx;
		ty = sourceMatrix.ty;
		
	}
	
	
	public function copyRowFrom (row:Int, vector3D:Vector3D):Void {
		
		if (row > 2) {
			
			throw "Row " + row + " out of bounds (2)";
			
		} else if (row == 0) {
			
			a = vector3D.x;
			c = vector3D.y;
			
		} else if (row == 1) {
			
			b = vector3D.x;
			d = vector3D.y;
			
		} else {
			
			tx = vector3D.x;
			ty = vector3D.y;
			
		}
		
	}
	
	
	public function copyRowTo (row:Int, vector3D:Vector3D):Void {
		
		if (row > 2) {
			
			throw "Row " + row + " out of bounds (2)";
			
		} else if (row == 0) {
			
			vector3D.x = a;
			vector3D.y = b;
			vector3D.z = tx;
			
		} else if (row == 1) {
			
			vector3D.x = c;
			vector3D.y = d;
			vector3D.z = ty;
			
		}else {
			
			vector3D.setTo (0, 0, 1);
			
		}
		
	}
	
	
	/**
	 * Includes parameters for scaling, rotation, and translation. When applied
	 * to a matrix it sets the matrix's values based on those parameters.
	 *
	 * <p>Using the <code>createBox()</code> method lets you obtain the same
	 * matrix as you would if you applied the <code>identity()</code>,
	 * <code>rotate()</code>, <code>scale()</code>, and <code>translate()</code>
	 * methods in succession. For example, <code>mat1.createBox(2,2,Math.PI/4,
	 * 100, 100)</code> has the same effect as the following:</p>
	 * 
	 * @param scaleX   The factor by which to scale horizontally.
	 * @param scaleY   The factor by which scale vertically.
	 * @param rotation The amount to rotate, in radians.
	 * @param tx       The number of pixels to translate(move) to the right
	 *                 along the <i>x</i> axis.
	 * @param ty       The number of pixels to translate(move) down along the
	 *                 <i>y</i> axis.
	 */
	public function createBox (scaleX:Float, scaleY:Float, rotation:Float = 0, tx:Float = 0, ty:Float = 0):Void {
		
		//identity ();
		//rotate (rotation);
		//scale (scaleX, scaleY);
		//translate (tx, ty);
		
		if (rotation != 0) {
			
			var cos = Math.cos (rotation);
			var sin = Math.sin (rotation);
			
			a = cos * scaleX;
			b = sin * scaleY;
			c = -sin * scaleX;
			d = cos * scaleY;
			
		} else {
			
			a = scaleX;
			b = 0;
			c = 0;
			d = scaleY;
			
		}
		
		this.tx = tx;
		this.ty = ty;
		
	}
	
	
	/**
	 * Creates the specific style of matrix expected by the
	 * <code>beginGradientFill()</code> and <code>lineGradientStyle()</code>
	 * methods of the Graphics class. Width and height are scaled to a
	 * <code>scaleX</code>/<code>scaleY</code> pair and the
	 * <code>tx</code>/<code>ty</code> values are offset by half the width and
	 * height.
	 *
	 * <p>For example, consider a gradient with the following
	 * characteristics:</p>
	 *
	 * <ul>
	 *   <li><code>GradientType.LINEAR</code></li>
	 *   <li>Two colors, green and blue, with the ratios array set to <code>[0,
	 * 255]</code></li>
	 *   <li><code>SpreadMethod.PAD</code></li>
	 *   <li><code>InterpolationMethod.LINEAR_RGB</code></li>
	 * </ul>
	 *
	 * <p>The following illustrations show gradients in which the matrix was
	 * defined using the <code>createGradientBox()</code> method with different
	 * parameter settings:</p>
	 * 
	 * @param width    The width of the gradient box.
	 * @param height   The height of the gradient box.
	 * @param rotation The amount to rotate, in radians.
	 * @param tx       The distance, in pixels, to translate to the right along
	 *                 the <i>x</i> axis. This value is offset by half of the
	 *                 <code>width</code> parameter.
	 * @param ty       The distance, in pixels, to translate down along the
	 *                 <i>y</i> axis. This value is offset by half of the
	 *                 <code>height</code> parameter.
	 */
	public function createGradientBox (width:Float, height:Float, rotation:Float = 0, tx:Float = 0, ty:Float = 0):Void {
		
		a = width / 1638.4;
		d = height / 1638.4;
		
		// rotation is clockwise
		if (rotation != 0) {
			
			var cos = Math.cos (rotation);
			var sin = Math.sin (rotation);
			
			b = sin * d;
			c = -sin * a;
			a *= cos;
			d *= cos;
			
		} else {
			
			b = 0;
			c = 0;
			
		}
		
		this.tx = tx + width / 2;
		this.ty = ty + height / 2;
		
	}
	
	
	/**
	 * Given a point in the pretransform coordinate space, returns the
	 * coordinates of that point after the transformation occurs. Unlike the
	 * standard transformation applied using the <code>transformPoint()</code>
	 * method, the <code>deltaTransformPoint()</code> method's transformation
	 * does not consider the translation parameters <code>tx</code> and
	 * <code>ty</code>.
	 * 
	 * @param point The point for which you want to get the result of the matrix
	 *              transformation.
	 * @return The point resulting from applying the matrix transformation.
	 */
	public function deltaTransformPoint (point:Point):Point {
		
		return new Point (point.x * a + point.y * c, point.x * b + point.y * d);
		
	}
	
	
	public function equals (matrix):Bool {
		
		return (matrix != null && tx == matrix.tx && ty == matrix.ty && a == matrix.a && b == matrix.b && c == matrix.c && d == matrix.d);
		
	}
	
	
	/**
	 * Sets each matrix property to a value that causes a null transformation. An
	 * object transformed by applying an identity matrix will be identical to the
	 * original.
	 *
	 * <p>After calling the <code>identity()</code> method, the resulting matrix
	 * has the following properties: <code>a</code>=1, <code>b</code>=0,
	 * <code>c</code>=0, <code>d</code>=1, <code>tx</code>=0,
	 * <code>ty</code>=0.</p>
	 *
	 * <p>In matrix notation, the identity matrix looks like this:</p>
	 * 
	 */
	public function identity ():Void {
		
		a = 1;
		b = 0;
		c = 0;
		d = 1;
		tx = 0;
		ty = 0;
		
	}
	
	
	/**
	 * Performs the opposite transformation of the original matrix. You can apply
	 * an inverted matrix to an object to undo the transformation performed when
	 * applying the original matrix.
	 * 
	 */
	public function invert ():Matrix {
		
		var norm = a * d - b * c;
		
		if (norm == 0) {
			
			a = b = c = d = 0;
			tx = -tx;
			ty = -ty;
			
		} else {
			
			norm = 1.0 / norm;
			var a1 = d * norm;
			d = a * norm;
			a = a1;
			b *= -norm;
			c *= -norm;
			
			var tx1 = - a * tx - c * ty;
			ty = - b * tx - d * ty;
			tx = tx1;
			
		}
		
		//__cleanValues ();
		
		return this;
		
	}
	
	
	public inline function mult (m:Matrix) {
		
		var result = new Matrix ();

		result.a = a * m.a + b * m.c;
		result.b = a * m.b + b * m.d;
		result.c = c * m.a + d * m.c;
		result.d = c * m.b + d * m.d;

		result.tx = tx * m.a + ty * m.c + m.tx;
		result.ty = tx * m.b + ty * m.d + m.ty;

		return result;
		
	}
	
	
	/**
	 * Applies a rotation transformation to the Matrix object.
	 *
	 * <p>The <code>rotate()</code> method alters the <code>a</code>,
	 * <code>b</code>, <code>c</code>, and <code>d</code> properties of the
	 * Matrix object. In matrix notation, this is the same as concatenating the
	 * current matrix with the following:</p>
	 * 
	 * @param angle The rotation angle in radians.
	 */
	public function rotate (theta:Float):Void {
		
		/*
		   Rotate object "after" other transforms
			
		   [  a  b   0 ][  ma mb  0 ]
		   [  c  d   0 ][  mc md  0 ]
		   [  tx ty  1 ][  mtx mty 1 ]
			
		   ma = md = cos
		   mb = sin
		   mc = -sin
		   mtx = my = 0
			
		 */
		
		var cos = Math.cos (theta);
		var sin = Math.sin (theta);
		
		var a1 = a * cos - b * sin;
		b = a * sin + b * cos;
		a = a1;
		
		var c1 = c * cos - d * sin;
		d = c * sin + d * cos;
		c = c1;
		
		var tx1 = tx * cos - ty * sin;
		ty = tx * sin + ty * cos;
		tx = tx1;
		
		//__cleanValues ();
		
	}
	
	
	/**
	 * Applies a scaling transformation to the matrix. The <i>x</i> axis is
	 * multiplied by <code>sx</code>, and the <i>y</i> axis it is multiplied by
	 * <code>sy</code>.
	 *
	 * <p>The <code>scale()</code> method alters the <code>a</code> and
	 * <code>d</code> properties of the Matrix object. In matrix notation, this
	 * is the same as concatenating the current matrix with the following
	 * matrix:</p>
	 * 
	 * @param sx A multiplier used to scale the object along the <i>x</i> axis.
	 * @param sy A multiplier used to scale the object along the <i>y</i> axis.
	 */
	public function scale (sx:Float, sy:Float) {
		
		/*
			
		   Scale object "after" other transforms
			
		   [  a  b   0 ][  sx  0   0 ]
		   [  c  d   0 ][  0   sy  0 ]
		   [  tx ty  1 ][  0   0   1 ]
		 */
		
		a *= sx;
		b *= sy;
		c *= sx;
		d *= sy;
		tx *= sx;
		ty *= sy;
		
		//__cleanValues ();
		
	}
	
	
	private inline function setRotation (theta:Float, scale:Float = 1) {
		
		a = Math.cos (theta) * scale;
		c = Math.sin (theta) * scale;
		b = -c;
		d = a;
		
		//__cleanValues ();
		
	}
	
	
	public function setTo (a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float):Void {
		
		this.a = a;
		this.b = b;
		this.c = c;
		this.d = d;
		this.tx = tx;
		this.ty = ty;
		
	}
	
	
	public inline function to3DString (roundPixels:Bool = false):String {
		
		// identityMatrix
		//  [a,b,tx,0],
		//  [c,d,ty,0],
		//  [0,0,1, 0],
		//  [0,0,0, 1]
		//
		// matrix3d(a,       b, 0, 0, c, d,       0, 0, 0, 0, 1, 0, tx,     ty, 0, 1)
		
		if (roundPixels) {
			
			return "matrix3d(" + a + ", " + b + ", " + "0, 0, " + c + ", " + d + ", " + "0, 0, 0, 0, 1, 0, " + Std.int (tx) + ", " + Std.int (ty) + ", 0, 1)";
			
		} else {
			
			return "matrix3d(" + a + ", " + b + ", " + "0, 0, " + c + ", " + d + ", " + "0, 0, 0, 0, 1, 0, " + tx + ", " + ty + ", 0, 1)";
			
		}
		
	}
	
	
	public inline function toMozString () {
		
		return "matrix(" + a + ", " + b + ", " + c + ", " + d + ", " + tx + "px, " + ty + "px)";
		
	}
	
	
	/**
	 * Returns a text value listing the properties of the Matrix object.
	 * 
	 * @return A string containing the values of the properties of the Matrix
	 *         object: <code>a</code>, <code>b</code>, <code>c</code>,
	 *         <code>d</code>, <code>tx</code>, and <code>ty</code>.
	 */
	public inline function toString ():String {
		
		return "matrix(" + a + ", " + b + ", " + c + ", " + d + ", " + tx + ", " + ty + ")";
		
	}
	
	
	/**
	 * Returns the result of applying the geometric transformation represented by
	 * the Matrix object to the specified point.
	 * 
	 * @param point The point for which you want to get the result of the Matrix
	 *              transformation.
	 * @return The point resulting from applying the Matrix transformation.
	 */
	public function transformPoint (pos:Point) {
		
		return new Point (__transformX (pos), __transformY (pos));
		
	}
	
	
	/**
	 * Translates the matrix along the <i>x</i> and <i>y</i> axes, as specified
	 * by the <code>dx</code> and <code>dy</code> parameters.
	 * 
	 * @param dx The amount of movement along the <i>x</i> axis to the right, in
	 *           pixels.
	 * @param dy The amount of movement down along the <i>y</i> axis, in pixels.
	 */
	public function translate (dx:Float, dy:Float) {
		
		var m = new Matrix ();
		m.tx = dx;
		m.ty = dy;
		this.concat (m);
		
	}
	
	
	@:noCompletion private function toArray (transpose:Bool = false):Float32Array {
		
		if (transpose) {
			
			__array[0] = a;
			__array[1] = c;
			__array[2] = 0;
			__array[3] = b;
			__array[4] = d;
			__array[5] = 0;
			__array[6] = tx;
			__array[7] = ty;
			__array[8] = 1;
			
		} else {
			
			__array[0] = a;
			__array[1] = b;
			__array[2] = tx;
			__array[3] = c;
			__array[4] = d;
			__array[5] = ty;
			__array[6] = 0;
			__array[7] = 0;
			__array[8] = 1;
			
		}
		
		return __array;
		
	}
	
	
	@:noCompletion private inline function __cleanValues ():Void {
		
		a = Math.round (a * 1000) / 1000;
		b = Math.round (b * 1000) / 1000;
		c = Math.round (c * 1000) / 1000;
		d = Math.round (d * 1000) / 1000;
		tx = Math.round (tx * 10) / 10;
		ty = Math.round (ty * 10) / 10;
		
	}
	
	
	@:noCompletion public inline function __transformX (pos:Point):Float {
		
		return pos.x * a + pos.y * c + tx;
		
	}
	
	
	@:noCompletion public inline function __transformY (pos:Point):Float {
		
		return pos.x * b + pos.y * d + ty;
		
	}
	
	
	@:noCompletion public inline function __translateTransformed (pos:Point):Void {
		
		tx = __transformX (pos);
		ty = __transformY (pos);
		
		//__cleanValues ();
		
	}
	
	
}


#else
typedef Matrix = openfl._v2.geom.Matrix;
#end
#else
typedef Matrix = flash.geom.Matrix;
#end