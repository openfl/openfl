package openfl.gl;


#if (!openfl_next && !flash && !js && !display)
typedef GLUniformLocation = openfl._v2.gl.GLUniformLocation;
#else
typedef GLUniformLocation = lime.graphics.opengl.GLUniformLocation;
#end