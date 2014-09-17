package openfl.gl;


#if (!next && !flash && !js && !display)
typedef GL = openfl._v2.gl.GLProgram;
#else
typedef GLProgram = lime.graphics.opengl.GLProgram;
#end