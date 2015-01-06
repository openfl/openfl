package openfl.display3D; #if !flash


import openfl.gl.GL;


abstract Context3DStencilAction(Int) {
	
	
	public static inline var DECREMENT_SATURATE = GL.DECR;
	public static inline var DECREMENT_WRAP = GL.DECR_WRAP;
	public static inline var INCREMENT_SATURATE = GL.INCR;
	public static inline var INCREMENT_WRAP = GL.INCR_WRAP;
	public static inline var INVERT = GL.INVERT;
	public static inline var KEEP = GL.KEEP;
	public static inline var SET = GL.REPLACE;
	public static inline var ZERO = GL.ZERO;
	
	
	inline function new (a:Int) {
		
		this = a;
		
	}
	
	
	@:from static public inline function fromInt (s:Int) {
		
		return new Context3DStencilAction(s);
		
	}
	
	
	@:to public inline function toInt ():Int {
		
		return this;
		
	}
	
	
}


#else
typedef Context3DStencilAction = flash.display3D.Context3DStencilAction;
#end