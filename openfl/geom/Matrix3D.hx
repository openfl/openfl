package openfl.geom; #if !flash


import openfl.geom.Orientation3D;
import openfl.geom.Vector3D;
import openfl.errors.Error;
import openfl.Vector;


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
class Matrix3D {
	
	
	public var determinant (get, null):Float;
	public var position (get, set):Vector3D;
	public var rawData:Vector<Float>;
	
	
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
	public function new (v:Vector<Float> = null) {
		
		if (v != null && v.length == 16) {
			
			rawData = v;
			
		} else {
			
			rawData = [ 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0 ];
			
		}
		
	}
	
	
	public inline function append (lhs:Matrix3D):Void {
		
		var m111:Float = this.rawData[0], m121:Float = this.rawData[4], m131:Float = this.rawData[8], m141:Float = this.rawData[12],
			m112:Float = this.rawData[1], m122:Float = this.rawData[5], m132:Float = this.rawData[9], m142:Float = this.rawData[13],
			m113:Float = this.rawData[2], m123:Float = this.rawData[6], m133:Float = this.rawData[10], m143:Float = this.rawData[14],
			m114:Float = this.rawData[3], m124:Float = this.rawData[7], m134:Float = this.rawData[11], m144:Float = this.rawData[15],
			m211:Float = lhs.rawData[0], m221:Float = lhs.rawData[4], m231:Float = lhs.rawData[8], m241:Float = lhs.rawData[12],
			m212:Float = lhs.rawData[1], m222:Float = lhs.rawData[5], m232:Float = lhs.rawData[9], m242:Float = lhs.rawData[13],
			m213:Float = lhs.rawData[2], m223:Float = lhs.rawData[6], m233:Float = lhs.rawData[10], m243:Float = lhs.rawData[14],
			m214:Float = lhs.rawData[3], m224:Float = lhs.rawData[7], m234:Float = lhs.rawData[11], m244:Float = lhs.rawData[15];
		
		rawData[0] = m111 * m211 + m112 * m221 + m113 * m231 + m114 * m241;
		rawData[1] = m111 * m212 + m112 * m222 + m113 * m232 + m114 * m242;
		rawData[2] = m111 * m213 + m112 * m223 + m113 * m233 + m114 * m243;
		rawData[3] = m111 * m214 + m112 * m224 + m113 * m234 + m114 * m244;
		
		rawData[4] = m121 * m211 + m122 * m221 + m123 * m231 + m124 * m241;
		rawData[5] = m121 * m212 + m122 * m222 + m123 * m232 + m124 * m242;
		rawData[6] = m121 * m213 + m122 * m223 + m123 * m233 + m124 * m243;
		rawData[7] = m121 * m214 + m122 * m224 + m123 * m234 + m124 * m244;
		
		rawData[8] = m131 * m211 + m132 * m221 + m133 * m231 + m134 * m241;
		rawData[9] = m131 * m212 + m132 * m222 + m133 * m232 + m134 * m242;
		rawData[10] = m131 * m213 + m132 * m223 + m133 * m233 + m134 * m243;
		rawData[11] = m131 * m214 + m132 * m224 + m133 * m234 + m134 * m244;
		
		rawData[12] = m141 * m211 + m142 * m221 + m143 * m231 + m144 * m241;
		rawData[13] = m141 * m212 + m142 * m222 + m143 * m232 + m144 * m242;
		rawData[14] = m141 * m213 + m142 * m223 + m143 * m233 + m144 * m243;
		rawData[15] = m141 * m214 + m142 * m224 + m143 * m234 + m144 * m244;
		
	}
	
	
	public inline function appendRotation (degrees:Float, axis:Vector3D, pivotPoint:Vector3D = null):Void {
		
		var m = getAxisRotation (axis.x, axis.y, axis.z, degrees);
		
		if (pivotPoint != null) {
			
			var p = pivotPoint;
			m.appendTranslation (p.x, p.y, p.z);
			
		}
		
		this.append (m);
		
	}
	
	
	public inline function appendScale (xScale:Float, yScale:Float, zScale:Float):Void {
		
		this.append (new Matrix3D ([ xScale, 0.0, 0.0, 0.0, 0.0, yScale, 0.0, 0.0, 0.0, 0.0, zScale, 0.0, 0.0, 0.0, 0.0, 1.0 ]));
		
	}
	
	
	public inline function appendTranslation (x:Float, y:Float, z:Float):Void {
		
		rawData[12] += x;
		rawData[13] += y;
		rawData[14] += z;
		
	}
	
	
	/**
	 * Returns a new Matrix object that is a clone of this matrix, with an exact
	 * copy of the contained object.
	 * 
	 * @return A Matrix object.
	 */
	public inline function clone ():Matrix3D {
		
		return new Matrix3D (this.rawData.copy ());
		
	}
	
	
	public function copyColumnFrom (column:Int, vector3D:Vector3D):Void {
		
		switch( column ) {
		
			case 0:
				rawData[ 0 ] = vector3D.x;
				rawData[ 1 ] = vector3D.y;
				rawData[ 2 ] = vector3D.z;
				rawData[ 3 ] = vector3D.w;
			case 1:
				rawData[ 4 ] = vector3D.x;
				rawData[ 5 ] = vector3D.y;
				rawData[ 6 ] = vector3D.z;
				rawData[ 7 ] = vector3D.w;
			case 2:
				rawData[ 8 ] = vector3D.x;
				rawData[ 9 ] = vector3D.y;
				rawData[ 10 ] = vector3D.z;
				rawData[ 11 ] = vector3D.w;
			case 3:
				rawData[ 12 ] = vector3D.x;
				rawData[ 13 ] = vector3D.y;
				rawData[ 14 ] = vector3D.z;
				rawData[ 15 ] = vector3D.w;
			default:
				throw new Error( "Error, Column " + column + " out of bounds [0, ..., 3]");
		}
		
	}
	
	
	public function copyColumnTo (column:Int, vector3D:Vector3D):Void {

		switch( column )
		{
			case 0:
				vector3D.x = rawData[ 0 ];
				vector3D.y = rawData[ 1 ];
				vector3D.z = rawData[ 2 ];
				vector3D.w = rawData[ 3 ];
			case 1:
				vector3D.x = rawData[ 4 ];
				vector3D.y = rawData[ 5 ];
				vector3D.z = rawData[ 6 ];
				vector3D.w = rawData[ 7 ];
			case 2:
				vector3D.x = rawData[ 8 ];
				vector3D.y = rawData[ 9 ];
				vector3D.z = rawData[ 10 ];
				vector3D.w = rawData[ 11 ];
			case 3:
				vector3D.x = rawData[ 12 ];
				vector3D.y = rawData[ 13 ];
				vector3D.z = rawData[ 14 ];
				vector3D.w = rawData[ 15 ];
			default:
				throw new Error( "Error, Column " + column + " out of bounds [0, ..., 3]");
		}
		
	}


