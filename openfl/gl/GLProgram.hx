package openfl.gl;


#if (!next && !flash && !js)
typedef GL = openfl._v2.gl.GLProgram;
#else
typedef GLProgram = lime.graphics.opengl.GLProgram;
#end