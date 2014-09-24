package openfl.gl;


#if (!openfl_next && !flash && !js && !display)
typedef GLRenderbuffer = openfl._v2.gl.GLRenderbuffer;
#else
typedef GLRenderbuffer = lime.graphics.opengl.GLRenderbuffer;
#end