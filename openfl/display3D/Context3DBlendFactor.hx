package openfl.display3D;


import openfl.gl.GL;


abstract Context3DBlendFactor(Int) {
	
	
	inline public static var DESTINATION_ALPHA:Int = GL.DST_ALPHA;
	inline public static var DESTINATION_COLOR:Int = GL.DST_COLOR;
	inline public static var ONE:Int = GL.ONE;
	inline public static var ONE_MINUS_DESTINATION_ALPHA:Int = GL.ONE_MINUS_DST_ALPHA;
	inline public static var ONE_MINUS_DESTINATION_COLOR:Int = GL.ONE_MINUS_DST_COLOR;
	inline public static var ONE_MINUS_SOURCE_ALPHA:Int = GL.ONE_MINUS_SRC_ALPHA;
	inline public static var ONE_MINUS_SOURCE_COLOR:Int = GL.ONE_MINUS_SRC_COLOR;
	inline public static var SOURCE_ALPHA:Int = GL.SRC_ALPHA;
	inline public static var SOURCE_COLOR:Int = GL.SRC_COLOR;
	inline public static var ZERO:Int = GL.ZERO;
	
	
	inline function new (a:Int) {
		
		this = a;
		
	}
	
	
	@:from public static inline function fromInt (s:Int) {
		
		return new Context3DBlendFactor (s);
		
	}
	
	
	@:to public inline function toInt ():Int {
		
		return this;
		
	}
	
	
}