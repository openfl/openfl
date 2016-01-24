package openfl.display3D;


import openfl.gl.GL;


abstract Context3DCompareMode(Int) {
	
	
	public static inline var ALWAYS = GL.ALWAYS;
	public static inline var EQUAL = GL.EQUAL;
	public static inline var GREATER = GL.GREATER;
	public static inline var GREATER_EQUAL = GL.GEQUAL;
	public static inline var LESS = GL.LESS;
	public static inline var LESS_EQUAL = GL.LEQUAL; // TODO : wrong value
	public static inline var NEVER = GL.NEVER;
	public static inline var NOT_EQUAL = GL.NOTEQUAL;
	
	
	inline function new (a:Int) {
		
		this = a;
		
	}
	
	
	@:from public static inline function fromInt (s:Int) {
		
		return new Context3DCompareMode (s);
		
	}
	
	
	@:to public inline function toInt ():Int {
		
		return this;
		
	}
	
	
}