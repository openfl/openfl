package openfl.gl;


#if (!next && !flash && !js && !display)
typedef GL = openfl._v2.gl.GLFramebuffer;
#else
typedef GLFramebuffer = lime.graphics.opengl.GLFramebuffer;
#end