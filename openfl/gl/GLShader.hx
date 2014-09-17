package openfl.gl;


#if (!next && !flash && !js)
typedef GL = openfl._v2.gl.GLShader;
#else
typedef GLShader = lime.graphics.opengl.GLShader;
#end