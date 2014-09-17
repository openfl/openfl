package openfl.gl;


#if (!next && !flash && !js && !display)
typedef GL = openfl._v2.gl.GLRenderbuffer;
#else
typedef GLRenderbuffer = lime.graphics.opengl.GLRenderbuffer;
#end