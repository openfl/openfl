package openfl.geom; #if !flash #if (display || openfl_next || js)


import openfl.display.DisplayObject;


class Transform {
	
	
	public var colorTransform:ColorTransform;
	public var concatenatedColorTransform:ColorTransform;
	public var concatenatedMatrix:Matrix;
	public var matrix (get, set):Matrix;
	public var matrix3D (get, set):Matrix3D;
	public var pixelBounds:Rectangle;
	
	@:noCompletion private var __displayObject:DisplayObject;
	@:noCompletion private var __hasMatrix:Bool;
	@:noCompletion private var __hasMatrix3D:Bool;
	
	
	public function new (displayObject:DisplayObject) {
		
		colorTransform = new ColorTransform ();
		concatenatedColorTransform = new ColorTransform ();
		concatenatedMatrix = new Matrix ();
		pixelBounds = new Rectangle ();
		
		__displayObject = displayObject;
		__hasMatrix = true;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private function get_matrix ():Matrix {
		
		if (__hasMatrix) {
			
			var matrix = new Matrix ();
			matrix.scale (__displayObject.scaleX, __displayObject.scaleY);
			matrix.rotate (__displayObject.rotation * (Math.PI / 180));
			matrix.translate (__displayObject.x, __displayObject.y);
			return matrix;
			
		}
		
		return null;
		
	}
	
	
	@:noCompletion private function set_matrix (value:Matrix):Matrix {
		
		if (value == null) {
			
			__hasMatrix = false;
			return null;
			
		}
		
		__hasMatrix = true;
		__hasMatrix3D = false;
		
		if (__displayObject != null) {
			
			__displayObject.x = value.tx;
			__displayObject.y = value.ty;
			__displayObject.scaleX = Math.sqrt ((value.a * value.a) + (value.b * value.b));
			__displayObject.scaleY = Math.sqrt ((value.c * value.c) + (value.d * value.d));
			__displayObject.rotation = Math.atan2 (value.b, value.a) * (180 / Math.PI);
			
		}
		
		return value;
		
	}
	
	
	@:noCompletion private function get_matrix3D ():Matrix3D {
		
		if (__hasMatrix3D) {
			
			var matrix = new Matrix ();
			matrix.scale (__displayObject.scaleX, __displayObject.scaleY);
			matrix.rotate (__displayObject.rotation * (Math.PI / 180));
			matrix.translate (__displayObject.x, __displayObject.y);
			
			return new Matrix3D ([ matrix.a, matrix.b, 0.0, 0.0, matrix.c, matrix.d, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, matrix.tx, matrix.ty, 0.0, 1.0 ]);
			
		}
		
		return null;
		
	}
	
	
	@:noCompletion private function set_matrix3D (value:Matrix3D):Matrix3D {
		
		if (value == null) {
			
			__hasMatrix3D = false;
			return null;
			
		}
		
		__hasMatrix = false;
		__hasMatrix3D = true;
		
		if (__displayObject != null) {
			
			__displayObject.x = value.rawData[12];
			__displayObject.y = value.rawData[13];
			__displayObject.scaleX = Math.sqrt ((value.rawData[0] * value.rawData[0]) + (value.rawData[1] * value.rawData[1]));
			__displayObject.scaleY = Math.sqrt ((value.rawData[4] * value.rawData[4]) + (value.rawData[5] * value.rawData[5]));
			__displayObject.rotation = Math.atan2 (value.rawData[1], value.rawData[0]) * (180 / Math.PI);
			
		}
		
		return value;
		
	}
	
	
}


#else
typedef Transform = openfl._v2.geom.Transform;
#end
#else
typedef Transform = flash.geom.Transform;
#end