package openfl.display3D;


import openfl.gl.GL;


abstract Context3DTriangleFace(Int) {
	
	
	inline public static var BACK = GL.FRONT;
	inline public static var FRONT = GL.BACK;
	inline public static var FRONT_AND_BACK = GL.FRONT_AND_BACK;
	inline public static var NONE = 0;
	
	
	inline function new (a:Int) {
		
		this = a;
		
	}
	
	
	@:from public static inline function fromInt (s:Int) {
		
		return new Context3DTriangleFace (s);
		
	}
	
	
	@:to public inline function toInt ():Int {
		
		return this;
		
	}
	
	
}