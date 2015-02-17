package openfl._v2.geom; #if lime_legacy


import openfl.geom.Vector3D;


class Matrix #if (cpp && haxe_ver < 3.2) implements cpp.rtti.FieldNumericIntegerLookup #end {
	
	
	public var a:Float;
	public var b:Float;
	public var c:Float;
	public var d:Float;
	public var tx:Float;
	public var ty:Float;
	
	
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
	
	
	public function copyFrom (other:Matrix):Void {
		
		this.a = other.a;
		this.b = other.b;
		this.c = other.c;
		this.d = other.d;
		this.tx = other.tx;
		this.ty = other.ty;
		
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
		
		if (rotation != 0.0) {
			
			var cos = Math.cos (rotation);
			var sin = Math.sin (rotation);
			b = sin * d;
			c = -sin * a;
			a *= cos;
			d *= cos;
			
		} else {
			
			b = c = 0;
			
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
		
		return this;
		
	}
	
	
	public function mult (m:Matrix):Matrix {
		
		var result = new Matrix ();
		
		result.a = a * m.a + b * m.c;
		result.b = a * m.b + b * m.d;
		result.c = c * m.a + d * m.c;
		result.d = c * m.b + d * m.d;
		
		result.tx = tx * m.a + ty * m.c + m.tx;
		result.ty = tx * m.b + ty * m.d + m.ty;
		
		return result;
		
	}
	
	
	public function rotate (angle:Float):Void {
		
		var cos = Math.cos (angle);
		var sin = Math.sin (angle);
		
		var a1 = a * cos - b * sin;
		b = a * sin + b * cos;
		a = a1;
		
		var c1 = c * cos - d * sin;
		d = c * sin + d * cos;
		c = c1;
		
		var tx1 = tx * cos - ty * sin;
		ty = tx * sin + ty * cos;
		tx = tx1;
		
	}
	
	
	public function scale (x:Float, y:Float):Void {
		
		a *= x;
		b *= y;
		
		c *= x;
		d *= y;
		
		tx *= x;
		ty *= y;
		
	}
	
	
	public function setRotation (angle:Float, scale:Float = 1):Void {
		
		a = Math.cos (angle) * scale;
		c = Math.sin (angle) * scale;
		b = -c;
		d = a;
		
	}
	
	
	public function setTo (a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float):Void {
		
		this.a = a;
		this.b = b;
		this.c = c;
		this.d = d;
		this.tx = tx;
		this.ty = ty;
		
	}
	
	
	public function toString ():String {
		
		return "(a=" + a + ", b=" + b + ", c=" + c + ", d=" + d + ", tx=" + tx + ", ty=" + ty + ")";
		
	}
	
	
	public function transformPoint (point:Point):Point {
		
		return new Point (point.x * a + point.y * c + tx, point.x * b + point.y * d + ty);
		
	}
	
	
	public function translate (x:Float, y:Float):Void {
		
		tx += x;
		ty += y;
		
	}
	
	
}


#end
