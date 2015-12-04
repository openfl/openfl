package openfl.display3D; #if (!display && !flash)


import openfl.gl.GL;


class Context3DClearMask {
	
	
	public static inline var ALL:Int = COLOR | DEPTH | STENCIL;
	public static inline var COLOR:Int = GL.COLOR_BUFFER_BIT;
	public static inline var DEPTH:Int = GL.DEPTH_BUFFER_BIT;
	public static inline var STENCIL:Int = GL.STENCIL_BUFFER_BIT;
	
	
}


#else


#if flash
@:native("flash.display3D.Context3DClearMask")
#end

extern class Context3DClearMask {
	
	public static var ALL:Int;
	public static var COLOR:Int;
	public static var DEPTH:Int;
	public static var STENCIL:Int;
	
}


#end