package openfl.gl;


#if (!next && !flash && !js && !display)
typedef GL = openfl._v2.gl.GLShader;
#else
typedef GLShader = lime.graphics.opengl.GLShader;
#end