	public function copyFrom (other:Matrix3D):Void {

		rawData = other.rawData.copy();

	}

	public function copyRawDataFrom( vector:Vector<Float>, index:UInt = 0, transpose:Bool = false ) {
		
		if ( transpose )
			this.transpose();
	  
		var l : UInt = vector.length - index;
		for ( c in 0...l )
			rawData[c] = vector[c+index];
	  
		if ( transpose )
			this.transpose();

	}


	public function copyRawDataTo( vector:Vector<Float>, index:UInt = 0, transpose:Bool = false ) {

		if ( transpose )
		   this.transpose();

		var l : UInt = rawData.length;
		for ( c in 0...l )
			vector[c + index ] = rawData[c];
		
		if ( transpose )
			this.transpose();

	}


	public function copyRowFrom( row:UInt, vector3D:Vector3D ) {

		switch( row ) {

			case 0:
				rawData[ 0 ] = vector3D.x;
				rawData[ 4 ] = vector3D.y;
				rawData[ 8 ] = vector3D.z;
				rawData[ 12 ] = vector3D.w;
			
			case 1:
				rawData[ 1 ] = vector3D.x;
				rawData[ 5 ] = vector3D.y;
				rawData[ 9 ] = vector3D.z;
				rawData[ 13 ] = vector3D.w;
			
			case 2:
				rawData[ 2 ] = vector3D.x;
				rawData[ 6 ] = vector3D.y;
				rawData[ 10 ] = vector3D.z;
				rawData[ 14 ] = vector3D.w;
			
			case 3:
				rawData[ 3 ] = vector3D.x;
				rawData[ 7 ] = vector3D.y;
				rawData[ 11 ] = vector3D.z;
				rawData[ 15 ] = vector3D.w;
			
			default:
				throw new Error( "Error, Row " + row + " out of bounds [0, ..., 3]");
		}
		
	}
	
	
	public static function create2D (x:Float, y:Float, scale:Float = 1, rotation:Float = 0) {
		
		var theta = rotation * Math.PI / 180.0;
		var c = Math.cos (theta);
		var s = Math.sin (theta);
		
		return new Matrix3D ([
			c*scale,  -s*scale, 0,  0,
			s*scale,  c*scale, 0,  0,
			0,        0,        1,  0,
			x,        y,        0,  1
		]);
		
	}
   
   
	public static function createABCD (a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float) {
		
		return new Matrix3D ([
			a, b, 0, 0,
			c, d, 0, 0,
			0, 0, 1, 0,
			tx,ty,0, 1
		]);
		
	}
	
	
	public static function createOrtho (x0:Float, x1:Float,  y0:Float, y1:Float, zNear:Float, zFar:Float) {
		
		var sx = 1.0 / (x1 - x0);
		var sy = 1.0 / (y1 - y0);
		var sz = 1.0 / (zFar - zNear);
		
		return new Matrix3D ([
			2.0 * sx,     0,          0,                 0,
			0,            2.0 * sy,   0,                 0,
			0,            0,          -2.0 * sz,         0,
			- (x0 + x1) * sx, - (y0 + y1) * sy, - (zNear + zFar) * sz,  1,
		]);
		
	}
	
	
	public function copyRowTo (row:Int, vector3D:Vector3D):Void {

		switch( row ) {
		
			case 0:
				vector3D.x = rawData[ 0 ];
				vector3D.y = rawData[ 4 ];
				vector3D.z = rawData[ 8 ];
				vector3D.w = rawData[ 12 ];
			
			case 1:
				vector3D.x = rawData[ 1 ];
				vector3D.y = rawData[ 5 ];
				vector3D.z = rawData[ 9 ];
				vector3D.w = rawData[ 13 ];
			
			case 2:
				vector3D.x = rawData[ 2 ];
				vector3D.y = rawData[ 6 ];
				vector3D.z = rawData[ 10 ];
				vector3D.w = rawData[ 14 ];
			
			case 3:
				vector3D.x = rawData[ 3 ];
				vector3D.y = rawData[ 7 ];
				vector3D.z = rawData[ 11 ];
				vector3D.w = rawData[ 15 ];
			
			default:
				throw new Error( "Error, Row " + row + " out of bounds [0, ..., 3]");
		}
		
	}
	
	
	public function copyToMatrix3D (other:Matrix3D):Void {
		
		other.rawData = rawData.copy();
	
	}
	
	
	/**
	 * Returns the transformation matrix's translation, rotation, and scale settings as a Vector of three Vector3D objects.
	 */
	public function decompose(?orientationStyle:Orientation3D):Vector<Vector3D> {
		
		if (orientationStyle == null)
			orientationStyle = Orientation3D.EULER_ANGLES;
		
		var vec = new Vector<Vector3D>();
		var m = clone();
		var mr = m.rawData.copy();
		
		var pos = new Vector3D (mr[12], mr[13], mr[14]);
		mr[12] = 0;
		mr[13] = 0;
		mr[14] = 0;
		
		var scale = new Vector3D ();
		
		scale.x = Math.sqrt(mr[0] * mr[0] + mr[1] * mr[1] + mr[2] * mr[2]);
		scale.y = Math.sqrt(mr[4] * mr[4] + mr[5] * mr[5] + mr[6] * mr[6]);
		scale.z = Math.sqrt(mr[8] * mr[8] + mr[9] * mr[9] + mr[10] * mr[10]);
		
		if (mr[0] * (mr[5] * mr[10] - mr[6] * mr[9]) - mr[1] * (mr[4] * mr[10] - mr[6] * mr[8]) + mr[2] * (mr[4] * mr[9] - mr[5] * mr[8]) < 0) {
			
			scale.z = -scale.z;
			
		}
		
		mr[0] /= scale.x;
		mr[1] /= scale.x;
		mr[2] /= scale.x;
		mr[4] /= scale.y;
		mr[5] /= scale.y;
		mr[6] /= scale.y;
		mr[8] /= scale.z;
		mr[9] /= scale.z;
		mr[10] /= scale.z;
		
		var rot = new Vector3D ();
		switch (orientationStyle) {
			
			case Orientation3D.AXIS_ANGLE:
				rot.w = Math.acos((mr[0] + mr[5] + mr[10] - 1) / 2);
				
				var len = Math.sqrt((mr[6] - mr[9]) * (mr[6] - mr[9]) + (mr[8] - mr[2]) * (mr[8] - mr[2]) + (mr[1] - mr[4]) * (mr[1] - mr[4]));
				
				if (len != 0) {
					
					rot.x = (mr[6] - mr[9]) / len;
					rot.y = (mr[8] - mr[2]) / len;
					rot.z = (mr[1] - mr[4]) / len;
					
				} else {
					
					rot.x = rot.y = rot.z = 0;
					
				}
			
			case Orientation3D.QUATERNION:
				var tr = mr[0] + mr[5] + mr[10];
				
				if (tr > 0) {
					rot.w = Math.sqrt(1 + tr) / 2;
					
					rot.x = (mr[6] - mr[9]) / (4 * rot.w);
					rot.y = (mr[8] - mr[2]) / (4 * rot.w);
					rot.z = (mr[1] - mr[4]) / (4 * rot.w);
				} else if ((mr[0] > mr[5]) && (mr[0] > mr[10])) {
					rot.x = Math.sqrt(1 + mr[0] - mr[5] - mr[10]) / 2;
					
					rot.w = (mr[6] - mr[9]) / (4 * rot.x);
					rot.y = (mr[1] + mr[4]) / (4 * rot.x);
					rot.z = (mr[8] + mr[2]) / (4 * rot.x);
				} else if (mr[5] > mr[10]) {
					rot.y = Math.sqrt(1 + mr[5] - mr[0] - mr[10]) / 2;
					
					rot.x = (mr[1] + mr[4]) / (4 * rot.y);
					rot.w = (mr[8] - mr[2]) / (4 * rot.y);
					rot.z = (mr[6] + mr[9]) / (4 * rot.y);
				} else {
					rot.z = Math.sqrt(1 + mr[10] - mr[0] - mr[5]) / 2;

					rot.x = (mr[8] + mr[2]) / (4 * rot.z);
					rot.y = (mr[6] + mr[9]) / (4 * rot.z);
					rot.w = (mr[1] - mr[4]) / (4 * rot.z);
				}
			
			case Orientation3D.EULER_ANGLES:
				rot.y = Math.asin(-mr[2]);

				if (mr[2] != 1 && mr[2] != -1) {
					rot.x = Math.atan2(mr[6], mr[10]);
					rot.z = Math.atan2(mr[1], mr[0]);
				} else {
					rot.z = 0;
					rot.x = Math.atan2(mr[4], mr[5]);
				}
		}
		
		vec.push(pos);
		vec.push(rot);
		vec.push(scale);
		
		return vec;

	}


