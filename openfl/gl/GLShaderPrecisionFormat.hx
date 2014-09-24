package openfl.gl;


#if (!openfl_next && !flash && !js && !display)
typedef GLShaderPrecisionFormat = openfl._v2.gl.GLShaderPrecisionFormat;
#else
typedef GLShaderPrecisionFormat = lime.graphics.opengl.GLShaderPrecisionFormat;
#end