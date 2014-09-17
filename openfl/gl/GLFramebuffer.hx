package openfl.gl;


#if (!next && !flash && !js)
typedef GL = openfl._v2.gl.GLFramebuffer;
#else
typedef GLFramebuffer = lime.graphics.opengl.GLFramebuffer;
#end