	public function deltaTransformVector( v:Vector3D ):Vector3D {

		var x:Float = v.x, y:Float = v.y, z:Float = v.z;

		return new Vector3D (
			(x * rawData[0] + y * rawData[4] + z * rawData[8] + rawData[3]),
			(x * rawData[1] + y * rawData[5] + z * rawData[9] + rawData[7]),
			(x * rawData[2] + y * rawData[6] + z * rawData[10] + rawData[11]),
			0);

	}


	public function identity() {

		rawData = [ 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0 ];
	
	}
	
	
	public static function interpolate (thisMat:Matrix3D, toMat:Matrix3D, percent:Float):Matrix3D {
		
		var m = new Matrix3D ();
		
		for (i in 0...16) {
			
			m.rawData[i] = thisMat.rawData[i] + (toMat.rawData[i] - thisMat.rawData[i]) * percent;
			
		}
		
		return m;
		
	}
	
	
	public inline function interpolateTo (toMat:Matrix3D, percent:Float):Void {
		
		for (i in 0...16) {
			
			rawData[i] = rawData[i] + (toMat.rawData[i] - rawData[i]) * percent;
			
		}
		
	}
	
	
	/**
	 * Performs the opposite transformation of the original matrix. You can apply
	 * an inverted matrix to an object to undo the transformation performed when
	 * applying the original matrix.
	 * 
	 */
	public inline function invert ():Bool {
		
		var d = determinant;
		var invertable = Math.abs (d) > 0.00000000001;
		
		if (invertable) {
			
			d = 1 / d;
			
			var m11:Float = rawData[0]; var m21:Float = rawData[4]; var m31:Float = rawData[8]; var m41:Float = rawData[12];
			var m12:Float = rawData[1]; var m22:Float = rawData[5]; var m32:Float = rawData[9]; var m42:Float = rawData[13];
			var m13:Float = rawData[2]; var m23:Float = rawData[6]; var m33:Float = rawData[10]; var m43:Float = rawData[14];
			var m14:Float = rawData[3]; var m24:Float = rawData[7]; var m34:Float = rawData[11]; var m44:Float = rawData[15];
			
			rawData[0] = d * (m22 * (m33 * m44 - m43 * m34) - m32 * (m23 * m44 - m43 * m24) + m42 * (m23 * m34 - m33 * m24));
			rawData[1] = -d * (m12 * (m33 * m44 - m43 * m34) - m32 * (m13 * m44 - m43 * m14) + m42 * (m13 * m34 - m33 * m14));
			rawData[2] = d * (m12 * (m23 * m44 - m43 * m24) - m22 * (m13 * m44 - m43 * m14) + m42 * (m13 * m24 - m23 * m14));
			rawData[3] = -d * (m12 * (m23 * m34 - m33 * m24) - m22 * (m13 * m34 - m33 * m14) + m32 * (m13 * m24 - m23 * m14));
			rawData[4] = -d * (m21 * (m33 * m44 - m43 * m34) - m31 * (m23 * m44 - m43 * m24) + m41 * (m23 * m34 - m33 * m24));
			rawData[5] = d * (m11 * (m33 * m44 - m43 * m34) - m31 * (m13 * m44 - m43 * m14) + m41 * (m13 * m34 - m33 * m14));
			rawData[6] = -d * (m11 * (m23 * m44 - m43 * m24) - m21 * (m13 * m44 - m43 * m14) + m41 * (m13 * m24 - m23 * m14));
			rawData[7] = d * (m11 * (m23 * m34 - m33 * m24) - m21 * (m13 * m34 - m33 * m14) + m31 * (m13 * m24 - m23 * m14));
			rawData[8] = d * (m21 * (m32 * m44 - m42 * m34) - m31 * (m22 * m44 - m42 * m24) + m41 * (m22 * m34 - m32 * m24));
			rawData[9] = -d * (m11 * (m32 * m44 - m42 * m34) - m31 * (m12 * m44 - m42 * m14) + m41 * (m12 * m34 - m32 * m14));
			rawData[10] = d * (m11 * (m22 * m44 - m42 * m24) - m21 * (m12 * m44 - m42 * m14) + m41 * (m12 * m24 - m22 * m14));
			rawData[11] = -d * (m11 * (m22 * m34 - m32 * m24) - m21 * (m12 * m34 - m32 * m14) + m31 * (m12 * m24 - m22 * m14));
			rawData[12] = -d * (m21 * (m32 * m43 - m42 * m33) - m31 * (m22 * m43 - m42 * m23) + m41 * (m22 * m33 - m32 * m23));
			rawData[13] = d * (m11 * (m32 * m43 - m42 * m33) - m31 * (m12 * m43 - m42 * m13) + m41 * (m12 * m33 - m32 * m13));
			rawData[14] = -d * (m11 * (m22 * m43 - m42 * m23) - m21 * (m12 * m43 - m42 * m13) + m41 * (m12 * m23 - m22 * m13));
			rawData[15] = d * (m11 * (m22 * m33 - m32 * m23) - m21 * (m12 * m33 - m32 * m13) + m31 * (m12 * m23 - m22 * m13));
			
		}
		
		return invertable;
		
	}
	
	
	public function pointAt (pos:Vector3D, at:Vector3D = null, up:Vector3D = null):Void {
		
		if (at == null) {
			
			at = new Vector3D (0, 0, -1);
			
		}
		
		if (up == null) {
			
			up = new Vector3D (0, -1, 0);
			
		}
		
		var dir = at.subtract(pos);
		var vup = up.clone();
		var right:Vector3D;
		
		dir.normalize ();
		vup.normalize ();
		
		var dir2 = dir.clone ();
		dir2.scaleBy (vup.dotProduct (dir));
		
		vup = vup.subtract (dir2);
		
		if (vup.length > 0) {
			
			vup.normalize ();
			
		} else {
			
			if (dir.x != 0) {
				
				vup = new Vector3D (-dir.y, dir.x, 0);
				
			} else {
				
				vup = new Vector3D (1, 0, 0);
				
			}
			
		}
		
		right = vup.crossProduct (dir);
		right.normalize ();
		
		rawData[0] = right.x;
		rawData[4] = right.y;
		rawData[8] = right.z;
		rawData[12] = 0.0;
		rawData[1] = vup.x;
		rawData[5] = vup.y;
		rawData[9] = vup.z;
		rawData[13] = 0.0;
		rawData[2] = dir.x;
		rawData[6] = dir.y;
		rawData[10] = dir.z;
		rawData[14] = 0.0;
		rawData[3] = pos.x;
		rawData[7] = pos.y;
		rawData[11] = pos.z;
		rawData[15] = 1.0;
		
	}
	
	
	public inline function prepend (rhs:Matrix3D):Void {
		
		var m111:Float = rhs.rawData[0], m121:Float = rhs.rawData[4], m131:Float = rhs.rawData[8], m141:Float = rhs.rawData[12],
			m112:Float = rhs.rawData[1], m122:Float = rhs.rawData[5], m132:Float = rhs.rawData[9], m142:Float = rhs.rawData[13],
			m113:Float = rhs.rawData[2], m123:Float = rhs.rawData[6], m133:Float = rhs.rawData[10], m143:Float = rhs.rawData[14],
			m114:Float = rhs.rawData[3], m124:Float = rhs.rawData[7], m134:Float = rhs.rawData[11], m144:Float = rhs.rawData[15],
			m211:Float = this.rawData[0], m221:Float = this.rawData[4], m231:Float = this.rawData[8], m241:Float = this.rawData[12],
			m212:Float = this.rawData[1], m222:Float = this.rawData[5], m232:Float = this.rawData[9], m242:Float = this.rawData[13],
			m213:Float = this.rawData[2], m223:Float = this.rawData[6], m233:Float = this.rawData[10], m243:Float = this.rawData[14],
			m214:Float = this.rawData[3], m224:Float = this.rawData[7], m234:Float = this.rawData[11], m244:Float = this.rawData[15];
		
		rawData[0] = m111 * m211 + m112 * m221 + m113 * m231 + m114 * m241;
		rawData[1] = m111 * m212 + m112 * m222 + m113 * m232 + m114 * m242;
		rawData[2] = m111 * m213 + m112 * m223 + m113 * m233 + m114 * m243;
		rawData[3] = m111 * m214 + m112 * m224 + m113 * m234 + m114 * m244;
		
		rawData[4] = m121 * m211 + m122 * m221 + m123 * m231 + m124 * m241;
		rawData[5] = m121 * m212 + m122 * m222 + m123 * m232 + m124 * m242;
		rawData[6] = m121 * m213 + m122 * m223 + m123 * m233 + m124 * m243;
		rawData[7] = m121 * m214 + m122 * m224 + m123 * m234 + m124 * m244;
		
		rawData[8] = m131 * m211 + m132 * m221 + m133 * m231 + m134 * m241;
		rawData[9] = m131 * m212 + m132 * m222 + m133 * m232 + m134 * m242;
		rawData[10] = m131 * m213 + m132 * m223 + m133 * m233 + m134 * m243;
		rawData[11] = m131 * m214 + m132 * m224 + m133 * m234 + m134 * m244;
		
		rawData[12] = m141 * m211 + m142 * m221 + m143 * m231 + m144 * m241;
		rawData[13] = m141 * m212 + m142 * m222 + m143 * m232 + m144 * m242;
		rawData[14] = m141 * m213 + m142 * m223 + m143 * m233 + m144 * m243;
		rawData[15] = m141 * m214 + m142 * m224 + m143 * m234 + m144 * m244;
		
	}
	
	
	public inline function prependRotation (degrees:Float, axis:Vector3D, pivotPoint:Vector3D = null):Void {
		
		var m = getAxisRotation (axis.x, axis.y, axis.z, degrees);
		
		if (pivotPoint != null) {
			
			var p = pivotPoint;
			m.appendTranslation (p.x, p.y, p.z);
			
		}
		
		this.prepend (m);
		
	}
	
	
	public inline function prependScale (xScale:Float, yScale:Float, zScale:Float):Void {
		
		this.prepend (new Matrix3D ([xScale, 0.0, 0.0, 0.0, 0.0, yScale, 0.0, 0.0, 0.0, 0.0, zScale, 0.0, 0.0, 0.0, 0.0, 1.0]));
		
	}
	
	
	public inline function prependTranslation (x:Float, y:Float, z:Float):Void {
		
		var m = new Matrix3D ();
		m.position = new Vector3D (x, y, z);
		this.prepend (m);
		
	}
	
	
	public function recompose (components:Vector<Vector3D>, ?orientationStyle:Orientation3D):Bool {
		
		if (components.length < 3 || components[2].x == 0 || components[2].y == 0 || components[2].z == 0)
			return false;
	  
		if (orientationStyle == null)
			orientationStyle = Orientation3D.EULER_ANGLES;
		
		identity();
		
		var scale = [];
		scale[0] = scale[1] = scale[2] = components[2].x;
		scale[4] = scale[5] = scale[6] = components[2].y;
		scale[8] = scale[9] = scale[10] = components[2].z;
		
		switch (orientationStyle) {
			
			case Orientation3D.EULER_ANGLES:
				var cx = Math.cos(components[1].x);
				var cy = Math.cos(components[1].y);
				var cz = Math.cos(components[1].z);
				var sx = Math.sin(components[1].x);
				var sy = Math.sin(components[1].y);
				var sz = Math.sin(components[1].z);
				
				rawData[0]=cy*cz*scale[0];
				rawData[1]=cy*sz*scale[1];
				rawData[2]=- sy*scale[2];
				rawData[3]=0;
				rawData[4] = (sx*sy*cz-cx*sz)*scale[4];
				rawData[5] = (sx*sy*sz+cx*cz)*scale[5];
				rawData[6]=sx*cy*scale[6];
				rawData[7]=0;
				rawData[8] = (cx*sy*cz+sx*sz)*scale[8];
				rawData[9] = (cx*sy*sz-sx*cz)*scale[9];
				rawData[10]=cx*cy*scale[10];
				rawData[11]=0;
				rawData[12]=components[0].x;
				rawData[13]=components[0].y;
				rawData[14]=components[0].z;
				rawData[15]=1;

			default:

				var x = components[1].x;
				var y = components[1].y;
				var z = components[1].z;
				var w = components[1].w;
				if (Type.enumEq(orientationStyle, Orientation3D.AXIS_ANGLE)) {
					x *= Math.sin(w/2);
					y *= Math.sin(w/2);
					z *= Math.sin(w/2);
					w = Math.cos(w/2);
				}
				
				rawData[0] = (1-2*y*y-2*z*z)*scale[0];
				rawData[1] = (2*x*y+2*w*z)*scale[1];
				rawData[2] = (2*x*z-2*w*y)*scale[2];
				rawData[3] = 0;
				rawData[4] = (2*x*y-2*w*z)*scale[4];
				rawData[5] = (1-2*x*x-2*z*z)*scale[5];
				rawData[6] = (2*y*z+2*w*x)*scale[6];
				rawData[7] = 0;
				rawData[8] = (2*x*z+2*w*y)*scale[8];
				rawData[9] = (2*y*z-2*w*x)*scale[9];
				rawData[10] = (1-2*x*x-2*y*y)*scale[10];
				rawData[11] = 0;
				rawData[12] = components[0].x;
				rawData[13] = components[0].y;
				rawData[14] = components[0].z;
				rawData[15] = 1;
		}
		
		if (components[2].x == 0)
			rawData[0] = 1e-15;
		if (components[2].y == 0)
			rawData[5] = 1e-15;
		if (components[2].z == 0)
			rawData[10] = 1e-15;
					
		return !(components[2].x == 0 || components[2].y == 0 || components[2].y == 0);
	}
	
	
	public inline function transformVector (v:Vector3D):Vector3D {
		
		var x:Float = v.x, y:Float = v.y, z:Float = v.z;
		
		return new Vector3D (
			(x * rawData[0] + y * rawData[4] + z * rawData[8] + rawData[12]),
			(x * rawData[1] + y * rawData[5] + z * rawData[9] + rawData[13]),
			(x * rawData[2] + y * rawData[6] + z * rawData[10] + rawData[14]),
			(x * rawData[3] + y * rawData[7] + z * rawData[11] + rawData[15]));
		
	}
	
	
	public function transformVectors (vin:Vector<Float>, vout:Vector<Float>):Void {
		
		var i = 0;
		
		while (i + 3 <= vin.length) {
			
			var x:Float = vin[i], y:Float = vin[i + 1], z:Float = vin[i + 2];
			
			vout[i] = x * rawData[0] + y * rawData[4] + z * rawData[8] + rawData[12];
			vout[i + 1] = x * rawData[1] + y * rawData[5] + z * rawData[9] + rawData[13];
			vout[i + 2] = x * rawData[2] + y * rawData[6] + z * rawData[10] + rawData[14];
			
			i += 3;
			
		}
		
	}
	
	
	public inline function transpose ():Void {
		
		var oRawData = rawData.copy ();
		rawData[1] = oRawData[4];
		rawData[2] = oRawData[8];
		rawData[3] = oRawData[12];
		rawData[4] = oRawData[1];
		rawData[6] = oRawData[9];
		rawData[7] = oRawData[13];
		rawData[8] = oRawData[2];
		rawData[9] = oRawData[6];
		rawData[11] = oRawData[14];
		rawData[12] = oRawData[3];
		rawData[13] = oRawData[7];
		rawData[14] = oRawData[11];
		
	}

