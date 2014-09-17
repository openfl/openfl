package openfl.gl;


#if (!next && !flash && !js)
typedef GL = openfl._v2.gl.GLShaderPrecisionFormat;
#else
typedef GLShaderPrecisionFormat = lime.graphics.opengl.GLShaderPrecisionFormat;
#end