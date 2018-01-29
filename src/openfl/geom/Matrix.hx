package openfl.geom;


import lime.math.Matrix3;
import lime.utils.Float32Array;
import lime.utils.ObjectPool;
import openfl.geom.Point;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class Matrix {
	
	
	private static var __identity = new Matrix ();
	private static var __matrix3 = new Matrix3 ();
	private static var __pool = new ObjectPool<Matrix> (function () return new Matrix (), function (m) m.identity ());
	
	public var a:Float;
	public var b:Float;
	public var c:Float;
	public var d:Float;
	public var tx:Float;
	public var ty:Float;
	
	private var __array:Float32Array;
	
	
	public function new (a:Float = 1, b:Float = 0, c:Float = 0, d:Float = 1, tx:Float = 0, ty:Float = 0) {
		
		this.a = a;
		this.b = b;
		this.c = c;
		this.d = d;
		this.tx = tx;
		this.ty = ty;
		
	}
	
	
	public function clone ():Matrix {
		
		return new Matrix (a, b, c, d, tx, ty);
		
	}
	
	
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
	
	
	public function deltaTransformPoint (point:Point):Point {
		
		return new Point (point.x * a + point.y * c, point.x * b + point.y * d);
		
	}
	
	
	public function equals (matrix):Bool {
		
		return (matrix != null && tx == matrix.tx && ty == matrix.ty && a == matrix.a && b == matrix.b && c == matrix.c && d == matrix.d);
		
	}
	
	
	public function identity ():Void {
		
		a = 1;
		b = 0;
		c = 0;
		d = 1;
		tx = 0;
		ty = 0;
		
	}
	
	
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
	
	
	public function scale (sx:Float, sy:Float):Void {
		
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
	
	
	private function setRotation (theta:Float, scale:Float = 1):Void {
		
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
		
		if (roundPixels) {
			
			return 'matrix3d($a, $b, 0, 0, $c, $d, 0, 0, 0, 0, 1, 0, ${Std.int (tx)}, ${Std.int (ty)}, 0, 1)';
			
		} else {
			
			return 'matrix3d($a, $b, 0, 0, $c, $d, 0, 0, 0, 0, 1, 0, $tx, $ty, 0, 1)';
			
		}
		
	}
	
	
	public inline function toMozString () {
		
		return 'matrix($a, $b, $c, $d, ${tx}px, ${ty}px)';
		
	}
	
	
	public function toString ():String {
		
		return 'matrix($a, $b, $c, $d, $tx, $ty)';
		
	}
	
	
	public function transformPoint (pos:Point):Point {
		
		return new Point (__transformX (pos.x, pos.y), __transformY (pos.x, pos.y));
		
	}
	
	
	public function translate (dx:Float, dy:Float):Void {
		
		tx += dx;
		ty += dy;
		
	}
	
	
	private function toArray (transpose:Bool = false):Float32Array {
		
		if (__array == null) {
			
			__array = new Float32Array (9);
			
		}
		
		if (transpose) {
			
			__array[0] = a;
			__array[1] = b;
			__array[2] = 0;
			__array[3] = c;
			__array[4] = d;
			__array[5] = 0;
			__array[6] = tx;
			__array[7] = ty;
			__array[8] = 1;
			
		} else {
			
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
	
	
	private inline function __cleanValues ():Void {
		
		a = Math.round (a * 1000) / 1000;
		b = Math.round (b * 1000) / 1000;
		c = Math.round (c * 1000) / 1000;
		d = Math.round (d * 1000) / 1000;
		tx = Math.round (tx * 10) / 10;
		ty = Math.round (ty * 10) / 10;
		
	}
	
	
	private function __toMatrix3 ():Matrix3 {
		
		__matrix3.setTo (a, b, c, d, tx, ty);
		return __matrix3;
		
	}
	
	
	public inline function __transformInversePoint (point:Point):Void {
		
		var norm = a * d - b * c;
		
		if (norm == 0) {
			
			point.x = -tx;
			point.y = -ty;
			
		} else {
			
			var px = (1.0 / norm) * (c * (ty - point.y) + d * (point.x - tx));
			point.y = (1.0 / norm) * ( a * (point.y - ty) + b * (tx - point.x) );
			point.x = px;
			
		}
		
	}
	
	
	public inline function __transformInverseX (px:Float, py:Float):Float {
		
		var norm = a * d - b * c;
		
		if (norm == 0) {
			
			return -tx;
			
		} else {
			
			return (1.0 / norm) * (c * (ty - py) + d * (px - tx));
			
		}
		
	}
	
	
	public inline function __transformInverseY (px:Float, py:Float):Float {
		
		var norm = a * d - b * c;
		
		if (norm == 0) {
			
			return -ty;
			
		} else {
			
			return (1.0 / norm) * (a * (py - ty) + b * (tx - px));
			
		}
		
	}
	
	
	public inline function __transformPoint (point:Point):Void {
		
		var px = point.x;
		var py = point.y;
		
		point.x = __transformX (px, py);
		point.y = __transformY (px, py);
		
	}
	
	
	public inline function __transformX (px:Float, py:Float):Float {
		
		return px * a + py * c + tx;
		
	}
	
	
	public inline function __transformY (px:Float, py:Float):Float {
		
		return px * b + py * d + ty;
		
	}
	
	
	public inline function __translateTransformed (px:Float, py:Float):Void {
		
		tx = __transformX (px, py);
		ty = __transformY (px, py);
		
		//__cleanValues ();
		
	}
	
	
}