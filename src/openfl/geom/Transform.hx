package openfl.geom;


import openfl.display.DisplayObject;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

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
	
	
	#if openfljs
	private static function __init__ () {
		
		untyped Object.defineProperties (Transform.prototype, {
			"colorTransform": { get: untyped __js__ ("function () { return this.get_colorTransform (); }"), set: untyped __js__ ("function (v) { return this.set_colorTransform (v); }") },
			"concatenatedMatrix": { get: untyped __js__ ("function () { return this.get_concatenatedMatrix (); }"), set: untyped __js__ ("function (v) { return this.set_concatenatedMatrix (v); }") },
			"matrix": { get: untyped __js__ ("function () { return this.get_matrix (); }"), set: untyped __js__ ("function (v) { return this.set_matrix (v); }") },
			"matrix3D": { get: untyped __js__ ("function () { return this.get_matrix3D (); }"), set: untyped __js__ ("function (v) { return this.set_matrix3D (v); }") },
		});
		
	}
	#end
	
	
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
			
			__colorTransform.__copyFrom (value);
			
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
			
			__setTransform (value.a, value.b, value.c, value.d, value.tx, value.ty);
			
		}
		
		return value;
		
	}
	
	
	private function get_matrix3D ():Matrix3D {
		
		if (__hasMatrix3D) {
			
			var matrix = __displayObject.__transform;
			return new Matrix3D (Vector.ofArray ([ matrix.a, matrix.b, 0.0, 0.0, matrix.c, matrix.d, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, matrix.tx, matrix.ty, 0.0, 1.0 ]));
			
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
		
		__setTransform (value.rawData[0], value.rawData[1], value.rawData[5], value.rawData[6], value.rawData[12], value.rawData[13]);
		
		return value;
		
	}
	
	
	private function __setTransform (a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float):Void {
		
		if (__displayObject != null) {
			
			var scaleX = 0.0;
			var scaleY = 0.0;
			
			if (b == 0) {
				
				scaleX = a;
				
			} else {
				
				scaleX = Math.sqrt (a * a + b * b);
				
			}
			
			if (c == 0) {
				
				scaleY = a;
				
			} else {
				
				scaleY = Math.sqrt (c * c + d * d);
				
			}
			
			__displayObject.__scaleX = scaleX;
			__displayObject.__scaleY = scaleY;
			
			var rotation = (180 / Math.PI) * Math.atan2 (d, c) - 90;
			
			if (rotation != __displayObject.__rotation) {
				
				__displayObject.__rotation = rotation;
				var radians = rotation * (Math.PI / 180);
				__displayObject.__rotationSine = Math.sin (radians);
				__displayObject.__rotationCosine = Math.cos (radians);
				
			}
			
			__displayObject.__transform.a = a;
			__displayObject.__transform.b = b;
			__displayObject.__transform.c = c;
			__displayObject.__transform.d = d;
			__displayObject.__transform.tx = tx;
			__displayObject.__transform.ty = ty;
			
			__displayObject.__setTransformDirty ();
			
		}
		
	}
	
	
}