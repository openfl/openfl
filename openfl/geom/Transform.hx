package openfl.geom;


import openfl.display.DisplayObject;

@:access(openfl.display.DisplayObject)
@:access(openfl.geom.ColorTransform)


class Transform {
	
	
	public var colorTransform (get, set):ColorTransform;
	public var concatenatedColorTransform (default, null):ColorTransform;
	public var concatenatedMatrix (get, never):Matrix;
	public var matrix (get, set):Matrix;
	public var matrix3D (get, set):Matrix3D;
	public var pixelBounds (default, null):Rectangle;
	
	private var __colorTransform:ColorTransform;
	private var __displayObject:DisplayObject;
	private var __hasMatrix:Bool;
	private var __hasMatrix3D:Bool;
	
	
	public function new (displayObject:DisplayObject) {
		
		__colorTransform = new ColorTransform ();
		concatenatedColorTransform = new ColorTransform ();
		pixelBounds = new Rectangle ();
		
		__displayObject = displayObject;
		__hasMatrix = true;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_colorTransform ():ColorTransform {
		
		return __colorTransform;
		
	}
	
	
	private function set_colorTransform (value:ColorTransform):ColorTransform {
		
		if (!__colorTransform.__equals (value)) {
			
			__colorTransform = value;
			
			if (value != null) {
				
				__displayObject.alpha = value.alphaMultiplier;
				
			}
			
			__displayObject.__setRenderDirty ();
			
		}
		
		return __colorTransform;
		
	}
	
	
	private function get_concatenatedMatrix ():Matrix {
		
		if (__hasMatrix) {
			
			return __displayObject.__getWorldTransform ().clone ();
			
		}
		
		return null;
		
	}
	
	
	private function get_matrix ():Matrix {
		
		if (__hasMatrix) {
			
			return __displayObject.__transform.clone ();
			
		}
		
		return null;
		
	}
	
	
	private function set_matrix (value:Matrix):Matrix {
		
		if (value == null) {
			
			__hasMatrix = false;
			return null;
			
		}
		
		__hasMatrix = true;
		__hasMatrix3D = false;
		
		if (__displayObject != null) {
			
			var rotation = (180 / Math.PI) * Math.atan2 (value.d, value.c) - 90;
			
			if (rotation != __displayObject.__rotation) {
				
				__displayObject.__rotation = rotation;
				var radians = rotation * (Math.PI / 180);
				__displayObject.__rotationSine = Math.sin (radians);
				__displayObject.__rotationCosine = Math.cos (radians);
				
			}
			
			__displayObject.__transform.copyFrom (value);
			__displayObject.__setTransformDirty ();
			
		}
		
		return value;
		
	}
	
	
	private function get_matrix3D ():Matrix3D {
		
		if (__hasMatrix3D) {
			
			var matrix = __displayObject.__transform;
			return new Matrix3D ([ matrix.a, matrix.b, 0.0, 0.0, matrix.c, matrix.d, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, matrix.tx, matrix.ty, 0.0, 1.0 ]);
			
		}
		
		return null;
		
	}
	
	
	private function set_matrix3D (value:Matrix3D):Matrix3D {
		
		if (value == null) {
			
			__hasMatrix3D = false;
			return null;
			
		}
		
		__hasMatrix = false;
		__hasMatrix3D = true;
		
		if (__displayObject != null) {
			
			var rotation = (180 / Math.PI) * Math.atan2 (value.rawData[5], value.rawData[4]) - 90;
			
			if (rotation != __displayObject.__rotation) {
				
				__displayObject.__rotation = rotation;
				var radians = rotation * (Math.PI / 180);
				__displayObject.__rotationSine = Math.sin (radians);
				__displayObject.__rotationCosine = Math.cos (radians);
				
			}
			
			__displayObject.__transform.a = value.rawData[0];
			__displayObject.__transform.b = value.rawData[1];
			__displayObject.__transform.c = value.rawData[5];
			__displayObject.__transform.d = value.rawData[6];
			__displayObject.__transform.tx = value.rawData[12];
			__displayObject.__transform.ty = value.rawData[13];
			
			__displayObject.__setTransformDirty ();
			
		}
		
		return value;
		
	}
	
	
}