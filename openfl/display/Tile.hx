package openfl.display;


import openfl.geom.Matrix;


class Tile {
	
	
	public var data:Dynamic;
	public var id:Int;
	public var matrix:Matrix;
	public var rotation (get, set):Float;
	public var scaleX (get, set):Float;
	public var scaleY (get, set):Float;
	public var x (get, set):Float;
	public var y (get, set):Float;
	
	
	public function new (id:Int = 0, x:Float = 0, y:Float = 0, scaleX:Float = 1, scaleY:Float = 1, rotation:Float = 0) {
		
		this.id = id;
		this.matrix = new Matrix ();
		if (x != 0) this.x = x;
		if (y != 0) this.y = y;
		if (scaleX != 1) this.scaleX = scaleX;
		if (scaleY != 1) this.scaleY = scaleY;
		if (rotation != 0) this.rotation = rotation;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_rotation ():Float {
		
		return (180 / Math.PI) * Math.atan2 (matrix.d, matrix.c) - 90;
		
	}
	
	
	private function set_rotation (value:Float):Float {
		
		var radians = value * (Math.PI / 180);
		var rotationSine = Math.sin (radians);
		var rotationCosine = Math.cos (radians);
		
		var __scaleX = this.scaleX;
		var __scaleY = this.scaleY;
		
		matrix.a = rotationCosine * __scaleX;
		matrix.b = rotationSine * __scaleX;
		matrix.c = -rotationSine * __scaleY;
		matrix.d = rotationCosine * __scaleY;
		
		return value;
		
	}
	
	
	private function get_scaleX ():Float {
		
		if (matrix.b == 0) {
			
			return matrix.a;
			
		} else {
			
			return Math.sqrt (matrix.a * matrix.a + matrix.b * matrix.b);
			
		}
		
	}
	
	
	private function set_scaleX (value:Float):Float {
		
		if (matrix.b == 0) {
			
			matrix.a = value;
			
		} else {
			
			var rotation = this.rotation;
			var radians = value * (Math.PI / 180);
			var rotationSine = Math.sin (radians);
			var rotationCosine = Math.cos (radians);
			
			var a = rotationCosine * value;
			var b = rotationSine * value;
			
			matrix.a = a;
			matrix.b = b;
			
		}
		
		return value;
		
	}
	
	
	private function get_scaleY ():Float {
		
		if (matrix.c == 0) {
			
			return matrix.d;
			
		} else {
			
			return Math.sqrt (matrix.c * matrix.c + matrix.d * matrix.d);
			
		}
		
	}
	
	
	private function set_scaleY (value:Float):Float {
		
		if (matrix.c == 0) {
			
			matrix.d = value;
			
		} else {
			
			var rotation = this.rotation;
			var radians = value * (Math.PI / 180);
			var rotationSine = Math.sin (radians);
			var rotationCosine = Math.cos (radians);
			
			var c = -rotationSine * value;
			var d = rotationCosine * value;
			
			matrix.c = c;
			matrix.d = d;
			
		}
		
		return value;
		
	}
	
	
	private inline function get_x ():Float {
		
		return matrix.tx;
		
	}
	
	
	private inline function get_y ():Float {
		
		return matrix.ty;
		
	}
	
	
	private inline function set_x (value:Float):Float {
		
		return matrix.tx = value;
		
	}
	
	
	private inline function set_y (value:Float):Float {
		
		return matrix.ty = value;
		
	}
	
	
}