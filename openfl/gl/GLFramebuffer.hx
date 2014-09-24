package openfl.gl;


#if (!openfl_next && !flash && !js && !display)
typedef GLFramebuffer = openfl._v2.gl.GLFramebuffer;
#else
typedef GLFramebuffer = lime.graphics.opengl.GLFramebuffer;
#end