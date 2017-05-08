package openfl.gl;


#if (!js || !html5 || display)
typedef GLObject = lime.graphics.opengl.GL.GLObject;
#else
typedef GLObject = Dynamic;
#end