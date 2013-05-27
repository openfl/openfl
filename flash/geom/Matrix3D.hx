package flash.geom;
#if (flash || display)


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
@:require(flash10) extern class Matrix3D {
	var determinant(default,null) : Float;
	var position : Vector3D;
	var rawData : flash.Vector<Float>;

	/**
	 * Creates a new Matrix object with the specified parameters. In matrix
	 * notation, the properties are organized like this:
	 *
	 * <p>If you do not provide any parameters to the <code>new Matrix()</code>
	 * constructor, it creates an <i>identity matrix</i> with the following
	 * values:</p>
	 *
	 * <p>In matrix notation, the identity matrix looks like this:</p>
	 */
	function new(?v : flash.Vector<Float>) : Void;
	function append(lhs : Matrix3D) : Void;
	function appendRotation(degrees : Float, axis : Vector3D, ?pivotPoint : Vector3D) : Void;
	function appendScale(xScale : Float, yScale : Float, zScale : Float) : Void;
	function appendTranslation(x : Float, y : Float, z : Float) : Void;

	/**
	 * Returns a new Matrix object that is a clone of this matrix, with an exact
	 * copy of the contained object.
	 * 
	 * @return A Matrix object.
	 */
	function clone() : Matrix3D;
	@:require(flash11) function copyColumnFrom(column : Int, vector3D : Vector3D) : Void;
	@:require(flash11) function copyColumnTo(column : Int, vector3D : Vector3D) : Void;
	@:require(flash11) function copyFrom(sourceMatrix3D : Matrix3D) : Void;
	@:require(flash11) function copyRawDataFrom(vector : flash.Vector<Float>, index : Int = 0, transpose : Bool = false) : Void;
	@:require(flash11) function copyRawDataTo(vector : flash.Vector<Float>, index : Int = 0, transpose : Bool = false) : Void;
	@:require(flash11) function copyRowFrom(row : Int, vector3D : Vector3D) : Void;
	@:require(flash11) function copyRowTo(row : Int, vector3D : Vector3D) : Void;
	@:require(flash11) function copyToMatrix3D(dest : Matrix3D) : Void;
	#if !display
	function decompose(?orientationStyle : Orientation3D) : flash.Vector<Vector3D>;
	#end
	function deltaTransformVector(v : Vector3D) : Vector3D;

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
	function identity() : Void;
	function interpolateTo(toMat : Matrix3D, percent : Float) : Void;

	/**
	 * Performs the opposite transformation of the original matrix. You can apply
	 * an inverted matrix to an object to undo the transformation performed when
	 * applying the original matrix.
	 * 
	 */
	function invert() : Bool;
	function pointAt(pos : Vector3D, ?at : Vector3D, ?up : Vector3D) : Void;
	function prepend(rhs : Matrix3D) : Void;
	function prependRotation(degrees : Float, axis : Vector3D, ?pivotPoint : Vector3D) : Void;
	function prependScale(xScale : Float, yScale : Float, zScale : Float) : Void;
	function prependTranslation(x : Float, y : Float, z : Float) : Void;
	#if !display
	function recompose(components : flash.Vector<Vector3D>, ?orientationStyle : Orientation3D) : Bool;
	#end
	function transformVector(v : Vector3D) : Vector3D;
	function transformVectors(vin : flash.Vector<Float>, vout : flash.Vector<Float>) : Void;
	function transpose() : Void;
	static function interpolate(thisMat : Matrix3D, toMat : Matrix3D, percent : Float) : Matrix3D;
}


#end