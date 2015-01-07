package openfl.geom; #if !flash #if (display || openfl_next || js)


import openfl.display.DisplayObject;


class Transform {
	
	
	public var colorTransform:ColorTransform;
	public var concatenatedColorTransform:ColorTransform;
	public var concatenatedMatrix:Matrix;
	public var matrix (get, set):Matrix;
	public var pixelBounds:Rectangle;
	
	@:noCompletion private var __displayObject:DisplayObject;
	@:noCompletion private var __matrix:Matrix;
	
	
	public function new (displayObject:DisplayObject) {
		
		colorTransform = new ColorTransform ();
		concatenatedColorTransform = new ColorTransform ();
		concatenatedMatrix = new Matrix ();
		pixelBounds = new Rectangle ();
		
		__displayObject = displayObject;
		__matrix = new Matrix ();
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private function get_matrix ():Matrix {
		
		if (__matrix != null) {
			
			var m00 = __displayObject.__skewA * __displayObject.scaleX;
			var m01 = __displayObject.__skewB * __displayObject.scaleX;
			var m10 = __displayObject.__skewC * __displayObject.scaleY;
			var m11 = __displayObject.__skewD * __displayObject.scaleY;
			var angle = __displayObject.rotation * Math.PI / 180.0;
			var s = Math.sin(angle);
			var c = Math.cos(angle);
			__matrix.setTo(
				m00 * c - m01 * s,
				m00 * s + m01 * c,
				m10 * c - m11 * s,
				m10 * s + m11 * c,
				__displayObject.x, __displayObject.y);
			return __matrix.clone ();
			
		}
		
		return null;
		
	}
	
	
	@:noCompletion private function set_matrix (value:Matrix):Matrix {
		
		if (value == null) {
			
			return __matrix = null;
			
		}
		
		if (__displayObject != null) {
			
			__displayObject.x = value.tx;
			__displayObject.y = value.ty;
			__displayObject.scaleX = Math.sqrt ((value.a * value.a) + (value.b * value.b));
			__displayObject.scaleY = Math.sqrt ((value.c * value.c) + (value.d * value.d));
			if ((value.a * value.d - value.b * value.c) < 0.0) {
				
				__displayObject.scaleY = -__displayObject.scaleY;
				
			}
			var angle = Math.atan2 (value.b, value.a);
			__displayObject.rotation = angle * 180.0 / Math.PI;
			var s = Math.sin(-angle);
			var c = Math.cos(-angle);
			__displayObject.__skewA = value.a * c - value.b * s;
			__displayObject.__skewB = value.a * s + value.b * c;
			__displayObject.__skewC = value.c * c - value.d * s;
			__displayObject.__skewD = value.c * s + value.d * c;
			if (__displayObject.scaleX != 0.0) {
			
				__displayObject.__skewA /= __displayObject.scaleX;
				__displayObject.__skewB /= __displayObject.scaleX;
			
			}
			if (__displayObject.scaleY != 0.0) {
			
				__displayObject.__skewC /= __displayObject.scaleY;
				__displayObject.__skewD /= __displayObject.scaleY;
			
			}
			
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