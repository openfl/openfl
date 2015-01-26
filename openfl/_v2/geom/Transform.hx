package openfl._v2.geom; #if lime_legacy


import openfl.display.DisplayObject;
import openfl.geom.Matrix3D;


class Transform {
	
	
	public var colorTransform (get, set):ColorTransform;
	public var concatenatedColorTransform (get, null):ColorTransform;
	public var concatenatedMatrix (get, null):Matrix;
	public var matrix (get, set):Matrix;
	public var matrix3D (get, set):Matrix3D;
	public var pixelBounds (get, null):Rectangle;
	
	@:noCompletion private var __hasMatrix:Bool;
	@:noCompletion private var __hasMatrix3D:Bool;
	@:noCompletion private var __parent:DisplayObject;
	
	
	public function new (parent:DisplayObject) {
		
		__parent = parent;
		__hasMatrix = true;
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function get_colorTransform ():ColorTransform { return __parent.__getColorTransform (); }
	private function set_colorTransform (value:ColorTransform):ColorTransform { __parent.__setColorTransform (value); return value; }
	private function get_concatenatedColorTransform ():ColorTransform { return __parent.__getConcatenatedColorTransform (); }
	private function get_concatenatedMatrix ():Matrix { return __parent.__getConcatenatedMatrix (); }
	
	
	@:noCompletion private function get_matrix ():Matrix {
		
		if (__hasMatrix) {
			
			return __parent.__getMatrix ();
			
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
		
		if (__parent != null) {
			
			__parent.__setMatrix (value);
			
		}
		
		return value;
		
	}
	
	
	@:noCompletion private function get_matrix3D ():Matrix3D {
		
		if (__hasMatrix3D) {
			
			var matrix = __parent.__getMatrix ();
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
		
		if (__parent != null) {
			
			var matrix = new Matrix (value.rawData[0], value.rawData[1], value.rawData[4], value.rawData[5], value.rawData[12], value.rawData[13]);
			__parent.__setMatrix (matrix);
			
		}
		
		return value;
		
	}
	
	
	private function get_pixelBounds ():Rectangle { return __parent.__getPixelBounds (); }
	
	
}


#end