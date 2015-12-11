package openfl.display3D;


import openfl.gl.GL;


class Context3DClearMask {
	
	
	public static inline var ALL:Int = COLOR | DEPTH | STENCIL;
	public static inline var COLOR:Int = GL.COLOR_BUFFER_BIT;
	public static inline var DEPTH:Int = GL.DEPTH_BUFFER_BIT;
	public static inline var STENCIL:Int = GL.STENCIL_BUFFER_BIT;
	
	
}