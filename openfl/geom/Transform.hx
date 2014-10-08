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
			
			__matrix.identity ();
			__matrix.scale (__displayObject.scaleX, __displayObject.scaleY);
			__matrix.rotate (__displayObject.rotation * (Math.PI / 180));
			__matrix.translate (__displayObject.x, __displayObject.y);
			
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
			__displayObject.rotation = Math.atan2 (value.b, value.a) * (180 / Math.PI);
			
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