	private static function getAxisRotation( x:Float, y:Float, z:Float, degrees:Float ):Matrix3D {

		var m = new Matrix3D();

		var a1 = new Vector3D(x, y, z);
		var rad = -degrees * (Math.PI / 180);
		var c = Math.cos(rad);
		var s = Math.sin(rad);
		var t = 1.0 - c;

		m.rawData[0] = c + a1.x * a1.x * t;
		m.rawData[5] = c + a1.y * a1.y * t;
		m.rawData[10] = c + a1.z * a1.z * t;

		var tmp1 = a1.x * a1.y * t;
		var tmp2 = a1.z * s;
		m.rawData[4] = tmp1 + tmp2;
		m.rawData[1] = tmp1 - tmp2;
		tmp1 = a1.x * a1.z * t;
		tmp2 = a1.y * s;
		m.rawData[8] = tmp1 - tmp2;
		m.rawData[2] = tmp1 + tmp2;
		tmp1 = a1.y * a1.z * t;
		tmp2 = a1.x*s;
		m.rawData[9] = tmp1 + tmp2;
		m.rawData[6] = tmp1 - tmp2;

		return m;

	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	@:noCompletion public inline function get_determinant ():Float {
		
		return 1 * ((rawData[0] * rawData[5] - rawData[4] * rawData[1]) * (rawData[10] * rawData[15] - rawData[14] * rawData[11]) 
			- (rawData[0] * rawData[9] - rawData[8] * rawData[1]) * (rawData[6] * rawData[15] - rawData[14] * rawData[7])
			+ (rawData[0] * rawData[13] - rawData[12] * rawData[1]) * (rawData[6] * rawData[11] - rawData[10] * rawData[7])
			+ (rawData[4] * rawData[9] - rawData[8] * rawData[5]) * (rawData[2] * rawData[15] - rawData[14] * rawData[3])
			- (rawData[4] * rawData[13] - rawData[12] * rawData[5]) * (rawData[2] * rawData[11] - rawData[10] * rawData[3])
			+ (rawData[8] * rawData[13] - rawData[12] * rawData[9]) * (rawData[2] * rawData[7] - rawData[6] * rawData[3]));
	
	}
	
	
	@:noCompletion public inline function get_position ():Vector3D {
		
		return new Vector3D (rawData[12], rawData[13], rawData[14]);
		
	}
	
	
	@:noCompletion public inline function set_position (val:Vector3D):Vector3D {
		
		rawData[12] = val.x;
		rawData[13] = val.y;
		rawData[14] = val.z;
		return val;
		
	}
	
	
}


#else


@:forward(determinant, position, append, appendRotation, appendScale, appendTranslation, clone, copyColumnFrom, copyColumnTo, copyFrom, copyRowFrom, copyRowTo, copyToMatrix3D, deltaTransformVector, identity, interpolateTo, invert, pointAt, prepend, prependRotation, prependScale, prependTranslation, transformVector, transpose)


abstract Matrix3D(flash.geom.Matrix3D) from flash.geom.Matrix3D to flash.geom.Matrix3D {
	
	
	public var rawData (get, set):Vector<Float>;
	
	
	public inline function new (v:Vector<Float> = null) {
		
		this = new flash.geom.Matrix3D (v);
		
	}
	
	
	public function copyRawDataFrom (vector:Vector<Float>, index:UInt = 0, transpose:Bool = false):Void {
		
		this.copyRawDataFrom (vector, index, transpose);
		
	}
	
	
	public function copyRawDataTo (vector:Vector<Float>, index:UInt = 0, transpose:Bool = false):Void {
		
		this.copyRawDataTo (vector, index, transpose);
		
	}
	
	
	public function decompose (orientationStyle:Orientation3D = null):Vector<Vector3D> {
		
		return this.decompose (orientationStyle == null ? EULER_ANGLES : orientationStyle);
		
	}
	
	
	public static function interpolate (thisMat:Matrix3D, toMat:Matrix3D, percent:Float):Matrix3D {
		
		return flash.geom.Matrix3D.interpolate (thisMat, toMat, percent);
		
	}
	
	
	public function recompose (components:Vector<Vector3D>, orientationStyle:Orientation3D = null):Bool {
		
		return this.recompose (components, orientationStyle == null ? EULER_ANGLES : orientationStyle);
		
	}
	
	
	public function transformVectors (vin:Vector<Float>, vout:Vector<Float>):Void {
		
		this.transformVectors (vin, vout);
		
	}
	
	
	private inline function get_rawData ():Vector<Float> {
		
		return this.rawData;
		
	}
	
	
	private inline function set_rawData (value:Vector<Float>):Vector<Float> {
		
		return this.rawData = value;
		
	}
	
	
}


#end